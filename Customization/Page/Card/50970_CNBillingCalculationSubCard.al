page 50970 "Billing Calculation CN Card"
{
    PageType = ListPart;
    SourceTable = "Billing Calculation CN";
    ApplicationArea = All;
    Caption = 'Billing Calculation CN Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                // field("ID"; Rec."ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("Credit Note ID"; Rec."Credit Note ID")
                {
                    ApplicationArea = all;
                    Caption = 'Credit Note ID';
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Item"; Rec."Item")
                {
                    ApplicationArea = All;
                    Caption = 'Item';
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Editable = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Editable = false;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    Editable = false;
                }
            }
            field("Total Amount"; Rec."Total Amount")
            {
                ApplicationArea = All;
            }
        }
    }
}