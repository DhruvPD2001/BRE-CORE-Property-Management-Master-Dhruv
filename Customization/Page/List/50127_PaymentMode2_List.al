page 50127 "Payment Mode2 List"
{
    PageType = List;
    SourceTable = "Payment Mode2";
    ApplicationArea = All;
    Caption = 'Payment Mode Grid List';
    //  UsageCategory = Lists;
    CardPageId = 50928;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
