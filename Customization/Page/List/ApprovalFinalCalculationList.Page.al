page 50916 "Approval FinalCalculation List"
{
    PageType = List;
    SourceTable = "Approval Final Calculation";
    ApplicationArea = All;
    Caption = 'Approval Final Calculation List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

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
                    ToolTip = 'Specifies the unique identifier for this record.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the contract or record.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant linked to this contract.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }

                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Final Calculation or related reference for the contract.';
                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Specifies the related record link. Click to open the associated Final Calculation record.';


                    trigger OnDrillDown()
                    var
                        FinalCalculation: Record "Final Calculation";
                    begin

                        // Navigate to the Revenue Structure Card page
                        if FinalCalculation.Get(Rec."Link") then
                            PAGE.RUN(PAGE::"Final Calculation Card", FinalCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the contract becomes active.';
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the contract is scheduled to end.';
                }

                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the contract is terminated.';
                }

                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total monetary value of the contract.';
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
                Visible = IsFinanceManager;
                ToolTip = 'Click to approve the selected record. This action is available only to Finance Managers.';


                trigger OnAction()
                var
                    FinalCalculation: Record "Final Calculation";
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?') then begin
                        // Update entry status
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();

                        // Update main record status
                        if FinalCalculation.Get(Rec."ID") then begin
                            FinalCalculation.Status := FinalCalculation.Status::Approved;
                            FinalCalculation.Modify();
                        end;

                        Message('Entry has been approved successfully!');
                    end;
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