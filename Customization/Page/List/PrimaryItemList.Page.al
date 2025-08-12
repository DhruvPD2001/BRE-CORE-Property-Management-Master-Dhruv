page 50901 "Primary Item List"
{
    PageType = List;
    SourceTable = "Primary Item";
    ApplicationArea = All;
    Caption = 'Primary Item List';
    UsageCategory = Lists;
    CardPageId = 50902;

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
                    ToolTip = 'Specifies the unique identifier for this record.';
                }
                field("Primary Item Type"; Rec."Primary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Item Name';
                    ToolTip = 'Specifies the main item type or category associated with this record.';
                }
            }
        }
    }

}
