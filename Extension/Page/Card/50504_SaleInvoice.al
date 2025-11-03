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
                            Message('Now you can Post the invoice as it is approved');
                        end else
                            if Rec."Approval Status" = Rec."Approval Status"::Rejected then begin
                                ShowDialogBox.DialogboxForRejection(Rec);
                                // Rejectionmail.SendInvoiceToLeaseManager(Rec);
                            end;
                        UpdateInvoiceApprovalStatus();
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
            begin
                if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                    Error('The Sales Invoice cannot be posted because the approval status is not "Approved".');
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

    procedure UpdateInvoiceApprovalStatus()
    var
        PaymentSchedule2: Record "Payment Schedule2";
    begin
        PaymentSchedule2.SetRange("Invoice ID", Rec."No.");
        if PaymentSchedule2.FindSet() then begin
            repeat
                PaymentSchedule2.Validate("Invoice Approval Status", Rec."Approval Status");
                PaymentSchedule2.Modify();
            until PaymentSchedule2.Next() = 0;
        end;
    end;

    var
        approvaleditable: Boolean;
        NotAccessFieldFM: Boolean;

}

