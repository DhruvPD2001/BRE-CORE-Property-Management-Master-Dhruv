page 50990 "InvoiceCreditNoteSummary"
{
    PageType = ListPart;
    SourceTable = InvoiceCreditNoteSummary;
    ApplicationArea = All;
    Caption = 'Invoice / Credit Note Summary';
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    ToolTip = 'Specifies the description';
                    Editable = false;
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice';
                    ToolTip = 'Specifies the invoice amount.';
                }
                field(CreditNote; Rec."Credit Note")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note';
                    ToolTip = 'Specifies the credit note amount.';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    ToolTip = 'Specifies the invoiced amount.';
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    ToolTip = 'Specifies the invoice identification number.';
                }
                field("Credit Noted"; Rec."Credit Noted")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Noted';
                    ToolTip = 'Specifies the credited amount.';
                }
            }
            field(TotalInvoice; Rec."Total Invoice")
            {
                ApplicationArea = All;
                Caption = 'Total Invoice';
                ToolTip = 'Specifies the total invoice amount.';
                Editable = false;
            }
            field(TotalCreditNote; Rec."Total Credit Note")
            {
                ApplicationArea = All;
                Caption = 'Total Credit Note';
                ToolTip = 'Specifies the total credit note amount.';
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateInvoice)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                ToolTip = 'Generate the invoice';
                Image = Invoice;
                trigger OnAction()
                var
                    GenerateInvoicesCreditNotesFinalCalculation: Codeunit "GenerateInvoiceCreditNoteFC";
                begin
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateBillingInvoice(Rec);
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateAdditionalChargesInvoice(Rec);
                end;
            }
        }
    }



    procedure SetContractNo(pContractNo: Integer)
    begin
        ContractNo := pContractNo;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract No." := ContractNo;
    end;

    var
        ContractNo: Integer;
}