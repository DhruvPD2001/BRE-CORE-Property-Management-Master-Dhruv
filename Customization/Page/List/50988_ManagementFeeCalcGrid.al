page 50988 "Management Fee Calc Grid"
{
    PageType = ListPart;
    SourceTable = "Management Fee Calc. Line";
    ApplicationArea = All;
    Caption = 'Management Fee Agreements';
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'System-generated entry number for the management fee record.';
                    Editable = false;
                    Visible = false;

                }
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Caption = 'PMC Vendor ID';
                    ToolTip = 'Specifies the vendor ID of the property management company.';
                    Editable = false;
                    Visible = false;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    Visible = false;
                    Editable = false;
                }
                field("Property Management Company"; Rec."Property Management Company")
                {
                    ApplicationArea = All;
                    Caption = 'Property Management Company';
                    ToolTip = 'Specifies the name of the property management company responsible for managing the property.';
                    Editable = false;
                }
                field("Company/Owner Name"; Rec."Company/Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company / Owner Name';
                    ToolTip = 'Specifies the legal owner of the property.';
                    Editable = false;


                }

                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property for which the management fee is defined.';
                    Editable = false;
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies whether the property is Residential or Commercial.';
                    Editable = false;
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Method';
                    ToolTip = 'Specifies how the management fee is calculated, such as percentage of revenue, annual rent, collections, per unit, or hybrid.';
                    Editable = false;

                }

                field("Calculation Sub-Type"; Rec."Calculation Sub-Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Sub-Type';
                    ToolTip = 'Specifies whether the calculation is percentage-based or a fixed amount.';
                    Editable = false;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage Type';
                    ToolTip = 'Specifies whether the percentage applied is fixed or variable.';
                    Editable = false;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                    ToolTip = 'Specifies the agreed Percentage for management fee calculation.';
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the agreed fixed amount for management fee calculation.';
                    Editable = false;
                }

                field("Base Amount Source"; Rec."Base Amount Source")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Source';
                    ToolTip = 'Specifies the base amount used for fee calculation, such as revenue, collections, or annual rent.';
                    Editable = false;
                }

                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount';
                    Editable = false;
                }
                field("Management Fee"; Rec."Management Fee")
                {
                    ApplicationArea = All;
                    Caption = 'Management Fee';
                    Editable = false;
                }
                field("Validity Period"; Rec."Validity Period")
                {
                    ApplicationArea = All;
                    Caption = 'Validity Period';
                    Editable = false;
                    Visible = false;
                }
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = All;
                    Caption = 'Valid From';
                    ToolTip = 'Specifies the start date from which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = All;
                    Caption = 'Valid To';
                    ToolTip = 'Specifies the end date until which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'Indicates whether the management fee contract is active or expired.';
                    Editable = false;
                    Visible = false;
                    //   Editable = false;
                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(ShowCalculation)
            {
                Caption = 'Show Entries';
                Image = Entries;
                trigger OnAction()
                begin

                end;

            }
        }
    }
}
