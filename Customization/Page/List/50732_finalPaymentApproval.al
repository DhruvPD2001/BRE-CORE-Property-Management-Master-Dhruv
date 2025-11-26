page 50732 "final payment approval"
{
    PageType = List;
    SourceTable = finalPaymentApproval;
    ApplicationArea = All;
    Caption = 'Final Payment Approval';
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;
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
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment transaction ID"; Rec."Payment transaction ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Received)
            {
                Caption = 'Received';
                ApplicationArea = All;
                Image = Received;

                trigger OnAction()
                var
                    SelectedRecs: Record "finalPaymentApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    Finalsettlement: Record "FinalSettlement";
                    PaymentStatus: Enum "Payment Status";
                //  FinalsettlementRefund: Record "FinalSettlementRefund";
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
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'Received';
                                SelectedRecs.Modify();

                                // FinalsettlementRefund.SetRange("Contract ID", SelectedRecs."Contract ID");

                                // if FinalsettlementRefund.FindSet() then begin
                                //     FinalsettlementRefund."Refund Payment Status" := PaymentStatus::Received;
                                //     FinalsettlementRefund.Modify(true);
                                // end;

                                Finalsettlement.SetRange("Contract ID", SelectedRecs."Contract ID");
                                if Finalsettlement.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    Finalsettlement."Receivable Payment Status" := PaymentStatus::Received;
                                    Finalsettlement.receivablePaymentStatuss := 'Received';
                                    Finalsettlement.Modify(true);
                                end;
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }
            action(NotReceived)
            {
                Caption = 'Not Received';
                ApplicationArea = All;
                Image = "Not Received";

                trigger OnAction()
                var
                    SelectedRecs: Record "finalPaymentApproval";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                    Finalsettlement1: Record "FinalSettlement";
                    PaymentStatus1: Enum "Payment Status";
                begin
                    // Store selected records
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'Not Received'; // Set status to "Declined"
                                SelectedRecs.Modify();


                                Finalsettlement1.SetRange("Contract ID", SelectedRecs."Contract ID");
                                if Finalsettlement1.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    Finalsettlement1."Receivable Payment Status" := PaymentStatus1::Cancelled;
                                    Finalsettlement1.receivablePaymentStatuss := 'Not Received';
                                    Finalsettlement1.Modify(true);
                                end;
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
}