page 50952 "Pending Recevieable Grid"
{
    PageType = ListPart;
    SourceTable = "Pending Receviable Grid";
    ApplicationArea = All;
    Caption = 'Pending Receivable/Payable List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; Caption = 'Contract ID'; Editable = false; Visible = false; }
                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; Visible = false; }

                field(RevenueDescription; Rec.RevenueDescription) { ApplicationArea = All; Caption = 'Revenue Description'; Editable = false; }
                field(RevisedAmount; Rec.RevisedAmount) { ApplicationArea = All; Caption = 'Revised Amount'; Editable = false; }
                field(RevisedVAT; Rec.RevisedVAT) { ApplicationArea = All; Caption = 'Revised VAT'; Editable = false; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { ApplicationArea = All; Caption = 'Revised Amount Incl. VAT'; Editable = false; }
                field(ReceiptsAmount; Rec.ReceiptsAmount) { ApplicationArea = All; Caption = 'Receipts Amount'; Editable = false; }
                field(ReceiptsVAT; Rec.ReceiptsVAT) { ApplicationArea = All; Caption = 'Receipts VAT'; Editable = false; }
                field(ReceiptsAmountInclVAT; Rec.ReceiptsAmountInclVAT) { ApplicationArea = All; Caption = 'Receipts Amount Incl. VAT'; Editable = false; }
                field(DifferenceAmount; Rec.DifferenceAmount) { ApplicationArea = All; Caption = 'Difference Amount'; Editable = false; }
                field(DifferenceVAT; Rec.DifferenceVAT) { ApplicationArea = All; Caption = 'Difference VAT'; Editable = false; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { ApplicationArea = All; Caption = 'Difference Amount Incl. VAT'; Editable = false; }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;

                }
                field("CrditNoteID Security Deposit"; Rec."CrditNoteID Security Deposit")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note ID Security Deposit';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        postedsalesinvoice: Record "Sales Cr.Memo Header";
                    begin
                        postedsalesinvoice.SetRange("No.", Rec."CrditNoteID Security Deposit");
                        if postedsalesinvoice.FindFirst() then begin
                            PAGE.Run(PAGE::"Posted Sales Credit Memo", postedsalesinvoice);
                        end;
                    end;

                }
                field(GeneratedCRMemoSD; Rec.GeneratedCRMemoSD)
                {
                    ApplicationArea = All;
                    Caption = 'Generated CR Memo SD';
                    Editable = false;
                    Visible = false;
                }
            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;

                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised AmountIncl. VAT"; Rec."Total Revised AmountIncl. VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Receipts Values")
                    {
                        field("Total Receipts Amount"; Rec."Total Receipts Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts VAT"; Rec."Total Receipts VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts AmountIncl. VAT"; Rec."Total Receipts AmountIncl. VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }

                    }
                    group("Difference & Summary")
                    {
                        field("Total Difference Amount"; Rec."Total Difference Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Refundable"; Rec."Total Refundable")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receivable"; Rec."Total Receivable")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }

                    }
                }



            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Credit Note For Security Deposit")
            {
                Caption = 'Credit Note For Security Deposit';
                Image = CreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CreateSecurityDepositCreditMemo();
                end;
            }
        }
    }


    procedure CreateSecurityDepositCreditMemo()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        SalesHeader1: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        CreditMemoNo: Code[20];
        InvoiceNo: Code[20];
        SalesPost: Codeunit "Sales-Post";
        customercard: Record Customer;
        pendingReceivableRec: Record "Pending Receviable Grid";

    begin
        pendingReceivableRec.SetRange("Contract ID", Rec."Contract ID");
        pendingReceivableRec.SetRange(GeneratedCRMemoSD, true);
        if pendingReceivableRec.FindFirst() then
            Message('Credit Memo for Security Deposit has already been generated for this contract.')
        else begin

            // Implementation for creating credit memo for security deposit
            PaymentScheduleRec.Reset();
            PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
            PaymentScheduleRec.SetRange("Secondary Item Type", 'Security Deposit Amount');
            PaymentScheduleRec.SetFilter("Payment Status", '<>%1', 'Received'); // Empty = Not Received

            if PaymentScheduleRec.IsEmpty then begin
                Message('No pending Security Deposit payments found for Credit Memo generation.');
                exit;
            end;

            if PaymentScheduleRec.FindFirst() then begin
                InvoiceNo := PaymentScheduleRec."Invoice ID";
                SalesHeader1 := CreateSalesHeader(Rec."Contract ID", PaymentScheduleRec."Tenant ID", PaymentScheduleRec."Property Classification", InvoiceNo);
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
                createSalesLine(SalesHeader1, PaymentScheduleRec.Amount, PaymentScheduleRec."VAT Amount", PaymentScheduleRec);

                pendingReceivableRec.Reset();
                pendingReceivableRec.SetRange("Contract ID", Rec."Contract ID");
                pendingReceivableRec.SetRange(RevenueDescription, 'Security Deposit Amount');
                if pendingReceivableRec.FindFirst() then begin
                    pendingReceivableRec."CrditNoteID Security Deposit" := SalesHeader1."No.";
                    pendingReceivableRec.GeneratedCRMemoSD := true;
                    pendingReceivableRec.Modify();
                end;

                SalesPost.Run(SalesHeader1);
                Message('✅ Sales Credit Memo created for the Security Deposit Amount');
            end;
        end;


    end;




    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]; pInvoiceID: Code[50]): Record "Sales Header"
    var
        SalesHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
        TenancyContractRec: Record "Tenancy Contract";
    begin

        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Credit Memo Nos.", Today, true);

        salesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader.Validate("Contract ID", pContractID);
        salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        salesHeader."Posting No. Series" := salesReciveable."Posted Credit Memo Nos.";
        salesHeader."Approval Status for CreditNote" := SalesHeader."Approval Status for CreditNote"::Approved;
        SalesHeader.Validate("Applies-to Doc. Type", SalesHeader."Applies-to Doc. Type"::Invoice);
        SalesHeader.Validate("Applies-to Doc. No.", pInvoiceID);
        TenancyContractRec.SetRange("Contract ID", pContractID);
        if TenancyContractRec.FindFirst() then begin
            SalesHeader."Property Name" := TenancyContractRec."Property Name";
            SalesHeader."Unit Name" := TenancyContractRec."Unit Name";
            SalesHeader."Contract Tenure" := TenancyContractRec."Contract Tenor";
            SalesHeader."Contract Period" := Format(TenancyContractRec."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(TenancyContractRec."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
            SalesHeader."Contract Amount" := Round(TenancyContractRec."Annual Rent Amount");
        end;

        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure createSalesLine(var SalesHeader2: Record "Sales Header"; pAmount: Decimal; pVATAmount: Decimal; var paymentScheduleRec1: Record "Payment Schedule2")
    var
        saleline: Record "Sales Line";
        item: Record Item;
        newSaleslines: Record "Sales Line";
    begin
        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::"Credit Memo";
        saleline.Validate("Document No.", SalesHeader2."No.");

        // Calculate Line No
        newSaleslines.SetRange("Document No.", SalesHeader2."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::"Credit Memo");
        newSaleslines.SetRange("Contract ID", SalesHeader2."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000
        else
            saleline."Line No." := 1000;

        saleline.Validate("Contract ID", SalesHeader2."Contract ID");
        saleline.Type := saleline.Type::Item;
        saleline.Validate("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");

        // Map item by description
        item.SetRange(Description, paymentScheduleRec1."Secondary Item Type");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.")
        else
            Error('No item found with description "%1"', paymentScheduleRec1."Secondary Item Type");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(paymentScheduleRec1.Amount));
        saleline."Contract ID" := paymentScheduleRec1."Contract ID";
        saleline.Insert();

    end;
}