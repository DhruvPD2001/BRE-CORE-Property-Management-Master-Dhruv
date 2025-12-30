page 50946 "Rent Calculation SubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    // UsageCategory = Administration;
    SourceTable = "Rent Calculation Subpage";
    Caption = 'Rent Calculation';


    layout
    {
        area(Content)
        {
            repeater(Group)

            {

                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                    Editable = false;
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                }

                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;

                }

                field("Number of Days"; Rec."Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;


                }

                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;


                }

                field("Yearly No. of Installment"; Rec."Yearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                }


                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                    Visible = false;
                }

                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Propety Classification"; Rec."Propety Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Property Classification';
                    Visible = false;
                }


            }




            group(" ")
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
                    Editable = false;

                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                    Visible = false;
                    Editable = false;
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                    Visible = false;
                    Editable = false;
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    Visible = false;
                    Editable = false;
                }






                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    ToolTip = 'Enter the Link.';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        tenancyContract: Record "Tenancy Contract";
                        TargetRecord: Record "Rent Calculation";
                        RevenueStructure: Record "Rent Calculation Subpage"; // Main table
                        InstallmentStructure: Record "Rent Calculation Subpage2"; // Second subgrid table
                        fetchMonth: Codeunit "Fetch Month";
                        StartDate: Date;
                        TargetPageID: Integer;
                        EndDate: Date;
                        AnnualAmount: Decimal;
                        NumInstallments: Integer;
                        InstallmentAmount: Decimal;
                        InstallmentStartDate: Date;
                        InstallmentEndDate: Date;
                        DueDate: Date;
                        DaysPerInstallment: Integer;
                        InstallmentNumber: Integer;
                        DaysInYear: Integer;
                        IsLeapYear: Boolean;
                        YearCounter: Integer;
                        TotalYears: Integer;
                        VATAmount: Decimal;
                        AmountandVAT: Decimal;
                        Totalamount: Integer;
                        Installment: Integer;
                        VATPer: Integer;
                        VATAmount2: Decimal;
                        TotalCalculatedAmount: Decimal;
                        LastInstallmentAmount: Decimal;
                        InstallmentAmount2: Decimal;

                        PeriodStartDate: Date;
                        MonthsPerInstallment: Decimal;
                        DaysInMonth: Integer;
                        NextMonthDate: Date;
                        TotalInstallments: Integer;


                        isMonthEnd: Boolean;
                        isMonthStart: Boolean;
                        PeriodEndDate: Date;
                        IntMonthsPerInstallment: Integer;
                        OffsetMonths: Integer;
                        BaseDay: Integer;
                        StartMonth: Integer;
                        StartYear: Integer;
                        NextMonth: Integer;
                        NextMonthYear: Integer;
                        DaysInTargetMonth: Integer;
                        DaysInPeriod: Integer;
                        counter: Integer;
                        OriginalStartDate: Date;
                        YearNo: Integer;
                        UnitId: Code[20];
                    begin
                        tenancyContract.Get(Rec."Contract ID");
                        InstallmentStructure.SetRange("RC ID", Rec."RC ID");
                        if InstallmentStructure.FindSet() then begin
                            InstallmentStructure.DeleteAll();
                        end;

                        InstallmentStartDate := GetStartDate(tenancyContract."Contract Start Date", tenancyContract."Contract End Date", isMonthEnd, isMonthStart);
                        OriginalStartDate := InstallmentStartDate;
                        OffsetMonths := fetchMonth.GetNoofMonthsFromFrequency(Format(tenancyContract."Payment Frequency"));
                        InstallmentEndDate := 0D;
                        NumInstallments := RevenueStructure."Yearly No. of Installment";

                        // Set filters to fetch related records
                        // RevenueStructure.SetRange("Proposal ID", Rec."Proposal ID");
                        RevenueStructure.SetRange("Tenant ID", Rec."Tenant ID");
                        RevenueStructure.SetRange("Contract ID", Rec."Contract ID");
                        RevenueStructure.SetRange("RC ID", Rec."RC ID");
                        //TargetRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                        TargetRecord.SetRange("Tenant ID", Rec."Tenant ID");
                        TargetRecord.SetRange("RC ID", Rec."RC ID");


                        if RevenueStructure.FindSet() then begin
                            // Loop through Revenue Structure to calculate and populate or update Installment Structure
                            repeat
                                if RevenueStructure.Year < YearNo then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;
                                if RevenueStructure."Unit ID" <> UnitId then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;

                                AnnualAmount := RevenueStructure."Final Annual Amount";
                                StartDate := RevenueStructure."Period Start Date";
                                EndDate := RevenueStructure."Period End Date";
                                //VATAmount := RevenueStructure."VAT Amount";
                                VATPer := RevenueStructure."VAT %";
                                TotalYears := RevenueStructure."Year";
                                TargetPageID := RevenueStructure."RC ID";
                                if TargetRecord.FindSet() then begin
                                    Installment := TargetRecord."Number of Installments";

                                end;





                                //  InstallmentAmount := RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment";

                                InstallmentAmount := ROUND(RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment", 0.01);

                                TotalCalculatedAmount := InstallmentAmount * RevenueStructure."Yearly No. of Installment";  // 1666.67*3 = 5000.01
                                LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."Final Annual Amount"; // 5000.01 - 5000 = 0.01
                                InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;   // 1666.67 - 0.01 = 1666.66

                                for InstallmentNumber := 1 to RevenueStructure."Yearly No. of Installment" do begin

                                    if InstallmentEndDate > tenancyContract."Contract Start Date" then begin
                                        InstallmentStartDate := CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate);
                                        if isMonthEnd then begin
                                            InstallmentStartDate := CalcDate('<CM>', InstallmentStartDate);
                                            // fetchMonth.GetNoofDaysInMonth(Date2DMY(InstallmentStartDate, 2), Date2DMY(InstallmentStartDate, 3));
                                            InstallmentEndDate := CalcDate('<-1D>', CalcDate('<CM>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate)));
                                        end
                                        // else if isMonthStart then begin
                                        //     InstallmentStartDate := CalcDate('<-CM>', InstallmentStartDate);
                                        //     // DaysInMonth := fetchMonth.GetNoofDaysInMonth(Date2DMY(InstallmentStartDate, 2), Date2DMY(InstallmentStartDate, 3));
                                        //     InstallmentEndDate := CalcDate('<-1D>', CalcDate('<CM>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate)));
                                        // end
                                        else
                                            InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));
                                    end
                                    else
                                        InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));


                                    if InstallmentEndDate > tenancyContract."Contract End Date" then
                                        InstallmentEndDate := tenancyContract."Contract End Date";

                                    InstallmentStructure.SetRange("RC ID", TargetPageID);
                                    InstallmentStructure.SetRange("Year", TotalYears);
                                    InstallmentStructure.SetRange("Installment No.", InstallmentNumber);
                                    InstallmentStructure.SetRange("Revenue Str. Subpage Entry No.", RevenueStructure."Entry No.");
                                    if InstallmentStructure.FindFirst() then begin
                                        // Update existing record

                                        if InstallmentNumber = 1 then
                                            InstallmentStructure.Amount := InstallmentAmount2
                                        // InstallmentStructure."Installment Start Date" := RevenueStructure."Period Start Date";
                                        // InstallmentStructure."Installment End Date" := RevenueStructure."Period Start Date" + ROUND(RevenueStructure."Number of Days" / RevenueStructure."Yearly No. of Installment", 1, '<') - 1;
                                        else
                                            InstallmentStructure.Amount := InstallmentAmount;
                                        // InstallmentStructure."Installment Start Date" := RevenueStructure."Period Start Date" + (InstallmentNumber - 1) * ROUND(RevenueStructure."Number of Days" / RevenueStructure."Yearly No. of Installment", 1, '<');

                                        // InstallmentStructure."Installment End Date" := RevenueStructure."Period Start Date" + InstallmentNumber * ROUND(RevenueStructure."Number of Days" / RevenueStructure."Yearly No. of Installment", 1, '<');

                                        InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                        InstallmentStructure.Modify();
                                        //  Message('Date Update Successfully!');
                                    end else begin
                                        // Insert new record
                                        InstallmentStructure.Init();
                                        InstallmentStructure."RC ID" := TargetPageID;
                                        InstallmentStructure."Revenue Str. Subpage Entry No." := RevenueStructure."Entry No.";
                                        // InstallmentStructure."Proposal ID" := RevenueStructure."Proposal ID";
                                        InstallmentStructure."Tenant ID" := RevenueStructure."Tenant ID";
                                        InstallmentStructure."Contract ID" := RevenueStructure."Contract ID";
                                        InstallmentStructure."Primary Classification" := RevenueStructure."Propety Classification";
                                        // InstallmentStructure."VAT Amount" := VATAmount2;
                                        InstallmentStructure."VAT %" := VATPer;
                                        InstallmentStructure."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                        InstallmentStructure."Year" := TotalYears;
                                        InstallmentStructure."Installment No." := InstallmentNumber;
                                        // InstallmentStructure.Amount := InstallmentAmount;
                                        if InstallmentNumber = RevenueStructure."Yearly No. of Installment" then begin
                                            InstallmentStructure.Amount := InstallmentAmount2;
                                        end else begin
                                            InstallmentStructure.Amount := InstallmentAmount;
                                        end;
                                        if InstallmentStructure."VAT %" = 1 then
                                            InstallmentStructure."VAT %" := 5
                                        else
                                            InstallmentStructure."VAT %" := 0;

                                        InstallmentStructure."VAT Amount" := InstallmentStructure.Amount * (InstallmentStructure."VAT %" / 100);
                                        InstallmentStructure."Amount Including VAT" := InstallmentStructure.Amount + InstallmentStructure."VAT Amount";


                                        PeriodStartDate := RevenueStructure."Period Start Date";
                                        PeriodEndDate := RevenueStructure."Period End Date";


                                        // Assign results back
                                        InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                        // Ensure the last installment end date matches the full period end date
                                        IF InstallmentNumber = RevenueStructure."Yearly No. of Installment" THEN
                                            InstallmentStructure."Installment End Date" := RevenueStructure."Period End Date";

                                        InstallmentStructure."Due Date" := InstallmentStructure."Installment Start Date";
                                        InstallmentStructure.Insert();

                                    end;


                                    TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                    // TargetRecord.SetRange("Proposal ID", RevenueStructure."Proposal ID");
                                    TargetRecord.SetRange("RC ID", RevenueStructure."RC ID");
                                    TargetRecord.SetRange("Secondary Item Type", RevenueStructure."Secondary Item Type");



                                    if TargetRecord.FindSet() then begin
                                        repeat
                                            // Calculate or retrieve the Installment value

                                            Installment := TargetRecord."Number of Installments";
                                            // Update the existing record
                                            TargetRecord."Number of Installments" := Installment;
                                            TargetRecord.Modify();
                                        until TargetRecord.Next() = 0;
                                    end else begin
                                        // If no records exist, insert a new record
                                        TargetRecord.Init();
                                        // TargetRecord."Proposal ID" := RevenueStructure."Proposal ID";
                                        TargetRecord."Contract ID" := RevenueStructure."Contract ID";
                                        TargetRecord."RC ID" := RevenueStructure."RC ID";
                                        TargetRecord."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                        TargetRecord."Number of Installments" := Installment; // Ensure Installment is correctly initialized or calculated
                                        TargetRecord.Insert();
                                        Clear(TargetRecord);
                                    end;

                                    Clear(InstallmentStructure);


                                end;
                                UnitId := RevenueStructure."Unit ID";
                                YearNo := RevenueStructure.Year;
                            until RevenueStructure.Next() = 0;
                            Message('Data Create Successfully!');
                        end else
                            Error('No records found in the Revenue Structure.');
                    end;

                }
            }

        }


    }







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
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

    end;

    var
        ContractID: Integer;
        proposalID: Integer;
        tenantID: Code[20];



    procedure GetStartDate(pContractStartDate: Date; pContractEndDate: Date; var isMonthEnd: Boolean; var isMonthStart: Boolean): Date
    var
        StartDate: Date;
    begin
        isMonthEnd := false;
        isMonthStart := false;
        if pContractStartDate = CalcDate('<-CM>', pContractStartDate) then begin
            StartDate := CalcDate('<-CM>', pContractStartDate);
            isMonthStart := true;
        end
        else
            if pContractStartDate = CalcDate('<CM>', pContractStartDate) then begin
                StartDate := CalcDate('<CM>', pContractStartDate);
                isMonthEnd := true;
            end
            else
                StartDate := pContractStartDate;

        exit(StartDate);
    end;


}









