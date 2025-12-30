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
}