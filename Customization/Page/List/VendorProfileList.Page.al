page 50944 "Vendor Profile List"
{
    PageType = List;
    SourceTable = "Vendor Profile";
    ApplicationArea = All;
    Caption = 'Vendor Profiles';
    UsageCategory = Lists;
    CardPageId = 50942;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the vendor.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the vendor.';
                }
                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number for the vendor.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the vendor contract or engagement begins.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the vendor contract or engagement ends.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the vendor contract, such as Active, Expired, or Terminated.';
                }
            }
        }
    }

}
