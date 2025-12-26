page 50145 "Adjustment Deposits"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Adjustment Deposits";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the contract associated with the adjustment or refund.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of deposit being adjusted or refunded.';
                    trigger OnValidate()
                    begin
                        ClearAllFields();
                        ClearNarration();
                    end;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the deposit is to be refunded or adjusted.';

                    trigger OnValidate()
                    begin
                        ClearNarration();
                        UpdateNarration();
                        RefundValidateDepositAmount(Rec);

                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount to be refunded or adjusted.';

                    trigger OnValidate()
                    begin
                        ValidateAmount();
                    end;

                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows narration based on the transaction type selected.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Preview)
            {
                Caption = 'Post Refund';
                Image = PrepaymentPost;
                trigger OnAction()
                var
                    adjustmentDepositsRec: Record "Adjustment Deposits";
                    GenJournalLineRec: Record "Gen. Journal Line";
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";
                begin
                    GenJournalLineRec.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                    if GenJournalLineRec.FindSet() then
                        GenJournalLineRec.DeleteAll();

                    adjustmentDepositsRec.SetRange("Contract ID", Rec."Contract ID");
                    adjustmentDepositsRec.SetRange("Transaction Type", Rec."Transaction Type"::Refund);
                    if adjustmentDepositsRec.FindSet() then
                        repeat
                            RefundDepositAmount(adjustmentDepositsRec);
                        until adjustmentDepositsRec.Next() = 0;

                    Commit();
                    GenJournalLineRec.Reset();
                    GenJournalLineRec.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                    if GenJournalLineRec.FindFirst() then
                        GenJnlPost.Preview(GenJournalLineRec);
                end;
            }
            action(Post)
            {
                Caption = 'Post Adjustment';
                Image = Post;
                trigger OnAction()
                var
                    adjustmentDepositsRec: Record "Adjustment Deposits";
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", 'CASH RECE');
                    GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
                    if GenJnlLine.FindSet() then
                        GenJnlLine.DeleteAll();

                    adjustmentDepositsRec.SetRange("Contract ID", Rec."Contract ID");
                    if adjustmentDepositsRec.FindSet() then
                        repeat
                            AdditinalchargescashReceipt(adjustmentDepositsRec);
                        until adjustmentDepositsRec.Next() = 0;
                    // Commit created journal lines and open Cash Receipt Journals for user review
                    Commit();
                    PAGE.Run(PAGE::"Cash Receipt Journal");
                end;
            }
        }
    }

    var
        refundNarrationLbl: Label '%1 refund for contract ID "%2"', Comment = '%1 = Item Description, %2 = Contract ID';
        adjustnarrationLbl: Label '%1 adjusted with other receivables for contract ID "%2"', Comment = '%1 = Item Description, %2 = Contract ID';
        errorSDamountLbl: Label 'Amount should be less than or equal to the Security Deposit amount.', Comment = 'Error message when Security Deposit amount is invalid.';
        errorChilleramountLbl: Label 'Amount should be less than or equal to the Chiller Deposit amount.', Comment = 'Error message when Chiller Deposit amount is invalid.';
        errorOtheramountLbl: Label 'Amount should be less than or equal to the Other Deposit amount.', Comment = 'Error message when Other Deposit amount is invalid.';

    procedure UpdateNarration()
    begin
        case Rec."Transaction Type" of
            Rec."Transaction Type"::Refund:
                Rec.Narration := StrSubstNo(refundNarrationLbl, Rec."Item Description", Rec."Contract Id");
            Rec."Transaction Type"::Adjustment:
                Rec.Narration := StrSubstNo(adjustnarrationLbl, Rec."Item Description", Rec."Contract Id");
            Rec."Transaction Type"::" ":
                Rec.Narration := '';
        end;
    end;

    procedure ClearNarration()
    begin
        Rec.Narration := '';
    end;

    procedure ValidateAmount()
    var
        finalCalculationRec: Record "Final Calculation";
    begin
        finalCalculationRec.SetRange("Contract ID", Rec."Contract Id");
        if finalCalculationRec.FindFirst() then
            if Rec."Transaction Type" = Rec."Transaction Type"::Refund then
                case Rec."Item Description" of
                    Rec."Item Description"::"Security Deposit":
                        if Rec.Amount > finalCalculationRec."Net Balance" then
                            Error(errorSDamountLbl);
                    Rec."Item Description"::"Chiller Deposit":
                        if Rec.Amount > finalCalculationRec."Chiller Deposit" then
                            Error(errorChilleramountLbl);
                    Rec."Item Description"::"Other Deposit":
                        if Rec.Amount > finalCalculationRec."Other Deposit" then
                            Error(errorOtheramountLbl);
                end
            else
                case Rec."Item Description" of
                    Rec."Item Description"::"Security Deposit":
                        if Rec.Amount > finalCalculationRec."Remaining Security Deposit" then
                            Error(errorSDamountLbl);
                    Rec."Item Description"::"Chiller Deposit":
                        if Rec.Amount > finalCalculationRec."Remaining Chiller Deposit" then
                            Error(errorChilleramountLbl);
                    Rec."Item Description"::"Other Deposit":
                        if Rec.Amount > finalCalculationRec."Remaining Other Deposit" then
                            Error(errorOtheramountLbl);
                end
    end;

    procedure ClearAllFields()
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::" ";
        Rec.Amount := 0;
    end;

    procedure AdditinalchargescashReceipt(adjustmentDepositsRec: Record "Adjustment Deposits")
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "Final Calculation";
        TerminationCharges: Record "Additional Charges Sub";
        PendingReceivableGrid: Record "Pending Receviable Grid";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        BillingCalculation: Record "Final Billing Calculation Grid";
        Math: Codeunit Math;
        PostingDate: Date;
        DocumentNo: Code[20];
        InvoiceNo: Code[20];
        AdditionalInvoiceNo: Code[20];
        Tenantid: Code[20];
        Tenantname: Text[250];
        LastLineNo: Integer;
        AppliedAmount: Decimal;
        adjustableDeposit: Decimal;
        Totaladdtionalcharges: Decimal;
        TotalReceivable: Decimal;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ContractID: Integer;
        isReceivablePresent: Boolean;
        BalanceAccountNo: Code[20];
        TotalClaim: Decimal;
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

        // Only process Adjustment transaction types in this procedure
        if ((adjustmentDepositsRec."Transaction Type" = adjustmentDepositsRec."Transaction Type"::Adjustment) AND (adjustmentDepositsRec.Amount = 0)) or (adjustmentDepositsRec."Transaction Type" = adjustmentDepositsRec."Transaction Type"::Refund) then
            exit;

        // Use a clear document number for adjustment postings
        DocumentNo := 'ADJUSTMENT-' + Format(adjustmentDepositsRec."Contract ID");

        // Retrieve Final Calculation record
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", adjustmentDepositsRec."Contract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', adjustmentDepositsRec."Contract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        ContractID := finalcalculation."Contract ID";
        TotalClaim := finalcalculation."Total Claim";



        // Retrieve Termination Charges (additional charges) and calculate totals

        AppliedAmount := adjustmentDepositsRec.Amount;

        // Create General Journal Line
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        case adjustmentDepositsRec."Item Description" of
            adjustmentDepositsRec."Item Description"::"Security Deposit":
                BalanceAccountNo := '4502';
            adjustmentDepositsRec."Item Description"::"Chiller Deposit",
            adjustmentDepositsRec."Item Description"::"Other Deposit":
                BalanceAccountNo := '4508';
        end;





        // Insert a single cash receipt journal line for this adjustment record
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := adjustmentDepositsRec.Narration;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;
        GenJnlLine."Contract ID" := ContractID;
        GenJnlLine.Amount := Round(-AppliedAmount);
        GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
        GenJnlLine."Item Description" := adjustmentDepositsRec."Item Description";
        GenJnlLine."Transaction Type" := adjustmentDepositsRec."Transaction Type";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := BalanceAccountNo;
        // Do not set Applies-to fields since we don't need Posted Invoice IDs for adjustments
        GenJnlLine.Insert(true);
        LastLineNo += 10000;
    end;

    procedure RefundDepositAmount(adjustmentDepositsRec: Record "Adjustment Deposits")
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "Final Calculation";
        TerminationCharges: Record "Additional Charges Sub";
        PendingReceivableGrid: Record "Pending Receviable Grid";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        BillingCalculation: Record "Final Billing Calculation Grid";
        Math: Codeunit Math;
        PostingDate: Date;
        DocumentNo: Code[20];
        InvoiceNo: Code[20];
        AdditionalInvoiceNo: Code[20];
        Tenantid: Code[20];
        Tenantname: Text[250];
        LastLineNo: Integer;
        AppliedAmount: Decimal;
        adjustableDeposit: Decimal;
        Totaladdtionalcharges: Decimal;
        TotalReceivable: Decimal;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ContractID: Integer;
        isReceivablePresent: Boolean;
        BalanceAccountNo: Code[20];
        TotalClaim: Decimal;
    begin
        JournalTemplateName := 'GENERAL';
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

        // Only process Adjustment transaction types in this procedure
        if ((adjustmentDepositsRec."Transaction Type" = adjustmentDepositsRec."Transaction Type"::Refund) AND (adjustmentDepositsRec.Amount = 0)) or (adjustmentDepositsRec."Transaction Type" = adjustmentDepositsRec."Transaction Type"::Refund) then
            exit;

        // Use a clear document number for adjustment postings
        DocumentNo := 'ADJUSTMENT-' + Format(adjustmentDepositsRec."Contract ID");

        // Retrieve Final Calculation record
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", adjustmentDepositsRec."Contract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', adjustmentDepositsRec."Contract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        ContractID := finalcalculation."Contract ID";
        TotalClaim := finalcalculation."Total Claim";



        // Retrieve Termination Charges (additional charges) and calculate totals

        AppliedAmount := adjustmentDepositsRec.Amount;

        // Create General Journal Line
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        case adjustmentDepositsRec."Item Description" of
            adjustmentDepositsRec."Item Description"::"Security Deposit":
                BalanceAccountNo := '4502';
            adjustmentDepositsRec."Item Description"::"Chiller Deposit",
            adjustmentDepositsRec."Item Description"::"Other Deposit":
                BalanceAccountNo := '4508';
        end;


        // Insert a single cash receipt journal line for this adjustment record
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := adjustmentDepositsRec.Narration;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;
        GenJnlLine."Contract ID" := ContractID;
        GenJnlLine.Amount := Round(-AppliedAmount);
        GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
        GenJnlLine."Item Description" := adjustmentDepositsRec."Item Description";
        GenJnlLine."Transaction Type" := adjustmentDepositsRec."Transaction Type";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := BalanceAccountNo;
        // Do not set Applies-to fields since we don't need Posted Invoice IDs for adjustments
        GenJnlLine.Insert(true);
        LastLineNo += 10000;
    end;


    // Validate deposit amount

    procedure RefundValidateDepositAmount(var adjustmenrtDepositsRec: Record "Adjustment Deposits")
    var
        finalcalculationRec: Record "Final Calculation";
    begin
        finalcalculationRec.SetRange("Contract ID", adjustmenrtDepositsRec."Contract Id");
        if finalcalculationRec.FindFirst() then
            if adjustmenrtDepositsRec."Transaction Type" = adjustmenrtDepositsRec."Transaction Type"::Refund then
                if finalcalculationRec."Total Claim" <> 0 then
                    case adjustmenrtDepositsRec."Item Description" of
                        adjustmenrtDepositsRec."Item Description"::"Security Deposit":
                            if finalcalculationRec."Remaining Security Deposit" = 0 then
                                Error('No Security Deposit available for refund.');
                        adjustmenrtDepositsRec."Item Description"::"Chiller Deposit":
                            if finalcalculationRec."Remaining Chiller Deposit" = 0 then
                                Error('No Chiller Deposit available for refund.');
                        adjustmenrtDepositsRec."Item Description"::"Other Deposit":
                            if finalcalculationRec."Remaining Other Deposit" = 0 then
                                Error('No Other Deposit available for refund.');
                    end;
    end;
}