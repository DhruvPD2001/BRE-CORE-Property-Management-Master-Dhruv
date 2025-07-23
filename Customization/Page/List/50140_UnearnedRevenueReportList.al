page 50140 "Unearned Revenue Report List"
{
    PageType = List;
    SourceTable = "Unearned Revenue Report";
    ApplicationArea = All;
    Caption = 'Unearned Revenue Report List';
    UsageCategory = Lists;
    CardPageId = 50139;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                }
                field("Starting Date Year"; Rec."Starting Date Year")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date Year';
                }
                field("Ending Date Year"; Rec."Ending Date Year")
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date Year';
                }
            }
        }
    }
}