pageextension 50516 ValueEntryExt extends "Value Entries"
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