page 50910 "Rent Calculate Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    // UsageCategory = Administration;
    SourceTable = "Rent Calculate Sub";


    layout
    {
        area(Content)
        {
            repeater(Group)

            {

                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                    Editable = false;
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                }

                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                }

                field("Number of Days"; Rec."Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                }

                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ShowMandatory = true;
                    NotBlank = true;


                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }

            }
            group(" ")
            {

                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = All;
                }

                field("Total Final Annual Amount"; Rec."Total Final Annual Amount")
                {
                    ApplicationArea = All;
                }

            }

        }


    }


    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;
        // Rec."Proposal ID" := proposalID;
        // RevenuestructureID := RevenuestructureRec."RS ID"; // Automatically generated ID

    end;

    var
        ContractID: Integer;
        proposalID: Integer;
        tenantID: Code[20];






}









