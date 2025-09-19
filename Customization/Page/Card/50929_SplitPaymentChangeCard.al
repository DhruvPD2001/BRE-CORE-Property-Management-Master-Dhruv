page 50929 "Split Payment Change Card"
{
    PageType = ListPart;
    SourceTable = "Split Payment Change";
    ApplicationArea = All;
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }

                field("Split Payment Series"; Rec."Split Payment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Series';

                    // Trasfer from Table Start
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentMode2Rec: Record "Payment Mode2";
                        Selection: Page "Payment Mode2 List";
                        ExistingSeries: Text;
                        SplitPayChange: Record "Split Payment Change";
                    begin
                        // Ensure Contract ID is selected first
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // ✅ Check if any line already has a Payment Series
                        SplitPayChange.Reset();
                        SplitPayChange.SetRange("Contract ID", Rec."Contract ID");
                        if SplitPayChange.FindFirst() then
                            ExistingSeries := SplitPayChange."Split Payment Series";

                        // Filter Payment Mode2 records based on Contract ID
                        PaymentMode2Rec.Reset();
                        PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentMode2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            Selection.SetSelectionFilter(PaymentMode2Rec);

                            if PaymentMode2Rec.FindSet() then
                                // ✅ Validation: check against existing series
                                if (ExistingSeries <> '') and (ExistingSeries <> PaymentMode2Rec."Payment Series") then
                                    Error(
                                      'You can only select the same Payment Series (%1) for all lines.',
                                      ExistingSeries);

                            if PaymentMode2Rec.FindSet() then begin
                                Rec."Split Payment Series" := PaymentMode2Rec."Payment Series"; // Select only one value
                            end;
                        end;
                    end;
                    // Trasfer from Table End
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';

                    // Trasfer from Table Star

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentSchedule2Rec: Record "Payment Schedule2";
                        SelectedSchedule: Record "Payment Schedule2";
                        Selection: Page "Payment Schedule2 List";
                        TempSelected: Record "Payment Schedule2" temporary;
                        NewLine: Record "Split Payment Change"; // Table where split lines are stored
                        // For totals
                        TotalAmount: Decimal;
                        TotalVATAmount: Decimal;
                        TotalAmountInclVAT: Decimal;
                        SelectedPaymentSeries: Text[250];
                        UnselectedPaymentSeries: Text[250];
                    begin
                        // ✅ Contract ID validation
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // ✅ Filter Payment Schedule2 records for current Contract & Payment Series
                        PaymentSchedule2Rec.Reset();
                        PaymentSchedule2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSchedule2Rec.SetRange("Payment Series", Rec."Split Payment Series");

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentSchedule2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            // ✅ Clear Totals
                            Clear(TotalAmount);
                            Clear(TotalVATAmount);
                            Clear(TotalAmountInclVAT);
                            Clear(SelectedPaymentSeries);

                            // ✅ Get selected rows
                            Selection.SetSelectionFilter(SelectedSchedule);
                            if SelectedSchedule.FindSet() then
                                repeat
                                    // Store in temporary buffer
                                    TempSelected.Init();
                                    TempSelected.TransferFields(SelectedSchedule);
                                    TempSelected.Insert();

                                    // Build comma-separated Secondary Item list
                                    if SelectedPaymentSeries <> '' then
                                        SelectedPaymentSeries += ', ';
                                    SelectedPaymentSeries += SelectedSchedule."Secondary Item Type";

                                    // Sum up selected amounts
                                    TotalAmount += SelectedSchedule.Amount;
                                    TotalVATAmount += SelectedSchedule."VAT Amount";
                                    TotalAmountInclVAT += SelectedSchedule."Amount Including VAT";
                                until SelectedSchedule.Next() = 0;

                            // ✅ Update CURRENT LINE with totals of selected items
                            Rec."Secondary Item Type" := SelectedPaymentSeries;
                            Rec."Split Amount" := TotalAmount;
                            Rec."Split VAT Amount" := TotalVATAmount;
                            Rec."Split Amount Including VAT" := TotalAmountInclVAT;
                            Rec.Modify();

                            Clear(TotalAmount);
                            Clear(TotalVATAmount);
                            Clear(TotalAmountInclVAT);

                            // ✅ Insert new lines for UNSELECTED items
                            PaymentSchedule2Rec.Reset();
                            PaymentSchedule2Rec.SetRange("Contract ID", Rec."Contract ID");
                            PaymentSchedule2Rec.SetRange("Payment Series", Rec."Split Payment Series");

                            if PaymentSchedule2Rec.FindSet() then
                                repeat
                                    // Check if current record was NOT selected
                                    TempSelected.SetRange("Contract ID", PaymentSchedule2Rec."Contract ID");
                                    TempSelected.SetRange("Payment Series", PaymentSchedule2Rec."Payment Series");
                                    TempSelected.SetRange("Entry No.", PaymentSchedule2Rec."Entry No.");

                                    if not TempSelected.FindFirst() then begin
                                        if UnselectedPaymentSeries <> '' then
                                            UnselectedPaymentSeries += ', ';
                                        UnselectedPaymentSeries += Format(PaymentSchedule2Rec."Secondary Item Type");

                                        TotalAmount += PaymentSchedule2Rec.Amount;
                                        TotalVATAmount += PaymentSchedule2Rec."VAT Amount";
                                        TotalAmountInclVAT += PaymentSchedule2Rec."Amount Including VAT";
                                    end;
                                until PaymentSchedule2Rec.Next() = 0;

                            NewLine.Init();
                            NewLine."Contract ID" := Rec."Contract ID";
                            NewLine."Tenant Id" := Rec."Tenant Id";
                            NewLine."Split Payment Series" := Rec."Split Payment Series";
                            NewLine."Secondary Item Type" := UnselectedPaymentSeries;
                            NewLine."Split Amount" := TotalAmount;
                            NewLine."Split VAT Amount" := TotalVATAmount;
                            NewLine."Split Amount Including VAT" := TotalAmountInclVAT;
                            NewLine.Insert();
                            Clear(NewLine);
                        end;

                        CurrPage.Update(true);
                    end;

                }
                field("Split Due Date"; Rec."Split Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Split Due Date';
                }
                field("Split Payment Mode"; Rec."Split Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Mode';
                }

                field("Split Amount"; Rec."Split Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount';
                }

                field("Split VAT Amount"; Rec."Split VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split VAT Amount';
                }

                field("Split Amount Including VAT"; Rec."Split Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount Including VAT';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';

                }

            }

        }

    }

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;

    end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Tenant ID" := tenantID;
        Rec."Contract ID" := ContractID;
    end;

    var
        tenantID: Code[20];
        ContractID: Integer;

}