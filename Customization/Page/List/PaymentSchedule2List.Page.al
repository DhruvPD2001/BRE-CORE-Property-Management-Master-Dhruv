page 50925 "Payment Schedule2 List"
{
    PageType = List;
    SourceTable = "Payment Schedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Grid List';
    //  UsageCategory = Lists;
    CardPageId = 50922;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment series or reference number used to group related payment transactions.';
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the secondary item associated with this record, if applicable.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount before VAT for this record.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated VAT amount for this transaction.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount including VAT.';
                }
            }
        }
    }

}
