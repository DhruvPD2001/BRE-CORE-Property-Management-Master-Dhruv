page 50951 "Final Billing Calculation"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Billing Calculation Grid';
    SourceTable = "Final Billing Calculation Grid";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RevenueDescription; Rec.RevenueDescription) { Caption = 'Revenue Description'; ApplicationArea = All; Editable = false; }
                field("Contract ID"; Rec."Contract ID") { Caption = 'Contract ID'; ApplicationArea = All; Editable = false; Visible = false; }

                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; Visible = false; }

                field(InvoicedAmount; Rec.InvoicedAmount) { Caption = 'Invoiced Amount'; ApplicationArea = All; Editable = false; }
                field(InvoicedVAT; Rec.InvoicedVAT) { Caption = 'Invoiced VAT'; ApplicationArea = All; Editable = false; }
                field(InvoicedAmountInclVAT; Rec.InvoicedAmountInclVAT) { Caption = 'Invoiced Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
                field(RevisedAmount; Rec.RevisedAmount) { Caption = 'Revised Amount'; ApplicationArea = All; Editable = false; }
                field(RevisedVAT; Rec.RevisedVAT) { Caption = 'Revised VAT'; ApplicationArea = All; Editable = false; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { Caption = 'Revised Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
                field(DifferenceAmount; Rec.DifferenceAmount) { Caption = 'Difference Amount'; ApplicationArea = All; Editable = false; }
                field(DifferenceVAT; Rec.DifferenceVAT) { Caption = 'Difference VAT'; ApplicationArea = All; Editable = false; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { Caption = 'Difference Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
                field("Termination Date"; Rec."Termination Date")
                {
                    Caption = 'Termination Date';
                    ApplicationArea = All;
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
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Classification';
                    Editable = false;
                    Visible = false;
                }
                field("Invoiced"; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    // Editable = false;
                }

            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Invoice Values")
                    {
                        field("Total Invoiced Amount"; Rec."Total Invoiced Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced Amount';
                        }
                        field("Total Invoiced VAT"; Rec."Total Invoiced VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced VAT';
                        }
                        field("Total Invoiced AmountIncl. VAT"; Rec."Total Invoiced AmountIncl. VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced Amount Incl. VAT';
                        }
                    }
                    group("Revised Values")
                    {

                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount';
                            Editable = false;

                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised VAT';
                            Editable = false;

                        }
                        field("Total Revised AmountIncl.VAT"; Rec."Total Revised AmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount Incl. VAT';
                            Editable = false;
                        }

                    }
                    // group("Difference & Summary")
                    // {
                    //     field("Total Differnece Amount"; Rec."Total Differnece Amount")
                    //     {
                    //         ApplicationArea = All;
                    //         Editable = false;
                    //         Caption = 'Total Differnece Amount';
                    //     }
                    //     field("Total Difference VAT"; Rec."Total Difference VAT")
                    //     {
                    //         ApplicationArea = All;
                    //         Editable = false;
                    //         Caption = 'Total Difference VAT';
                    //     }
                    //     field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                    //     {
                    //         ApplicationArea = All;
                    //         Editable = false;
                    //         Caption = 'Total Difference Amount Incl. VAT';
                    //     }
                    // }
                    group("Summary")
                    {
                        field("Invoice To Be Raised"; Rec."Invoice To Be Raised")
                        {
                            ApplicationArea = All;
                            Caption = 'Invoice To Be Raised';
                            Editable = false;
                        }
                        field("Credit Note To Be Raised"; Rec."Credit Note To Be Raised")
                        {
                            ApplicationArea = All;
                            Caption = 'Credit Note To Be Raised';
                            Editable = false;
                        }

                        field("Creditnote"; Rec."Creditnote")
                        {
                            ApplicationArea = All;
                            Caption = 'Creditnote';
                            Editable = false;
                            Visible = false;
                        }

                    }
                }



            }
            group("Final Billing Details")
            {
                grid(BillingDetail)
                {
                    GridLayout = Columns;

                    group("Invoice Details")
                    {
                        field("Invoice Amount"; Rec."Invoice Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Invoice Amount';
                            Editable = false;
                        }
                        field("Posted Invoice ID"; Rec."Posted Invoice ID")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Invoice ID';
                            DrillDown = true;
                            ToolTip = 'Click to view the invoice.';
                            //  DrillDownPageId = "Sales Invoice";
                            trigger OnDrillDown()
                            var
                                SalesHeader: Record "Sales Header";
                                SalesLine: Record "Sales Line";
                                SalesLine2: Record "Sales Line";
                                postedsalesinvoice: Record "Sales Invoice Header";
                            begin


                                SalesHeader.SetRange("No.", Rec."Posted Invoice ID");
                                if SalesHeader.FindFirst() then begin
                                    PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                                end else begin
                                    postedsalesinvoice.SetRange("No.", Rec."Posted Invoice ID");
                                    if postedsalesinvoice.FindFirst() then begin
                                        PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);
                                    end;
                                end;

                            end;

                        }
                        field("Invoice Document"; Rec."Invoice Document")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Invoice Document';


                            DrillDown = true;
                            trigger OnDrillDown()
                            var
                                FileURL: Text;
                            begin
                                FileURL := Rec."Invoice Document URL";
                                if FileURL = '' then
                                    Error('No document is available to view.');
                                OpenFileInBrowser(FileURL);
                            end;
                        }
                        field("Invoice Document URL"; Rec."Invoice Document URL")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Invoice Document URL';
                            Visible = false;
                            //  DrillDown = true;

                        }
                    }
                    group("Credit Note Details")
                    {
                        field("Credit Note Amount"; Rec."Credit Note Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Credit Note Amount';
                            Editable = false;
                        }
                        field("Credit Note ID"; Rec."Credit Note ID")
                        {
                            ApplicationArea = All;
                            Caption = 'Credit Note ID';
                            Editable = false;
                            DrillDown = true;

                            trigger OnDrillDown()
                            var
                                creditnote: Record "Credit Note";
                            begin
                                creditnote.SetRange("Credit Note No.", Rec."Credit Note ID");
                                if creditnote.FindFirst() then
                                    Page.Run(Page::"Credit Note Card", creditnote)
                                else
                                    Message('No Credit Note found with this ID.');
                            end;
                        }
                        field("Credit Note Document"; Rec."Credit Note Document")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Credit Note Document';


                            DrillDown = true;
                            trigger OnDrillDown()
                            var
                                FileURL: Text;
                            begin
                                FileURL := Rec."Credit Note Document URL";
                                if FileURL = '' then
                                    Error('No document is available to view.');
                                OpenFileInBrowser(FileURL);
                            end;
                        }
                        field("Credit Note Document URL"; Rec."Credit Note Document URL")
                        {
                            ApplicationArea = All;
                            Caption = 'Credit Note Document URL';
                            Editable = false;
                            Visible = false;
                            //  DrillDown = true;

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
            action(Invoice)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                Image = NewInvoice;
                trigger OnAction()
                var
                    newsalesheader: Record "Sales Header";
                    salesheader1card: Record "Sales Header";
                    BillingCalculationGrid: Record "Final Billing Calculation Grid";
                    customercard: Record Customer;
                    pendingrecevieable: Record "Final Billing Calculation Grid";
                    userConfirmed: Boolean;

                begin
                    if Rec.DifferenceAmountInclVAT < 0 then begin
                        if Rec.Invoiced = false then begin
                            userConfirmed := Confirm('Do you want to create the invoice?', false);
                            if not userConfirmed then
                                exit;
                            newsalesheader := CreateSalesHeader(Rec."Contract ID", Rec."Tenant ID", Rec."Property Classification");
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

                            BillingCalculationGrid.SetRange("Contract ID", Rec."Contract ID");
                            BillingCalculationGrid.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
                            if BillingCalculationGrid.FindSet() then
                                repeat
                                    Saleslinecreate(newsalesheader, BillingCalculationGrid);
                                    BillingCalculationGrid.Invoiced := true;
                                    BillingCalculationGrid."Invoice ID" := newsalesheader."No.";
                                    BillingCalculationGrid."Posted Invoice ID" := newsalesheader."No.";
                                    BillingCalculationGrid.Modify();
                                until BillingCalculationGrid.Next() = 0;
                            Message('Invoice has been generated, please click on the Invoice ID to proceed further');

                        end else begin
                            Message('Already Invoiced is created');
                        end
                    end else begin
                        Message('Need to create Credit Note');
                    end;



                end;
            }

            action(GenerateCreditNote)
            {
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                Image = PostDocument;

                trigger OnAction()
                var
                    CreditNoteListPage: Page "Credit Note List"; // Or use the correct Page ID/name if different
                begin
                    PAGE.Run(PAGE::"Credit Note List");
                end;
            }
        }
    }
    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
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
        //newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
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
        if item.FindSet() then begin

            saleline.Validate("No.", item."No.");
        end;
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(Billingcalculation.DifferenceAmount));
        saleline."Contract ID" := Billingcalculation."Contract ID";
        // saleline."FC ID" := Billingcalculation.;
        saleline.Insert();
        Clear(saleline);
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    // trigger OnAfterGetRecord()
    // var
    // begin
    //     FetchDataFromRevenueCalcGrid();
    //     Receiptamountfrompaymentscheule();
    //     DifferenceAmountCalculation();
    //     GetPositiveAmount();
    //     GetOnlyCreditNoteAmount();
    //     GetOnlyInvoiceAmount();
    // end;

    // procedure FetchDataFromRevenueCalcGrid()
    // var
    //     RevenueGrid: Record "Final Revenue Calculation Grid";
    // begin
    //     RevenueGrid.SetRange("Contract ID", Rec."Contract ID");
    //     RevenueGrid.SetRange("Revenue Description", Rec.RevenueDescription);
    //     if RevenueGrid.FindSet() then
    //         repeat
    //             Rec.RevisedAmount := RevenueGrid."Revised Amount";
    //             Rec.RevisedVAT := RevenueGrid."Revised VAT";
    //             Rec.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
    //             Rec.Modify();
    //         until RevenueGrid.Next() = 0;

    // end;

    // procedure DifferenceAmountCalculation()
    // var

    // begin

    //     Rec."DifferenceAmount" := Rec.InvoicedAmount - Rec.RevisedAmount;
    //     Rec."DifferenceVAT" := Rec.InvoicedVAT - Rec.RevisedVAT;
    //     Rec.DifferenceAmountInclVAT := Rec.InvoicedAmountInclVAT - Rec.RevisedAmountInclVAT;
    //     Rec.Modify();

    // end;

    // procedure Receiptamountfrompaymentscheule()
    // var
    //     PaymentScheduleRec: Record "Payment Schedule2";
    //     Totalamount: Decimal;
    //     VATAmount: Decimal;
    //     AmountIncVAT: Decimal;
    // begin
    //     Totalamount := 0;
    //     PaymentScheduleRec.Reset();
    //     PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
    //     //PaymentScheduleRec.SetFilter("Due Date", '<%1', Rec."Termination Date");
    //     PaymentScheduleRec.SetFilter("Workflow frequency date", '<%1', Rec."Termination Date");
    //     PaymentScheduleRec.SetRange(Invoiced, true);
    //     PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
    //     if PaymentScheduleRec.FindSet() then begin
    //         repeat
    //             Totalamount += PaymentScheduleRec.Amount;
    //             VATAmount += PaymentScheduleRec."VAT Amount";
    //             AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

    //         until PaymentScheduleRec.Next() = 0;
    //     end;
    //     PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
    //     PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
    //     if PaymentScheduleRec.FindSet() then
    //         repeat
    //             Rec.InvoicedAmount := Totalamount;
    //             Rec.InvoicedVAT := VATAmount;
    //             Rec.InvoicedAmountInclVAT := AmountIncVAT;
    //             Rec.Modify();
    //         until PaymentScheduleRec.Next() = 0;
    // end;

    // procedure GetPositiveAmount()
    // var
    // begin
    //     if Rec."Total DifferenceAmountIncl.VAT" < 0 then begin
    //         Rec."Invoice To Be Raised" := Abs(Rec."Total DifferenceAmountIncl.VAT");
    //         Rec.Modify();
    //     end else begin
    //         if Rec."CreditNote" = true then begin
    //             Rec."Credit Note To Be Raised" := 0;
    //         end else begin
    //             Rec."Credit Note To Be Raised" := Rec."Total DifferenceAmountIncl.VAT";
    //             Rec.Modify();
    //         end;
    //     end;
    // END;

    // procedure GetOnlyCreditNoteAmount()
    // var
    //     TotalPositiveDifference: Decimal;
    //     billingcalculationgird: Record "Final Billing Calculation Grid";
    // begin
    //     billingcalculationgird.SetRange("Contract ID", Rec."Contract ID");
    //     billingcalculationgird.SetFilter("DifferenceAmountInclVAT", '>%1', 0);
    //     if billingcalculationgird.FindSet() then
    //         repeat
    //             TotalPositiveDifference += billingcalculationgird."DifferenceAmountInclVAT"
    //         until billingcalculationgird.Next() = 0;
    //     Rec."Credit Note Amount" := TotalPositiveDifference;
    //     Rec.Modify();
    // end;

    // procedure GetOnlyInvoiceAmount()
    // var
    //     TotalNegativeDifference: Decimal;
    //     billingcalculationgird: Record "Final Billing Calculation Grid";
    // begin
    //     billingcalculationgird.SetRange("Contract ID", Rec."Contract ID");
    //     billingcalculationgird.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
    //     if billingcalculationgird.FindSet() then
    //         repeat
    //             TotalNegativeDifference += billingcalculationgird."DifferenceAmountInclVAT"
    //         until billingcalculationgird.Next() = 0;
    //     Rec."Invoice Amount" := Abs(TotalNegativeDifference);
    //     Rec.Modify();
    // end;
    trigger OnAfterGetRecord()
    var
    begin
        FetchDataFromRevenueCalcGrid();
        Receiptamountfrompaymentscheule();
        DifferenceAmountCalculation();
        GetPositiveAmount();

        CreditNoteTotalAmount();
        InvoiceTotalAmount();
        GetOnlyCreditNoteAmount();
        GetOnlyInvoiceAmount();
        InvoiceAmountZero();

    end;

    procedure FetchDataFromRevenueCalcGrid()
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", Rec."Contract ID");
        RevenueGrid.SetRange("Revenue Description", Rec.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                Rec.RevisedAmount := RevenueGrid."Revised Amount";
                Rec.RevisedVAT := RevenueGrid."Revised VAT";
                Rec.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
            //   Rec.Modify();
            until RevenueGrid.Next() = 0;

    end;

    procedure DifferenceAmountCalculation()
    var

    begin

        Rec."DifferenceAmount" := Rec.InvoicedAmount - Rec.RevisedAmount;
        Rec."DifferenceVAT" := Rec.InvoicedVAT - Rec.RevisedVAT;
        Rec.DifferenceAmountInclVAT := Rec.InvoicedAmountInclVAT - Rec.RevisedAmountInclVAT;
        // Rec.Modify();

    end;

    procedure Receiptamountfrompaymentscheule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        //PaymentScheduleRec.SetFilter("Due Date", '<%1', Rec."Termination Date");
        PaymentScheduleRec.SetFilter("Workflow frequency date", '<%1', Rec."Termination Date");
        PaymentScheduleRec.SetRange(Invoiced, true);
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then begin
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

            until PaymentScheduleRec.Next() = 0;
        end;
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Rec.InvoicedAmount := Totalamount;
                Rec.InvoicedVAT := VATAmount;
                Rec.InvoicedAmountInclVAT := AmountIncVAT;
            //   Rec.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;

    procedure GetPositiveAmount()
    var
    begin
        // if Rec."Total DifferenceAmountIncl.VAT" < 0 then begin
        //     Rec."Invoice To Be Raised" := Abs(Rec."Total DifferenceAmountIncl.VAT");
        //     Rec.Modify();
        // end else begin
        if Rec."CreditNote" = true then begin
            Rec."Credit Note To Be Raised" := 0;
            // end else begin
            //     Rec."Credit Note To Be Raised" := Rec."Total DifferenceAmountIncl.VAT";
            //     //    Rec.Modify();
            // end;
        end;
    END;

    procedure InvoiceAmountZero()
    var
    begin
        if Rec.Invoiced = true then begin
            Rec."Invoice To Be Raised" := 0;
        end;
    end;


    procedure CreditNoteTotalAmount()
    var
        TotalPositiveDifference: Decimal;
        billingcalculation: Record "Final Billing Calculation Grid";
    begin
        billingcalculation.SetRange("Contract ID", Rec."Contract ID");
        billingcalculation.SetFilter("DifferenceAmountInclVAT", '>%1', 0);
        if billingcalculation.FindSet() then
            repeat
                TotalPositiveDifference += billingcalculation."DifferenceAmountInclVAT"
            until billingcalculation.Next() = 0;

        Rec."Credit Note To Be Raised" := TotalPositiveDifference;
        // Rec.Modify();
    end;


    procedure InvoiceTotalAmount()
    var
        TotalNegativeDifference: Decimal;
        billingcalculationgird1: Record "Final Billing Calculation Grid";
    begin
        billingcalculationgird1.SetRange("Contract ID", Rec."Contract ID");
        billingcalculationgird1.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
        if billingcalculationgird1.FindSet() then
            repeat
                TotalNegativeDifference += billingcalculationgird1."DifferenceAmountInclVAT"
            until billingcalculationgird1.Next() = 0;

        Rec."Invoice To Be Raised" := Abs(TotalNegativeDifference);
        //  Rec.Modify();
    end;

    procedure GetOnlyCreditNoteAmount()
    var
        TotalPositiveDifference: Decimal;
        billingcalculationgird: Record "Final Billing Calculation Grid";
    begin
        billingcalculationgird.SetRange("Contract ID", Rec."Contract ID");
        billingcalculationgird.SetFilter("DifferenceAmountInclVAT", '>%1', 0);
        if billingcalculationgird.FindSet() then
            repeat
                TotalPositiveDifference += billingcalculationgird."DifferenceAmountInclVAT"
            until billingcalculationgird.Next() = 0;
        Rec."Credit Note Amount" := TotalPositiveDifference;
        // Rec."Credit Note To Be Raised" := TotalPositiveDifference;
        //  Rec.Modify();
    end;

    procedure GetOnlyInvoiceAmount()
    var
        TotalNegativeDifference: Decimal;
        billingcalculationgird: Record "Final Billing Calculation Grid";
    begin
        billingcalculationgird.SetRange("Contract ID", Rec."Contract ID");
        billingcalculationgird.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
        if billingcalculationgird.FindSet() then
            repeat
                TotalNegativeDifference += billingcalculationgird."DifferenceAmountInclVAT"
            until billingcalculationgird.Next() = 0;
        Rec."Invoice Amount" := Abs(TotalNegativeDifference);
        //  Rec."Invoice To Be Raised" := Abs(TotalNegativeDifference);
        Rec.Modify();
    end;

}
