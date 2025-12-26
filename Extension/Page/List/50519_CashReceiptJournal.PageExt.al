pageextension 50519 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                Caption = 'Item Description';
                ToolTip = 'Specifies the description of the item.';
                Editable = false;
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
                ToolTip = 'Specifies the type of transaction.';
                Editable = false;
            }

        }

    }
    actions
    {
        modify(Post)
        {
            ApplicationArea = All;
            trigger OnBeforeAction()
            var
                finalcalculationRec: Record "Final Calculation";
                cashRecJournalLine: Record "Gen. Journal Line";
                tenancyContractRec: Record "Tenancy Contract";
                AmountToDeduct: Decimal;
            begin
                cashRecJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                cashRecJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                if cashRecJournalLine.FindSet() then
                    repeat

                        // Only apply adjustments for Cash Receipt Journal entries created by our Adjustment flow
                        if (cashRecJournalLine."Journal Template Name" <> 'CASH RECE') then
                            exit;

                        if cashRecJournalLine."Document No." = '' then
                            exit;

                        // Only process when Transaction Type indicates Adjustment
                        if cashRecJournalLine."Transaction Type" <> cashRecJournalLine."Transaction Type"::Adjustment then
                            exit;

                        // Determine positive amount to deduct (journal lines are payments and may be negative)
                        AmountToDeduct := cashRecJournalLine.Amount;
                        if AmountToDeduct < 0 then
                            AmountToDeduct := -AmountToDeduct;

                        finalcalculationRec.SetRange("Contract ID", cashRecJournalLine."Contract ID");
                        if finalcalculationRec.FindFirst() then
                            case Format(cashRecJournalLine."Item Description") of
                                'Security Deposit':
                                    begin
                                        if finalcalculationRec."Security Deposit" >= AmountToDeduct then
                                            finalcalculationRec."Remaining Security Deposit" := finalcalculationRec."Security Deposit" - AmountToDeduct
                                        else
                                            finalcalculationRec."Remaining Security Deposit" := 0;
                                        if tenancyContractRec.Get(cashRecJournalLine."Contract ID") then begin
                                            tenancyContractRec.Validate(Adjustments, tenancyContractRec.Adjustments + AmountToDeduct);
                                            tenancyContractRec.Modify();
                                        end;
                                    end;
                                'Chiller Deposit':
                                    begin
                                        if finalcalculationRec."Chiller Deposit" >= AmountToDeduct then
                                            finalcalculationRec."Remaining Chiller Deposit" := finalcalculationRec."Chiller Deposit" - AmountToDeduct
                                        else
                                            finalcalculationRec."Remaining Chiller Deposit" := 0;
                                    end;
                                'Other Deposit':
                                    begin
                                        if finalcalculationRec."Other Deposit" >= AmountToDeduct then
                                            finalcalculationRec."Remaining Other Deposit" := finalcalculationRec."Other Deposit" - AmountToDeduct
                                        else
                                            finalcalculationRec."Remaining Other Deposit" := 0;
                                    end;
                            end;
                        finalcalculationRec.Modify();

                    until cashRecJournalLine.Next() = 0;
            end;
        }
    }

}