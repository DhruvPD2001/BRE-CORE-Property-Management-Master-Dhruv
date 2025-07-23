page 50142 "Sub Unearned Prking Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Sub Unearned Parking Report";
    Caption = 'Unearned Parking Revenue Report';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Header No."; Rec."Header No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Property; Rec.Property)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Suspension Date"; Rec."Suspension Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Other Charges Value"; Rec."Other Charges Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice Raised During the Year"; Rec."Invoice Raised During the Year")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("RevenueAllocated DuringtheYear"; Rec."RevenueAllocated DuringtheYear")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unearned Revenue Balance"; Rec."Unearned Revenue Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CalculatedUnearnedRevBalance; Rec.CalculatedUnearnedRevBalance)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortfall/Excess"; Rec."Shortfall/Excess")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}