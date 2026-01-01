page 50941 "Contract Renewal SubPage Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Contract Renewal Subpage";
    Caption = 'Other Payments';

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
                    ShowMandatory = true;
                    NotBlank = true;

                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;

                    trigger OnValidate()
                    begin
                        UpdateLeaseProposalAmount();
                    end;

                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;

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

                    // trigger OnValidate()
                    // begin
                    //     UpdateLeaseProposalAmount();
                    // end;
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

                // field("Payment Type"; Rec."Payment Type")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Payment Type';
                //     ToolTip = 'Enter the Payment Type.';

                //     // trigger OnValidate()
                //     // begin
                //     //     if Rec."Payment Type" = Rec."Payment Type"::Installment then
                //     //         isvisible := true
                //     //     else
                //     //         isvisible := false
                //     // end;


                // }


                // field("No. of Installments"; Rec."No. of Installments")
                // {
                //     ApplicationArea = All;
                //     Caption = 'No. of Installments';
                // }

                field("Generate Payment Schedule"; Rec."Generate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;
                    //Visible = isvisible;

                    // trigger OnValidate()
                    // begin
                    //     CurrPage.Update(true); // Refresh the page to apply visibility changes
                    // end;




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


                    begin

                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin


                            //TargetRecord.SetRange("Proposal ID", Rec."ProposalID");
                            TargetRecord.SetRange("Secondary Item Type", Rec."Secondary Item Type");
                            TargetRecord.SetRange("Tenant ID", Rec."TenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                // TargetRecord."Number of Installments" := Rec."No. of Installments";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                //TargetRecord."Proposal ID" := Rec."ProposalID";
                                TargetRecord."Tenant ID" := Rec."TenantID";
                                TargetRecord."Secondary Item Type" := Rec."Secondary Item Type";
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                // TargetRecord."Number of Installments" := Rec."No. of Installments";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord.Insert();


                                StartDate := TargetRecord."Contract Start Date";
                                EndDate := TargetRecord."Contract End Date";
                                AnnualAmount := TargetRecord."Amount";
                                //NumInstallments := TargetRecord."Number of Installments";
                                // VATAmount := TargetRecord."VAT Amount";
                                // VATandAmount := TargetRecord."Amount Including VAT";

                                //TargetRecord.Modify();





                                if (StartDate = 0D) or (EndDate = 0D) or (AnnualAmount = 0) then
                                    Error('Start Date, End Date, and Amount must be populated.');

                                YearCounter := 1;
                                PeriodStartDate := StartDate;




                                while PeriodStartDate <= EndDate do begin
                                    RevenueStructure.Init();
                                    RevenueStructure."RS ID" := TargetRecord."RS ID";
                                    // RevenueStructure."Proposal Id" := TargetRecord."Proposal ID";
                                    RevenueStructure."Tenant Id" := TargetRecord."Tenant ID";
                                    RevenueStructure."Year" := YearCounter;
                                    RevenueStructure."Period Start Date" := PeriodStartDate;

                                    RevenueStructure."VAT Amount" := TargetRecord."VAT Amount";
                                    RevenueStructure."Amount Including VAT" := TargetRecord."Amount Including VAT";
                                    RevenueStructure."Secondary Item Type" := TargetRecord."Secondary Item Type";
                                    RevenueStructure."VAT %" := TargetRecord."VAT %";


                                    if PeriodStartDate + 365 > EndDate then
                                        PeriodEndDate := EndDate
                                    else
                                        PeriodEndDate := PeriodStartDate + 365 - 1;

                                    RevenueStructure."Period End Date" := PeriodEndDate;

                                    NumDays := PeriodEndDate - PeriodStartDate + 1;

                                    // Check if February 29 falls within the range
                                    StartYear := Date2DMY(PeriodStartDate, 3); // Extract the year of PeriodStartDate
                                    EndYear := Date2DMY(PeriodEndDate, 3);    // Extract the year of PeriodEndDate

                                    IsLeapYearInRange := false;

                                    for CurrentYear := StartYear to EndYear do begin
                                        if IsLeapYear(CurrentYear) then begin
                                            LeapDate := DMY2Date(29, 2, CurrentYear); // Generate February 29 date
                                            if (LeapDate >= PeriodStartDate) and (LeapDate <= PeriodEndDate) then begin
                                                IsLeapYearInRange := true;
                                                break; // No need to check further if a leap year is found in range
                                            end;
                                        end;
                                    end;

                                    // Adjust the number of days if a leap year is in range
                                    if IsLeapYearInRange then
                                        NumDays := NumDays + 1;


                                    // RevenueStructure."Number of Days" := NumDays;

                                    // RevenueStructure."Final Annual Amount" := Round(AnnualAmount / (EndDate - StartDate + 1) * 365, 2);
                                    // RevenueStructure."Yearly No. of Installment" := Round(NumInstallments / (EndDate - StartDate + 1) * 365, 2);


                                    // RevenueStructure.Insert();
                                    // // Clear(RevenueStructure);


                                    // PeriodStartDate := PeriodEndDate + 1;
                                    // YearCounter += 1;


                                    // NumDays := PeriodEndDate - PeriodStartDate + 1;
                                    RevenueStructure."Number of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);

                                    //  InsertedInstallments += RevenueStructure."Yearly No. of Installment";

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

                                    // Clear(InstallmentStructure);
                                end;
                                // Clear(RevenueStructure);


                            end;


                            //end;
                            Message('Record are updated in Revenue Structure.Click on the respective link to View the details');
                            // PAGE.RUN(Page::"Revenue Structure List");

                        end
                        else
                            Message('Installment cannot be set for One-Time payment');

                    end;


                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    DrillDown = true;
                    Visible = false;


                    trigger OnDrillDown()
                    var
                        RevenueStructureRec: Record "Revenue Structure";
                        Revenuestructureid: Integer;
                    begin
                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin

                            //     if Rec."Link" = 0 then begin
                            //         if RevenueStructureRec.FindLast() then begin
                            //             // If found, get the latest RS ID
                            //             Revenuestructureid := RevenueStructureRec."RS ID";
                            //         end else begin
                            //             // If no record is found, create a new Revenue Structure record
                            //             RevenueStructureRec.Init();
                            //             RevenueStructureRec.Insert(true);  // Insert the new record and generate the RS ID

                            //             // Get the newly created RS ID
                            //             Revenuestructureid := RevenueStructureRec."RS ID";
                            //         end;

                            //         Rec."Link" := Revenuestructureid;

                            //         exit;
                            //     end;

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
            }
        }
    }



    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;





    procedure SetId(pId: Integer)
    begin
        Id := pId;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Id := Id;
        Rec.TenantID := tenantID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;

    end;

    var
        Id: Integer;

        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

        isvisible: Boolean;


    procedure UpdateLeaseProposalAmount()
    var
        LeaseProposal: Record "Contract Renewal"; // Replace with your actual Lease Proposal table name
    begin
        // Apply a filter on the ProposalID to find matching Lease Proposal records
        if (Rec."Secondary Item Type" = 'Security Deposit') or
           (Rec."Secondary Item Type" = 'Rera Fees') or
           (Rec."Secondary Item Type" = 'Ejari Processing Fees') or
           (Rec."Secondary Item Type" = 'Renewal Amount') then begin
            LeaseProposal.SetRange("ID", Rec."ID"); // Adjust the field names to your table schema

            if LeaseProposal.FindSet() then begin
                // Update the respective fields based on "Secondary Item Type"
                case Rec."Secondary Item Type" of
                    'Security Deposit':
                        LeaseProposal."Security Deposit Amount" := Rec."Amount Including VAT";
                    'Rera Fees':
                        LeaseProposal."Rera" := Rec."Amount Including VAT";
                    'Ejari Processing Fees':
                        LeaseProposal."Ejari Processing Charges" := Rec."Amount Including VAT";
                    'Renewal Amount':
                        LeaseProposal."Renewal Charges" := Rec."Amount Including VAT";
                end;

                LeaseProposal.Modify(); // Save the changes
            end;
        end;
    end;


}



