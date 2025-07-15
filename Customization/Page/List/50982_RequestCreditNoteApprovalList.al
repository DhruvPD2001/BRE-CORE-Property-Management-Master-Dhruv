page 50982 "RequestCreditNoteApprovalList"
{
    PageType = List;
    SourceTable = RequestCreditNoteApprovalList;
    ApplicationArea = All;
    Caption = 'Request Credit Note Approval List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Editable = false;
                }
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        RequestCreditNote: Record "Request Credit Note";
                    begin
                        RequestCreditNote.SetRange("Request No.", Rec."Request No.");
                        if RequestCreditNote.FindSet() then
                            PAGE.RunModal(PAGE::"Request Credit Note Card", RequestCreditNote)
                        else
                            Message('No Request Credit Note found using FindFirst either.');
                    end;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
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
                Visible = IsFinanceManager;
                Image = Approve;

                trigger OnAction()

                var
                    SelectedRec: Record RequestCreditNoteApprovalList;
                    RequestCreditNote: Record "Request Credit Note";
                    RemarkDialog: Page "DialogBoxForInvoiceRejection";
                    RemarkText: Text;
                    DialogResult: Action;
                    // 💡 Include your codeunit
                    RecipientEmail: Text; // ✅ Add this
                    GenerateCreditMemo: Codeunit "Credit Memo Generate"; // ✅ Add this

                begin
                    if Rec.Status = 'Pending' then begin


                        // if DialogResult = Action::OK then begin
                        //     RemarkText := RemarkDialog.GetReason();

                        //     if RemarkText <> '' then begin
                        // Update approval table
                        SelectedRec := Rec;
                        SelectedRec.Status := 'Approved';
                        SelectedRec.Modify();

                        // Update all matching Vendor Proposal records
                        RequestCreditNote.SetRange("Request No.", SelectedRec."Request No.");
                        RequestCreditNote.SetRange("Contract ID", SelectedRec."Contract ID");
                        if RequestCreditNote.FindSet() then begin
                            repeat

                                RequestCreditNote.Status := RequestCreditNote.Status::Approved;
                                RequestCreditNote.Modify();
                            until RequestCreditNote.Next() = 0;
                        end;



                        Commit();
                        CurrPage.Update();
                        Message('Request Approved Successfully with Remarks for Contract ID: %1', SelectedRec."Contract ID");
                        GenerateCreditMemo.GenerateCreditMemo(SelectedRec);

                        //     end;
                        // end;
                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Visible = IsFinanceManager;
                Image = Reject;

                trigger OnAction()
                var
                    SelectedRec: Record "RequestCreditNoteApprovalList";
                    RequestCreditNote1: Record "Request credit Note";
                    RemarkDialog: Page "DialogBoxForInvoiceRejection";
                    RemarkText: Text;
                    DialogResult: Action;
                begin
                    if Rec.Status = 'Pending' then begin
                        DialogResult := RemarkDialog.RunModal();

                        if DialogResult = Action::OK then begin
                            RemarkText := RemarkDialog.GetReason();

                            if RemarkText <> '' then begin
                                // Update in approval table
                                SelectedRec := Rec;
                                SelectedRec.Status := 'Rejected';
                                SelectedRec.Remark := RemarkText;
                                SelectedRec.Modify();

                                // Update in vendor proposal table
                                RequestCreditNote1.SetRange("Request No.", SelectedRec."Request No.");
                                RequestCreditNote1.SetRange("Contract ID", SelectedRec."Contract ID");
                                if RequestCreditNote1.FindSet() then begin
                                    repeat
                                        RequestCreditNote1."Reason for Rejection" := RemarkText;
                                        RequestCreditNote1.Status := RequestCreditNote1.Status::Rejected;
                                        RequestCreditNote1.Modify();
                                        RequestCreditNote1.Modify();
                                    until RequestCreditNote1.Next() = 0;
                                end;

                                Commit();
                                CurrPage.Update();
                                Message('Request Rejected with Remark.');
                            end;
                        end;
                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(ApproveRecrord; Approve)
            {

            }
            actionref(RejectRecord; Reject)
            {

            }
        }
    }
    trigger OnOpenPage()
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
        IsFinanceManager: Boolean;
}