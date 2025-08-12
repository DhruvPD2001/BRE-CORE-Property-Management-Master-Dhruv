page 50960 "Calculation Type List"
{
    PageType = List;
    SourceTable = "Calculation Type";
    ApplicationArea = All;
    Caption = 'Calculation Type List';
    UsageCategory = Lists;
    CardPageId = 50959;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    ToolTip = 'Specifies the unique identifier for the record.';
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Type';
                    ToolTip = 'Specifies the type of calculation applied for this record.';
                }
            }
        }
    }

}
