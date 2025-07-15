page 50981 "Request CreditNote Grid"
{
    PageType = ListPart;
    SourceTable = "Request Credit Note Grid";
    ApplicationArea = All;
    Caption = 'Request Credit Note Grid';


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                }

                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Series';

                    //TableRelation = "Payment Mode2"."Payment Series" where("Contract ID" = field("Contract ID"));
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        paymenschedule2: Record "Payment Schedule2";
                        paymentmode2Rec: Record "Payment Mode2";
                    begin
                        Rec."Current Rent Amount" := 0; // Reset current rent amount on series change
                        paymentmode2Rec.SetRange("Contract ID", ContractID);
                        if Page.RunModal(Page::"Payment Mode2 List", paymentmode2Rec) = Action::LookupOK then begin
                            Rec."Payment Series" := paymentmode2Rec."Payment Series";
                            Rec."Contract ID" := ContractID;
                            if Rec."Line No." = 0 then
                                Rec.Insert(true);
                            paymentmode2Rec.SetRange("Payment Series", Rec."Payment Series");
                            paymentmode2Rec.SetRange("Contract ID", Rec."Contract ID");
                            //paymenschedule2.SetFilter("Secondary Item Type", '=%1', 'Rent');
                            if paymentmode2Rec.FindSet() then
                               // repeat 
                               begin
                                Rec."Current Rent Amount" := paymentmode2Rec.Amount;
                                Rec."Total Reduction" := Rec."Current Rent Amount";
                                // Rec."Secondary Item Type" := paymenschedule2."Secondary Item Type";
                            end;
                        end;
                    end;
                }
                field("View Charges Details"; Rec."View Charges Details")
                {
                    ApplicationArea = All;
                    Caption = 'View Charges Details';
                    Editable = false; // This field is not editable
                    ToolTip = 'Click to view detailed charges for this request.';

                    trigger OnDrillDown()
                    var
                        PaymentModeRec: Record "Payment Mode2";
                        PaymentScheduleRec: Record "Payment Schedule2";
                        FilteredSchedulePage: Page "Payment Schedule Card2"; // Replace with your actual page name
                    begin

                        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");

                        PaymentScheduleRec.SetRange("Payment Series", Rec."Payment Series");


                        if PaymentScheduleRec.FindFirst() then
                            FilteredSchedulePage.SetTableView(PaymentScheduleRec);


                        PAGE.Run(PAGE::"Payment Schedule Card2", PaymentScheduleRec);

                    end;
                }
                field("Current Rent Amount"; Rec."Current Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Current Rent Amount';
                    Editable = false;
                }
                field("Total Reduction"; Rec."Total Reduction")
                {
                    ApplicationArea = All;
                    Caption = 'Total Rent Reduction';
                    trigger OnValidate()
                    var
                    begin
                        if Rec."Total Reduction" > Rec."Current Rent Amount" then
                            Error('Total Rent Reduction cannot exceed Current Rent Amount.');
                        Rec."Total Pay Rent Amount" := Rec."Current Rent Amount" - Rec."Total Reduction";
                    end;

                }
                field("Total Pay Rent Amount"; Rec."Total Pay Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Pay Rent Amount';
                    Editable = false; // This field is calculated and not editable
                }

                field("Credit Memo Generated"; Rec."Credit Memo Generated")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Memo Generated';
                    Editable = false; // This field is calculated and not editable
                    // This field is calculated and not editable
                }

            }

        }


    }
    // actions
    // {
    //     area(Processing)
    //     {
    //         action(Submit)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Submit';
    //             Image = Submit;

    //             trigger OnAction()
    //             var
    //                 creditnotegrid: Record "Request Credit Note Grid";
    //             begin
    //                 creditnotegrid.DeleteAll();
    //             end;
    //         }
    //     }
    // }



    var
        requestno: Code[20];
        ContractID: Integer;


    // procedure SetRequestNo(pRequestNo: Code[20])
    // begin
    //     requestno := pRequestNo;
    // end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;
}