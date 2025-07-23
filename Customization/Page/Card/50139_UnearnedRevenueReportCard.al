page 50139 "Unearned Revenue Report Card"
{
    PageType = Card;
    SourceTable = "Unearned Revenue Report";
    ApplicationArea = All;
    Caption = 'Unearned Revenue Report';

    layout
    {
        area(Content)
        {
            group("Unearned Revenue Report")
            {
                Caption = 'Unearned Revenue Report';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     if xRec."No." <> Rec."No." then
                    //         ClearSubgridData();
                    // end;
                }
                field("Starting Date Year"; Rec."Starting Date Year")
                {
                    ApplicationArea = All;
                }
                field("Ending Date Year"; Rec."Ending Date Year")
                {
                    ApplicationArea = All;
                }
            }
            group("Unearned Revenue Report Report Details")
            {
                Caption = 'Unearned Revenue Report Details';
                part("Unearned Revenue Report Details"; "Sub Unearned Revenue Card")
                {
                    SubPageLink = "Header No." = field("No.");
                }
            }
        }
    }
}