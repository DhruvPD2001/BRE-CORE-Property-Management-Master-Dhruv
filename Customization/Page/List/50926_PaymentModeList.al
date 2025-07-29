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
                }

                // field("PS ID"; Rec."PS ID")
                // {
                //     ApplicationArea = All;
                //     Caption = 'PS_ID';
                // }
                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Proposal ID';
                // }

                field("Contract Start date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                }


            }
        }
    }

}
