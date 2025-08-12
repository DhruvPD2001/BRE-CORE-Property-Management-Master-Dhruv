page 50956 "Vendor Category List"
{
    PageType = List;
    SourceTable = "Vendor Category";
    ApplicationArea = All;
    Caption = 'Vendor Category List';
    UsageCategory = Lists;
    CardPageId = 50955;

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
                field("Vendor Category Type"; Rec."Vendor Category Type")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Category Name';
                    ToolTip = 'Specifies the vendor category name associated with the vendor.';
                }
            }
        }
    }

}
