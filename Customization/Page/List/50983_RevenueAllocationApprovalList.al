page 50983 "RevenueAllocationApproval List"
{
    PageType = List;
    SourceTable = "Revenue Allocation Approval";
    ApplicationArea = All;
    Caption = 'Revenue Allocation Approval List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                }
                field("RA_ID"; Rec."RA_ID")
                {
                    ApplicationArea = All;
                    Caption = 'RA_ID';
                    Editable = false;
                }
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        revenueallocation: Record "Revenue Allocation Details";
                    begin
                        revenueallocation.SetRange("No.", Rec."ID");
                        if revenueallocation.FindSet() then
                            PAGE.RunModal(PAGE::"Revenue Allocation Card", revenueallocation)
                        else
                            Message('No Revenue Allocation found using FindFirst either.');
                    end;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    Caption = 'Financial Year';
                    Editable = false;
                }
                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                    Caption = 'Month';
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
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFinanceManager;


                trigger OnAction()
                var
                    revenueallocation: Record "Revenue Allocation Details";
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?') then begin
                        // Update entry status
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();

                        if revenueallocation.Get(Rec."ID") then begin
                            revenueallocation.Status := revenueallocation.Status::Approve;
                            revenueallocation.Modify();
                        end;
                        Message('Entry has been approved successfully!');
                    end;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    revenueallocation: Record "Revenue Allocation Details";
                begin
                    if Rec.Status = Rec.Status::Reject then
                        Error('This entry is already rejected');
                    // Update current record
                    Rec.Status := Rec.Status::Reject;
                    // Rec."Reason for Rejection" := ReasonForRejection;
                    Rec.Modify();

                    // Update Credit Note record
                    if revenueallocation.Get(Rec."ID") then begin
                        revenueallocation.Status := revenueallocation.Status::Reject;
                        revenueallocation.Modify();
                    end;

                    Message('Entry has been rejected successfully!');
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

        if UserPersonalization.Get(UserSecurityId()) then begin

            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;
        end;

        exit(false);
    end;

    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;
}
