page 50986 "Mangement Fee Master Card"
{
    SourceTable = "Management Fee MasterData";
    ApplicationArea = All;
    Caption = 'Management Fee Master Card';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    TableRelation = Vendor;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;


                }
            }
            part(ManagementFeeGrid; "Management Fee Grid ListPart")
            {
                SubPageLink = "Management Fee Number" = FIELD("Management Fee Number"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Management Fee Details';
                UpdatePropagation = Both;
            }
        }
    }


}