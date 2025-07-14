page 50922 "Payment Schedule Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Schedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
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
                    //Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    //  Editable = false;

                }
                field("Overdue Invoice"; Rec."Overdue Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Invoice';
                    //Editable = false;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No of Days"; Rec."No of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Workflow frequency date"; Rec."Workflow frequency date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract start date"; Rec."Contract start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("VAT%"; Rec."VAT%")
                {
                    ApplicationArea = All;
                    Caption = 'VAT%';
                    Editable = false;
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

                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque Number';
                    Editable = false;
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                }

                field("Credit Note Amount"; Rec."Credit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                }

                field("Final Rent Amount"; Rec."Final Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                }


            }

        }

    }






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


        Requestcreditnotegrid.SetRange("Contract ID", Rec."Contract ID");
        Requestcreditnotegrid.SetRange("Payment Series", Rec."Payment Series");
        Requestcreditnotegrid.SetRange("Credit Memo Generated", true);
        if Requestcreditnotegrid.FindSet() then
            repeat
                Rec."Credit Note No." := Requestcreditnotegrid."Credit Note No.";
                Rec."Credit Note Amount" := Requestcreditnotegrid."Total Reduction";

            until Requestcreditnotegrid.Next() = 0;

        Rec."Final Rent Amount" := Rec."Amount Including VAT" - Rec."Credit Note Amount";
        Rec.Modify();
    end;




    var
        InvoicedField: Boolean;






}






