pageextension 50513 CustomerLedgerEntriesExt extends "Customer Ledger Entries"
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
        }
    }
}