pageextension 50514 GeneralLedgerEntriesExt extends "General Ledger Entries"
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