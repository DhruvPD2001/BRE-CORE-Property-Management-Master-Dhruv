page 50950 "Final Revenue Calculation Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Revenue Calculation Grid';
    SourceTable = "Final Revenue Calculation Grid";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Revenue Description"; Rec."Revenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    Visible = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount';
                    ToolTip = 'Specifies the original amount';
                    Editable = false;
                }
                field("Original VAT"; Rec."Original VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Original VAT';
                    ToolTip = 'Specifies the original VAT amount';
                    Editable = false;
                }
                field("Original Amount Incl."; Rec."Original Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount Incl.';
                    ToolTip = 'Specifies the original amount including VAT';
                    Editable = false;
                }
                field("Revised Amount"; Rec."Revised Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    ToolTip = 'Specifies the revised amount after recalculation';
                    Editable = false;
                }
                field("Revised VAT"; Rec."Revised VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    ToolTip = 'Specifies the revised VAT amount';
                    Editable = false;
                }
                field("Revised Amount Incl."; Rec."Revised Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl.';
                    ToolTip = 'Specifies the revised amount including VAT';
                    Editable = false;
                }
                field("Difference Amount"; Rec."Difference Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    ToolTip = 'Specifies the difference in amount';
                    Editable = false;
                }
                field("Difference VAT"; Rec."Difference VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    ToolTip = 'Specifies the difference in VAT';
                    Editable = false;
                }
                field("Difference Amount Incl."; Rec."Difference Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl.';
                    ToolTip = 'Specifies the difference in amount including VAT';
                    Editable = false;
                }
                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    Editable = false;
                    Visible = false;

                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    Visible = false;
                }
                field("Revised VAT %"; Rec."Revised VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'Reviseed VAT %';
                    Editable = false;
                    Visible = false;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    Editable = false;
                    Visible = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    Visible = false;
                }
                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
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

            }
            group("")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Original Values")
                    {
                        field("Total Original Amount"; Rec."Total Original Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original Amount';
                            Editable = false;
                        }
                        field("Total Original VAT"; Rec."Total Original VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original VAT';
                            Editable = false;
                        }

                        field("Total Orgininal AmountIncl.VAT"; Rec."Total Orgininal AmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Orgininal Amount Incl. VAT';
                            Editable = false;

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
                    group("Difference Values")
                    {
                        field("Total Difference Amount"; Rec."Total Difference Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount';
                            Editable = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Differnece VAT';
                            Editable = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount Incl. VAT';
                            Editable = false;
                        }
                    }
                }



            }
        }
    }
    ////////////// END 6 ///////////////////////
}