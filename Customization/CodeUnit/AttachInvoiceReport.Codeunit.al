codeunit 50111 "Attach Invoice Report"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', false, false)]
    local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean)
    var
        SalesHeader1: Record "Sales Header";
        ConfigRecord: Record AzureConfiguration;
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        azureBlobUploader: Codeunit "Azure AD Blob Storage";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStream: InStream;
        FileName: Text;
        SASUrlBase: Text;
        UploadResult: Text;
        ValidFormats: List of [Text];
        FileExtension: Text[10];
        ReportID: Integer;
        OutStream: OutStream;
        folderName: Text;
        postingGroup: Code[20];
    begin
        if not ConfigRecord.FindFirst() then
            Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
        ValidFormats.Add('.png');
        ValidFormats.Add('.jpg');
        ValidFormats.Add('.jpeg');

        SASUrlBase := ConfigRecord."SAS URL";
        FileExtension := '.pdf';
        ReportID := 50104;
        SalesHeader1.Reset();
        SalesHeader1.SetRange("No.", SalesHeader."No.");
        SalesHeader1.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if not SalesHeader1.FindFirst() then
            Error('Sales Invoice record not found.');

        RecRef.GetTable(SalesHeader1);
        TempBlob.CreateOutStream(OutStream);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

        TempBlob.CreateInStream(InStream);
        FileName := 'Invoice_' + SalesInvHeader."No." + FileExtension;
        folderName := 'SalesInvoiceDocuments';
        UploadResult := azureBlobUploader.UploadDocumentToBlob(InStream, FileName, folderName);
        SalesInvHeader."View Invoice" := CopyStr(FileName, 1, StrLen(FileName));
        SalesInvHeader."View Document URL" := CopyStr(UploadResult, 1, StrLen(UploadResult));
        AddDocumentInBillingCalculations(SalesInvHeader);
        AddDocumentInAdditionalCharges(SalesInvHeader);

        if tenancyContract.Get(SalesHeader."Contract ID") then begin
            postingGroup := CopyStr(UpperCase(tenancyContract."Property Classification"), 1, 20);
            if customer.Get(tenancyContract."Tenant ID") then begin
                customer."Gen. Bus. Posting Group" := postingGroup;
                customer."VAT Bus. Posting Group" := postingGroup;
                customer."Customer Posting Group" := postingGroup;
                customer.Modify();
            end;

            SalesInvHeader.Validate("Gen. Bus. Posting Group", postingGroup);
            SalesInvHeader.Validate("VAT Bus. Posting Group", postingGroup);
            SalesInvHeader.Validate("Customer Posting Group", postingGroup);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        SalesLine: Record "Sales Line";
        TenancyContract: Record "Tenancy Contract";
    begin
        if PreviewMode then
            exit;

        if not TenancyContract.Get(SalesHeader."Contract ID") then
            exit;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindSet(true) then
            repeat
                SalesLine.Validate(
                    "Gen. Bus. Posting Group",
                    CopyStr(UpperCase(TenancyContract."Property Classification"), 1, 20));

                SalesLine.Validate(
                    "VAT Bus. Posting Group",
                    CopyStr(UpperCase(TenancyContract."Property Classification"), 1, 20));

                SalesLine.Validate("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");

                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
    end;

    procedure AddDocumentInAdditionalCharges(salesInvHeaderRec: Record "Sales Invoice Header")

    var
        additionalcharges: Record "Additional Charges Sub";

    begin
        additionalcharges.SetRange("Contract ID", salesInvHeaderRec."Contract ID");
        additionalcharges.SetRange("Invoiced ID", salesInvHeaderRec."No.");
        if additionalcharges.FindSet() then
            repeat
                additionalcharges."Invoice Document" := salesInvHeaderRec."View Invoice";
                additionalcharges."Invoice Document URL" := salesInvHeaderRec."View Document URL";
                additionalcharges.Modify();
            until additionalcharges.Next() = 0;

    end;

    procedure AddDocumentInBillingCalculations(salesInvHeaderRec: Record "Sales Invoice Header")
    var
        billingcalculationgrid: Record "Final Billing Calculation Grid";
    begin
        billingcalculationgrid.SetRange("Contract ID", salesInvHeaderRec."Contract ID");
        billingcalculationgrid.SetRange("Invoice ID", salesInvHeaderRec."No.");
        if billingcalculationgrid.FindSet() then
            repeat
                billingcalculationgrid."Invoice Document" := salesInvHeaderRec."View Invoice";
                billingcalculationgrid."Invoice Document URL" := salesInvHeaderRec."View Document URL";
                billingcalculationgrid.Modify();
            until billingcalculationgrid.Next() = 0;
    end;
}

