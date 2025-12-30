pageextension 50521 ApplyEntriesPageExt extends "Apply Customer Entries"
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