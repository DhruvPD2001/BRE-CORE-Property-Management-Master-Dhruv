page 50907 "Secondary Item List"
{
    PageType = List;
    SourceTable = "Secondary Item";
    ApplicationArea = All;
    Caption = 'Secondary Item List';
    UsageCategory = Lists;
    CardPageId = 50908;

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
                    Caption = 'Primary Item';
                    TableRelation = "Primary Item";
                    ToolTip = 'Specifies the main item associated with this record. Select from the list of available primary items.';
                    Lookup = true;
                }
                field("Category Types"; Rec."Category Types")
                {
                    ApplicationArea = All;
                    Caption = 'Category Types';
                    TableRelation = "Category Type";
                    ToolTip = 'Specifies the category type linked to the selected primary item.';
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the secondary item associated with this record, if applicable.';
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Specifies the VAT (Value-Added Tax) percentage applicable to this item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.Init();
                    Rec.Insert(true);
                    CurrPage.Update();
                end;
            }
        }
    }


}
