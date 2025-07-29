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
                }
                field("Contract Start Date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                }

                field("Contract End Date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
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
                // field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Total Amount Including VAT';

                // }


            }
        }
    }

}
