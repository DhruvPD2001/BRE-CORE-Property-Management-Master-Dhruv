page 50338 "Security Deposit List"
{
    PageType = List;
    SourceTable = "Security Deposit";
    ApplicationArea = All;
    Caption = 'Security Deposits';
    CardPageId = 50337;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Security Deposit ID"; Rec."Security Deposit ID")
                {
                    ApplicationArea = All;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }

                field("Tenant Full Name"; Rec."Tenant Full Name")
                {
                    ApplicationArea = All;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                }

                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = styleExpr;
                }

                field("New_Contract ID"; Rec."New_Contract ID")
                {
                    ApplicationArea = All;
                }

                field("New_Tenant Full Name"; Rec."New_Tenant Full Name")
                {
                    ApplicationArea = All;
                }

                field("New_Contract Start Date"; Rec."New_Contract Start Date")
                {
                    ApplicationArea = All;
                }

                field("New_Contract End Date"; Rec."New_Contract End Date")
                {
                    ApplicationArea = All;
                }

                field("New_Security Deposit Amount"; Rec."Carry Forward Amount")
                {
                    ApplicationArea = All;
                }

                field("Adjusted amount"; Rec."Security Deposit Amt. Pending")
                {
                    ApplicationArea = All;
                }

            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        styleExpr := GetStatusStyle();
    end;

    var
        styleExpr: Text;

    procedure GetStatusStyle(): Text
    begin
        if Rec.Status = Rec.Status::Open then
            exit('Strong');
        if Rec.Status = Rec.Status::Posted then
            exit('Favorable');
    end;
}
