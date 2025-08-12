page 50908 "Secondary Item Card"
{
    PageType = Card;
    SourceTable = "Secondary Item";
    ApplicationArea = All;
    Caption = 'Secondary Item Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Secondary Item Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the unique system-generated ID for this record.';
                }

                field("Primary Item Type"; Rec."Primary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Item Type';
                    ToolTip = 'Select the associated Primary Item Type.';

                }
                field("Category Types"; Rec."Category Types")
                {
                    ApplicationArea = All;
                    Caption = 'Category Types';
                    ToolTip = 'Enter the Category Types.';
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("VAT Type"; Rec."VAT Type")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Type';
                    ToolTip = 'Enter the VAT Type.';
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }

                field("Charges Status"; Rec."Charges Status")
                {
                    ApplicationArea = All;
                    Caption = 'Charges Status';
                    ToolTip = 'Enter the Charges Status.';

                }
            }
        }
    }


}
