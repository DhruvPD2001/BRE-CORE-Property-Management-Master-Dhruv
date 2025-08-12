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
                    ToolTip = 'Specifies the unique number assigned to this request.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the contract associated with this request.';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    ToolTip = 'Specifies the unique number of the tenant related to this request.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    ToolTip = 'Specifies the date when the request was submitted.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Indicates the current status of the request.';
                }
                field("Adjust with Invoice"; Rec."Adjust with Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Adjust with Invoice';
                    ToolTip = 'Specifies whether the request amount should be adjusted against an existing invoice.';
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(Approve)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Approve';
    //         }
    //         action(Reject)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Reject';
    //         }
    //     }
    // }

}