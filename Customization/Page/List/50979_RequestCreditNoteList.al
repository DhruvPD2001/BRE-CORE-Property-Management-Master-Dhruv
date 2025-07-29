page 50979 "Request Credit Note List"
{
    PageType = List;
    SourceTable = "Request Credit Note";
    ApplicationArea = All;
    Caption = 'Request Credit Note List';
    UsageCategory = Lists;
    CardPageId = "Request Credit Note Card";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field("Adjust with Invoice"; Rec."Adjust with Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Adjust with Invoice';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
            }
        }
    }

}