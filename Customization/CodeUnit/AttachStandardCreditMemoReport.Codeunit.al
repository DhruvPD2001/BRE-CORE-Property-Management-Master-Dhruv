codeunit 50112 "Attach Credit Memo Report"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesCrMemoHeaderInsert, '', false, false)]
    local procedure OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
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
        ReportID := 50116;
        SalesHeader1.Reset();
        SalesHeader1.SetRange("No.", SalesHeader."No.");
        SalesHeader1.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if not SalesHeader1.FindFirst() then
            Error('Sales Credit Memo record not found.');

        RecRef.GetTable(SalesHeader1);
        TempBlob.CreateOutStream(OutStream);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

        TempBlob.CreateInStream(InStream);
        FileName := 'CreditMemo_' + SalesCrMemoHeader."No." + FileExtension;
        folderName := 'SalesCreditMemoDocuments';
        UploadResult := azureBlobUploader.UploadDocumentToBlob(InStream, FileName, folderName);
        SalesCrMemoHeader."Credit Memo Document" := CopyStr(FileName, 1, StrLen(FileName));
        SalesCrMemoHeader."Credit Memo URL" := CopyStr(UploadResult, 1, StrLen(UploadResult));
    end;
}