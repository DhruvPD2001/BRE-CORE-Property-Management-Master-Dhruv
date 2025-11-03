pageextension 50503 salesinvoiceext extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                trigger OnValidate()
                var
                    tenancyContract: Record "Tenancy Contract";
                begin
                    tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                    if tenancyContract.FindFirst() then begin

                        Rec."Property Name" := tenancyContract."Property Name";
                        Rec."Unit Name" := tenancyContract."Unit Name";
                        Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                        Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + 'To' + Format(tenancyContract."Contract End Date");

                    end else begin
                        rec."Property Name" := '';
                        Rec."Unit Name" := '';
                        Rec."Contract Tenure" := '';
                        Rec."Contract Period" := ''

                        // Rec."Tenant Name" := '';

                    end;
                end;
            }
            field("Property Name"; Rec."Property Name")
            {
                Caption = 'Property Name';
                ApplicationArea = All;
                Editable = false;
            }
            field("Unit Name"; Rec."Unit Name")
            {
                Caption = 'Unit Name';
                ApplicationArea = All;
                Editable = false;
            }
            field("Contract Tenure"; Rec."Contract Tenure")
            {
                Caption = 'Contract Tenure';
                ApplicationArea = All;
                Editable = false;
            }
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                Caption = 'Customer Phone No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                Caption = 'Customer Email';
                ApplicationArea = All;
                Editable = false;
            }

            field("Contract Period"; Rec."Contract Period")
            {
                Caption = 'Contract Period';
                ApplicationArea = All;
            }
            field("Reason for Rejection"; Rec."Reason for Rejection")
            {
                Caption = 'Reason For Rejection';
                ApplicationArea = All;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                Caption = 'Approval Status';
                ApplicationArea = All;
                //  Editable = approvaleditable;
                //Editable = true;
            }
            field("Tenant Name"; Rec."Tenant Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer P.O"; Rec."Customer P.O")
            {
                ApplicationArea = All;
                Caption = 'Customer P.O';
            }
            field("Customer P.O Date"; Rec."Customer P.O Date")
            {
                ApplicationArea = All;
                Caption = 'Customer P.O Date';
            }
        }
    }

    actions
    {
        // addbefore("&Invoice")
        // {
        //     action(CreateSalesInvoice)
        //     {
        //         Caption = 'Sale Invoice';
        //         ApplicationArea = All;
        //         trigger OnAction()
        //         var
        //             generateSaleInvoice: Codeunit GenerateConsolidatedInvoices;

        //         begin
        //             //generateSaleInvoice.GenerateConsolidatedInvoicesDirectly();
        //             //generateSaleInvoice.Run();

        //         end;
        //     }
        // }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                    Error('The Sales Invoice cannot be posted because the approval status is not "Approved".');

            end;
        }


    }


    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";


    begin
        //   approvaleditable := GetUserEditableStatus();
        customer.SetRange("No.", Rec."Sell-to Customer No.");
        if customer.FindSet() then begin
            Rec."Sell-to Customer Name" := customer.Name;
            Rec."Sell-to Address" := customer.Address;
            Rec."Gen. Bus. Posting Group" := customer."Gen. Bus. Posting Group";
            Rec."VAT Bus. Posting Group" := customer."VAT Bus. Posting Group";
            Rec."Customer Posting Group" := customer."Customer Posting Group";
            Rec."Sell-to Phone No." := customer."Phone No.";
            Rec."Sell-to E-Mail" := customer."E-Mail";
            Rec."Bill-to Customer No." := customer."No.";
            Rec."Bill-to Name" := customer.Name;
            Rec."Bill-to Address" := customer.Address;
            Rec.Modify();

        end;

        salesline.SetRange("Document No.", Rec."No.");
        if salesline.FindSet() then
            repeat

                salesline."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
                salesline."Customer Price Group" := Rec."Customer Price Group";
                salesline."VAT Bus. Posting Group" := Rec."VAT Bus. Posting Group";

                salesline.Modify();
            until salesline.Next() = 0;




        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin

            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + ' To ' + Format(tenancyContract."Contract End Date")
        end else begin

            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';
        end;


    end;


    var
        approvaleditable: Boolean;
}
//     
