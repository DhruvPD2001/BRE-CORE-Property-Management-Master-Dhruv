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
        if InvoiceCreditNoteSummaryRec1.FindFirst() then begin
            if InvoiceCreditNoteSummaryRec1.Invoice > 0 then begin
                TerminationAdditionalCharges.SetRange("Contract ID", InvoiceCreditNoteSummaryRec1."Contract No.");
                if TerminationAdditionalCharges.FindFirst() then begin
                    newsalesheader := AdditionalchargesSalesHeader(TerminationAdditionalCharges."Contract ID", TerminationAdditionalCharges."Tenant ID", TerminationAdditionalCharges."Unit Type");
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
        end;

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

}