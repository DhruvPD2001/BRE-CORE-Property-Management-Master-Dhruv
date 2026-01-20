page 50148 "Management Fee Calc. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Management Fee Calc. Header";
    Caption = 'Management Fee Calculation List';
    CardPageId = 50146;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(MgtFeeCalcList)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the entry number of the management fee calculation record.';
                }
                field("Report Date"; Rec."Report Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the management fee report.';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the owner for whom the management fee is calculated.';
                }
                field("All Owners"; Rec."All Owners")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the management fee calculation applies to all owners.';
                }
                field(Property; Rec.Property)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property associated with the management fee calculation.';
                }
                field("All Properties"; Rec."All Properties")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the management fee calculation applies to all properties.';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for the management fee calculation.';
                }
                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting period for the management fee calculation.';
                }
                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending period for the management fee calculation.';
                }
            }
        }
    }
}