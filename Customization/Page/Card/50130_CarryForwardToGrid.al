page 50130 "Carry Forward Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Security Deposit";
    Caption = 'Carry Forward To';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New Contract ID"; Rec."New_Contract ID")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Carry Forward Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CarryForward)
            {
                ApplicationArea = All;
                Caption = 'Carry Forward';
                Image = TransferFunds;
                trigger OnAction()
                var
                    securityDepositRec: Record "Security Deposit";
                    tenancyContractRec: Record "Tenancy Contract";
                    securityDepositCard: Page "Security Deposit Card";
                begin
                    securityDepositRec.Reset();
                    securityDepositRec.Init();

                    PopulateContractDetails(securityDepositRec, contractId);
                    securityDepositCard.SetRecord(securityDepositRec);
                    securityDepositCard.Run();
                end;
            }
        }
    }

    var
        contractId: Integer;

    procedure SetContractId(pContractId: Integer)
    begin
        contractId := pContractId;
    end;

    procedure PopulateContractDetails(var pSecurityDepositRec: Record "Security Deposit"; pContractId: Integer)
    var
        tenancyContractRec: Record "Tenancy Contract";
    begin
        if tenancyContractRec."Security Deposit Amount" = tenancyContractRec."Carry Forward Out" then
            exit;
        if tenancyContractRec.Get(pContractId) then begin
            pSecurityDepositRec."Contract ID" := pContractId;
            pSecurityDepositRec."Tenant Full Name" := tenancyContractRec."Customer Name";
            pSecurityDepositRec."Property Classification" := tenancyContractRec."Property Classification";
            pSecurityDepositRec."Contract Start Date" := tenancyContractRec."Contract Start Date";
            pSecurityDepositRec."Contract End Date" := tenancyContractRec."Contract End Date";
            pSecurityDepositRec."Security Deposit Amount" := tenancyContractRec."Security Deposit Amount";
            pSecurityDepositRec."Balance Amount" := tenancyContractRec."Security Balanced Amount";
            pSecurityDepositRec.Insert(true);
        end;
    end;
}