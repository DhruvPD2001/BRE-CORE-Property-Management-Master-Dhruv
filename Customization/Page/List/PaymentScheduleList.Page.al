page 50923 "Payment Schedule List"
{
    PageType = List;
    SourceTable = "Payment Schedule";
    ApplicationArea = All;
    Caption = 'Payment Schedule List';
    UsageCategory = Lists;
    CardPageId = 50921;


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
                field("Contract Start Date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Specifies the date when the contract becomes active.';
                }

                field("Contract End Date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
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
