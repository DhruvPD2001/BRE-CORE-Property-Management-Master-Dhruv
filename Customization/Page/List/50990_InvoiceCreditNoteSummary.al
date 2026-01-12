page 50990 "InvoiceCreditNoteSummary"
{
    PageType = ListPart;
    SourceTable = InvoiceCreditNoteSummary;
    ApplicationArea = All;
    Caption = 'Invoice / Credit Note Summary';


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
                field("Credit Noted"; Rec."Credit Noted")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Noted';
                    ToolTip = 'Specifies the credited amount.';
                }
            }
            field("Total Amount"; Rec.Total)
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
                ToolTip = 'Specifies the total amount of all final adjustments and contract reductions.';
                Editable = false;
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