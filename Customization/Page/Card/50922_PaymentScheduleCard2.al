page 50922 "Payment Schedule Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Schedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Types';
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';



                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment Start Date';
                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment End Date';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Due Date';
                }

                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment No.';
                }


                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Payment Series';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Tenant Name';
                }


                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';

                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    Editable = InvoicedField;

                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = InvoicedField;
                }
                field("Invoice Approval Status"; Rec."Invoice Approval Status")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Approval Status';
                    Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    Editable = false;
                    Visible = false;

                }
                field("Overdue Invoice"; Rec."Overdue Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Invoice';
                    Editable = false;
                    Visible = false;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("No of Days"; Rec."No of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Workflow frequency date"; Rec."Workflow frequency date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Contract start date"; Rec."Contract start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("VAT%"; Rec."VAT%")
                {
                    ApplicationArea = All;
                    Caption = 'VAT%';
                    Editable = false;
                    Visible = false;
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Received Date"; Rec."Payment Recieved Date")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Received Date';
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

                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                    Visible = false;

                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque Number';
                    Editable = false;
                    Visible = false;
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                    Editable = false;
                    Visible = false;
                }

                field("Credit Note Amount"; Rec."Credit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                    Editable = false;
                    Visible = false;
                }

                field("Final Rent Amount"; Rec."Final Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                    Editable = false;
                    Visible = false;
                }
                field("Final RentAmountIncludingVAT"; Rec."Final RentAmountIncludingVAT")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount Including VAT"';
                    Editable = false;
                    Visible = false;
                }


            }
        }


    }


    actions
    {

        area(Processing)
        {
            action(FirstInvoice)
            {
                ApplicationArea = All;
                Caption = 'Initiate Contract Invoice';
                Image = Calculate;
                ToolTip = 'Create the first invoice of the contract based on the payment schedule.';
                trigger OnAction()
                var
                    PaymentScheduleRec: Record "Payment Schedule";
                    newsalesheader: Record "Sales Header";
                    salesheader1card: Record "Sales Header";
                    PaymentScheduleGrid: Record "Payment Schedule2";
                    customercard: Record Customer;
                    userConfirmed: Boolean;
                    PaymentscheduleGridRec: Record "Payment Schedule2";
                begin
                    PaymentScheduleGrid.SetRange("Contract ID", Rec."Contract ID");
                    PaymentScheduleGrid.SetRange("Tenant ID", Rec."Tenant ID");
                    PaymentScheduleGrid.SetFilter(Invoiced, '=false');
                    PaymentScheduleGrid.SetRange("Installment No.", 1);
                    if not PaymentScheduleGrid.FindSet() then begin
                        Message('No uninvoiced first installment records found.');
                        exit;
                    end else begin
                        userConfirmed := Confirm('Do you want to create the invoice?', false);
                        if not userConfirmed then
                            exit;
                        newsalesheader := CreateSalesHeader(PaymentScheduleGrid."Contract ID", PaymentScheduleGrid."Tenant ID", PaymentScheduleGrid."Property Classification");
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

                        PaymentscheduleGridRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentscheduleGridRec.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentscheduleGridRec.SetFilter(Invoiced, '=false');
                        PaymentscheduleGridRec.SetRange("Installment No.", 1);
                        if PaymentscheduleGridRec.FindSet() then
                            repeat
                                Saleslinecreate(newsalesheader, PaymentscheduleGridRec);
                                // Update the Payment Schedule record to mark it as invoiced
                                PaymentscheduleGridRec.Invoiced := true;
                                PaymentscheduleGridRec."Invoice ID" := newsalesheader."No.";
                                PaymentscheduleGridRec.Modify();
                            until PaymentscheduleGridRec.Next() = 0;
                        Message('Invoice %1 created successfully for first installment.', newsalesheader."No.");
                    end;
                    // Initialize totals

                end;
            }
        }
    }

    procedure CreateSalesHeader(pcontractid: Integer; pTenantID: Code[20]; pUnitType: Text[50]): Record "Sales Header"
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

    procedure Saleslinecreate(var salesheader1: Record "Sales Header"; var PaymentscheduleGridLine: Record "Payment Schedule2")
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
        item.SetRange(Description, PaymentscheduleGridLine."Secondary Item Type");
        if item.FindSet() then begin

            saleline.Validate("No.", item."No.");
        end;
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(PaymentscheduleGridLine.Amount));
        saleline."Contract ID" := PaymentscheduleGridLine."Contract ID";
        saleline."FC ID" := salesheader1."FC ID";
        saleline.Insert();
        Clear(saleline);
    end;

    procedure NotAccessInvoicedFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin

        if UserPersonalization1.Get(UserSecurityId()) then begin

            case UserPersonalization1."Profile ID" of
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

    // trigger OnAfterGetRecord()
    // var
    //     PaymentSchedule: Record "Payment Schedule";
    //     workflowfrequency: Record "Workflow Frequency PR";
    // begin
    //     InvoicedField := NotAccessInvoicedFieldFinanceManager();





    //     if PaymentSchedule.Get(Rec."Contract ID")
    //       then begin
    //         Rec."Contract start date" := PaymentSchedule."Contract Start date";
    //         Rec.Modify();
    //     end;

    //     workflowfrequency.SetRange("Property ID", Rec."Property ID");
    //     workflowfrequency.SetRange(Workflow, workflowfrequency.Workflow::Invoice);
    //     if workflowfrequency.FindSet() then begin
    //         Rec."No of Days" := workflowfrequency."No. of Days";
    //         Rec.Modify();
    //     end;


    //     if Rec."No of Days" = 0 then begin
    //         Rec."Workflow frequency date" := Rec."Due Date";
    //         Rec.Modify();
    //     end else begin
    //         Rec."Workflow frequency date" := CalcDate('-' + Format(Rec."No of Days") + 'D', Rec."Due Date");
    //         Rec.Modify();
    //     end;
    // end;

    trigger OnAfterGetRecord()
    var
        PaymentSchedule: Record "Payment Schedule";
        workflowfrequency: Record "Workflow Frequency PR";
        TempDueDate: Date;
        Requestcreditnotegrid: Record "Request Credit Note Grid";
    begin
        InvoicedField := NotAccessInvoicedFieldFinanceManager();

        if PaymentSchedule.Get(Rec."Contract ID") then
            Rec."Contract start date" := PaymentSchedule."Contract Start date";

        workflowfrequency.SetRange("Property ID", Rec."Property ID");
        workflowfrequency.SetRange(Workflow, workflowfrequency.Workflow::Invoice);
        if workflowfrequency.FindSet() then
            Rec."No of Days" := workflowfrequency."No. of Days";

        TempDueDate := Rec."Due Date";

        if TempDueDate <> 0D then begin
            if Rec."No of Days" = 0 then
                Rec."Workflow frequency date" := TempDueDate
            else
                Rec."Workflow frequency date" := CalcDate('-' + Format(Rec."No of Days") + 'D', TempDueDate);
        end else
            Rec."Workflow frequency date" := 0D; // or skip, or raise a warning




        Rec."Final Rent Amount" := Rec."Amount" - Rec."Credit Note Amount";
        Rec."Final RentAmountIncludingVAT" := Rec."Final Rent Amount" + (Rec."Final Rent Amount" * Rec."VAT%") / 100;
        //    Round("Final Rent Amount" + ("Final Rent Amount" * "VAT%") / 100, 0.01);
        Rec.Modify();
    end;





    var
        InvoicedField: Boolean;






}






