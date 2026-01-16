codeunit 50116 GenerateInvoiceCreditNoteFC
{
    procedure GenerateBillingInvoice(var pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary)
    var
        BillingCalcGrid: Record "Final Billing Calculation Grid";
        InvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary;
        newsalesheader: Record "Sales Header";
        customercard: Record Customer;
    begin
        InvoiceCreditNoteSummaryRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
        InvoiceCreditNoteSummaryRec.SetRange(Description, 'Final Billing Calculation');
        InvoiceCreditNoteSummaryRec.SetRange(Invoiced, false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then begin
            if InvoiceCreditNoteSummaryRec.Invoice > 0 then begin

                BillingCalcGrid.SetRange("Contract ID", InvoiceCreditNoteSummaryRec."Contract No.");
                if BillingCalcGrid.FindFirst() then begin
                    newsalesheader := CreateSalesHeader(BillingCalcGrid."Contract ID", BillingCalcGrid."Tenant ID", BillingCalcGrid."Property Classification");
                    customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                    if customercard.FindSet() then begin
                        if newsalesheader."Property Classification" <> '' then begin
                            customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                            customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                            customercard.Modify();
                        end
                    end;
                    if newsalesheader."Property Classification" <> '' then begin
                        newsalesheader."Gen. Bus. Posting Group" := newsalesheader."Property Classification";
                        newsalesheader."Customer Posting Group" := newsalesheader."Property Classification";
                        newsalesheader.Modify();
                    end;
                end;

                BillingCalcGrid.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
                BillingCalcGrid.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
                if BillingCalcGrid.FindSet() then
                    repeat
                        Saleslinecreate(newsalesheader, BillingCalcGrid);
                        BillingCalcGrid.Modify();
                    until BillingCalcGrid.Next() = 0;
                BillingCalcGrid."Invoice ID" := newsalesheader."No.";
                InvoiceCreditNoteSummaryRec."Invoice ID" := newsalesheader."No.";
                InvoiceCreditNoteSummaryRec.Invoiced := true;
                InvoiceCreditNoteSummaryRec.Modify();
                Message('Invoice has been generated, please click on the Invoice ID to proceed further');
            end
        end;

    end;

    procedure GenerateBillingCreditNote(var pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary)
    var
        InvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary;
        creditNote: Record "Credit Note";
        finalcalculation: Record "Final Calculation";
    begin
        InvoiceCreditNoteSummaryRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
        InvoiceCreditNoteSummaryRec.SetRange(Description, 'Final Billing Calculation');
        InvoiceCreditNoteSummaryRec.SetRange("Credit Noted", false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then
            if InvoiceCreditNoteSummaryRec."Credit Note" > 0 then begin
                creditNote.Init();
                creditNote."Contract ID" := InvoiceCreditNoteSummaryRec."Contract No.";
                finalcalculation.SetRange("Contract ID", InvoiceCreditNoteSummaryRec."Contract No.");
                if finalcalculation.FindFirst() then begin
                    creditNote."Credit Note Type" := creditNote."Credit Note Type"::"Termination Credit Note";
                    creditNote."Contract Start Date" := finalcalculation."Contract Start Date";
                    creditNote."Contract End Date" := finalcalculation."Contract End Date"; // Convert Integer to Text
                    creditNote."Unit Type" := finalcalculation."Unit Type";
                    creditNote."Contract Amount" := finalcalculation."Contract Amount";
                    creditNote."Tenant ID" := finalcalculation."Tenant ID";
                    creditNote."Tenant Name" := finalcalculation."Tenant Name";
                    creditNote."Tenant Email" := finalcalculation."Tenant Email"; // Convert Integer to Text
                    creditNote."FC ID" := finalcalculation."FC ID";
                    creditNote.Insert(true);
                    BillingCalculationSub(creditNote);
                end;
                InvoiceCreditNoteSummaryRec."Credit Noted" := true;
                InvoiceCreditNoteSummaryRec.Modify();
            end;
    end;

    procedure BillingCalculationSub(pCreditNote: Record "Credit Note")
    var
        BillingCalculationSubCN: Record "Billing Calculation CN";
        BillingCalculationSubFC: Record "Final Billing Calculation Grid";
    begin
        BillingCalculationSubCN.SetRange("Contract ID", pCreditNote."Contract ID");
        if BillingCalculationSubCN.FindSet() then
            BillingCalculationSubCN.DeleteAll();

        BillingCalculationSubFC.SetRange("Contract ID", pCreditNote."Contract ID");
        if BillingCalculationSubFC.FindSet() then
            repeat
                if BillingCalculationSubFC."DifferenceAmount" > 0 then begin
                    BillingCalculationSubCN.Init();
                    BillingCalculationSubCN."Credit Note ID" := pCreditNote."ID";
                    BillingCalculationSubCN."Contract ID" := pCreditNote."Contract ID";
                    BillingCalculationSubCN."Tenant ID" := pCreditNote."Tenant ID";
                    BillingCalculationSubCN."Item" := BillingCalculationSubFC."RevenueDescription";
                    BillingCalculationSubCN."Amount" := BillingCalculationSubFC."DifferenceAmount";
                    BillingCalculationSubCN."VAT Amount" := BillingCalculationSubFC."DifferenceVAT";
                    BillingCalculationSubCN."Amount Including VAT" := BillingCalculationSubFC."DifferenceAmountInclVAT";
                    BillingCalculationSubCN.Insert();
                    Clear(BillingCalculationSubCN);
                end;
            until BillingCalculationSubFC.Next() = 0;
    end;

    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; PropertyClassification: Text[50]): Record "Sales Header"
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
        customercard: Record Customer;
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := PropertyClassification;
        salesHeader."Posting No. Series" := salesReciveable."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure Saleslinecreate(salesheader1: Record "Sales Header"; Billingcalculation: Record "Final Billing Calculation Grid")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
    begin
        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;
        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then begin
            saleline."Line No." := newSaleslines."Line No." + 1000;
        end
        else begin
            saleline."Line No." := 1000;
        end;
        saleline."Document No." := salesheader1."No.";
        saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, Billingcalculation.RevenueDescription);
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if item.FindSet() then begin

            saleline.Validate("No.", item."No.");
        end;
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(Billingcalculation.DifferenceAmount));
        saleline."Contract ID" := Billingcalculation."Contract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure GenerateAdditionalChargesInvoice(var pInvoiceCreditNoteSummaryRec1: Record InvoiceCreditNoteSummary)
    var
        TerminationAdditionalCharges: Record "Additional Charges Sub";
        InvoiceCreditNoteSummaryRec1: Record InvoiceCreditNoteSummary;
        newsalesheader: Record "Sales Header";
        customercard: Record Customer;
    begin
        InvoiceCreditNoteSummaryRec1.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec1."Contract No.");
        InvoiceCreditNoteSummaryRec1.SetRange(Description, 'Termination Additional Charges');
        InvoiceCreditNoteSummaryRec1.SetRange(Invoiced, false);
        if InvoiceCreditNoteSummaryRec1.FindFirst() then
            // begin
            if InvoiceCreditNoteSummaryRec1.Invoice > 0 then begin
                TerminationAdditionalCharges.SetRange("Contract ID", InvoiceCreditNoteSummaryRec1."Contract No.");
                if TerminationAdditionalCharges.FindFirst() then begin
                    newsalesheader := AdditionalchargesSalesHeader(TerminationAdditionalCharges."Contract ID", TerminationAdditionalCharges."Tenant ID", TerminationAdditionalCharges."Unit Type");
                    customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                    if customercard.FindSet() then
                        // begin
                        if newsalesheader."Property Classification" <> '' then begin
                            customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                            customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                            customercard.Modify();
                        end;
                    // end;
                    if newsalesheader."Property Classification" <> '' then begin
                        newsalesheader."Gen. Bus. Posting Group" := newsalesheader."Property Classification";
                        newsalesheader."Customer Posting Group" := newsalesheader."Property Classification";
                        newsalesheader.Modify();
                    end;
                end;

                TerminationAdditionalCharges.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec1."Contract No.");
                TerminationAdditionalCharges.SetRange(Invoiced, false);
                if TerminationAdditionalCharges.FindSet() then
                    repeat
                        AdditionalchargesSaleslinecreate(newsalesheader, TerminationAdditionalCharges);
                        TerminationAdditionalCharges.Modify();
                    until TerminationAdditionalCharges.Next() = 0;
                TerminationAdditionalCharges."Invoiced ID" := newsalesheader."No.";
                TerminationAdditionalCharges."Posted Invoice ID" := newsalesheader."No.";
                InvoiceCreditNoteSummaryRec1.Invoiced := true;
                InvoiceCreditNoteSummaryRec1."Invoice ID" := newsalesheader."No.";
                InvoiceCreditNoteSummaryRec1.Modify();
                Message('Invoice has been generated of Additional Charges, please click on the Invoice ID to proceed further');
            end
        // end;

    end;

    procedure AdditionalchargesSalesHeader(pContractID: Integer; pTenantID: Code[20]; pUnitType: Text[50]): Record "Sales Header";
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
        customercard: Record Customer;
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        salesHeader."Posting No. Series" := salesReciveable."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure AdditionalchargesSaleslinecreate(salesheader1: Record "Sales Header"; TerminationchargesGrid: Record "Additional Charges Sub")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
    begin
        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;
        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then begin
            saleline."Line No." := newSaleslines."Line No." + 1000;
        end
        else begin
            saleline."Line No." := 1000;
        end;
        saleline."Document No." := salesheader1."No.";
        saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, TerminationchargesGrid."Secondary Item Type");
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if item.FindSet() then begin

            saleline.Validate("No.", item."No.");
        end;
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(TerminationchargesGrid.Amount));
        saleline."Contract ID" := TerminationchargesGrid."Contract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure GenerateFinalAdjtContractReductionCreditNote(var pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary)
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        InvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary;
        salesHeader: Record "Sales Header";
        salesHeader1: Record "Sales Header";
        SalesLine: Record "Sales Line";
        customercard: Record Customer;
        pendingReceivableRec: Record "Pending Receviable Grid";
        finalAdjContractRed: Record FinancialAdjContractReduction;
        SalesPost: Codeunit "Sales-Post";
        pendingReceviablePage: Page "Pending Recevieable Grid";
        item: Record Item;
        LineNo: Integer;
        CreditMemoNo: Code[20];
        InvoiceNo: Code[20];
        itemCreditMemoCreated: Boolean;
        glCreditMemoCreated: Boolean;
    begin
        InvoiceCreditNoteSummaryRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
        InvoiceCreditNoteSummaryRec.SetRange(Description, 'Financial Adjustments / Contract Reductions');
        InvoiceCreditNoteSummaryRec.SetRange("Credit Noted", false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then
            if InvoiceCreditNoteSummaryRec."Credit Note" > 0 then begin
                finalAdjContractRed.SetRange("Contract No.", InvoiceCreditNoteSummaryRec."Contract No.");
                if finalAdjContractRed.FindSet() then
                    repeat
                        item.SetRange(Description, finalAdjContractRed."Revenue Description");
                        item.SetRange("Item type template", item."Item type template"::"Secondary Item");
                        item.SetFilter("Category Types", '%1|%2|%3|%4', 'Refundable Deposit', 'Government fees', 'Govt. Fees', 'Government Fees');
                        if item.FindSet() then
                            ProcessCreditMemo(pInvoiceCreditNoteSummaryRec, item, finalAdjContractRed, salesHeader, salesHeader1, itemCreditMemoCreated, glCreditMemoCreated, false)
                        else begin
                            item.SetRange(Description, finalAdjContractRed."Revenue Description");
                            item.SetRange("Item type template", item."Item type template"::"Secondary Item");
                            item.SetFilter("Category Types", '%1|%2', 'Revenue', 'Charges');
                            if item.FindSet() then
                                ProcessCreditMemo(pInvoiceCreditNoteSummaryRec, item, finalAdjContractRed, salesHeader, salesHeader1, itemCreditMemoCreated, glCreditMemoCreated, true);

                        end;
                    until finalAdjContractRed.Next() = 0;

                // Implementation for creating credit memo for security deposit
                // SalesPost.Run(SalesHeader1);
                Message('✅ Sales Credit Memo created for the Security Deposit Amount');
                InvoiceCreditNoteSummaryRec."Credit Noted" := true;
                InvoiceCreditNoteSummaryRec.Modify();
            end;
    end;

    procedure ProcessCreditMemo(pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary; item: Record Item; finalAdjContractRed: Record FinancialAdjContractReduction; var salesHeader: Record "Sales Header"; var salesHeader1: Record "Sales Header"; var itemCreditMemoCreated: Boolean; var GLcreditMemoCreated: Boolean; pIsGLAccountLine: Boolean)
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        finalCalculation: Record "Final Calculation";
        customercard: Record Customer;
        pendingReceviablePage: Page "Pending Recevieable Grid";
        InvoiceNo: Code[20];
    begin
        if not pIsGLAccountLine then begin
            PaymentScheduleRec.Reset();
            PaymentScheduleRec.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
            PaymentScheduleRec.SetRange("Secondary Item Type", finalAdjContractRed."Revenue Description");
            PaymentScheduleRec.SetFilter("Payment Status", '<>%1', 'Received'); // Empty = Not Received
            if PaymentScheduleRec.IsEmpty then begin
                Message('No pending Security Deposit payments found for Credit Memo generation.');
                exit;
            end;
            if PaymentScheduleRec.FindFirst() then
                if not itemCreditMemoCreated then begin
                    InvoiceNo := PaymentScheduleRec."Invoice ID";
                    salesHeader := pendingReceviablePage.CreateSalesHeader(pInvoiceCreditNoteSummaryRec."Contract No.", PaymentScheduleRec."Tenant ID", PaymentScheduleRec."Property Classification", InvoiceNo);
                    InvoiceNo := '';
                    customercard.SetRange("No.", salesHeader."Sell-to Customer No.");
                    if customercard.FindFirst() then
                        if salesHeader."Property Classification" <> '' then begin
                            customercard.Validate("Gen. Bus. Posting Group", salesHeader."Property Classification");
                            customercard.Validate("Customer Posting Group", salesHeader."Property Classification");
                            customercard.Modify();
                        end;

                    if salesHeader."Property Classification" <> '' then begin
                        salesHeader.Validate("Gen. Bus. Posting Group", salesHeader."Property Classification");
                        salesHeader.Validate("Customer Posting Group", salesHeader."Property Classification");
                        salesHeader.Modify();
                    end;
                    pendingReceviablePage.createSalesLine(salesHeader, item, PaymentScheduleRec.Amount, PaymentScheduleRec."VAT Amount", PaymentScheduleRec, pIsGLAccountLine);
                    itemCreditMemoCreated := true;
                end
                else
                    pendingReceviablePage.createSalesLine(salesHeader, item, PaymentScheduleRec.Amount, PaymentScheduleRec."VAT Amount", PaymentScheduleRec, pIsGLAccountLine);
        end
        else
            if not GLcreditMemoCreated then begin
                finalCalculation.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
                if finalCalculation.FindFirst() then
                    SalesHeader1 := pendingReceviablePage.CreateSalesHeader(pInvoiceCreditNoteSummaryRec."Contract No.", finalCalculation."Tenant ID", PaymentScheduleRec."Property Classification", InvoiceNo);

                customercard.SetRange("No.", SalesHeader1."Sell-to Customer No.");
                if customercard.FindFirst() then
                    if SalesHeader1."Property Classification" <> '' then begin
                        customercard.Validate("Gen. Bus. Posting Group", SalesHeader1."Property Classification");
                        customercard.Validate("Customer Posting Group", SalesHeader1."Property Classification");
                        customercard.Modify();
                    end;

                if SalesHeader1."Property Classification" <> '' then begin
                    SalesHeader1.Validate("Gen. Bus. Posting Group", SalesHeader1."Property Classification");
                    SalesHeader1.Validate("Customer Posting Group", SalesHeader1."Property Classification");
                    SalesHeader1.Modify();
                end;
                pendingReceviablePage.createSalesLine(SalesHeader1, item, finalAdjContractRed.Amount, finalAdjContractRed."VAT Amount", PaymentScheduleRec, pIsGLAccountLine);
                GLcreditMemoCreated := true;
            end
            else
                pendingReceviablePage.createSalesLine(SalesHeader1, item, finalAdjContractRed.Amount, finalAdjContractRed."VAT Amount", PaymentScheduleRec, pIsGLAccountLine);
    end;
}