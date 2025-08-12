page 50937 "Payment Type List"
{
    PageType = List;
    SourceTable = "Payment Type";
    ApplicationArea = All;
    Caption = 'Payment Type List';
    UsageCategory = Lists;
    CardPageId = 50936;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment ID"; Rec."Payment ID")
                {
                    ApplicationArea = All;
                    Caption = 'Payment ID';
                    ToolTip = 'Specifies the unique identifier for the payment record.';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method';
                    ToolTip = 'Specifies the method used to make the payment, such as cash, bank transfer, or cheque.';
                }
            }
        }
    }

}
