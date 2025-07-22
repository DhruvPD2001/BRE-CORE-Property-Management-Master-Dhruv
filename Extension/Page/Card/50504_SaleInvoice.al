pageextension 50504 SalesInvoice extends "Sales Invoice"
{

    layout
    {
        addafter(General)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";
                        customercard: Record Customer;
                    begin
                        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancyContract.FindFirst() then begin
                            Rec."Tenant Name" := tenancyContract."Customer Name";
                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            Rec."Property Classification" := tenancyContract."Property Classification";
                            Rec."Contract Amount" := Round(tenancyContract."Annual Rent Amount");
                        end else begin
                            Rec."Tenant Name" := '';
                            rec."Property Name" := '';
                            Rec."Unit Name" := '';
                            Rec."Contract Tenure" := '';
                            Rec."Contract Period" := '';
                            Rec."Property Classification" := '';

                            // Rec."Tenant Name" := '';

                        end;

                        customercard.SetRange("No.", Rec."Sell-to Customer No.");
                        if customercard.FindSet() then begin
                            if Rec."Property Classification" <> '' then begin
                                customercard.Validate("Gen. Bus. Posting Group", Rec."Property Classification");
                                customercard.Validate("Customer Posting Group", Rec."Property Classification");
                                customercard.Modify();
                            end
                        end;
                        if Rec."Property Classification" <> '' then begin
                            //  Rec."Gen. Bus. Posting Group" := Rec."Property Classification";
                            Rec.Validate("Gen. Bus. Posting Group", Rec."Property Classification");
                            Rec."Customer Posting Group" := Rec."Property Classification";
                            Rec.Modify();
                        end;
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    Caption = 'Property Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    Caption = 'Customer Phone No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    Caption = 'Customer Email';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer P.O"; Rec."Customer P.O")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O';
                    Editable = NotAccessFieldFM;
                }
                field("Customer P.O Date"; Rec."Customer P.O Date")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O Date';
                    Editable = NotAccessFieldFM;
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Period';
                    Editable = false;
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                    Caption = 'Reason For Rejection';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                    //Editable = true;

                    trigger OnValidate()

                    var
                        emailrecord: Codeunit SendInvoiceToTenant;
                        Rejectionmail: Codeunit RejectSalesInvoice;
                        ShowDialogBox: Codeunit ShowDialogboxRejctionInvoice;
                    begin
                        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
                            emailrecord.SendInvoice(Rec); // Pass the current record if needed
                        end else
                            if Rec."Approval Status" = Rec."Approval Status"::Rejected then begin
                                ShowDialogBox.DialogboxForRejection(Rec);
                                // Rejectionmail.SendInvoiceToLeaseManager(Rec);
                            end;
                    end;
                }
                field("Overdue Invoice"; Rec."Overdue Invoice")
                {
                    Caption = 'Overdue Invoice';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


            }

        }

        addlast(General)
        {
            field("FC ID"; Rec."FC ID")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("View Document URL"; Rec."View Document URL")
            {
                ApplicationArea = All;
                Caption = 'View Document URL';
            }
            field("View Invoice"; Rec."View Invoice")
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."View Document URL";


                    if FileURL = '' then
                        Error('No document is available to view.');


                    OpenFileInBrowser(FileURL);
                end;

            }
        }

    }

    actions
    {
        addafter(Release)
        {
            action("Run Report")
            {
                Caption = 'Run Report';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvoice: Record "Sales Header";
                    SalesInvoiceReport: Report InvoiceTemplate;
                begin
                    Commit();
                    SalesInvoice.SetRange("No.", Rec."No.");
                    SalesInvoiceReport.SetTableView(SalesInvoice);
                    SalesInvoiceReport.Run();
                end;
            }

        }
        addafter(Action9)
        {
            action(ResendForApproval)
            {
                ApplicationArea = All;
                Caption = 'Resend For Approval';
                Image = SendMail;
                trigger OnAction()
                var
                    ResendInvoiceMail: Codeunit ResendUpdateInvoiceFM;
                begin
                    ResendInvoiceMail.ResendUpdateInvoice(Rec);
                end;
            }
            // action(ChangeCustomerPostingGroup)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Customer Posting Group';

            //     trigger OnAction()
            //     var
            //         customercard: Record Customer;
            //     begin
            //         customercard.SetRange("No.", Rec."Sell-to Customer No.");
            //         if customercard.FindSet() then begin
            //             if Rec."Property Classification" <> '' then begin
            //                 customercard.Validate("Gen. Bus. Posting Group", Rec."Property Classification");
            //                 customercard.Validate("Customer Posting Group", Rec."Property Classification");
            //                 customercard.Modify();
            //             end
            //         end;
            //         if Rec."Property Classification" <> '' then begin
            //             Rec."Gen. Bus. Posting Group" := Rec."Property Classification";
            //             Rec."Customer Posting Group" := Rec."Property Classification";
            //             Rec.Modify();
            //         end;
            //     end;
            // }



        }

        modify(Post)
        {
            trigger OnBeforeAction()
            var
                // AzureBlobUploader: Codeunit "Azure Blob Management";
                InStream: InStream;
                FileName: Text;
                SASUrlBase: Text;
                SASUrlWithFileName: Text;
                UploadResult: Text;
                TempBlob: Codeunit "Temp Blob";
                ValidFormats: List of [Text];
                FileExtension: Text[10];
                FileSize: Decimal;
                ConfigRecord: Record AzureConfiguration;
                ReportID: Integer; // Your report ID
                RecRef: RecordRef;
                FieldRef1: FieldRef;
                FieldRef2: FieldRef;
                OutStream: OutStream;
                documentattachment: Codeunit UploadAttachment;
                SalesHeader1: Record "Sales Header";
                customercard: Record Customer;
                azureBlobUploader: Codeunit "Azure AD Blob Storage";

                folderName: Text;

            begin
                if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                    Error('The Sales Invoice cannot be posted because the approval status is not "Approved".');
                if not ConfigRecord.FindFirst() then
                    Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
                ValidFormats.Add('.png');
                ValidFormats.Add('.jpg');
                ValidFormats.Add('.jpeg');

                SASUrlBase := ConfigRecord."SAS URL";
                FileExtension := '.pdf';
                ReportID := 50104;
                //  RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                // RecRef.GetTable(Rec);
                SalesHeader1.Reset();
                SalesHeader1.SetRange("No.", Rec."No.");
                if not SalesHeader1.FindFirst() then
                    Error('Sales Invoice record not found.');

                // Open the correct record in RecRef
                RecRef.GetTable(SalesHeader1);
                // RecRef.GetTable(Rec);
                TempBlob.CreateOutStream(OutStream);
                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);



                TempBlob.CreateInStream(InStream);
                FileName := 'Invoice_' + Rec."No." + FileExtension;
                // SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));
                folderName := 'SalesInvoiceDocuments';
                UploadResult := azureBlobUploader.UploadDocumentToBlob(InStream, FileName, folderName);
                // UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                Rec."View Invoice" := FileName;
                Rec."View Document URL" := UploadResult;
                Rec.Modify();

            end;
        }


    }
    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure GetUserEditableStatus(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then begin

            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;
        end;

        exit(false);
    end;

    procedure NotAccessFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin

        if UserPersonalization1.Get(UserSecurityId()) then begin

            case UserPersonalization1."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);
                'LEASE_MANAGER':
                    exit(true);
                'finance manager':
                    exit(false);
            end;
        end;

        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";
        customercard: Record Customer;
    begin
        approvaleditable := GetUserEditableStatus();
        NotAccessFieldFM := NotAccessFieldFinanceManager();
        customer.SetRange("No.", Rec."Sell-to Customer No.");
        if customer.FindSet() then begin
            Rec."Sell-to Customer Name" := customer.Name;
            Rec."Sell-to Address" := customer.Address;
            Rec."Gen. Bus. Posting Group" := customer."Gen. Bus. Posting Group";
            Rec."VAT Bus. Posting Group" := customer."VAT Bus. Posting Group";
            Rec."Customer Posting Group" := customer."Customer Posting Group";
            Rec."Sell-to Phone No." := customer."Phone No.";
            Rec."Sell-to E-Mail" := customer."E-Mail";
            Rec."Bill-to Customer No." := customer."No.";
            Rec."Bill-to Name" := customer.Name;
            Rec."Bill-to Address" := customer.Address;
            Rec.Modify();

        end;

        // salesline.SetRange("Document No.", Rec."No.");
        // if salesline.FindSet() then
        //     repeat

        //         salesline."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
        //         salesline."Customer Price Group" := Rec."Customer Price Group";
        //         salesline."VAT Bus. Posting Group" := Rec."VAT Bus. Posting Group";

        //         salesline.Modify();
        //     until salesline.Next() = 0;

        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin

            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
            Rec."Tenant Name" := tenancyContract."Customer Name";
            // Rec."Property Classification" := tenancyContract."Property Classification";
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + '  To  ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>')
        end else begin

            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';

        end;



    end;


    var
        approvaleditable: Boolean;
        NotAccessFieldFM: Boolean;

}

