page 50931 "Revenue Recognition List"
{
    PageType = List;
    SourceTable = "Revenue Recognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Rent List';
    UsageCategory = Lists;
    CardPageId = 50930;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("RR Id"; Rec."RR Id")
                {
                    ApplicationArea = All;
                    Caption = 'RR Id';
                    ToolTip = 'Specifies the unique Revenue Recognition (RR) identifier for this entry.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the unique identifier for the contract associated with this record.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'Specifies the unique identifier for the tenant linked to the contract.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the date when this record or contract period begins.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the date when this record or contract period ends.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Specifies the total monetary value agreed upon in the contract.';
                }
            }
        }
    }

}
