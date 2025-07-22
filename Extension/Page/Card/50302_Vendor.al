pageextension 50302 Vendor extends "Vendor Card"
{
    layout
    {

        modify("Country/Region Code")
        {
            Visible = false;
        }

        modify(City)
        {
            Visible = false;
        }

        modify("Post Code")
        {
            Visible = false;
        }
        modify(ShowMap)
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }

        addafter("Blocked")
        {
            field("Vendor Category"; Rec."Vendor Category")
            {
                ApplicationArea = All;
                Caption = 'Vendor Category';
                TableRelation = "Vendor Category"."Vendor Category Type";
            }
        }

        addafter("Address 2")
        {
            field("Country"; Rec."Country")
            {
                ApplicationArea = All;
                Caption = 'Country';
                TableRelation = Country."Country Code";
            }
        }
        addafter("Country")
        {
            field("Emirate"; Rec."Emirate Name")
            {
                ApplicationArea = All;
                Caption = 'Emirate';
                TableRelation = Emirate."Emirate Name" where("Country Code" = field(Country));
            }
        }

        addafter("Emirate")
        {
            field("Community"; Rec."Community")
            {
                ApplicationArea = All;
                Caption = 'Community';
                TableRelation = Community."Community Name" where("Emirate Name" = field("Emirate Name"));
            }
        }
    }
}