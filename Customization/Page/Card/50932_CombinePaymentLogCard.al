page 50932 "CombinePaymentLogCard"
{
    PageType = ListPart;
    SourceTable = "CombinePaymentLog";
    ApplicationArea = All;
    Caption = 'Combine Payment Log Details';
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("New VAT Amount"; Rec."New VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Change Amount Including VAT"; Rec."Change Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("cheque No"; Rec."C_Cheque_Number")
                {
                    ApplicationArea = All;
                }
                field("Deposit Bank"; Rec."C_Deposit_Bank")
                {
                    ApplicationArea = All;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

            }

        }

    }
}