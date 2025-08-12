page 50904 "Category List"
{
    PageType = List;
    SourceTable = "Category Type";
    ApplicationArea = All;
    Caption = 'Category List';
    UsageCategory = Lists;
    CardPageId = 50905;

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
                    ToolTip = 'Specifies the main item linked to this record. Choose from the list of available primary items.';
                    Lookup = true;
                }
                field("Category Types"; Rec."Category Types")
                {
                    ApplicationArea = All;
                    Caption = 'Category Types';
                    ToolTip = 'Specifies the category type associated with the selected primary item.';
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
