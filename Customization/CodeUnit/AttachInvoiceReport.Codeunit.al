codeunit 50111 "Attach Invoice Report"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', false, false)]
    local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean)
    var
        SalesHeader1: Record "Sales Header";
        ConfigRecord: Record AzureConfiguration;
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
        AdddocumentInBillingCalculations(SalesInvHeader);
        AddDocumentInAdditionalCharges(SalesInvHeader);

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

    procedure AdddocumentInBillingCalculations(salesInvHeaderRec: Record "Sales Invoice Header")
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

