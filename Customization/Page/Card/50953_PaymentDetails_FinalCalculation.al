page 50953 "Payment Details"
{
    PageType = ListPart;
    SourceTable = "Payment Details";
    ApplicationArea = All;
    Caption = 'Payment Details';
    //UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;

                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if (Rec."Payment Date" > Rec."Termination Date") AND (Rec."Payment Status" <> 'Received') then begin
            Rec."Payment Status" := 'Due';
            StyleExprTxt := 'Unfavorable';
            Rec.Modify();
        end else begin
            StyleExprTxt := '   '
        end;
        if Rec."Payment Status" = 'Received' then begin
            Rec."Payment Status" := 'Paid';
            Rec.Modify();
        end;

    end;

    var
        StyleExprTxt: Text;
}