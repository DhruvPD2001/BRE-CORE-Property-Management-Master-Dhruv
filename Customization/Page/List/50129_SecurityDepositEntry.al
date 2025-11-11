page 50129 "Security Deposit Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Security Deposit Entry";
    Caption = 'Security Deposit Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Security Deposit ID"; Rec."Security Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Main Security Deposit"; Rec."Main Security Deposit")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsFinanceManager;
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
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
                Caption = 'Approve Entry';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFinanceManager; // Only show this action to Finance Managers

                trigger OnAction()
                var
                    AdjustSecurityDeposit: Record "Adjustment Security Deposit";
                    FinaCalculation: Record "Final Calculation";
                    CarryForwardGrid: Record "Carry Forward Grid";
                    SecurityDeposit: Record "Security Deposit";
                    TenancyContract: Record "Tenancy Contract";
                    TenancyContractSubpage: Record "Tenancy Contract Subpage";
                    TerminationAddCharges: Record "Additional Charges Sub";
                    PendingReceivableGrid: Record "Pending Receviable Grid";
                    ChillarDepositAmount: Decimal;
                    OtherDepositAmount: Decimal;
                    NetBalanceAmount: Decimal;
                    TotalRefundableDeposit: Decimal;
                    TotalClaimAmount: Decimal;
                    AmountIncludingVAT: Decimal;
                    TotalRefundableAmount: Decimal;
                    TotalReceivableAmount: Decimal;
                    TenantNo: Code[20];
                    NetAmount: Decimal;
                    SummeryNetAmount: Decimal;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?', true) then begin
                        // Update main record status
                        if AdjustSecurityDeposit.Get(Rec."Security Deposit ID") then begin
                            AdjustSecurityDeposit.Status := AdjustSecurityDeposit.Status::Approved;
                            AmountIncludingVAT := AdjustSecurityDeposit."Amount Including VAT";
                            AdjustSecurityDeposit.Modify();

                            // Get Chillar Deposit and Other Deposit amounts
                            ChillarDepositAmount := 0;
                            OtherDepositAmount := 0;
                            TenancyContract.Reset();
                            TenancyContract.SetRange("Contract ID", Rec."Contract ID");
                            if TenancyContract.FindFirst() then begin
                                TenantNo := TenancyContract."Tenant ID";

                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Chiller Deposit Amount');
                                if TenancyContractSubpage.FindFirst() then
                                    ChillarDepositAmount := TenancyContractSubpage.Amount;

                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Other Deposit');
                                if TenancyContractSubpage.FindFirst() then
                                    OtherDepositAmount := TenancyContractSubpage.Amount;
                            end;

                            // Calculate Net Balance and Total Refundable Deposit
                            NetBalanceAmount := Rec."Security Deposit";
                            TotalRefundableDeposit := NetBalanceAmount + ChillarDepositAmount + OtherDepositAmount;

                            // Get Total Claim Amount
                            TotalClaimAmount := 0;
                            TerminationAddCharges.Reset();
                            TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                            if TerminationAddCharges.FindSet() then begin
                                repeat
                                    TotalClaimAmount += TerminationAddCharges."Amount Including VAT";
                                until TerminationAddCharges.Next() = 0;
                            end;

                            if TotalClaimAmount = 0 then begin
                                TerminationAddCharges.Reset();
                                TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                                TerminationAddCharges.CalcSums(Amount);
                                TotalClaimAmount := TerminationAddCharges.Amount;

                                if TotalClaimAmount = 0 then
                                    TotalClaimAmount := GetTotalAmountFromTermination(Rec."Contract ID");
                            end;

                            // Get Pending Receivables
                            TotalRefundableAmount := 0;
                            TotalReceivableAmount := 0;
                            PendingReceivableGrid.Reset();
                            PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
                            if PendingReceivableGrid.FindFirst() then begin
                                TotalRefundableAmount := PendingReceivableGrid."Total Refundable";
                                TotalReceivableAmount := PendingReceivableGrid."Total Receivable";
                            end;

                            Message('Total Claim Amount calculated: %1', TotalClaimAmount + TotalReceivableAmount);
                            Message('Amount Including VAT from Adjustment Security Deposit: %1', AmountIncludingVAT);

                            // Update Final Calculation
                            FinaCalculation.Reset();
                            FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                            if FinaCalculation.FindFirst() then begin
                                FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
                                FinaCalculation."Adjustment Security Deposit" := Rec."Main Security Deposit" - Rec."Security Deposit";
                                FinaCalculation."Net Balance" := Rec."Security Deposit";
                                FinaCalculation."Chiller Deposit" := ChillarDepositAmount;
                                FinaCalculation."Other Deposit" := OtherDepositAmount;
                                FinaCalculation."Total Refundable Deposit" := TotalRefundableDeposit;
                                FinaCalculation."Total Claim" := TotalClaimAmount;

                                NetAmount := FinaCalculation."Total Claim" - FinaCalculation."Total Refundable Deposit";
                                if NetAmount < 0 then begin
                                    FinaCalculation."Total Refund" := ABS(NetAmount);
                                    FinaCalculation."Total Receive" := 0;
                                end else begin
                                    FinaCalculation."Total Receive" := ABS(NetAmount);
                                    FinaCalculation."Total Refund" := 0;
                                end;

                                SummeryNetAmount := 0;

                                // Scenario 1: Both are Receivable
                                if ((FinaCalculation."Total Receive" <> 0) and (TotalReceivableAmount <> 0)) or
                                   ((FinaCalculation."Total Receive" = 0) and (TotalReceivableAmount <> 0)) or
                                   ((FinaCalculation."Total Receive" <> 0) and (TotalReceivableAmount = 0)) then begin
                                    SummeryNetAmount := FinaCalculation."Total Receive" + ABS(TotalReceivableAmount);
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    FinaCalculation."Net Receivable From The Tenant" := SummeryNetAmount;
                                    FinaCalculation."Amount Refundable" := 0;
                                end;

                                // Scenario 2: Both are Refund
                                if ((FinaCalculation."Total Refund" <> 0) and (TotalRefundableAmount <> 0)) or
                                   ((FinaCalculation."Total Refund" <> 0) and (TotalRefundableAmount = 0)) or
                                   ((FinaCalculation."Total Refund" = 0) and (TotalRefundableAmount <> 0)) then begin
                                    SummeryNetAmount := FinaCalculation."Total Refund" + ABS(TotalRefundableAmount);
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    FinaCalculation."Amount Refundable" := FinaCalculation."Summery Net Balance";
                                    FinaCalculation."Net Receivable From The Tenant" := 0;
                                end;

                                // Scenario 3: Refund - Receivable
                                if (FinaCalculation."Total Refund" <> 0) and (TotalReceivableAmount <> 0) then begin
                                    SummeryNetAmount := FinaCalculation."Total Refund" - TotalReceivableAmount;
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    if SummeryNetAmount > 0 then begin
                                        FinaCalculation."Amount Refundable" := ABS(SummeryNetAmount);
                                        FinaCalculation."Net Receivable From The Tenant" := 0;
                                    end else begin
                                        FinaCalculation."Net Receivable From The Tenant" := ABS(SummeryNetAmount);
                                        FinaCalculation."Amount Refundable" := 0;
                                    end;
                                end;

                                // Scenario 4: Receive - Refundable
                                if (FinaCalculation."Total Receive" <> 0) and (TotalRefundableAmount <> 0) then begin
                                    SummeryNetAmount := FinaCalculation."Total Receive" - TotalRefundableAmount;
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    if SummeryNetAmount > 0 then begin
                                        FinaCalculation."Net Receivable From The Tenant" := ABS(SummeryNetAmount);
                                        FinaCalculation."Amount Refundable" := 0;
                                    end else begin
                                        FinaCalculation."Amount Refundable" := ABS(SummeryNetAmount);
                                        FinaCalculation."Net Receivable From The Tenant" := 0;
                                    end;
                                end;

                                FinaCalculation.Modify();
                                Message('Final Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
                            end else
                                Message('No Final Calculation record found for Contract ID: %1', Rec."Contract ID");
                        end else
                            Message('No Adjustment Security Deposit found');

                        // Handle carry forward grid
                        SecurityDeposit.Reset();
                        SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

                        if SecurityDeposit.FindSet() then begin
                            repeat
                                CarryForwardGrid.Reset();
                                CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
                                CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
                                CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."Carry Forward Amount");

                                if not CarryForwardGrid.FindFirst() then begin
                                    CarryForwardGrid.Init();
                                    CarryForwardGrid."Entry No." := GetNextEntryNo();
                                    CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
                                    CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."Carry Forward Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Insert();
                                end else begin
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."Carry Forward Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Modify();
                                end;
                            until SecurityDeposit.Next() = 0;
                        end else begin
                            CarryForwardGrid.Reset();
                            CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

                            if not CarryForwardGrid.FindFirst() then begin
                                CarryForwardGrid.Init();
                                CarryForwardGrid."Entry No." := GetNextEntryNo();
                                CarryForwardGrid."Contract ID" := Rec."Contract ID";
                                CarryForwardGrid."Total Amount" := Rec."Security Deposit";
                                CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                CarryForwardGrid.Insert();
                            end;
                        end;

                        // Process journal entries
                        AdditinalchargescashReceipt();

                        Message('Entry has been approved successfully!');
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();
                    end else
                        exit;
                end;
            }
        }
    }

    local procedure GetNextEntryNo(): Integer
    var
        CarryForwardGrid: Record "Carry Forward Grid";
    begin
        CarryForwardGrid.Reset();
        if CarryForwardGrid.FindLast() then
            exit(CarryForwardGrid."Entry No." + 1)
        else
            exit(1);
    end;

    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;

    // Add this trigger to check user permissions when the page loads
    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'FINANCE MANAGER' profile
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());

        if PermissionSet.FindSet() then begin
            repeat
                if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                    IsFinanceManager := true;
            until (PermissionSet.Next() = 0) or IsFinanceManager;
        end;

        // If user is not a Finance Manager, show error and exit
        if not IsFinanceManager then
            Error('You do not have permission to access this page. Only Finance Managers can access this page.');
    end;

    // Helper function to get the total amount from a parent termination record if needed
    local procedure GetTotalAmountFromTermination(ContractID: Integer): Decimal
    var
        TerminationHeader: Record "Additional Charges Sub"; // Use the actual table name
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        TerminationHeader.Reset();
        TerminationHeader.SetRange("Contract ID", ContractID);
        if TerminationHeader.FindFirst() then begin
            // Try to get TotalAmount field or equivalent
            if TerminationHeader.Get(ContractID) then
                TotalAmount := TerminationHeader."Total Amount"; // Use the correct field name
        end;
        exit(TotalAmount);
    end;



    procedure AdditinalchargescashReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "Final Calculation";
        TerminationCharges: Record "Termination Charges Sub";
        PendingReceivableGrid: Record "Pending Receviable Grid";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        BillingCalculation: Record "Final Billing Calculation Grid";
        finalsettlmentRefund: Record FinalSettlementRefund;
        finalsettlmentRefund1: Record FinalSettlementRefund;
        PostingDate: Date;
        DocumentNo: Code[20];
        RefundDocumentNo: Code[20];
        InvoiceNo: Code[20];
        AdditionalInvoiceNo: Code[20];
        Tenantid: Code[20];
        Tenantname: Text[100];
        LastLineNo: Integer;
        AppliedAmount: Decimal;
        securitydeposit: Decimal;
        chillerdeposit: Decimal;
        otherdeposit: Decimal;
        Totaladdtionalcharges: Decimal;
        TotalReceivable: Decimal;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        HasApplicableCharges: Boolean;
    begin
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // Validate Journal Template and Batch
        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if not GenJnlBatch.FindFirst() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();
        DocumentNo := 'REFUND-' + Format(Rec."Contract ID");
        RefundDocumentNo := 'REF-' + Format(Rec."Contract ID");

        // Retrieve Final Calculation record
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', Rec."Contract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        securitydeposit := Round(finalcalculation."Net Balance");
        chillerdeposit := Round(finalcalculation."Chiller Deposit");
        otherdeposit := Round(finalcalculation."Other Deposit");

        // Retrieve Termination Charges
        TerminationCharges.Reset();
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        if TerminationCharges.FindFirst() then
            AdditionalInvoiceNo := TerminationCharges."Posted Invoice ID"
        else
            AdditionalInvoiceNo := '';

        // Retrieve Billing Calculation
        BillingCalculation.Reset();
        BillingCalculation.SetRange("Contract ID", Rec."Contract ID");
        if BillingCalculation.FindFirst() then
            InvoiceNo := BillingCalculation."Posted Invoice ID"
        else
            InvoiceNo := '';

        // Calculate total additional charges
        Totaladdtionalcharges := 0;
        TerminationCharges.Reset();
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        if TerminationCharges.FindSet() then
            repeat
                Totaladdtionalcharges += TerminationCharges."Amount Including VAT";
            until TerminationCharges.Next() = 0;

        // Get total receivable from Pending Receivable Grid
        TotalReceivable := 0;
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
        if PendingReceivableGrid.FindFirst() then
            TotalReceivable := PendingReceivableGrid."Total Receivable";

        // Validate deposit amounts
        if (securitydeposit = 0) and (chillerdeposit = 0) and (otherdeposit = 0) then
            Error('No deposit amounts found to process for Contract ID %1', Rec."Contract ID");

        // Get last line number
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // *** SECURITY DEPOSIT PROCESSING ***
        while (securitydeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(securitydeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."Contract ID");

                // Create journal line for Additional Charges
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Security Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4502';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                securitydeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else if TotalReceivable > 0 then begin
                AppliedAmount := Min(securitydeposit, TotalReceivable);

                // Create journal line for Receivable
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Security Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4502';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                securitydeposit -= AppliedAmount;
                TotalReceivable -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // *** CHILLER DEPOSIT PROCESSING ***
        while (chillerdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(chillerdeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."Contract ID");

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Chiller Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                chillerdeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else if TotalReceivable > 0 then begin
                AppliedAmount := Min(chillerdeposit, TotalReceivable);

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Chiller Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                chillerdeposit -= AppliedAmount;
                TotalReceivable -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // *** OTHER DEPOSIT PROCESSING ***
        while (otherdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(otherdeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."Contract ID");

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Other Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                otherdeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else if TotalReceivable > 0 then begin
                AppliedAmount := Min(otherdeposit, TotalReceivable);

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Other Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                otherdeposit -= AppliedAmount;
                TotalReceivable -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // *** NEW: REFUND REMAINING DEPOSITS ***
        // Update Final Settlement Refund with remaining amounts
        finalsettlmentRefund1.Reset();
        finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
        if finalsettlmentRefund1.FindFirst() then begin
            finalsettlmentRefund1."Adjust Security Deposit" := securitydeposit;
            finalsettlmentRefund1."Adjust Chiller Deposit" := chillerdeposit;
            finalsettlmentRefund1."Adjust other deposit" := otherdeposit;
            finalsettlmentRefund1.Modify();
        end;

        // Create REFUND entries for remaining deposits
        if securitydeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Security Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4502';  // Security Deposit Account
            GenJnlLine.Amount := Round(-securitydeposit);  // Credit G/L (reduce liability)
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;  // Debit Customer (refund to tenant)
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        if chillerdeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Chiller Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4508';  // Chiller Deposit Account
            GenJnlLine.Amount := Round(-chillerdeposit);
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        if otherdeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Other Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4508';  // Other Deposit Account
            GenJnlLine.Amount := Round(-otherdeposit);
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        // *** FINAL POSTING ***
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if not GenJnlLine.IsEmpty() then begin
            if Confirm('Do you want to post journal lines?', true) then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
                Message('Journal entries have been created and posted successfully');
            end;
        end else
            Message('No journal lines were created. Please check the data for Contract ID: %1', Rec."Contract ID");
    end;

    local procedure Min(a: Decimal; b: Decimal): Decimal
    begin
        if a < b then
            exit(a)
        else
            exit(b);
    end;

}