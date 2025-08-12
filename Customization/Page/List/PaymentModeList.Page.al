page 50926 "Payment Mode List"
{
    PageType = List;
    SourceTable = "Payment Mode";
    ApplicationArea = All;
    Caption = 'Payment Mode List';
    UsageCategory = Lists;
    CardPageId = 50927;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract_ID';
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }

                field("Contract Start date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the contract becomes active.';
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the contract is scheduled to end.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'Specifies the unique identifier for the tenant linked to this contract.';
                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    ToolTip = 'Specifies the full name of the tenant associated with this contract.';
                }
            }
        }
    }

}
