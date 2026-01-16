page 50906 "Additional Charges Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Additional Charges Sub";
    Caption = 'Termination Additional Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    Editable = false;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    Editable = false;
                }
                // field(Invoiced; Rec.Invoiced)
                // {
                //     ApplicationArea = All;
                // }
                field("Invoiced ID"; Rec."Invoiced ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }

            group(TotalAmount)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted Invoice ID"; Rec."Posted Invoice ID")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Caption = 'Invoice ID';
                    Editable = false;
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
                    Caption = 'Invoice Document URL';
                    ToolTip = 'Click to view the invoice document.';
                    Editable = false;
                    Visible = false;
                }

            }
        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;

    end;

    procedure SetUnitType(punittype: Text[20])

    begin
        unittype := punittype;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;
        Rec."Unit Type" := unittype;

        // Add this call to update totals
        // CurrPage.UPDATE;
        // UpdateParentPage();
        // exit(true);
    end;

    // Add this procedure to call back to the parent page
    // procedure UpdateParentPage()
    // var
    //     FinalCalculationCard: Page "Final Calculation Card";
    // begin
    //     CurrPage.UPDATE;
    //     if CurrPage.EDITABLE then begin
    //         FinalCalculationCard.UpdateTotalsFromSubpage();
    //     end;
    // end;


    var
        contractID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

        unittype: Text[20];

}




