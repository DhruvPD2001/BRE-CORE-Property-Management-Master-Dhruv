pageextension 50512 "PostedsalesinvoiceList" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
            }
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
            }
        }
    }
}