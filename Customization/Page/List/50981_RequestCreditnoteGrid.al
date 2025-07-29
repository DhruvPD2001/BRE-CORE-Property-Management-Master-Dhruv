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
                        Rec."Current Charges Amount" := 0; // Reset Current Charges Amount on series change
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
                                Rec."Current Charges Amount" := paymentmode2Rec.Amount;
                                Rec."Total Reduction" := Rec."Current Charges Amount";
                                // Rec."Secondary Item Type" := paymenschedule2."Secondary Item Type";
                            end;
                        end;
                    end;
                }
                field("Charges"; Rec."Charges")
                {
                    ApplicationArea = All;
                    Caption = 'View Charges Details';
                    // This field is not editable
                    ToolTip = 'Click to view detailed charges for this request.';
                    TableRelation = "Payment Schedule2"."Secondary Item Type" where("Contract ID" = field("Contract ID"), "Payment Series" = field("Payment Series"));

                    trigger OnValidate()
                    var
                        PaymentSchedule2: Record "Payment Schedule2";
                    begin
                        PaymentSchedule2.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSchedule2.SetRange("Payment Series", Rec."Payment Series");
                        PaymentSchedule2.SetRange("Secondary Item Type", Rec.Charges);
                        if PaymentSchedule2.FindSet()
                        then begin
                            Rec."Current Charges Amount" := PaymentSchedule2.Amount;
                            Rec."Total Reduction" := Rec."Current Charges Amount";
                            Rec.Invoiced := PaymentSchedule2.Invoiced;
                            Rec."Invoice ID" := PaymentSchedule2."Invoice ID";

                        end;
                    end;

                }
                field("Current Charges Amount"; Rec."Current Charges Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Current Charges Amount';
                    Editable = false;
                }
                field("Total Reduction"; Rec."Total Reduction")
                {
                    ApplicationArea = All;
                    Caption = 'Total Reduction';
                    trigger OnValidate()
                    var
                    begin
                        if Rec."Total Reduction" > Rec."Current Charges Amount" then
                            Error('Total Rent Reduction cannot exceed Current Charges Amount.');
                        Rec."Total Pay Rent Amount" := Rec."Current Charges Amount" - Rec."Total Reduction";
                    end;

                }
                field("Total Pay Amount"; Rec."Total Pay Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Pay Amount';
                    Editable = false; // This field is calculated and not editable
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note No.';
                    Editable = false; // This field is not editable
                }

                field("Credit Memo Generated"; Rec."Credit Memo Generated")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Memo Generated';
                    Editable = IsFinanceManager;


                }

            }

        }



    }
    actions
    {
        area(Processing)
        {
            action(CeateandApplyCreditMemo)
            {
                Caption = 'Create & Apply Credit Memo';
                Image = CreditMemo;
                ApplicationArea = All;


                trigger OnAction()
                var
                    GenerateCreditMemo: Codeunit "Credit Memo Generate";
                    RequestCreditNoteRec: Record "Request Credit Note";
                    UserConfirmed: Boolean;
                begin
                    RequestCreditNoteRec.SetRange("Request No.", Rec."Request No.");
                    RequestCreditNoteRec.SetRange(Status, RequestCreditNoteRec.Status::Approved);
                    RequestCreditNoteRec.SetRange("Adjust with Invoice", RequestCreditNoteRec."Adjust with Invoice"::Pending);
                    if RequestCreditNoteRec.FindFirst() then begin
                        UserConfirmed := Confirm('Do you want to create and post the Sales Credit Memo now?', false);
                        if UserConfirmed then
                            GenerateCreditMemo.GenerateCreditMemo(Rec)
                        else
                            Message('Operation canceled by user.')
                    end
                    else
                        if RequestCreditNoteRec.Status <> RequestCreditNoteRec.Status::Approved then
                            Error('Credit Note must be approved before creating and applying a credit memo.');
                    if RequestCreditNoteRec."Adjust with Invoice" = RequestCreditNoteRec."Adjust with Invoice"::Adjusted then
                        Error('The Credit Note is already adjusted');
                end;
            }
        }
    }

    var
        requestno: Code[20];
        ContractID: Integer;
        IsFinanceManager: Boolean;


    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    trigger OnOpenPage()
    var
    begin
        IsFinanceManager := CheckUserRole();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then begin
            case UserPersonalization."Profile ID" of
                'FINANCE MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;
        end;
        exit(false);
    end;



}