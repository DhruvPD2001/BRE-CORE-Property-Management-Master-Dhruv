page 50972 "OverduePaymentmodelist"
{
    PageType = List;
    SourceTable = "OverDuePaymentmode";
    ApplicationArea = All;
    Caption = 'Overdue Payment Approval List';
    UsageCategory = Lists;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'ID';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Status';
                }
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Tenant Id';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract ID';
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment Series';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Due Date';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment Status';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Tenant Name';
                }
            }
        }
    }



    actions
    {
        area(processing)
        {
            action(Approved)
            {
                Caption = 'Approved';
                ToolTip = 'Approved';
                ApplicationArea = All;
                Image = Approval;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "OverDuePaymentmode";
                    emailsrec: Codeunit "Send Email Paymentmode Overdue";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    approvalstatus: Enum "Approval Status Enum";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = approvalstatus::Pending then begin
                                SelectedRecs.Status := approvalstatus::Approved;
                                emailsrec.SendEmailOverdue(Rec);
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }
            action(Rejected)
            {
                Caption = 'Rejected';
                ToolTip = 'Rejected';
                ApplicationArea = All;
                Image = Reject;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "OverDuePaymentmode";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                    approvalstatus: Enum "Approval Status Enum";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = approvalstatus::Pending then begin
                                SelectedRecs.Status := approvalstatus::Rejected; // Set status to "Declined"
                                SelectedRecs.Modify();
                                RejectCount += 1;
                            end else
                                ErrorCount += 1; // Count records that are not in "Pending" status
                        until SelectedRecs.Next() = 0;
                    Commit(); // Commit changes
                    CurrPage.Update(false); // Refresh page
                    // Display result messages
                    Message('%1 record(s) rejected. %2 record(s) were not in "Pending" status.', RejectCount, ErrorCount);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var

    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set

        IsFinanceManager := VisibleApproveAction();
    end;

    procedure VisibleApproveAction(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;

        exit(false);
    end;

    var
        IsFinanceManager: Boolean;
}