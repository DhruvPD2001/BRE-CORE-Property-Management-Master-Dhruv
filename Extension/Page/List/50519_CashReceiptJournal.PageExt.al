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
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
                ToolTip = 'Specifies the type of transaction.';
            }

        }

    }
    actions
    {
        modify(Post)
        {
            ApplicationArea = All;
            // trigger OnBeforeAction()
            // var
            //     finalcalculationRec: Record "Final Calculation";
            //     AmountToDeduct: Decimal;
            // begin
            //     // Only apply adjustments for Cash Receipt Journal entries created by our Adjustment flow
            //     if (Rec."Journal Template Name" <> 'CASH RECE') then
            //         exit;

            //     if Rec."Document No." = '' then
            //         exit;

            //     if CopyStr(Rec."Document No.", 1, 11) <> 'ADJUSTMENT-' then
            //         exit;

            //     // Only process when Transaction Type indicates Adjustment
            //     if Rec."Transaction Type" <> 'Adjustment' then
            //         exit;

            //     // Determine positive amount to deduct (journal lines are payments and may be negative)
            //     AmountToDeduct := Rec.Amount;
            //     if AmountToDeduct < 0 then
            //         AmountToDeduct := -AmountToDeduct;

            //     finalcalculationRec.SetRange("Contract ID", Rec."Contract ID");
            //     if finalcalculationRec.FindFirst() then begin
            //         case Rec."Item Description" of
            //             'Security Deposit':
            //                 begin
            //                     if finalcalculationRec."Remaining Security Deposit" >= AmountToDeduct then
            //                         finalcalculationRec."Remaining Security Deposit" -= AmountToDeduct
            //                     else
            //                         finalcalculationRec."Remaining Security Deposit" := 0;
            //                 end;
            //             'Chiller Deposit':
            //                 begin
            //                     if finalcalculationRec."Remaining Chiller Deposit" >= AmountToDeduct then
            //                         finalcalculationRec."Remaining Chiller Deposit" -= AmountToDeduct
            //                     else
            //                         finalcalculationRec."Remaining Chiller Deposit" := 0;
            //                 end;
            //             'Other Deposit':
            //                 begin
            //                     if finalcalculationRec."Remaining Other Deposit" >= AmountToDeduct then
            //                         finalcalculationRec."Remaining Other Deposit" -= AmountToDeduct
            //                     else
            //                         finalcalculationRec."Remaining Other Deposit" := 0;
            //                 end;
            //         end;
            //         finalcalculationRec.Modify();
            //     end;
            // end;
        }
    }

}