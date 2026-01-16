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
        salesHeader."Posting Date" := Today;
        salesHeader."Document Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader.Validate("Contract ID", pContractID);
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


    procedure createSalesLine(var SalesHeader2: Record "Sales Header"; item: Record Item; pAmount: Decimal; pVATAmount: Decimal; var paymentScheduleRec1: Record "Payment Schedule2"; pIsGLAccountLine: Boolean)
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        GenPostingSetup: Record "General Posting Setup";
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
        if pIsGLAccountLine then begin
            saleline.Validate(Type, saleline.Type::"G/L Account");
            GenPostingSetup.SetRange("Gen. Prod. Posting Group", item."Gen. Prod. Posting Group");
            GenPostingSetup.SetRange("Gen. Bus. Posting Group", SalesHeader2."Gen. Bus. Posting Group");
            if GenPostingSetup.FindFirst() then
                saleline.Validate("No.", GenPostingSetup."Sales Account");
        end
        else begin
            saleline.Validate(Type, saleline.Type::Item);
            saleline.Validate("No.", item."No.");
        end;

        saleline.Validate("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(pAmount));
        saleline."Contract ID" := SalesHeader2."Contract ID";
        saleline.Insert();

    end;
}