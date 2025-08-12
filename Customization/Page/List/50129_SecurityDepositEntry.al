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
                    GenJournalLine: Record "Gen. Journal Line";
                    GenJournalBatch: Record "Gen. Journal Batch";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    GLSetup: Record "General Ledger Setup";
                    ChillarDepositAmount: Decimal;
                    OtherDepositAmount: Decimal;
                    NetBalanceAmount: Decimal;
                    TotalRefundableDeposit: Decimal;
                    TotalClaimAmount: Decimal;
                    AmountIncludingVAT: Decimal;
                    TotalRefundableAmount: Decimal;
                    TotalReceivableAmount: Decimal;
                    AdjustedTotalClaimAmount: Decimal;
                    LastLineNo: Integer;
                    PostingDate: Date;
                    DocumentNo: Code[20];
                    TenantNo: Code[20];
                    TenantReceivableResAcc: Code[20];
                    TenantReceivableComAcc: Code[20];
                    SecurityDepositRefundAcc: Code[20];
                    ChillerDepositRefundAcc: Code[20];
                    NetAmount: Decimal;
                    SummeryNetAmount: Decimal;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?', true) then begin

                        // Update main record status
                        if AdjustSecurityDeposit.Get(Rec."Security Deposit ID") then begin
                            AdjustSecurityDeposit.Status := AdjustSecurityDeposit.Status::Approved;

                            // Get the Amount Including VAT from the Adjustment Security Deposit table
                            AmountIncludingVAT := AdjustSecurityDeposit."Amount Including VAT";

                            AdjustSecurityDeposit.Modify();

                            // Get Chillar Deposit amount from Tenancy Contract Subpage
                            ChillarDepositAmount := 0;
                            OtherDepositAmount := 0;
                            TenancyContract.Reset();
                            TenancyContract.SetRange("Contract ID", Rec."Contract ID");
                            if TenancyContract.FindFirst() then begin
                                // Store tenant number for journal entries
                                TenantNo := TenancyContract."Tenant ID";

                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Chiller Deposit Amount');
                                if TenancyContractSubpage.FindFirst() then begin
                                    ChillarDepositAmount := TenancyContractSubpage.Amount;
                                end;
                                // Get Other Deposit amount
                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Other Deposit');
                                if TenancyContractSubpage.FindFirst() then begin
                                    OtherDepositAmount := TenancyContractSubpage.Amount;
                                end;
                            end;

                            // Calculate Net Balance for Security Deposit
                            NetBalanceAmount := Rec."Security Deposit";

                            // Calculate Total Refundable Deposit
                            TotalRefundableDeposit := 0;  // Initialize to zero
                            TotalRefundableDeposit := NetBalanceAmount + ChillarDepositAmount + OtherDepositAmount;

                            // Get the Total Amount from Additional Charges Sub directly from Final Calculation
                            TotalClaimAmount := 0;

                            // Get Total Refundable from Pending Receivable Grid
                            TotalRefundableAmount := 0;
                            PendingReceivableGrid.Reset();
                            PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
                            if PendingReceivableGrid.FindFirst() then begin
                                TotalRefundableAmount := PendingReceivableGrid."Total Refundable";
                            end;

                            FinaCalculation.Reset();
                            FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                            if FinaCalculation.FindFirst() then begin
                                // Try to find the related Termination Additional Charges records
                                TerminationAddCharges.Reset();
                                TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                                if TerminationAddCharges.FindSet() then begin
                                    repeat
                                        // Add up the "Amount Including VAT" values
                                        TotalClaimAmount += TerminationAddCharges."Amount Including VAT";
                                    until TerminationAddCharges.Next() = 0;
                                end;

                                // If we couldn't find records or the total is still 0, try getting the TotalAmount field
                                if TotalClaimAmount = 0 then begin
                                    // Check if there's a field called TotalAmount in the Termination Additional Charges table
                                    // or try to access it from another source
                                    TerminationAddCharges.Reset();
                                    TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                                    TerminationAddCharges.CalcSums(Amount); // Try to use Amount if TotalAmount doesn't exist
                                    TotalClaimAmount := TerminationAddCharges.Amount;

                                    if TotalClaimAmount = 0 then begin
                                        // Final attempt - try to get it from a parent record if needed
                                        TotalClaimAmount := GetTotalAmountFromTermination(Rec."Contract ID");
                                    end;
                                end;

                                // Debug message to see what we found
                                Message('Total Claim Amount calculated: %1', TotalClaimAmount + PendingReceivableGrid."Total Receivable");

                                // Debug message to see what we found
                                Message('Amount Including VAT from Adjustment Security Deposit: %1', AmountIncludingVAT);

                                // Update Fina Calculation
                                FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
                                FinaCalculation."Adjustment Security Deposit" := Rec."Main Security Deposit" - Rec."Security Deposit";
                                FinaCalculation."Net Balance" := Rec."Security Deposit";
                                // Update Chillar Deposit field
                                FinaCalculation."Chiller Deposit" := ChillarDepositAmount;
                                FinaCalculation."Other Deposit" := OtherDepositAmount;
                                // Update Total Refundable Deposit
                                FinaCalculation."Total Refundable Deposit" := TotalRefundableDeposit;
                                // Update Total Claim with the sum of Total Amount from Additional Charges Sub
                                FinaCalculation."Total Claim" := TotalClaimAmount;

                                NetAmount := FinaCalculation."Total Claim" - FinaCalculation."Total Refundable Deposit";
                                if NetAmount < 0 then begin
                                    FinaCalculation."Total Refund" := ABS(NetAmount); // negative value
                                    FinaCalculation."Total Receive" := 0;
                                end else begin
                                    FinaCalculation."Total Receive" := ABS(NetAmount); // positive value
                                    FinaCalculation."Total Refund" := 0;
                                end;

                                // Initialize variables
                                SummeryNetAmount := 0;

                                // Scenario 1: Both are Receivable
                                if ((FinaCalculation."Total Receive" <> 0) and (PendingReceivableGrid."Total Receivable" <> 0) or
                                (FinaCalculation."Total Receive" = 0) and (PendingReceivableGrid."Total Receivable" <> 0) or
                                (FinaCalculation."Total Receive" <> 0) and (PendingReceivableGrid."Total Receivable" = 0)) then begin
                                    SummeryNetAmount := FinaCalculation."Total Receive" + ABS(PendingReceivableGrid."Total Receivable");
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    FinaCalculation."Net Receivable From The Tenant" := SummeryNetAmount;
                                    FinaCalculation."Amount Refundable" := 0;
                                end;

                                // Scenario 2: Both are Refund

                                if ((FinaCalculation."Total Refund" <> 0) and (PendingReceivableGrid."Total Refundable" <> 0) or
                                (FinaCalculation."Total Refund" <> 0) and (PendingReceivableGrid."Total Refundable" = 0) or
                                (FinaCalculation."Total Refund" = 0) and (PendingReceivableGrid."Total Refundable" <> 0)) then begin
                                    SummeryNetAmount := FinaCalculation."Total Refund" + ABS(PendingReceivableGrid."Total Refundable");
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    FinaCalculation."Amount Refundable" := FinaCalculation."Summery Net Balance";
                                    FinaCalculation."Net Receivable From The Tenant" := 0;
                                end;

                                // Scenario 3: Refund (500) - Receivable (300) => 200 Amount Refundable

                                if (FinaCalculation."Total Refund" <> 0) and (PendingReceivableGrid."Total Receivable" <> 0) then begin
                                    SummeryNetAmount := FinaCalculation."Total Refund" - PendingReceivableGrid."Total Receivable";
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    if SummeryNetAmount > 0 then begin
                                        FinaCalculation."Amount Refundable" := ABS(SummeryNetAmount); // Positive => Refundable
                                        FinaCalculation."Net Receivable From The Tenant" := 0;
                                    end else begin
                                        FinaCalculation."Net Receivable From The Tenant" := ABS(SummeryNetAmount); // Negative => Receivable
                                        FinaCalculation."Amount Refundable" := 0;
                                    end;
                                end;

                                // Scenario 4: Receive (500) - Refundable (300) => 200 Net Receivable

                                if (FinaCalculation."Total Receive" <> 0) and (PendingReceivableGrid."Total Refundable" <> 0) then begin
                                    SummeryNetAmount := FinaCalculation."Total Receive" - PendingReceivableGrid."Total Refundable";
                                    FinaCalculation."Summery Net Balance" := SummeryNetAmount;
                                    if SummeryNetAmount > 0 then begin
                                        FinaCalculation."Net Receivable From The Tenant" := ABS(SummeryNetAmount); // Positive => Receivable
                                        FinaCalculation."Amount Refundable" := 0;
                                    end else begin
                                        FinaCalculation."Amount Refundable" := ABS(SummeryNetAmount); // Negative => Refundable
                                        FinaCalculation."Net Receivable From The Tenant" := 0;
                                    end;
                                end;

                                FinaCalculation.Modify();

                            end else begin
                                Message('No Pending Receivable Grid record found for Contract ID: %1', Rec."Contract ID");
                            end;

                            Message('Final Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
                        end else
                            Message('No Final Calculation record found for Contract ID: %1', Rec."Contract ID");

                        // Handle carry forward grid for security deposits
                        SecurityDeposit.Reset();
                        SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

                        if SecurityDeposit.FindSet() then begin
                            repeat
                                // Check if a Carry Forward Grid record already exists
                                CarryForwardGrid.Reset();
                                CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
                                CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
                                CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."Carry Forward Amount"); // Additional Check

                                if not CarryForwardGrid.FindFirst() then begin
                                    // Create new record only if it doesn't exist
                                    CarryForwardGrid.Init();
                                    // Get the next available Entry No.
                                    CarryForwardGrid."Entry No." := GetNextEntryNo();
                                    CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
                                    CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."Carry Forward Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Insert();
                                end else begin
                                    // Update existing record
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."Carry Forward Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Modify();
                                end;
                            until SecurityDeposit.Next() = 0;
                        end else begin
                            // If no Security Deposit records exist, create a basic Carry Forward Grid record
                            CarryForwardGrid.Reset();
                            CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

                            if not CarryForwardGrid.FindFirst() then begin
                                CarryForwardGrid.Init();
                                // Get the next available Entry No.
                                CarryForwardGrid."Entry No." := GetNextEntryNo();
                                CarryForwardGrid."Contract ID" := Rec."Contract ID";
                                // You'll need to determine the New Contract ID from elsewhere
                                CarryForwardGrid."Total Amount" := Rec."Security Deposit";
                                CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                CarryForwardGrid.Insert();
                            end;
                        end;
                        AdditinalchargescashReceipt();
                        Message('Entry has been approved successfully!');
                        // Update entry status
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
    begin
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // if not GenJnlTemplate.Get(JournalTemplateName) then
        //     Error('The Journal Template %1 does not exist.', JournalTemplateName);

        // GenJnlBatch.Reset();
        // GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        // GenJnlBatch.SetRange(Name, JournalBatchName);
        // if not GenJnlBatch.FindFirst() then
        //     Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();
        DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        // if not finalcalculation.FindFirst() then
        //     Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        securitydeposit := Round(finalcalculation."Net Balance");
        chillerdeposit := Round(finalcalculation."Chiller Deposit");
        otherdeposit := Round(finalcalculation."Other Deposit");


        finalsettlmentRefund.SetRange("Contract ID", finalcalculation."Contract ID");
        if finalsettlmentRefund.FindSet() then begin
            finalsettlmentRefund."Adjust Security Deposit" := securitydeposit;
            finalsettlmentRefund."Adjust Chiller Deposit" := chillerdeposit;
            finalsettlmentRefund."Adjust other deposit" := otherdeposit;
            finalsettlmentRefund.Modify();
        end;
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        // if not TerminationCharges.FindFirst() then
        //     Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        BillingCalculation.SetRange("Contract ID", Rec."Contract ID");
        // if not BillingCalculation.FindFirst() then
        //     Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        InvoiceNo := BillingCalculation."Posted Invoice ID";
        AdditionalInvoiceNo := TerminationCharges."Posted Invoice ID";
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
        PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
        if PendingReceivableGrid.FindFirst() then
            TotalReceivable := PendingReceivableGrid."Total Receivable";

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // Main loop: continue until all deposits or both charges/receivable are zero
        while ((securitydeposit > 0))
              and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin

            // 1. Apply to Security Deposit
            if (securitydeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) then begin
                if Totaladdtionalcharges > 0 then begin
                    AppliedAmount := Min(securitydeposit, Totaladdtionalcharges);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust Security Deposit" := securitydeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end else if TotalReceivable > 0 then begin
                    AppliedAmount := Min(securitydeposit, TotalReceivable);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust Security Deposit" := securitydeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end;
            end;
        end;
        while ((chillerdeposit > 0))
                      and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin

            // 2. Apply to Chiller Deposit
            if (chillerdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) then begin
                if Totaladdtionalcharges > 0 then begin
                    AppliedAmount := Min(chillerdeposit, Totaladdtionalcharges);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust Chiller Deposit" := chillerdeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end else if TotalReceivable > 0 then begin
                    AppliedAmount := Min(chillerdeposit, TotalReceivable);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust Chiller Deposit" := chillerdeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end;
            end;
        end;

        while ((otherdeposit > 0))
                    and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do begin
            // 3. Apply to Other Deposit
            if (otherdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) then begin
                if Totaladdtionalcharges > 0 then begin
                    AppliedAmount := Min(otherdeposit, Totaladdtionalcharges);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust other deposit" := otherdeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end else if TotalReceivable > 0 then begin
                    AppliedAmount := Min(otherdeposit, TotalReceivable);
                    // Create journal line
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
                    finalsettlmentRefund1.SetRange("Contract ID", Rec."Contract ID");
                    if finalsettlmentRefund1.FindSet() then begin
                        finalsettlmentRefund1."Adjust other deposit" := otherdeposit;
                        finalsettlmentRefund1.Modify();
                    end;
                    LastLineNo += 10000;
                end;
            end;
        end;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if not GenJnlLine.IsEmpty() then
            if Confirm('Do you want to post journal lines?', true) then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
                Message('Journal entries have been created and posted successfully');
            end else
                exit;
    end;

    // Helper function
    local procedure Min(a: Decimal; b: Decimal): Decimal
    begin
        if a < b then
            exit(a)
        else
            exit(b);
    end;

}