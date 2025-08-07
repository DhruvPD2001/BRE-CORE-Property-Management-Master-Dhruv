page 50710 "Approval Payment Request"
{
    PageType = List;
    SourceTable = "Approval Payment Request";
    ApplicationArea = All;
    Caption = 'Payment Change Request Status List';
    UsageCategory = Lists;
    InsertAllowed = false;
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
                    Editable = false;
                }

                field("Manual/Auto Status"; Rec."Manual/Auto Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;


                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vat Amount"; Rec."Vat Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field(Items; Rec.Items)
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
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsFinanceManager;


                trigger OnAction()
                var
                    SelectedRecs: Record "Approval Payment Request";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
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
                                SelectedRecs.Status := 'Approve';
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                                ProcessApprovalAndSplitRequest();
                                GetNextSequenceNo();

                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);

                    //UpdatePaymentModeBySeries();
                    // ProcessCombineRequest();
                    //ProcessSplitRequest();
                    //ProcessApprovalRequest();


                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Image = Reject;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "Approval Payment Request";
                    RejectCount: Integer;
                    ErrorCount: Integer;

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
                                SelectedRecs.Status := 'Reject'; // Set status to "Declined"
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

        area(navigation)
        {

        }
    }





    procedure ProcessApprovalAndSplitRequest()
    var
        PaymentChangeReqTable: Record "Approval Payment Request";
        PaymentModeTable: Record "Payment Mode2";
        PaymentSchedule: Record "Payment Schedule2";
        ApprovalRec: Record "Approval Payment Request";
        PaymentModeRec: Record "Payment Mode2";
        PaymentScheduleRec: Record "Payment Schedule2";
        PaymentSeriesList: List of [Text];
        itemList: List of [Text];
        //NewPaymentSeries: Code[20];
        NewPaymentCode: Code[20];
        PaymentSeries: Text[100];
        RequestType: Text[20];
        SequenceNo, increment : Integer;
        ItemSeries: Text;
        paymentSeriesNos: List of [Text];
    //paymentSeries: Text[100];
    begin
        //Message('Processing Record for: Contract ID: %1, Tenant ID: %2, ID: %3',
        //Rec."Contract ID", Rec."Tenant ID", Rec."ID");

        // Fetch Approval Record for Current Contract, Tenant, and ID
        ApprovalRec.Reset();
        ApprovalRec.SetRange("Contract ID", Rec."Contract ID");
        ApprovalRec.SetRange("Tenant ID", Rec."Tenant ID");
        ApprovalRec.SetRange("ID", Rec."ID");
        ApprovalRec.SetRange(Status, 'Approve');

        if ApprovalRec.FindFirst() then begin
            RequestType := ApprovalRec."Request Type";
            PaymentSeries := ApprovalRec."Payment Series";

            if RequestType = 'Split' then begin
                // Filter Split Requests
                PaymentChangeReqTable.Reset();
                PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
                PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
                PaymentChangeReqTable.SetRange("ID", Rec."ID");
                PaymentChangeReqTable.SetRange(Status, 'Approve');
                PaymentChangeReqTable.SetRange("Request Type", 'Split');

                if not PaymentChangeReqTable.FindSet() then begin
                    Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                        Rec."Contract ID", Rec."Tenant ID", Rec."ID");
                    exit;
                end;

                repeat
                    // Debug message
                    Message('Processing Split Request for ID: %1', PaymentChangeReqTable.ID);

                    // Extract and store `Items` in a list
                    Clear(itemList);
                    if PaymentChangeReqTable."Items".Contains(',') then begin
                        foreach ItemSeries in PaymentChangeReqTable."Items".Split(',') do
                            itemList.Add(DelChr(ItemSeries, '>', ' '));
                    end else
                        itemList.Add(PaymentChangeReqTable."Items");


                    // paymentSeries := PaymentChangeReqTable."Payment Series";

                    // Cancel old payment records in PaymentModeTable
                    if PaymentChangeReqTable."Payment Series" <> '' then begin
                        PaymentModeTable.Reset();
                        PaymentModeTable.SetRange("Contract ID", Rec."Contract ID");
                        PaymentModeTable.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentModeTable.SetRange("Payment Series", paymentSeries);

                        if PaymentModeTable.FindSet() then begin
                            // repeat
                            PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Cancelled;
                            PaymentModeTable.Modify(true);
                            // Message('Cancelled Payment Series: %1', PaymentModeTable."Payment Series");
                            // until PaymentModeTable.Next() = 0;
                            Clear(PaymentModeTable);
                        end;
                    end;

                    // Generate new payment series
                    SequenceNo := GetNextSequenceNo();
                    NewPaymentCode := GeneratePaymentCode(SequenceNo);

                    // Insert new Payment Mode record
                    PaymentModeTable.Init();
                    PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
                    PaymentModeTable."Tenant ID" := PaymentChangeReqTable."Tenant ID";
                    PaymentModeTable."ID" := PaymentChangeReqTable."ID";
                    PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                    PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                    PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                    PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                    PaymentModeTable."Payment Mode" := PaymentChangeReqTable."Payment Mode";
                    PaymentModeTable."Payment Series" := NewPaymentCode;
                    PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Scheduled;
                    PaymentModeTable.Insert(true);
                    // PaymentModeRec.ModifyAll("Payment Mode", ApprovalRec."Payment Mode");
                    Clear(PaymentModeTable);
                    // Message('Inserted new Payment Mode record with Series: %1', NewPaymentCode);

                    // Update Payment Schedule for matching `Items` and `Payment Series`
                    for increment := 1 to itemList.Count() do begin
                        //foreach ItemSeries in itemList do begin
                        //foreach paymentSeries in paymentSeriesNos do begin
                        PaymentSchedule.Reset();
                        PaymentSchedule.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSchedule.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentSchedule.SetRange("Secondary Item Type", itemList.Get(increment));
                        PaymentSchedule.SetRange("Payment Series", paymentSeries);

                        if PaymentSchedule.FindSet() then begin
                            repeat
                                PaymentSchedule."Payment Series" := NewPaymentCode;
                                PaymentSchedule."Due Date" := PaymentChangeReqTable."Due Date";
                                PaymentSchedule.Modify(true);
                            // Message('Updated Payment Schedule: %1, Item: %2', PaymentSchedule."Payment Series", itemList.Get(increment));
                            until PaymentSchedule.Next() = 0;
                        end;
                        // end;
                    end;

                until PaymentChangeReqTable.Next() = 0;

            end else if RequestType = 'Combine' then begin

                // Filter PaymentChangeReqTable for approval requests with "Combine" type
                PaymentChangeReqTable.Reset();
                PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
                PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
                PaymentChangeReqTable.SetRange("ID", Rec."ID");
                PaymentChangeReqTable.SetRange(Status, 'Approve');
                PaymentChangeReqTable.SetRange("Request Type", 'Combine');

                if not PaymentChangeReqTable.FindSet() then begin
                    Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                        Rec."Contract ID", Rec."Tenant ID", Rec."ID");
                    exit;
                end;

                repeat
                    // Debug: Log each processing record
                    Message('Processing Record: Contract ID: %1, Tenant ID: %2, ID: %3',
                        PaymentChangeReqTable."Contract ID",
                        PaymentChangeReqTable."Tenant ID", PaymentChangeReqTable."ID");
                    // Clear(PaymentSeriesList);
                    // if PaymentSeries.Contains(',') then begin
                    //     foreach PaymentSeries in PaymentSeries.Split(',') do
                    //         PaymentSeriesList.Add(DelChr(PaymentSeries, '=', ' '));
                    // end else
                    //     PaymentSeriesList.Add(PaymentSeries);


                    Clear(paymentSeriesNos);
                    if PaymentChangeReqTable."Payment Series".Contains(',') then begin
                        foreach paymentSeries in PaymentChangeReqTable."Payment Series".Split(',') do
                            paymentSeriesNos.Add(DelChr(paymentSeries, '=', ' '));
                    end else begin
                        paymentSeriesNos.Add(PaymentChangeReqTable."Payment Series");
                    end;
                    // Update status of old payment records
                    for increment := 1 to paymentSeriesNos.Count() do begin
                        PaymentModeTable.Reset();
                        PaymentModeTable.SetRange("Payment Series", paymentSeriesNos.Get(increment));
                        PaymentModeTable.SetRange("Contract ID", Rec."Contract ID");
                        PaymentModeTable.SetRange("Tenant ID", Rec."Tenant ID");

                        if PaymentModeTable.FindSet() then begin
                            //repeat
                            PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Cancelled;
                            PaymentModeTable.Modify(true);
                            // Message('Cancelled Payment Status for: %1', PaymentModeTable."Payment Series");
                            Clear(PaymentModeTable);
                            //until PaymentModeTable.Next() = 0;
                        end;
                    end;

                    // Generate new payment series
                    SequenceNo := GetNextSequenceNo();
                    NewPaymentCode := GeneratePaymentCode(SequenceNo);

                    // Check if a record already exists in PaymentModeTable
                    PaymentModeTable.Reset();
                    PaymentModeTable.SetRange(Id, PaymentChangeReqTable.ID);
                    if not PaymentModeTable.FindFirst() then begin
                        // Insert new record
                        PaymentModeTable.Init();
                        PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
                        PaymentModeTable."Tenant ID" := PaymentChangeReqTable."Tenant ID";
                        PaymentModeTable."ID" := PaymentChangeReqTable."ID";
                        PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                        PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                        PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                        PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                        PaymentModeTable."Payment Mode" := PaymentChangeReqTable."Payment mode";
                        PaymentModeTable."Payment Series" := NewPaymentCode;
                        PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Scheduled;
                        PaymentModeTable.Insert(true);
                        // PaymentModeRec.ModifyAll("Payment Mode", ApprovalRec."Payment Mode");
                        Clear(PaymentModeTable);
                        // Message('Inserted new payment record with Payment Series: %1', NewPaymentCode);
                    end else begin
                        // Modify existing record
                        PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                        PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                        PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                        PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                        PaymentModeTable.Modify(true);
                        Message('Updated existing payment record with ID: %1', PaymentModeTable."ID");
                    end;

                    for increment := 1 to paymentSeriesNos.Count() do begin
                        PaymentSchedule.Reset();
                        PaymentSchedule.SetRange("Payment Series", paymentSeriesNos.Get(increment));
                        PaymentSchedule.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSchedule.SetRange("Tenant ID", Rec."Tenant ID");

                        if PaymentSchedule.FindSet() then begin
                            repeat
                                PaymentSchedule."Payment Series" := NewPaymentCode;
                                PaymentSchedule."Due Date" := PaymentChangeReqTable."Due Date";
                                PaymentSchedule.Modify(true);
                            //  Message('Updated Payment Schedule for: %1', PaymentSchedule."Payment Series");
                            until PaymentSchedule.Next() = 0;
                        end;
                    end;
                until PaymentChangeReqTable.Next() = 0;
            end
            //end;
            // end
            else if RequestType = 'Payment Mode' then begin
                PaymentModeRec.Reset();
                PaymentModeRec.SetRange("Payment Series", PaymentSeries);
                if PaymentModeRec.FindSet() then begin
                    PaymentModeRec.ModifyAll("Payment Mode", ApprovalRec."Payment Mode");
                    //  Message('Updated Payment Mode for Series: %1', PaymentSeries);
                end else
                    Error('Payment Series %1 not found in Payment Mode Table.', PaymentSeries);
            end;
        end else
            Error('No matching Approval Record found for Contract ID: %1, Tenant ID: %2, ID: %3',
                Rec."Contract ID", Rec."Tenant ID", Rec."ID");

        Message('Processing complete.');
    end;



    // procedure ProcessSplitRequest()
    // var
    //     PaymentChangeReqTable: Record "Approval Payment Request";
    //     PaymentModeTable: Record "Payment Mode2";
    //     PaymentSchedule: Record "Payment Schedule2";
    //     NewPaymentCode: Code[20];
    //     SequenceNo: Integer;
    //     paymentSeriesNos: List of [Text];
    //     itemList: List of [Text];
    //     ItemSeries: Text;
    //     paymentSeries: Text;
    //     increment: Integer;
    // begin
    //     // Debug message
    //     Message('Processing Record for: Contract ID: %1, Tenant ID: %2, ID: %3',
    //         Rec."Contract ID", Rec."Tenant ID", Rec."ID");

    //     // Filter records for 'Split' request type and 'Approved' status
    //     PaymentChangeReqTable.Reset();
    //     PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
    //     PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
    //     PaymentChangeReqTable.SetRange("ID", Rec."ID");
    //     PaymentChangeReqTable.SetRange(Status, 'Approve');
    //     PaymentChangeReqTable.SetRange("Request Type", 'Split');

    //     if not PaymentChangeReqTable.FindSet() then begin
    //         Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
    //             Rec."Contract ID", Rec."Tenant ID", Rec."ID");
    //         exit;
    //     end;

    //     repeat
    //         // Debug message
    //         Message('Processing Split Request for ID: %1', PaymentChangeReqTable.ID);

    //         // Extract and store `Items` in a list
    //         Clear(itemList);
    //         if PaymentChangeReqTable."Items".Contains(',') then begin
    //             foreach ItemSeries in PaymentChangeReqTable."Items".Split(',') do
    //                 itemList.Add(DelChr(ItemSeries, '>', ' '));
    //         end else
    //             itemList.Add(PaymentChangeReqTable."Items");


    //         paymentSeries := PaymentChangeReqTable."Payment Series";

    //         // Cancel old payment records in PaymentModeTable
    //         if PaymentChangeReqTable."Payment Series" <> '' then begin
    //             PaymentModeTable.Reset();
    //             PaymentModeTable.SetRange("Contract ID", Rec."Contract ID");
    //             PaymentModeTable.SetRange("Tenant ID", Rec."Tenant ID");
    //             PaymentModeTable.SetRange("Payment Series", paymentSeries);

    //             if PaymentModeTable.FindSet() then begin
    //                 // repeat
    //                 PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Cancelled;
    //                 PaymentModeTable.Modify(true);
    //                 Message('Cancelled Payment Series: %1', PaymentModeTable."Payment Series");
    //                 // until PaymentModeTable.Next() = 0;
    //                 Clear(PaymentModeTable);
    //             end;
    //         end;

    //         // Generate new payment series
    //         SequenceNo := GetNextSequenceNo();
    //         NewPaymentCode := GeneratePaymentCode(SequenceNo);

    //         // Insert new Payment Mode record
    //         PaymentModeTable.Init();
    //         PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
    //         PaymentModeTable."Tenant ID" := PaymentChangeReqTable."Tenant ID";
    //         PaymentModeTable."ID" := PaymentChangeReqTable."ID";
    //         PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
    //         PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
    //         PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
    //         PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
    //         PaymentModeTable."Payment Mode" := PaymentChangeReqTable."Payment Mode";
    //         PaymentModeTable."Payment Series" := NewPaymentCode;
    //         PaymentModeTable.Insert(true);
    //         Clear(PaymentModeTable);
    //         Message('Inserted new Payment Mode record with Series: %1', NewPaymentCode);

    //         // Update Payment Schedule for matching `Items` and `Payment Series`
    //         for increment := 1 to itemList.Count() do begin
    //             //foreach ItemSeries in itemList do begin
    //             //foreach paymentSeries in paymentSeriesNos do begin
    //             PaymentSchedule.Reset();
    //             PaymentSchedule.SetRange("Contract ID", Rec."Contract ID");
    //             PaymentSchedule.SetRange("Tenant ID", Rec."Tenant ID");
    //             PaymentSchedule.SetRange("Secondary Item Type", itemList.Get(increment));
    //             PaymentSchedule.SetRange("Payment Series", paymentSeries);

    //             if PaymentSchedule.FindSet() then begin
    //                 repeat
    //                     PaymentSchedule."Payment Series" := NewPaymentCode;
    //                     PaymentSchedule."Due Date" := PaymentChangeReqTable."Due Date";
    //                     PaymentSchedule.Modify(true);
    //                     Message('Updated Payment Schedule: %1, Item: %2', PaymentSchedule."Payment Series", itemList.Get(increment));
    //                 until PaymentSchedule.Next() = 0;
    //             end;
    //             // end;
    //         end;

    //     until PaymentChangeReqTable.Next() = 0;

    //     Message('Processing complete.');
    // end;












    // Generates a new payment code with a padded sequence number
    local procedure GeneratePaymentCode(SequenceNumber: Integer): Code[20]
    begin
        exit('PAY' + PadStr(Format(SequenceNumber), 2, '0')); // Format as PAY000001
    end;

    // Pads a string to a specified length with a specified character
    local procedure PadStr(Input: Text[20]; Length: Integer; PaddingChar: Char): Text[20]
    begin
        while StrLen(Input) < Length do
            Input := PaddingChar + Input;
        exit(Input);
    end;

    // Gets the next sequence number for the Payment Series
    local procedure GetNextSequenceNo(): Integer
    var
        MaxSequence: Integer;
        LastSequence: Text[10];
        MergedRecord: Record "Payment Mode2";
    begin
        MergedRecord.Reset();
        MergedRecord.SetRange("Contract ID", Rec."Contract ID");

        if MergedRecord.FindSet() then begin
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(MergedRecord."Payment Series", 4, StrLen(MergedRecord."Payment Series"));
                if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
                    MaxSequence := MaxSequence;
            until MergedRecord.Next() = 0;
        end else
            MaxSequence := 0; // Default to 0 if no records are found

        exit(MaxSequence + 1);
    end;





    trigger OnOpenPage()
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