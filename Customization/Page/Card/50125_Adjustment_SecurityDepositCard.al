page 50125 "Adjustment Security Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Adjustment Security Deposit";
    Caption = 'Adjustment Security Deposit';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("Main Security Deposit"; Rec."Main Security Deposit")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    // trigger OnValidate()
                    // begin
                    //     if (Rec."Status" = Rec."Status"::Approved) then begin
                    //         AdditinalchargescashReceipt();
                    //         // receivablecashrecipt();
                    //     end;
                    // end;

                }

                field("Security Amount Status"; Rec."Security Amount Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetControlVisibility();
                        if ShowTerminationCharges then
                            FetchAdditionalChargesData();
                        CurrPage.Update();
                    end;
                }
            }
            // group(Adjust_Installment)
            // {
            //     Visible = ShowAdjustInstallment;
            //     field("Payment Series"; Rec."Payment Series")
            //     {
            //         ApplicationArea = All;

            //         // Trasfer from Table Start  
            //         trigger OnLookup(var Text: Text): Boolean
            //         var
            //             PaymentMode2Rec: Record "Payment Mode2";
            //             Selection: Page "Payment Mode2 List";
            //             SelectedPaymentSeries: Text[250];
            //             TotalAmount: Decimal;
            //             TotalVATAmount: Decimal;
            //             TotalAmountInclVAT: Decimal;
            //         begin
            //             // First check if Contract ID is selected
            //             if Rec."Contract ID" = 0 then
            //                 Error('Please select a Contract ID first');

            //             // Filter Payment Mode2 records based on Contract ID
            //             PaymentMode2Rec.Reset();
            //             PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");

            //             Selection.LookupMode(true);
            //             Selection.SetTableView(PaymentMode2Rec);

            //             if Selection.RunModal() = ACTION::LookupOK then begin
            //                 // Clear totals
            //                 Clear(TotalAmount);
            //                 Clear(TotalVATAmount);
            //                 Clear(TotalAmountInclVAT);
            //                 Clear(SelectedPaymentSeries);

            //                 Selection.SetSelectionFilter(PaymentMode2Rec);
            //                 if PaymentMode2Rec.FindSet() then begin
            //                     repeat
            //                         // Add to payment series string
            //                         if SelectedPaymentSeries <> '' then
            //                             SelectedPaymentSeries := SelectedPaymentSeries + ',';
            //                         SelectedPaymentSeries := SelectedPaymentSeries + PaymentMode2Rec."Payment Series";

            //                         // Sum up amounts
            //                         TotalAmount += PaymentMode2Rec.Amount;
            //                         TotalVATAmount += PaymentMode2Rec."VAT Amount";
            //                         TotalAmountInclVAT += PaymentMode2Rec."Amount Including VAT";
            //                     until PaymentMode2Rec.Next() = 0;

            //                     // Set all values to the record
            //                     Rec."Payment Series" := SelectedPaymentSeries;
            //                     Rec.Amount := TotalAmount;
            //                     Rec."VAT Amount" := TotalVATAmount;
            //                     Rec."Amount Including VAT" := TotalAmountInclVAT;
            //                 end;
            //             end;
            //         end;
            //         // Trasfer from Table End
            //     }
            //     field(Amount; Rec.Amount)
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("VAT Amount"; Rec."VAT Amount")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Amount Including VAT"; Rec."Amount Including VAT")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Due Date"; Rec."Due Date")
            //     {
            //         ApplicationArea = All;
            //     }
            // }
            group(Termination_Charges)
            {
                Visible = ShowTerminationCharges;
                part(TerminationChargesLines; "Termination Charges Sub Card")
                {
                    ApplicationArea = All;
                    SubPageLink = "Contract ID" = field("Contract ID");  // Changed from ID to Contract ID
                    UpdatePropagation = Both;
                }
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post Entry';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SecurityDepositEntry: Record "Security Deposit Entry";
                    terminationcharges: Record "Termination Charges Sub";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // if (Rec."Security Amount Status" = Rec."Security Amount Status"::" ") then
                    //     Error('Please select Security Amount Status');

                    // if Rec.Amount = 0 then
                    //     Error('Amount must be specified');

                    // Create new entry
                    SecurityDepositEntry.Init();
                    SecurityDepositEntry."Security Deposit ID" := Rec.ID;
                    SecurityDepositEntry."Contract ID" := Rec."Contract ID";
                    SecurityDepositEntry."Main Security Deposit" := Rec."Main Security Deposit";
                    SecurityDepositEntry."Security Deposit" := Rec."Security Deposit";
                    SecurityDepositEntry."Start Date" := Rec."Contract Start Date";
                    SecurityDepositEntry."End Date" := Rec."Contract End Date";
                    SecurityDepositEntry.Status := Rec.Status; // Set initial status as Open
                    SecurityDepositEntry.Insert(true);
                    Message('Entry posted successfully!');

                    // Open the entries list
                    // Page.Run(Page::"Security Deposit Entries");
                end;
            }
        }
    }
    var
        ShowTerminationCharges: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility();
        if ShowTerminationCharges then
            FetchAdditionalChargesData();
    end;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     if (Rec."Status" = Rec."Status"::Approved) then begin
    //         AdditinalchargescashReceipt();
    //         //  receivablecashrecipt();
    //     end;
    // end;

    local procedure FetchAdditionalChargesData()
    var
        AdditionalCharges: Record "Additional Charges Sub";
        TerminationCharges: Record "Termination Charges Sub";
        FinalCalculation: Record "Final Calculation";
        NextEntryNo: Integer;
    begin
        if Rec."Contract ID" = 0 then
            exit;

        // Check if Final Calculation exists with same Contract ID
        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
        if not FinalCalculation.FindFirst() then
            exit;

        // Clear existing termination charges for this contract
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        TerminationCharges.DeleteAll();

        // Find the next available Entry No.
        if TerminationCharges.FindLast() then
            NextEntryNo := TerminationCharges."Entry No." + 1
        else
            NextEntryNo := 1; // If no records exist, start from 1

        // Copy data from Additional Charges to Termination Charges
        AdditionalCharges.SetRange("Contract ID", Rec."Contract ID");
        if AdditionalCharges.FindSet() then
            repeat
                TerminationCharges.Init();
                TerminationCharges."Entry No." := NextEntryNo; // Assign unique Entry No.
                TerminationCharges."Contract ID" := Rec."Contract ID";
                TerminationCharges."Secondary Item Type" := AdditionalCharges."Secondary Item Type";
                TerminationCharges.Amount := AdditionalCharges.Amount;
                TerminationCharges."VAT %" := AdditionalCharges."VAT %";
                TerminationCharges."VAT Amount" := AdditionalCharges."VAT Amount";
                TerminationCharges."Amount Including VAT" := AdditionalCharges."Amount Including VAT";
                TerminationCharges."Start Date" := AdditionalCharges."Start Date";
                TerminationCharges."End Date" := AdditionalCharges."End Date";
                TerminationCharges."Posted Invoice ID" := AdditionalCharges."Posted Invoice ID";

                TerminationCharges.Insert();
                NextEntryNo += 1; // Increment for the next record
            until AdditionalCharges.Next() = 0;
    end;

    local procedure SetControlVisibility()
    begin
        case Rec."Security Amount Status" of
            // Rec."Security Amount Status"::"Adjust Installment":
            //     begin
            //         ShowAdjustInstallment := true;
            //         ShowTerminationCharges := false;
            //     end;
            Rec."Security Amount Status"::"Termination Charges":
                begin
                    // ShowAdjustInstallment := false;
                    ShowTerminationCharges := true;

                    // Clear Adjust Installment fields
                    Rec."Payment Series" := '';
                    Rec.Amount := 0;
                    Rec."VAT Amount" := 0;
                    Rec."Amount Including VAT" := 0;
                    Rec."Due Date" := 0D;
                    Rec.Modify(false);
                end;
            // Rec."Security Amount Status"::"All Charges":  // NEW CASE for "All Charges"
            //     begin
            //         ShowAdjustInstallment := true;
            //         ShowTerminationCharges := true;
            //     end;
            else begin
                // ShowAdjustInstallment := false;
                ShowTerminationCharges := false;

                // Clear Adjust Installment fields
                // Rec."Payment Series" := '';
                // Rec.Amount := 0;
                // Rec."VAT Amount" := 0;
                // Rec."Amount Including VAT" := 0;
                // Rec."Due Date" := 0D;
                //  Rec.Modify(false);
            end;
        end;
    end;

}
