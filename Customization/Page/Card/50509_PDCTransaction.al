page 50509 "PDC Transaction"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PDC Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General Information';
                field("PDC ID"; Rec."PDC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant"; Rec."Tenant Name Display")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Cheque Number" := Rec."Cheque Number";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Deposit Bank" := Rec."Bank Name";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }

                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    // trigger OnValidate()
                    // var
                    //     PaymentSeriesRec: Record "Payment Mode2";
                    // begin
                    //     PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                    //     PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                    //     if PaymentSeriesRec.FindSet() then begin
                    //         PaymentSeriesRec."Amount Including VAT" := Rec.Amount;
                    //         PaymentSeriesRec.Modify();
                    //     end;
                    // end;
                }
                field("Old Cheque#"; Rec."Old Cheque#")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsLeaseManager;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                        oldStatus: Enum "PDC Status Type Enum";
                        CashReceiptJournalCodeunit: Codeunit "Cash Receipt Journal Entry";
                    begin

                        oldStatus := xRec."Cheque Status";

                        // if (oldStatus = oldStatus::Deposited) then begin
                        //     if (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) or (Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received") then begin
                        //         Error('You cannot change the status.');
                        //         Rec."Cheque Status" := oldStatus;
                        //         exit;
                        //     end
                        // end;

                        case oldStatus of
                            // oldStatus::"Cheque Received":
                            //No restricted transitions for "Cheque Received";

                            oldStatus::Cleared:
                                Error('Cheque status cannot be changed once it is Cleared.');
                            oldStatus::Deposited:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received") OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR
                                    (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Error('Cannot change Deposited status to %1.', Rec."Cheque Status");
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;

                            oldStatus::"Due cheque not deposited":
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Error('Cannot change Due, Cheque Not Deposited status to %1.', Rec."Cheque Status");
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;
                            oldStatus::Retrieved:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) then begin
                                    Error('Cannot change Retrieved status to %1.', Rec."Cheque Status");
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;

                            oldStatus::Returned:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) then begin

                                    Error('Cannot change Returned status to %1.', Rec."Cheque Status");
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;

                            oldStatus::"Replaced & Received":
                                if Rec."Cheque Status" = Rec."Cheque Status"::Cleared then begin
                                    Error('Cannot change Replaced & Received status to Cleared.');
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;

                            oldStatus::Deferred:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Error('Cannot change Deferred status to %1.', Rec."Cheque Status");
                                    Rec."Cheque Status" := oldStatus;
                                    exit;
                                end;
                        end;

                        // Check if the Cheque Status is set to 'Cleared'
                        if Rec."Cheque Status" = Rec."Cheque Status"::Cleared then begin
                            // Ensure the related Payment Series record exists

                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record
                                PaymentSeriesRec.Validate("Payment Status", PaymentSeriesRec."Payment Status"::Received);
                                // PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Received; // Update to your specific value
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Cleared;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                PaymentSeriesRec.Modify(); // Save the changes

                                CashReceiptJournalCodeunit.CreateCashReceiptJournal(PaymentSeriesRec);
                            end else
                                Error('The related Payment Series record was not found.');
                        end

                        else if Rec."Cheque Status" = Rec."Cheque Status"::Deposited then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record

                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Deposited;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Due;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                PaymentSeriesRec.Modify(); // Save the changes
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");

                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record

                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Cheque Received";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify(); // Save the changes
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Due cheque not deposited" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Due cheque not deposited";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify();
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Replaced & Received";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                // PaymentSeriesRec.Modify();
                                PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                PaymentSeriesRec."Cheque Number" := '';
                                PaymentSeriesRec.Modify();
                                Rec."Old Cheque#" := Rec."Cheque Number";
                                Rec."Cheque Number" := '';
                                Rec.Modify();
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::Retrieved then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Retrieved;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                // PaymentSeriesRec.Modify();
                                PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                PaymentSeriesRec."Cheque Number" := '';
                                PaymentSeriesRec.Modify();
                                Rec."Old Cheque#" := Rec."Cheque Number";
                                Rec."Cheque Number" := '';
                                Rec.Modify();
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::Returned then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Returned;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify();


                            end else
                                Error('The related Payment Series record was not found.');
                        end;
                    end;


                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }

                field(View; Rec.View)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."View Document URL";
                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;

                }

                group(HideFields)
                {
                    ShowCaption = false;
                    Visible = Isvisible;
                    // field("Replacement PDC ID"; Rec."Replacement PDC ID")
                    // {
                    //     ApplicationArea = All;

                    //     // Visible = Isvisible;
                    // }

                    field("Reason"; Rec."Reason")
                    {
                        ApplicationArea = All;
                        // Visible = Isvisible;
                        Visible = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateStatus)
            {
                Caption = 'Update Cheque Status';
                ApplicationArea = All;
                trigger OnAction()
                var
                // ChequeStatusHandler: Codeunit "Cheque Status Handler";
                begin
                    // ChequeStatusHandler.UpdateChequeStatus(Rec);
                end;
            }


        }
    }

    var
        myInt: Integer;
        IsLeaseManager: Boolean;
        Isvisible: Boolean;
        IsFieldEditable: Boolean;
        IsFinanceManager: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved)
    end;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then begin
                IsLeaseManager := true;
            end
            else if PermissionSet."Profile ID" = 'FINANCE MANAGER' then begin
                IsFinanceManager := true;
            end;

        end;
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


}