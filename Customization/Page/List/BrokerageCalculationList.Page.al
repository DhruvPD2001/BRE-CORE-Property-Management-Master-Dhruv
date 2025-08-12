page 50962 "Brokerage Calculation List"
{
    PageType = List;
    SourceTable = "Brokerage Calculation";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation List';
    UsageCategory = Lists;
    CardPageId = 50963;

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
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    ToolTip = 'Specifies the unique identifier of the owner associated with this record.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'Specifies the unique identifier of the property linked to this record.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the date when the record or agreement becomes effective.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the date when the record or agreement ends.';
                }

            }
        }
    }

}
