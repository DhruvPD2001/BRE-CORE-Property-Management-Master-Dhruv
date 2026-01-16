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
                    Editable = false;
                }
                field(CreditNote; Rec."Credit Note")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note';
                    ToolTip = 'Specifies the credit note amount.';
                    Editable = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    ToolTip = 'Specifies the invoiced amount.';
                    Editable = false;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                    ToolTip = 'Specifies the invoice identification number.';

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesLine: Record "Sales Line";
                        SalesLine2: Record "Sales Line";
                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        SalesHeader.SetRange("No.", Rec."Invoice ID");
                        if SalesHeader.FindFirst() then begin
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                        end else begin
                            postedsalesinvoice.SetRange("No.", Rec."Invoice ID");
                            if postedsalesinvoice.FindFirst() then begin
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);
                            end;
                        end;
                    end;
                }
                field("Credit Note ID"; Rec."Credit Note ID")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note ID';
                    Editable = false;
                    ToolTip = 'Specifies the credit note identification number.';

                    trigger OnDrillDown()
                    var
                        CreditNote: Record "Credit Note";
                    begin
                        CreditNote.SetRange("Credit Note No.", Rec."Credit Note ID");
                        if CreditNote.FindFirst() then begin
                            PAGE.Run(PAGE::"Credit Note Card", CreditNote);
                        end;
                    end;
                }
                field("Credit Noted"; Rec."Credit Noted")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Noted';
                    ToolTip = 'Specifies the credited amount.';
                    Editable = false;
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
            action(GenerateCreditNote)
            {
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                ToolTip = 'Generate the credit note';
                Image = CreditMemo;
                trigger OnAction()
                var
                    GenerateInvoicesCreditNotesFinalCalculation: Codeunit "GenerateInvoiceCreditNoteFC";
                begin
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateBillingCreditNote(Rec);
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateFinalAdjtContractReductionCreditNote(Rec);

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