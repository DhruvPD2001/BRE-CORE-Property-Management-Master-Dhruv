page 50961 "Brokerage Master Data List"
{
    PageType = List;
    SourceTable = "Brokerage Master Data";
    ApplicationArea = All;
    Caption = 'Brokerage Master Data';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique ID of the vendor associated with this record.';

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "Vendor Profile";
                    begin
                        VendorProfile.SetRange("Vendor ID", Rec."Vendor ID");
                        if VendorProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Vendor Profile Card", VendorProfile)
                        else
                            Message('No Vendor Profile found using FindFirst either.');
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the vendor associated with this record.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique ID of the tenancy contract linked to this record.';

                    trigger OnDrillDown()
                    var
                        tenancycontract: Record "Tenancy Contract";
                    begin
                        tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancycontract.FindSet() then
                            PAGE.RunModal(PAGE::"Tenancy Contract Card", tenancycontract)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique ID of the property associated with this record.';

                    trigger OnDrillDown()
                    var
                        PropertyProfile: Record "Property Registration";
                    begin
                        PropertyProfile.SetRange("Property ID", Rec."Property ID");
                        if PropertyProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Property Registration Card", PropertyProfile)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the property associated with this record.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates the start date of the contract or agreement.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates the end date of the contract or agreement.';
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of property, such as commercial or residential.';
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the method used for calculation (e.g., percentage or fixed amount).';
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The amount used as the base for percentage or fixed calculations.';
                }
                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of base amount used for calculations.';
                }
                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates whether the percentage is fixed, variable, or based on another factor.';
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the percentage value used in the calculation.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the calculated or fixed amount for this record.';
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies how often payments are made (e.g., monthly, quarterly).';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the current status of the contract (e.g., Active, Expired).';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the property owner.';
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the unique number assigned to the unit.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name or description of the unit.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the name of the tenant associated with this unit or contract.';
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique ID of the property owner.';
                }
            }
        }
    }

}
