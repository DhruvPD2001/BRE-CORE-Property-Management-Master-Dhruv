page 50980 "Request Credit Note Card"
{
    PageType = Card;
    SourceTable = "Request Credit Note";
    ApplicationArea = All;
    Caption = 'Request Credit Note Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    TableRelation = "Tenancy Contract";
                    trigger OnValidate()
                    var
                        TenancyContract: Record "Tenancy Contract";
                    begin
                        if Rec."Contract ID" <> 0 then begin
                            if not TenancyContract.Get(Rec."Contract ID") then
                                Error('The specified Contract ID does not exist.');
                            Rec."Tenant No." := TenancyContract."Tenant ID";
                            Rec."Customer Name" := TenancyContract."Customer Name";
                            Rec."Payment Frequency" := Format(TenancyContract."Payment Frequency");
                            Rec."Property Name" := TenancyContract."Property Name";
                            Rec."Property Classification" := TenancyContract."Property Classification";

                        end else begin
                            Rec."Tenant No." := '';
                            Rec."Customer Name" := '';
                            Rec."Payment Frequency" := '';
                            Rec."Property Name" := '';
                            Rec."Property Classification" := '';
                        end;
                    end;
                    // The ID is not editable since it's auto-incrementing
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false; // The name is not editable
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false; // The name is not editable
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    // The date is not editable
                }
                field(Reason; Rec.Reason)

                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                    // Allow editing for the reason
                }
                field("Request Source"; Rec."Request Source")
                {
                    ApplicationArea = All;
                    Caption = 'Request Source';
                    // Allow editing for the request source
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = IsFinanceManager;
                }
                field(Remark; Rec."Reason for Rejection")
                {
                    ApplicationArea = All;
                    Caption = 'Reason for Rejection';
                    MultiLine = true;
                    Editable = false; // Allow editing for the remark
                    // Allow editing for the remark
                }
                field("Adjust with Invoice"; Rec."Adjust with Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Adjust with Invoice';
                }
            }
            part("Request Credit Note Lines"; "Request CreditNote Grid")
            {
                SubPageLink = "Request No." = FIELD("Request No.");
                ApplicationArea = All;
                Caption = 'Request Credit Note Lines';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Submit for Approval")
            {
                ApplicationArea = All;
                Caption = 'Submit for Approval';
                Visible = CanSubmitForApproval;

                trigger OnAction()
                var
                    RequestCreditnoteapproval: Codeunit "Approval Request Crdit note ";
                begin
                    RequestCreditnoteapproval.SubmitCreditNote(Rec);
                    Dialog.Message('Email sent for approval.');
                    Dialog.Message('Your request has been submitted successfully.');
                end;
            }

        }
        area(Promoted)
        {
            actionref(submitforapproval; "Submit for Approval")
            {

            }
        }
    }






    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin

        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."Contract ID");
    end;



    trigger OnAfterGetRecord()
    var
    begin

        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."Contract ID");
        IsFinanceManager := CheckUserRole();
        CanSubmitForApproval := (Rec.Status in [Rec.Status::" ", Rec.Status::Rejected]);
    end;

    trigger OnOpenPage()
    var
    begin
        IsFinanceManager := CheckUserRole();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then begin
            case UserPersonalization."Profile ID" of
                'FINANCE MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;
        end;
        exit(false);
    end;

    var
        CanSubmitForApproval: Boolean;
        IsFinanceManager: Boolean;

}