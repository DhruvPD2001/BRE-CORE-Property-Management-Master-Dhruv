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
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

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
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("Unit ID"; Rec."Unit ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

}
