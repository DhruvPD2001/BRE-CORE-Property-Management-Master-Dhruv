page 50146 "Management Fee Calc."
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Management Fee Calc. Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Report Date"; Rec."Report Date")
                {
                    ApplicationArea = All;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }
                field(Property; Rec.Property)
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                }
                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                }
            }
            part(ManagementFeeGrid; "Management Fee Calc Grid")
            {
                SubPageLink = "Primary Key" = FIELD("Primary Key"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Management Fee Details';
                UpdatePropagation = Both;
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}