page 50939 "Tenancy Contract SubPage Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Tenancy Contract Subpage";
    Caption = 'Other Payments';
    DeleteAllowed = false;

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

                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';

                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;

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
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                }
                field("Invoiced and Paid"; Rec."Invoiced and Paid")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced and Paid';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Enter the Payment Type.';
                    ShowMandatory = true;
                    NotBlank = true;


                }



                field("Generate Payment Schedule"; Rec."Generate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        TargetPageID: Integer;
                        TargetRecord: Record "Revenue Structure"; // Replace with the actual table name
                        StartDate: Date;
                        EndDate: Date;
                        AnnualAmount: Decimal;
                        NumInstallments: Integer;
                        PeriodStartDate: Date;
                        PeriodEndDate: Date;
                        YearCounter: Integer;
                        NumDays: Integer;
                        RevenueStructure: Record "Revenue Structure Subpage";
                        InstallmentStructure: Record "Revenue Structure Subpage1"; // Second Table
                        InstallmentStartDate, InstallmentEndDate, InstallmentDueDate : Date;
                        PaymentMode: Option;
                        InstallmentNumber: Integer;
                        InstallmentYearcounter: Integer;
                        InstallmentAmount: Decimal;
                        DaysInPeriod, DaysPerInstallment : Integer;
                        CurrentStartDate: Date;
                        CurrentEndDate: Date;
                        InstallmentAnnualAmount: Decimal;
                        i: Integer;
                        DaysInYear: Integer;
                        IsLeapYear: Boolean;
                        Year: Integer;
                        RemainingInstallments: Integer;
                        InsertedInstallments: Integer;
                        VATAmount: Decimal;
                        VATandAmount: Decimal;
                        IsLeapYearInRange: Boolean;
                        CurrentYear: Integer;
                        StartYear: Integer;
                        EndYear: Integer;
                        LeapDate: Date;
                        Revenuestructureid: Integer;
                        //LeaseRecord: Record "Lease Proposal Details";

                        DaysToAdd: Integer;
                        LeapDays: Integer;
                    begin

                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin



                            TargetRecord.SetRange("Contract ID", Rec."ContractID");
                            TargetRecord.SetRange("Secondary Item Type", Rec."Secondary Item Type");
                            TargetRecord.SetRange("Tenant ID", Rec."TenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord."Entry No" := Rec."Entry No.";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                // TargetRecord."Proposal ID" := Rec."ProposalID";
                                TargetRecord."Contract ID" := Rec."ContractID";
                                TargetRecord."Tenant ID" := Rec."TenantID";
                                TargetRecord."Secondary Item Type" := Rec."Secondary Item Type";
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord."Entry No" := Rec."Entry No.";
                                TargetRecord.Insert();


                                StartDate := TargetRecord."Contract Start Date";
                                EndDate := TargetRecord."Contract End Date";
                                AnnualAmount := TargetRecord."Amount";






                                if (StartDate = 0D) or (EndDate = 0D) or (AnnualAmount = 0) then
                                    Error('Start Date, End Date, and Amount must be populated.');

                                YearCounter := 1;
                                PeriodStartDate := StartDate;




                                while PeriodStartDate <= EndDate do begin
                                    RevenueStructure.Init();
                                    RevenueStructure."RS ID" := TargetRecord."RS ID";
                                    RevenueStructure."Tenant Id" := TargetRecord."Tenant ID";
                                    RevenueStructure."Contract ID" := TargetRecord."Contract ID";
                                    RevenueStructure."Year" := YearCounter;
                                    RevenueStructure."Period Start Date" := PeriodStartDate;

                                    RevenueStructure."VAT Amount" := TargetRecord."VAT Amount";
                                    RevenueStructure."Amount Including VAT" := TargetRecord."Amount Including VAT";
                                    RevenueStructure."Secondary Item Type" := TargetRecord."Secondary Item Type";
                                    RevenueStructure."VAT %" := TargetRecord."VAT %";


                                    DaysToAdd := 365; // Default to 365 days
                                    LeapDays := 0;

                                    // if PeriodStartDate + 365 >= EndDate then
                                    //     PeriodEndDate := EndDate
                                    // else
                                    //     PeriodEndDate := PeriodStartDate + 365 - 1;



                                    // NumDays := PeriodEndDate - PeriodStartDate + 1;

                                    // Check if February 29 falls within the range
                                    // StartYear := Date2DMY(PeriodStartDate, 3); // Extract the year of PeriodStartDate
                                    // EndYear := Date2DMY(PeriodEndDate, 3);    // Extract the year of PeriodEndDate

                                    // IsLeapYearInRange := false;

                                    for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                                        if IsLeapYear(CurrentYear) then begin
                                            // Ensure the leap day (Feb 29) falls within the range
                                            if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                               (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                                LeapDays += 1;
                                        end;
                                    end;

                                    DaysToAdd := DaysToAdd + LeapDays;

                                    PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                                    if PeriodEndDate > EndDate then
                                        PeriodEndDate := EndDate;

                                    RevenueStructure."Period End Date" := PeriodEndDate;

                                    NumDays := PeriodEndDate - PeriodStartDate + 1;
                                    // Adjust the number of days if a leap year is in range
                                    // if IsLeapYearInRange then
                                    //     NumDays := NumDays + 1;

                                    RevenueStructure."Number of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);



                                    PeriodStartDate := PeriodEndDate + 1;
                                    YearCounter += 1;

                                    if TargetRecord.FindLast() then begin
                                        // If found, get the latest RS ID
                                        Revenuestructureid := TargetRecord."RS ID";
                                    end else begin
                                        // If no record is found, create a new Revenue Structure record
                                        TargetRecord.Init();
                                        TargetRecord.Insert(true);
                                        TargetRecord.Modify(true);  // Insert the new record and generate the RS ID

                                        // Get the newly created RS ID
                                        Revenuestructureid := TargetRecord."RS ID";
                                    end;

                                    Rec."Link" := Revenuestructureid;


                                end;

                            end;

                            Message('Record are updated in Revenue Structure.Click on the respective link to View the details');


                        end
                        else
                            Message('Installment cannot be set for One-Time payment');

                    end;


                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Structure Link';
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        RevenueStructureRec: Record "Revenue Structure";
                        Revenuestructureid: Integer;
                    begin
                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin

                            // Navigate to the Revenue Structure Card page
                            if RevenueStructureRec.Get(Rec."Link") then
                                PAGE.RUN(PAGE::"Revenue Structure Card", RevenueStructureRec)
                            else
                                Message('The related Revenue Structure does not exist.');
                        end
                        else
                            Message('Installment cannot be set for One-Time payment');
                    end;

                }
                field("Contract Renewal ID"; Rec."Contract Renewal ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        revenueStructure: Record "Revenue Structure";
        PaymentSchedule: Record "Payment Schedule2";
        SumInvoicedAmount: Decimal;
    begin
        revenueStructure.SetRange("RS ID", Rec.Link);
        if revenueStructure.IsEmpty() then
            Rec.Link := 0;

        // Calculate total invoiced amount for this secondary item type
        SumInvoicedAmount := 0;
        PaymentSchedule.SetRange("Contract ID", Rec.ContractID);
        PaymentSchedule.SetRange("Tenant ID", Rec.TenantID);
        PaymentSchedule.SetRange("Secondary Item Type", Rec."Secondary Item Type");
        // Only consider lines that are marked Invoiced and have an Invoice ID
        PaymentSchedule.SetFilter(Invoiced, '=true');
        PaymentSchedule.SetFilter("Invoice ID", '<>%1', '');
        if PaymentSchedule.FindSet() then begin
            repeat
                SumInvoicedAmount += PaymentSchedule.Amount;
            until PaymentSchedule.Next() = 0;

            // Update the displayed Invoiced amount on the Tenancy Subpage record
            Rec.Invoiced := SumInvoicedAmount;
        end else
            Rec.Invoiced := 0;

        Rec.Modify();


    end;


    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;



    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;



    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ContractID := ContractID;
        Rec.TenantID := tenantID;
        Rec.ProposalID := (proposalID);

    end;

    var
        ContractID: Integer;
        proposalID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;


}



