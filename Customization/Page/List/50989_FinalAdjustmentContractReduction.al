page 50989 "FinalAdjuContractReduction"
{
    PageType = ListPart;
    SourceTable = FinancialAdjContractReduction;
    ApplicationArea = All;
    Caption = 'Final Adjustment / Contract Reductions';
    InsertAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Revenue Description"; Rec."Revenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    ToolTip = 'Specifies the description of the revenue item.';

                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount for the final adjustment or contract reduction.';
                }
                field(VAT; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Specifies the VAT percentage applicable to the final adjustment or contract reduction.';
                }
                field("Amount Incl. VAT"; Rec."Amount Incl. VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Incl. VAT';
                    ToolTip = 'Specifies the total amount including VAT for the final adjustment or contract reduction.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies additional details or notes regarding the final adjustment or contract reduction.';
                }
                field("Credit Note ID"; Rec."Credit Note ID")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note ID';
                    ToolTip = 'Specifies the Credit Note identification number associated with this final adjustment or contract reduction.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        postedsalesinvoice: Record "Sales Cr.Memo Header";
                    begin
                        SalesHeader.SetRange("No.", Rec."Credit Note ID");
                        if SalesHeader.FindFirst() then begin
                            PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                        end else begin
                            postedsalesinvoice.SetRange("No.", Rec."Credit Note ID");
                            if postedsalesinvoice.FindFirst() then begin
                                PAGE.Run(PAGE::"Posted Sales Credit Memo", postedsalesinvoice);
                            end;
                        end;
                    end;
                }

            }
            field("Total Amount"; Rec.Total)
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
                ToolTip = 'Specifies the total amount of all final adjustments and contract reductions.';
                Editable = false;
            }
            field("Total VAT"; Rec."Total VAT")
            {
                ApplicationArea = All;
                Caption = 'Total VAT';
                ToolTip = 'Specifies the total VAT amount of all final adjustments and contract reductions.';
                Editable = false;
            }
            field("Total Amount Incl. VAT"; Rec."Total Amount Incl.VAT")
            {
                ApplicationArea = All;
                Caption = 'Total Amount Incl. VAT';
                ToolTip = 'Specifies the total amount including VAT of all final adjustments and contract reductions.';
                Editable = false;
            }
        }
    }
    var
        finaladjustmentcontractreduction: Record FinancialAdjContractReduction;


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