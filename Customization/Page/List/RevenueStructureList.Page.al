page 50913 "Revenue Structure List"
{
    PageType = List;
    SourceTable = "Revenue Structure";
    ApplicationArea = All;
    Caption = 'Revenue Structure List';
    UsageCategory = Lists;
    CardPageId = 50912;


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
                field("RS_ID"; Rec."RS ID")
                {
                    ApplicationArea = All;
                    Caption = 'RS_ID';
                    ToolTip = 'Specifies the unique Revenue Structure ID associated with the contract.';
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the secondary item linked to the contract, if applicable.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the monetary value related to this contract entry.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Specifies the date on which the contract becomes active.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Specifies the date on which the contract is scheduled to end.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Specifies the total number of payment instalments agreed upon in the contract.';
                }

            }
        }
    }

}
