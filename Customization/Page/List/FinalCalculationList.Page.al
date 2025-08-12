page 50900 "Final Calculation List"
{
    PageType = List;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation List';
    UsageCategory = Lists;
    CardPageId = 50903;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }
                field("FC_ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final Calculation or related reference for the contract.';
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of unit associated with this contract, such as residential or commercial.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total agreed monetary value for the contract.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the contract becomes effective.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the contract is scheduled to end.';
                }

                field("Initmation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the tenant or owner was informed about the contract status.';
                }

                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the contract is officially terminated.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'Specifies the unique identifier of the tenant associated with the contract.';
                }

                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the initially agreed duration of the contract, typically in months or years.';
                }


                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the actual time period the contract remained active.';
                }
            }
        }
    }

}
