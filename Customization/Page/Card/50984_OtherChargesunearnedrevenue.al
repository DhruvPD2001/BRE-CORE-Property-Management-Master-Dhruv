page 50984 "OtherCharges-UnearnedRevenue"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Other Charges UnearnedRevenue";
    Caption = 'Revenue Item';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }


    var
        No: Integer;

    procedure SetNo(pNo: Integer)
    begin
        No := pNo;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."No." := No;
        exit(true);
    end;
}