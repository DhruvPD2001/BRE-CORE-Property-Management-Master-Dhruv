page 50333 "Single Lum_AnnualAmnt SubPage"
{
    PageType = ListPart;
    SourceTable = "Single Lum_AnnualAmnt SubPage";
    ApplicationArea = All;
    Caption = 'Single Lum_AnnualAmount SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; rec."Proposal ID")
                {
                    ApplicationArea = All;
                }
                field("SL_Merged Unit ID"; rec."SL_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Visible = false;
                }
                field("SL_Unit ID"; rec."SL_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                }
                field("SL_Year"; rec.SL_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                }
                field("SL_Start Date"; rec."SL_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }

                field("SL_End Date"; rec."SL_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }
                field("SL_Number of Days"; rec."SL_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                }
                field("SL_Unit Sq Ft"; rec."SL_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("SL_Rate per Sq.Ft"; rec."SL_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("SL_Rent Increase %"; rec."SL_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    trigger OnValidate()
                    begin
                        if Rec."SL_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Calculate the annual amount and final annual amount based on rent increase
                        if Rec.SL_Year > 1 then begin
                            RecalculateRentIncrease();
                        end;

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                field("SL_Annual Amount"; rec."SL_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    ToolTip = 'Enter the annual amount manually or let it be calculated based on rate per sq.ft.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Lum_AnnualAmnt SubPage";
                        RentIncreasePercentage: Decimal;
                    begin
                        // Set Final Annual Amount to the entered Annual Amount
                        Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount";

                        // If this is the 2nd year or later, calculate the rent increase percentage
                        if Rec.SL_Year > 1 then begin
                            // Fetch the previous year's record
                            PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                            PreviousYearRecord.SetRange(SL_Year, Rec.SL_Year - 1);

                            if PreviousYearRecord.FindFirst() then begin
                                // Calculate the rent increase percentage based on the entered annual amount
                                if PreviousYearRecord."SL_Final Annual Amount" > 0 then
                                    RentIncreasePercentage :=
                                        ((Rec."SL_Annual Amount" - PreviousYearRecord."SL_Final Annual Amount") /
                                        PreviousYearRecord."SL_Final Annual Amount") * 100
                                else
                                    RentIncreasePercentage := 0;

                                // Update the Rent Increase % field with precise decimal value
                                Rec."SL_Rent Increase %" := RentIncreasePercentage;
                            end else
                                Error('No record found for the previous year to base the calculation.');
                        end;

                        Rec.Modify();
                        // Recalculate totals and per day rent
                        RecalculateFinalAnnualAmount();
                        RecalculateTotals();
                        RecalculatePerDayRent();
                    end;
                }
                field("SL_Round off"; rec."SL_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        // Recalculate the final annual amount
                        if Rec."SL_Round off" = 0 then
                            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount"
                        else
                            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount" + Rec."SL_Round off";

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent();
                        RecalculateTotals();
                    end;
                }
                field("SL_Final Annual Amount"; rec."SL_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                                                 // Recalculate totals
                        RecalculateTotals();
                    end;
                }
                field("SL_Per Day Rent"; rec."SL_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                                                 // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                // field("Single Lumpsum Rent1"; Rec."Single Lumpsum Rent1")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Single Lumpsum Rent Details';
                //     ToolTip = 'Click Here For Get Data.';
                //     DrillDown = true;
                //     trigger OnDrillDown()
                //     var
                //         LeaseProposal: Record "Lease Proposal Details"; // Replace with actual table name
                //         ExistingRecords: Record "Single Lum_AnnualAmnt SubPage"; // Target table
                //         PeriodStartDate: Date;
                //         PeriodEndDate: Date;
                //         TotalDays: Integer;
                //         YearCounter, LineNoCounter : Integer;
                //         DaysToAdd: Integer;
                //         LeapDays: Integer;
                //         CurrentYear: Integer;
                //     begin
                //         if Rec."Proposal ID" = 0 then
                //             Error('Proposal ID is missing or not assigned.');

                //         LeaseProposal.Reset();
                //         LeaseProposal.SetRange("Proposal ID", Rec."Proposal ID");

                //         if not LeaseProposal.FindFirst() then
                //             Error('No record found for Proposal ID %1.', Rec."Proposal ID");

                //         // Delete existing records to avoid duplication
                //         ExistingRecords.SetRange("Proposal ID", LeaseProposal."Proposal ID");
                //         if ExistingRecords.FindSet() then
                //             repeat
                //                 ExistingRecords.Delete();
                //             until ExistingRecords.Next() = 0;

                //         PeriodStartDate := LeaseProposal."Lease Start Date";
                //         YearCounter := 1;
                //         LineNoCounter := 1;

                //         // Loop to divide the period into yearly chunks and create records
                //         while PeriodStartDate <= LeaseProposal."Lease End Date" do begin
                //             ExistingRecords.Init();
                //             ExistingRecords."Proposal ID" := LeaseProposal."Proposal ID";
                //             ExistingRecords."SL_Line No." := LineNoCounter;
                //             ExistingRecords.SL_Year := YearCounter;
                //             ExistingRecords."SL_Start Date" := PeriodStartDate;

                //             // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                //             DaysToAdd := 365; // Default to 365 days
                //             LeapDays := 0;

                //             // Check for leap years in the range from Start Date to Start Date + 364 days
                //             for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                //                 if IsLeapYear(CurrentYear) then begin
                //                     // Ensure the leap day (Feb 29) falls within the range
                //                     if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                //                        (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                //                         LeapDays += 1;
                //                 end;
                //             end;

                //             // Adjust DaysToAdd to account for any leap days
                //             DaysToAdd := DaysToAdd + LeapDays;

                //             // Calculate the PeriodEndDate
                //             PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                //             // Ensure the end date does not exceed the Lease End Date
                //             if PeriodEndDate > LeaseProposal."Lease End Date" then
                //                 PeriodEndDate := LeaseProposal."Lease End Date";

                //             ExistingRecords."SL_End Date" := PeriodEndDate;

                //             // Calculate the number of days
                //             TotalDays := PeriodEndDate - PeriodStartDate + 1;
                //             ExistingRecords."SL_Number of Days" := TotalDays;

                //             // Populate other fields
                //             ExistingRecords."SL_Merged Unit ID" := LeaseProposal."Unit Name";
                //             ExistingRecords."SL_Unit Sq Ft" := LeaseProposal."Unit Size";

                //             // For the first year, initialize the Annual Amount and Final Annual Amount
                //             if YearCounter = 1 then begin
                //                 ExistingRecords."SL_Annual Amount" := 0; // User will enter manually
                //                 ExistingRecords."SL_Final Annual Amount" := 0;
                //             end;

                //             // Calculate Per Day Rent
                //             if TotalDays > 0 then
                //                 ExistingRecords."SL_Per Day Rent" := ExistingRecords."SL_Final Annual Amount" / TotalDays
                //             else
                //                 ExistingRecords."SL_Per Day Rent" := 0;

                //             ExistingRecords.Insert();

                //             // Update for the next year
                //             PeriodStartDate := PeriodEndDate + 1;
                //             YearCounter += 1;
                //             LineNoCounter += 1;
                //         end;

                //         CurrPage.Update();
                //     end;

                //     // end;

                // }
            }

            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec.TotalAnnualAmount)
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only

                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only

                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                }


                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                }
            }
        }


    }

    // actions
    // {
    //     area(processing)
    //     {
    //         action(InsertData)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Insert Data';
    //             Image = NewDocument; // Optionally, define an icon

    //             trigger OnAction()
    //             var
    //                 SingleLumSquareRec: Record "Single Lum_AnnualAmnt SubPage";
    //                 SubLeaseMergeRec: Record "Sub Lease Merged Units";
    //                 PerDayRevnue: Record "Per Day Rent for Revenue";
    //             begin
    //                 if Rec."Proposal ID" = 0 then
    //                     Error('Proposal ID is missing or not assigned.');

    //                 // Fetch data from the Merge SameSqure SubPage table
    //                 SingleLumSquareRec.SetRange("Proposal ID", Rec."Proposal ID");

    //                 // Fetch data from the Sub Lease Merged Units table
    //                 SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");

    //                 // Fetch the first record from the Merge SameSqure SubPage table
    //                 if SingleLumSquareRec.FindSet() then begin
    //                     repeat
    //                         // Loop through Sub Lease Merged Units and fetch relevant data
    //                         if SubLeaseMergeRec.FindSet() then begin
    //                             repeat
    //                                 PerDayRevnue.Init();
    //                                 // Initialize the record in the current grid with data from both tables
    //                                 PerDayRevnue."Proposal ID" := SingleLumSquareRec."Proposal ID";
    //                                 PerDayRevnue."Year" := SingleLumSquareRec."SL_Year"; // From Merge SameSqure SubPage
    //                                 PerDayRevnue."Per Day Rent Per Unit" := SingleLumSquareRec."SL_Per Day Rent"; // From Merge SameSqure SubPage

    //                                 // Fetch the unit size and single unit name from the Sub Lease Merged Units table
    //                                 PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
    //                                 PerDayRevnue."Unit ID" := SubLeaseMergeRec."Single Unit Name"; // From Sub Lease Merged Units

    //                                 // Check if the record already exists to prevent duplicates
    //                                 PerDayRevnue.SetRange("Proposal ID", PerDayRevnue."Proposal ID");
    //                                 PerDayRevnue.SetRange("Unit ID", PerDayRevnue."Unit ID");
    //                                 if not PerDayRevnue.FindFirst() then begin
    //                                     // Insert the new record only if it doesn't exist
    //                                     PerDayRevnue.Insert();
    //                                     Clear(PerDayRevnue);
    //                                 end;

    //                             until SubLeaseMergeRec.Next() = 0;
    //                         end;
    //                     until SingleLumSquareRec.Next() = 0;
    //                 end
    //                 else
    //                     Error('No matching records found in Merge SameSqure SubPage for the given Proposal ID.');

    //                 // Refresh the current page to display updated data
    //                 CurrPage.Update();
    //             end;
    //         }
    //     }
    // }
    local procedure RecalculateNumberOfDays()
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentYear: Integer;
        TotalDays: Integer;
        IsLeapYearInRange: Boolean;
    begin
        // Validate Start Date and End Date
        if Rec."SL_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."SL_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."SL_End Date" < Rec."SL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."SL_Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."SL_End Date", 3);    // Extract year of End Date
        TotalDays := Rec."SL_End Date" - Rec."SL_Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do begin
            if IsLeapYear(CurrentYear) then begin
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."SL_Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."SL_End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;
            end;
        end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."SL_Number of Days" := TotalDays;

        Rec.Modify();
    end;

    // Helper function to determine if a year is a leap year
    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    // local procedure IsLeapYear(Year: Integer): Boolean
    //     begin
    //         if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
    //             exit(true);
    //         exit(false);
    //     end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."SL_Number of Days" > 0 then
            Rec."SL_Per Day Rent" := Rec."SL_Final Annual Amount" / Rec."SL_Number of Days"
        else
            Rec."SL_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculateRentIncrease()
    var
        PreviousYearRecord: Record "Single Lum_AnnualAmnt SubPage";
        IncreaseFactor: Decimal;
    begin
        // Fetch the previous year's record
        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
        PreviousYearRecord.SetRange(SL_Year, Rec.SL_Year - 1);

        if PreviousYearRecord.FindFirst() then begin
            IncreaseFactor := 1 + (Rec."SL_Rent Increase %" / 100);
            Rec."SL_Annual Amount" := PreviousYearRecord."SL_Final Annual Amount" * IncreaseFactor;
            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount";

            // Recalculate Per Day Rent
            RecalculatePerDayRent();
        end else
            Error('No record found for the previous year to base the calculation.');
    end;

    // local procedure RecalculateTotals()
    // var
    //     TempRecord: Record "Single Lum_AnnualAmnt SubPage";
    //     TotalAnnual: Decimal;
    //     TotalFinal: Decimal;
    //     TotalRoundOff: Decimal;
    // begin
    //     // Initialize totals
    //     TotalAnnual := 0;
    //     TotalFinal := 0;
    //     TotalRoundOff := 0;

    //     // Loop through all records for the same Proposal ID to calculate totals
    //     TempRecord.SetRange("Proposal ID", Rec."Proposal ID");
    //     if TempRecord.FindSet() then
    //         repeat
    //             TotalAnnual += TempRecord."SL_Annual Amount";
    //             TotalFinal += TempRecord."SL_Final Annual Amount";
    //             TotalRoundOff += TempRecord."SL_Round off";
    //         until TempRecord.Next() = 0;

    //     // Update the totals in the current record
    //     Rec.TotalAnnualAmount := TotalAnnual;
    //     Rec.TotalFinalAmount := TotalFinal;
    //     Rec.TotalRoundOff := TotalRoundOff;

    //     Rec.Modify();
    //     CurrPage.Update();
    // end;

    local procedure RecalculateFinalAnnualAmount()
    var
        YearStart: Integer;
        YearEnd: Integer;
        CurrYear: Integer;
        YearStartDate: Date;
        YearEndDate: Date;
        OverlapStart: Date;
        OverlapEnd: Date;
        DaysInYear: Integer;
        DaysInPeriod: Integer;
        ProratedAmount: Decimal;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."SL_Start Date" = 0D) or (Rec."SL_End Date" = 0D) then begin
            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount" + Rec."SL_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."SL_End Date" < Rec."SL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."SL_Start Date", 3);
        YearEnd := Date2DMY(Rec."SL_End Date", 3);
        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."SL_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."SL_End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                if IsLeapYear(CurrYear) then
                    DaysInYear := 366
                else
                    DaysInYear := 365;

                ProratedAmount += (Rec."SL_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."SL_Final Annual Amount" := ProratedAmount + Rec."SL_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "Lease Proposal Details";
        TempRecord: Record "Single Lum_AnnualAmnt SubPage";
        TotalAnnual: Decimal;
        TotalFinal: Decimal;
        TotalRoundOff: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        // Initialize totals
        TotalAnnual := 0;
        TotalFinal := 0;
        TotalRoundOff := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Loop through all records for the same Proposal ID to calculate totals
        TempRecord.SetRange("Proposal ID", Rec."Proposal ID");
        if TempRecord.FindSet() then
            repeat
                TotalAnnual += TempRecord."SL_Annual Amount";
                TotalFinal += TempRecord."SL_Final Annual Amount";
                TotalRoundOff += TempRecord."SL_Round off";

                // Check for the first year and assign its Annual Amount
                if TempRecord."SL_Year" = 1 then
                    FirstYearAnnualAmount := TempRecord."SL_Final Annual Amount";
            until TempRecord.Next() = 0;

        // Update the totals in the current record
        Rec.TotalAnnualAmount := TotalAnnual;
        Rec.TotalFinalAmount := TotalFinal;
        Rec.TotalRoundOff := TotalRoundOff;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := TotalFinal; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        Rec.Modify();
        CurrPage.Update();
    end;


}
