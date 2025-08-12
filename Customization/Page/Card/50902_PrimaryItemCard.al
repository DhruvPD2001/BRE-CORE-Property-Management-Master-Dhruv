page 50902 "Primary Item Card"
{
    PageType = Card;
    SourceTable = "Primary Item";
    ApplicationArea = All;
    Caption = 'Primary Item Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Primary Item Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the unique system-generated ID for this record.';
                }
                field("Primary Item Type"; Rec."Primary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification Name';
                    ToolTip = 'Enter the primary classification name.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }


}



