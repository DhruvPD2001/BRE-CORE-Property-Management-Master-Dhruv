page 50136 "Overdue Payments List" // Use an appropriate page number
{
    PageType = List;
    SourceTable = "Payment Mode2"; // Replace with your actual payment table
    ApplicationArea = All;
    Caption = 'Overdue Payments';
    // UsageCategory = Lists;

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;  // Shows in red
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Days Overdue"; CalcDaysOverdue())
                {
                    ApplicationArea = All;
                    Caption = 'Days Overdue';
                    Style = Unfavorable;  // Shows in red
                }
                // Include payment status if available
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Unfavorable';
                }
                // Add any other relevant fields
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Filter only by payment status being Overdue
        Rec.SetRange("Payment Status", Rec."Payment Status"::Overdue);
    end;

    local procedure CalcDaysOverdue(): Integer
    begin
        if Rec."Due Date" = 0D then
            exit(0);

        exit(TODAY - Rec."Due Date");
    end;
}