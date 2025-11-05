page 50927 "Payment Mode Card"
{
    PageType = Card;
    SourceTable = "Payment Mode";
    ApplicationArea = All;
    Caption = 'Payment mode Details';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;

                    ShowMandatory = true;
                    NotBlank = true;
                    Editable = IsFieldEditable;

                    //Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Contract Start date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;


                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        PaymentModeRec: Record "Payment Mode2";
                        MissingFields: Text;
                        AnyMissing: Boolean;
                    begin
                        // ✅ Only validate when user is trying to approve
                        if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                            exit;

                        // ✅ Filter all payment mode records for this Contract ID
                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");

                        if not PaymentModeRec.FindSet() then
                            Error(
                              'Cannot change Approval Status to Approved. No payment mode details found for Contract %1.',
                              Rec."Contract ID");

                        AnyMissing := false;
                        MissingFields := '';

                        repeat
                            if PaymentModeRec."Payment Mode" = 'Pending' then
                                Error('Cannot change Approval Status to Approved. Payment Mode is still Pending for Series %1.',
                                  PaymentModeRec."Payment Series");
                            case PaymentModeRec."Payment Mode" of
                                'Cheque':
                                    begin
                                        if PaymentModeRec."Cheque Number" = '-' then begin
                                            AnyMissing := true;
                                            MissingFields +=
                                              StrSubstNo('Series %1: Cheque Number is missing.',
                                                PaymentModeRec."Payment Series");
                                        end;
                                        if PaymentModeRec."Deposit Bank" = '' then begin
                                            AnyMissing := true;
                                            MissingFields +=
                                              StrSubstNo('Series %1: Deposit Bank is missing.',
                                                PaymentModeRec."Payment Series");
                                        end;
                                        if PaymentModeRec."Upload Cheque" = 'Upload Cheque' then begin
                                            AnyMissing := true;
                                            MissingFields +=
                                              StrSubstNo('Series %1: Upload Cheque is missing.',
                                                PaymentModeRec."Payment Series");
                                        end;
                                    end;

                                'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                    // begin
                                    if PaymentModeRec."Deposit Bank" = '' then begin
                                        AnyMissing := true;
                                        MissingFields +=
                                          StrSubstNo('Series %1 (%2): Deposit Bank is missing.',
                                            PaymentModeRec."Payment Series",
                                            PaymentModeRec."Payment Mode");
                                        // end;
                                    end;
                            end;
                        until PaymentModeRec.Next() = 0;

                        // ✅ Block approval if any required field is missing
                        if AnyMissing then
                            Error(
                              'Cannot change Approval Status to Approved. The following required details are missing for Contract %1: %2',
                              Rec."Contract ID",
                              MissingFields);
                    end;

                    // Editable = IsFinanceManager AND IsFieldEditable;
                    // trigger OnValidate()
                    // begin
                    //     // Scenario 1: Update all payment grid records to "Approved" when card status changes
                    //     if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
                    //         UpdateAllPaymentGridApprovalStatus(Rec."Contract ID", Rec."Approval Status");
                    //     end;
                    // end;

                }

                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                }
                field("On-hold"; Rec."On-hold")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsFieldEditable;
                    // trigger OnValidate()
                    // var
                    //     paymentModeRec: Record "Payment Mode";
                    //     paymentSeriesRec: Record "Payment Mode2";
                    //     approvalPending: Boolean;
                    //     sendRejectionToLeaseTeam: Codeunit 50511;
                    // begin
                    //     if Rec."On-hold" = Rec."On-hold"::"True" then begin
                    //         approvalPending := false;
                    //         paymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                    //         paymentSeriesRec.SetRange("Tenant Id", Rec."Tenant Id");
                    //         if paymentSeriesRec.FindSet() then begin
                    //             repeat
                    //                 if paymentSeriesRec."Approval Status" = paymentSeriesRec."Approval Status"::Pending then begin
                    //                     approvalPending := true;
                    //                     break;
                    //                 end;
                    //             until paymentSeriesRec.Next() = 0;
                    //         end;

                    //         // Exit if there are any "Pending" approval statuses
                    //         if ApprovalPending then
                    //             exit;

                    //         if approvalPending = false then begin
                    //             sendRejectionToLeaseTeam.SendPaymentRejectionToLeaseManager(paymentSeriesRec."Contract ID", paymentSeriesRec."Tenant Id", paymentSeriesRec."Contract ID");
                    //         end;

                    //     end;
                    // end;
                }
                field(Isupdated; Rec.Isupdated)
                {
                    ApplicationArea = All;
                    Visible = false;
                }


            }



            group("Payment Mode")
            {
                part("PaymentMode"; "Payment Mode Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                    // Editable = IsFieldEditable;
                    // Visible = isVisible;
                }
            }


            group("CombinePaymentLog")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment Log';
                part("CombinePaymentsLog"; "CombinePaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            group("CombinePayment")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment';
                field("Combine Payment Series"; Rec."Combine Payment Series")
                {
                    ApplicationArea = All;

                    // Trasfer from Table Start
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentMode2Rec: Record "Payment Mode2";
                        Selection: Page "Payment Mode2 List";
                        SelectedPaymentSeries: Text[250];
                        TotalAmount: Decimal;
                        TotalVATAmount: Decimal;
                        TotalAmountInclVAT: Decimal;
                    begin
                        // First check if Contract ID is selected
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // Filter Payment Mode2 records based on Contract ID
                        PaymentMode2Rec.Reset();
                        PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentMode2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            // Clear totals
                            Clear(TotalAmount);
                            Clear(TotalVATAmount);
                            Clear(TotalAmountInclVAT);
                            Clear(SelectedPaymentSeries);

                            Selection.SetSelectionFilter(PaymentMode2Rec);
                            if PaymentMode2Rec.FindSet() then begin
                                repeat
                                    // Add to payment series string
                                    if SelectedPaymentSeries <> '' then
                                        SelectedPaymentSeries := SelectedPaymentSeries + ',';
                                    SelectedPaymentSeries := SelectedPaymentSeries + PaymentMode2Rec."Payment Series";

                                    // Sum up amounts
                                    TotalAmount += PaymentMode2Rec.Amount;
                                    TotalVATAmount += PaymentMode2Rec."VAT Amount";
                                    TotalAmountInclVAT += PaymentMode2Rec."Amount Including VAT";
                                until PaymentMode2Rec.Next() = 0;

                                // Set all values to the record
                                Rec."Combine Payment Series" := SelectedPaymentSeries;
                                Rec."Combine Amount" := TotalAmount;
                                Rec."Combine VAT Amount" := TotalVATAmount;
                                Rec."Combine Amount Including VAT" := TotalAmountInclVAT;
                            end;
                        end;
                    end;
                    // Trasfer from Table End
                }

                field("Combine Due Date"; Rec."Combine Due Date")
                {
                    ApplicationArea = All;
                }

                field("Combine Payment Mode"; Rec."Combine Payment Mode")
                {
                    ApplicationArea = All;
                }

                field("Combine Amount"; Rec."Combine Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Combine VAT Amount"; Rec."Combine VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Combine Amount Including VAT"; Rec."Combine Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            label(note)
            {
                Caption = 'Note: Cheque details are required only if Payment Mode is Cheque.';
                ApplicationArea = All;
                Style = Strong;
                Visible = IsCombineVisible;
            }
            group("ChequeDetails")
            {
                ShowCaption = false;
                field("cheque No"; Rec."C_Cheque_Number")
                {
                    ApplicationArea = All;
                }
                field("Deposit Bank"; Rec."C_Deposit_Bank")
                {
                    ApplicationArea = All;
                }
            }


            group("SplitPaymentLog")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment Log';
                part("SplitPaymentsLog"; "SplitPaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }
            group("SplitPayment")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment';
                part("SplitPayments"; "Split Payment Change Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            // group("SplitPayment")
            // {
            //     Visible = IsSplitVisible;
            //     Caption = 'Split Payment';
            //     field("Split Payment Series"; Rec."Split Payment Series")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Secondary Item Type"; Rec."Secondary Item Type")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Due Date"; Rec."Split Due Date")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Payment Mode"; Rec."Split Payment Mode")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Amount"; Rec."Split Amount")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split VAT Amount"; Rec."Split VAT Amount")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Amount Including VAT"; Rec."Split Amount Including VAT")
            //     {
            //         ApplicationArea = All;
            //     }
            // }

            group("PaymentModeChangeLog")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode Log';
                part("PaymentsModeChangeLog"; "PaymentModeChangeLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            group("ChangePaymentMode")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode';
                field("Change Payment Series"; Rec."Change Payment Series")
                {
                    ApplicationArea = All;

                    // Trasfer from Table Start
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentMode2Rec: Record "Payment Mode2";
                        Selection: Page "Payment Mode2 List";
                    begin
                        // Ensure Contract ID is selected first
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // Filter Payment Mode2 records based on Contract ID
                        PaymentMode2Rec.Reset();
                        PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentMode2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            Selection.SetSelectionFilter(PaymentMode2Rec);

                            if PaymentMode2Rec.FindSet() then begin
                                Rec."Change Payment Series" := PaymentMode2Rec."Payment Series"; // Select only one value
                            end;
                        end;
                    end;
                    // Trasfer from Table End
                }

                field("Change Payment Mode"; Rec."Change Payment Mode")
                {
                    ApplicationArea = All;
                }


            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CombineData)
            {
                Caption = 'Combine Data';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                var
                // Paymentmode: Record "Payment Mode";
                // Approvalpayment: Record "Approval Payment Request";
                begin
                    //IsVisible := NOT IsVisible;
                    IsCombineVisible := true;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := false;
                    RequestType := RequestType::Combine;
                    Status := Status::Manual;
                    Message('Combine Payment section is open.');
                    CombinePaymentLogStore();
                end;
            }

            action(SplitData)
            {
                Caption = 'Split Data';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                begin
                    // IsVisible := NOT IsVisible;
                    IsCombineVisible := false;
                    IsChangePaymodeVisible := false;
                    IsSplitVisible := true;
                    RequestType := RequestType::Split;
                    Status := Status::Manual;
                    Message('Split Payment section is open.');
                    SplitPaymentLogStore();
                end;
            }


            action(Paymode)
            {
                Caption = 'Payment Mode Change';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                begin
                    //IsVisible := NOT IsVisible;
                    IsCombineVisible := false;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := true;
                    RequestType := RequestType::"Payment Mode";
                    Status := Status::Manual;
                    Message('Paymode Payment section is open.');
                    PaymentModeLogStore();
                end;
            }


            action(RequestSend)
            {
                Caption = 'Request Send';
                ApplicationArea = All;
                Image = SendTo;


                trigger OnAction()
                var
                    Paymentmode: Record "Payment Mode";
                    Approvalpayment: Record "Approval Payment Request";
                    MaxID: Integer;
                    SplitPayChange: Record "Split Payment Change";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Find the highest ID and increment it
                    if Approvalpayment.FindLast() then
                        MaxID := Approvalpayment.ID + 1
                    else
                        MaxID := 1; // If no records exist, start from 1

                    if IsCombineVisible then begin
                        Approvalpayment.Init();
                        Approvalpayment.ID := MaxID; // Assign the new auto-incremented ID
                        Approvalpayment."Contract ID" := Rec."Contract ID";
                        Approvalpayment."Tenant ID" := Rec."Tenant ID";
                        Approvalpayment."Status" := 'Pending';
                        Approvalpayment."Request Type" := Format(RequestType);
                        Approvalpayment."Manual/Auto Status" := Format(Status);
                        Approvalpayment."Payment Series" := Rec."Combine Payment Series";
                        Approvalpayment."Due Date" := Rec."Combine Due Date";
                        Approvalpayment."Payment Mode" := Rec."Combine Payment Mode";
                        Approvalpayment."Amount" := Rec."Combine Amount";
                        Approvalpayment."VAT Amount" := Rec."Combine VAT Amount";
                        Approvalpayment."Change Amount" := Rec."Combine Amount Including VAT";
                        Approvalpayment."Payment mode ID" := Rec."Contract ID";
                        Approvalpayment.Insert();
                    end
                    else if IsSplitVisible then begin
                        if SplitPayChange.FindSet() then begin
                            repeat

                                if (SplitPayChange."Split Payment Series" <> '') and
                 (SplitPayChange."Secondary Item Type" <> '') and
                 (SplitPayChange."Split Due Date" <> 0D) and
                 //(SplitPayChange."Payment Mode" <> '') and
                 (SplitPayChange."Split Amount" <> 0) then begin


                                    Approvalpayment.Init(); // Initialize a new record
                                    Approvalpayment.ID := MaxID; // Assign unique ID
                                    MaxID += 1; // Increment for the next record

                                    Approvalpayment."Contract ID" := Rec."Contract ID";
                                    Approvalpayment."Tenant ID" := Rec."Tenant ID";
                                    Approvalpayment."Status" := 'Pending';
                                    Approvalpayment."Request Type" := Format(RequestType);
                                    Approvalpayment."Manual/Auto Status" := Format(Status);
                                    Approvalpayment.Items := SplitPayChange."Secondary Item Type";
                                    Approvalpayment."Payment Series" := SplitPayChange."Split Payment Series";
                                    Approvalpayment."Due Date" := SplitPayChange."Split Due Date";
                                    Approvalpayment."Payment Mode" := SplitPayChange."Split Payment Mode";
                                    Approvalpayment."Amount" := SplitPayChange."Split Amount";
                                    Approvalpayment."VAT Amount" := SplitPayChange."Split VAT Amount";
                                    Approvalpayment."Change Amount" := SplitPayChange."Split Amount Including VAT";
                                    Approvalpayment."Payment mode ID" := Rec."Contract ID";

                                    Approvalpayment.Insert(); // Insert inside the loop
                                end;
                            until SplitPayChange.Next() = 0;
                            SplitPayChange.Reset();
                            SplitPayChange.DeleteAll(); // Delete all records from the grid
                        end;
                    end
                    else if IsChangePaymodeVisible then begin
                        Approvalpayment.Init();
                        Approvalpayment.ID := MaxID;
                        Approvalpayment."Contract ID" := Rec."Contract ID";
                        Approvalpayment."Tenant ID" := Rec."Tenant ID";
                        Approvalpayment."Status" := 'Pending';
                        Approvalpayment."Request Type" := Format(RequestType);
                        Approvalpayment."Manual/Auto Status" := Format(Status);
                        Approvalpayment."Payment Series" := Rec."Change Payment Series";
                        Approvalpayment."Payment Mode" := Rec."Change Payment Mode";
                        Approvalpayment."Payment mode ID" := Rec."Contract ID";
                        Approvalpayment.Insert();
                    end;

                    Message('Approval Request Sent successfully!');

                    // Clear relevant fields after sending request
                    Clear(SplitPayChange."Split Payment Series");
                    Clear(SplitPayChange."Split Due Date");
                    Clear(SplitPayChange."Split Payment Mode");
                    Clear(SplitPayChange."Split Amount");
                    Clear(SplitPayChange."Secondary Item Type");
                    Clear(SplitPayChange."Split VAT Amount");
                    Clear(SplitPayChange."Split Amount Including VAT");

                    Clear(Rec."Combine Payment Series");
                    Clear(Rec."Combine Due Date");
                    Clear(Rec."Combine Payment Mode");
                    Clear(Rec."Combine Amount");
                    Clear(Rec."Combine VAT Amount");
                    Clear(Rec."Combine Amount Including VAT");

                    Clear(Rec."Change Payment Series");
                    Clear(Rec."Change Payment Mode");

                    // Modify and update the record
                    Rec.Modify();
                end;


                // trigger OnAction()
                // var
                //     Paymentmode: Record "Payment Mode";
                //     // Approvalpayment: Record "ManualApprovalPaymentRequest";
                //     Approvalpayment: Record "Approval Payment Request";
                //     MaxID: Integer;
                //     SplitPayChange: Record "Split Payment Change";
                // begin
                //     // Validate required fields
                //     if Rec."Contract ID" = 0 then
                //         Error('Contract ID must be specified');

                //     // Find the highest ID and increment it
                //     if Approvalpayment.FindLast() then
                //         MaxID := Approvalpayment.ID + 1
                //     else
                //         MaxID := 1; // If no records exist, start from 1

                //     // Create a new record
                //     Approvalpayment.Init();
                //     Approvalpayment.ID := MaxID; // Assign the new auto-incremented ID
                //     Approvalpayment."Contract ID" := Rec."Contract ID";
                //     Approvalpayment."Tenant ID" := Rec."Tenant ID";
                //     Approvalpayment."Status" := 'Pending';
                //     Approvalpayment."Request Type" := Format(RequestType);
                //     Approvalpayment."Manual/Auto Status" := Format(Status);

                //     if IsCombineVisible then begin
                //         Approvalpayment."Payment Series" := Rec."Combine Payment Series";
                //         Approvalpayment."Due Date" := Rec."Combine Due Date";
                //         Approvalpayment."Payment Mode" := Rec."Combine Payment Mode";
                //         Approvalpayment."Amount" := Rec."Combine Amount";
                //         Approvalpayment."VAT Amount" := Rec."Combine VAT Amount";
                //         Approvalpayment."Change Amount" := Rec."Combine Amount Including VAT";
                //     end
                //     else if IsSplitVisible then begin
                //         if SplitPayChange.FindSet() then begin
                //             repeat
                //                 Approvalpayment.Init();
                //                 Approvalpayment.ID := MaxID; // Assign the new auto-incremented ID
                //                 Approvalpayment."Contract ID" := Rec."Contract ID";
                //                 Approvalpayment."Tenant ID" := Rec."Tenant ID";
                //                 Approvalpayment."Status" := 'Pending';
                //                 Approvalpayment."Request Type" := Format(RequestType);
                //                 Approvalpayment."Manual/Auto Status" := Format(Status);
                //                 Approvalpayment.Items := SplitPayChange."Secondary Item Type";
                //                 Approvalpayment."Payment Series" := SplitPayChange."Split Payment Series";
                //                 Approvalpayment."Due Date" := SplitPayChange."Split Due Date";
                //                 Approvalpayment."Payment Mode" := SplitPayChange."Split Payment Mode";
                //                 Approvalpayment."Amount" := SplitPayChange."Split Amount";
                //                 Approvalpayment."VAT Amount" := SplitPayChange."Split VAT Amount";
                //                 Approvalpayment."Change Amount" := SplitPayChange."Split Amount Including VAT";
                //             // Approvalpayment.Insert();
                //             until SplitPayChange.Next() = 0;
                //         end;
                //     end
                //     else if IsChangePaymodeVisible then begin
                //         Approvalpayment."Payment Series" := Rec."Change Payment Series";
                //         Approvalpayment."Payment Mode" := Rec."Change Payment Mode";
                //     end;
                //     Approvalpayment.Insert();
                //     Message('Approval Request Sent successfully!');

                //     // Clear relevant fields after sending request
                //     Clear(SplitPayChange."Split Payment Series");
                //     Clear(SplitPayChange."Split Due Date");
                //     Clear(SplitPayChange."Split Payment Mode");
                //     Clear(SplitPayChange."Split Amount");
                //     Clear(SplitPayChange."Secondary Item Type");
                //     Clear(SplitPayChange."Split VAT Amount");
                //     Clear(SplitPayChange."Split Amount Including VAT");

                //     Clear(Rec."Combine Payment Series");
                //     Clear(Rec."Combine Due Date");
                //     Clear(Rec."Combine Payment Mode");
                //     Clear(Rec."Combine Amount");
                //     Clear(Rec."Combine VAT Amount");
                //     Clear(Rec."Combine Amount Including VAT");

                //     Clear(Rec."Change Payment Series");
                //     Clear(Rec."Change Payment Mode");

                //     // Modify and update the record
                //     Rec.Modify();
                // end;
            }
        }
    }




    trigger OnAfterGetRecord()
    begin
        // Fields are editable only if Approval Status is not "Approved"
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");
    end;


    trigger OnModifyRecord(): Boolean
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        //CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        //CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        // CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");

    end;

    procedure CombinePaymentLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        CombinePaymentLogsub: Record "CombinePaymentLog";
    begin

        CombinePaymentLogsub.SetRange("Contract ID", Rec."Contract ID");
        if CombinePaymentLogsub.FindSet() then begin
            CombinePaymentLogsub.DeleteAll();
        end;


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");
        // ApprovalPaymentRequest.SetRange("ID", CombinePaymentLogsub."ID");
        ApprovalPaymentRequest.SetRange("Request Type", 'Combine');
        if ApprovalPaymentRequest.FindSet() then begin
            repeat
                CombinePaymentLogsub.Init();
                CombinePaymentLogsub."Contract ID" := Rec."Contract ID";
                CombinePaymentLogsub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                CombinePaymentLogsub."ID" := ApprovalPaymentRequest.ID;
                CombinePaymentLogsub."Approval Status" := ApprovalPaymentRequest."Status";
                CombinePaymentLogsub."Request Type" := ApprovalPaymentRequest."Request Type";
                CombinePaymentLogsub."New Amount" := ApprovalPaymentRequest."Amount";
                CombinePaymentLogsub."New VAT Amount" := ApprovalPaymentRequest."Vat Amount";
                CombinePaymentLogsub."Change Amount Including VAT" := ApprovalPaymentRequest."Change Amount";
                CombinePaymentLogsub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                CombinePaymentLogsub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                CombinePaymentLogsub."Due Date" := ApprovalPaymentRequest."Due Date";
                CombinePaymentLogsub.Insert();
                Clear(CombinePaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;
        end;

    end;

    procedure SplitPaymentLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        SplitPaymentLogsub: Record "SplitPaymentLog";
    begin

        SplitPaymentLogsub.SetRange("Contract ID", Rec."Contract ID");
        if SplitPaymentLogsub.FindSet() then begin
            SplitPaymentLogsub.DeleteAll();
        end;


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");
        // ApprovalPaymentRequest.SetRange("ID", CombinePaymentLogsub."ID");
        ApprovalPaymentRequest.SetRange("Request Type", 'Split');
        if ApprovalPaymentRequest.FindSet() then begin
            repeat
                SplitPaymentLogsub.Init();
                SplitPaymentLogsub."Contract ID" := Rec."Contract ID";
                SplitPaymentLogsub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                SplitPaymentLogsub."ID" := ApprovalPaymentRequest.ID;
                SplitPaymentLogsub."Approval Status" := ApprovalPaymentRequest."Status";
                SplitPaymentLogsub."Request Type" := ApprovalPaymentRequest."Request Type";
                SplitPaymentLogsub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                SplitPaymentLogsub."New Amount" := ApprovalPaymentRequest."Amount";
                SplitPaymentLogsub."New VAT Amount" := ApprovalPaymentRequest."Vat Amount";
                SplitPaymentLogsub."Change Amount Including VAT" := ApprovalPaymentRequest."Change Amount";
                SplitPaymentLogsub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                SplitPaymentLogsub."Due Date" := ApprovalPaymentRequest."Due Date";
                SplitPaymentLogsub.Items := ApprovalPaymentRequest.Items;
                SplitPaymentLogsub.Insert();
                Clear(SplitPaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;
        end;

    end;


    procedure PaymentModeLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        PaymentModeLogSub: Record "PaymentModeChangeLog";
    begin

        PaymentModeLogSub.SetRange("Contract ID", Rec."Contract ID");
        if PaymentModeLogSub.FindSet() then begin
            PaymentModeLogSub.DeleteAll();
        end;


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");
        // ApprovalPaymentRequest.SetRange("ID", CombinePaymentLogsub."ID");
        ApprovalPaymentRequest.SetRange("Request Type", 'Payment Mode');
        if ApprovalPaymentRequest.FindSet() then begin
            repeat
                PaymentModeLogSub.Init();
                PaymentModeLogSub."Contract ID" := Rec."Contract ID";
                PaymentModeLogSub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                PaymentModeLogSub."ID" := ApprovalPaymentRequest.ID;
                PaymentModeLogSub."Approval Status" := ApprovalPaymentRequest."Status";
                PaymentModeLogSub."Request Type" := ApprovalPaymentRequest."Request Type";
                PaymentModeLogSub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                PaymentModeLogSub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                PaymentModeLogSub.Insert();
                Clear(PaymentModeLogSub);
            until ApprovalPaymentRequest.Next() = 0;
        end;

    end;



    // procedure UpdateAllPaymentGridApprovalStatus(ContractID: Integer; NewStatus: Enum "Approval Status Enum")
    // var
    //     PaymentGridRec: Record "Payment Mode2";
    // begin
    //     PaymentGridRec.SetRange("Contract ID", PaymentGridRec."Contract ID");
    //     if PaymentGridRec.FindSet() then
    //         repeat
    //             PaymentGridRec."Approval Status" := NewStatus;
    //             PaymentGridRec.Modify();
    //         until PaymentGridRec.Next() = 0;

    //     // Check if all are approved
    //     CheckAndUpdateCardApprovalStatus(ContractID);
    // end;

    // procedure CheckAndUpdateCardApprovalStatus(ContractID: Integer)
    // var
    //     PaymentGridRec: Record "Payment Mode2";
    //     AllApproved: Boolean;
    // begin
    //     AllApproved := true;
    //     PaymentGridRec.SetRange("Contract ID", ContractID);
    //     if PaymentGridRec.FindSet() then
    //         repeat
    //             if PaymentGridRec."Approval Status" <> PaymentGridRec."Approval Status"::Approved then
    //                 AllApproved := false;
    //         until (PaymentGridRec.Next() = 0) or not AllApproved;

    //     if AllApproved then begin
    //         Rec."Approval Status" := Rec."Approval Status"::Approved;
    //         Rec.Modify();
    //     end;
    // end;
    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;
        IsVisible: Boolean;
        IsCombineVisible: Boolean;
        IsSplitVisible: Boolean;

        IsChangePaymodeVisible: Boolean;
        RequestType: Option Combine,Split,"Payment Mode";

        Status: Option Manual,Frontend;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;
        end;


    end;

}



