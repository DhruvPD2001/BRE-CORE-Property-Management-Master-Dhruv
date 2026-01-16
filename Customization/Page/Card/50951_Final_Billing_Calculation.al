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
                        field("Total Differnece Amount"; Rec."Total Differnece Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Differnece Amount';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference VAT';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount Incl. VAT';
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

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;
}
