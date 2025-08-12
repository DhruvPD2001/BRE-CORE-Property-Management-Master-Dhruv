page 50948 "Rent Calculation List"
{
    PageType = List;
    SourceTable = "Rent Calculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation List';
    UsageCategory = Lists;
    CardPageId = 50945;


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
                field("RC_ID"; Rec."RC ID")
                {
                    ApplicationArea = All;
                    Caption = 'RC_ID';
                    ToolTip = 'Specifies the unique Revenue Calculation ID linked to this record.';
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the secondary item associated with this contract, if applicable.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the monetary value for this contract entry, excluding VAT.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Specifies the date when the contract becomes active.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Specifies the date when the contract is scheduled to end.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Specifies the total number of payment instalments agreed upon for this contract.';
                }

            }
        }
    }

}
