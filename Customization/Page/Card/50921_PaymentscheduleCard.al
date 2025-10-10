page 50921 "Payment Schedule Card"
{
    PageType = Card;
    SourceTable = "Payment Schedule";
    ApplicationArea = All;
    Caption = 'Payment Schedule Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    Editable = false;
                }
                field("Contract Start date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }


            part("PaymentSchedule"; "Payment Schedule Card2")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID"),
                  "Tenant ID" = FIELD("Tenant ID");
                ApplicationArea = All;
                Caption = 'Payment Schedule';

            }



            group(TotalAmountCalculation)
            {
                Caption = 'Total Amount Calculation';
                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                }
                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                }
            }

        }
    }


}



