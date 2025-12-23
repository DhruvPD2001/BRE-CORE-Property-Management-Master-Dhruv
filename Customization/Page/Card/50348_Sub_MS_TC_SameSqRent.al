page 50348 "TC Merge SameSqure SubPage"
{
    PageType = ListPart;
    SourceTable = "TC Merge SameSqure SubPage";
    ApplicationArea = All;
    Caption = 'Merge SameSqure SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("MS_Merged Unit ID"; rec."MS_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                }
                field("MS_Unit ID"; rec."MS_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                }
                field("MS_Year"; rec.MS_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                }
                field("MS_Start Date"; rec."MS_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                }
                field("MS_End Date"; rec."MS_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                }
                field("MS_Number of Days"; rec."MS_Number of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Number of Days';
                    ToolTip = 'Displays the total number of days for the period. Accounts for leap years.';
                    trigger OnValidate()
                    begin
                        RecalculateNumberOfDays();
                    end;
                }
                field("MS_Unit Sq Ft"; rec."MS_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                // field("MS_Rate per Sq.Ft"; rec."MS_Rate per Sq.Ft")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Rate per Sq.Ft';

                //     trigger OnValidate()
                //     var
                //         PreviousYearRecord: Record "Merge SameSqure SubPage";
                //         PreviousRate: Decimal;
                //     begin
                //         // Ensure the value is not negative
                //         if Rec."MS_Rate per Sq.Ft" < 0 then
                //             Error('Rate per Sq.Ft cannot be negative.');

                //         // Fetch the previous year's record to calculate Rent Increase %
                //         PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                //         PreviousYearRecord.SetRange("MS_Year", Rec.MS_Year - 1);

                //         if PreviousYearRecord.FindFirst() then begin
                //             PreviousRate := PreviousYearRecord."MS_Rate per Sq.Ft";

                //             // Ensure previous rate is greater than 0 to avoid division by zero
                //             if PreviousRate > 0 then
                //                 Rec."MS_Rent Increase %" :=
                //                     ((Rec."MS_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                //             else
                //                 Rec."MS_Rent Increase %" := 0; // No increase if previous rate is 0
                //         end else
                //             Rec."MS_Rent Increase %" := 0; // No increase for the first year or no previous record

                //         // Recalculate Annual Amount
                //         if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                //             Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
                //         else
                //             Rec."MS_Annual Amount" := 0;

                //         // Set Final Annual Amount equal to Annual Amount
                //         Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

                //         // Recalculate Per Day Rent
                //         RecalculatePerDayRent();

                //         // Save changes
                //         Rec.Modify();
                //         CurrPage.Update();
                //     end;
                // }

                field("MS_Rate per Sq.Ft"; rec."MS_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "CR Merge SameSqure SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."MS_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("ID", Rec."ID");
                        PreviousYearRecord.SetRange("MS_Year", Rec.MS_Year - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."MS_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."MS_Rent Increase %" :=
                                    ((Rec."MS_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."MS_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."MS_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                            Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
                        else
                            Rec."MS_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

                        RecalculateFinalAnnualAmount();
                        // Recalculate Per Day Rent
                        RecalculatePerDayRent();

                        // Recalculate totals dynamically
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                // field("MS_Rent Increase %"; rec."MS_Rent Increase %")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Rent Increase %';
                //     ToolTip = 'Enter the rent increase percentage for this year.';

                //     trigger OnValidate()
                //     var
                //         PreviousYearRecord: Record "Merge SameSqure SubPage";
                //         IncreaseFactor: Decimal;
                //     begin
                //         // Ensure that Rent Increase % is not negative
                //         if Rec."MS_Rent Increase %" < 0 then
                //             Error('Rent Increase % cannot be negative.');

                //         // Skip calculation for the first year
                //         if Rec.MS_Year = 1 then
                //             exit;

                //         // Fetch the previous year's record
                //         PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                //         PreviousYearRecord.SetRange(MS_Year, Rec.MS_Year - 1);

                //         if PreviousYearRecord.FindFirst() then begin
                //             // Calculate the new rate for the current year
                //             IncreaseFactor := 1 + (Rec."MS_Rent Increase %" / 100);
                //             Rec."MS_Rate per Sq.Ft" := PreviousYearRecord."MS_Rate per Sq.Ft" * IncreaseFactor;

                //             // Recalculate Annual Amount
                //             Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft";

                //             // Update Final Annual Amount to match Annual Amount
                //             Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

                //             // Recalculate Per Day Rent
                //             RecalculatePerDayRent();

                //             // Save changes
                //             Rec.Modify();
                //             CurrPage.Update();
                //         end else
                //             Error('No record found for the previous year to base the calculation.');
                //     end;

                // }

                field("MS_Rent Increase %"; rec."MS_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "CR Merge SameSqure SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."MS_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec.MS_Year = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("ID", Rec."ID");
                        PreviousYearRecord.SetRange("MS_Year", Rec.MS_Year - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."MS_Rent Increase %" / 100);
                            Rec."MS_Rate per Sq.Ft" := PreviousYearRecord."MS_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

                            RecalculateFinalAnnualAmount();
                            // Recalculate Per Day Rent
                            RecalculatePerDayRent();
                        end else
                            Error('No record found for the previous year to base the calculation.');

                        // Recalculate totals dynamically
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }
                field("MS_Annual Amount"; rec."MS_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }
                field("MS_Round off"; rec."MS_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }

                field("MS_Final Annual Amount"; rec."MS_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MS_Per Day Rent"; rec."MS_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;

                }
                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

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

    actions
    {
        area(processing)
        {
            action(InsertData)
            {
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon

                trigger OnAction()
                var
                    MergeSameSquareRec: Record "CR Merge SameSqure SubPage";
                    SubLeaseMergeRec: Record "CR Sub Lease Merged Units";
                    PerDayRevnue: Record "CR Per Day Rent for Revenue";
                    PerDayRevenueCalc: Decimal; // Variable to store the calculated revenue
                begin
                    if Rec."ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch data from the Merge SameSqure SubPage table
                    MergeSameSquareRec.SetRange("ID", Rec.ID);

                    // Fetch data from the Sub Lease Merged Units table
                    SubLeaseMergeRec.SetRange("ID", Rec."ID");

                    // Fetch the first record from the Merge SameSqure SubPage table
                    if MergeSameSquareRec.FindSet() then begin
                        repeat
                            // Loop through Sub Lease Merged Units and fetch relevant data
                            if SubLeaseMergeRec.FindSet() then begin
                                repeat
                                    PerDayRevnue.Init();

                                    // Initialize the record in the current grid with data from both tables
                                    PerDayRevnue."Contract Renewal Id" := MergeSameSquareRec."ID";
                                    PerDayRevnue."Year" := MergeSameSquareRec."MS_Year"; // From Merge SameSqure SubPage
                                    PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                    PerDayRevnue."Unit ID" := SubLeaseMergeRec."Single Unit Name"; // From Sub Lease Merged Units

                                    // Calculate Per Day Revenue using the updated formula
                                    if MergeSameSquareRec."MS_Unit Sq Ft" = 0 then
                                        Error('MS Unit Sq Ft cannot be zero for Proposal ID %1.', MergeSameSquareRec."ID");

                                    // Directly calculate without rounding
                                    PerDayRevenueCalc := MergeSameSquareRec."MS_Per Day Rent" * SubLeaseMergeRec."Unit Size" / MergeSameSquareRec."MS_Unit Sq Ft";
                                    PerDayRevnue."Per Day Rent Per Unit" := PerDayRevenueCalc; // Assign the calculated value

                                    // Check if the record already exists to prevent duplicates
                                    PerDayRevnue.SetRange(Year, PerDayRevnue.Year);
                                    PerDayRevnue.SetRange("ID", PerDayRevnue."ID");
                                    PerDayRevnue.SetRange("Unit ID", PerDayRevnue."Unit ID");

                                    // Find if a record with the same ID and Unit ID already exists
                                    if PerDayRevnue.FindFirst() then begin
                                        // Record exists, so skip inserting
                                        Clear(PerDayRevnue);
                                    end
                                    else begin
                                        // Insert the new record only if it doesn't exist
                                        PerDayRevnue.Insert();
                                        Clear(PerDayRevnue);
                                    end;

                                until SubLeaseMergeRec.Next() = 0;
                            end;
                        until MergeSameSquareRec.Next() = 0;
                    end
                    else
                        Error('No matching records found in Merge SameSqure SubPage for the given Proposal ID.');

                    // Refresh the current page to display updated data
                    CurrPage.Update();
                end;
            }
        }

    }
    //-----------------Calculate Total Days in Months's-----------------//

    local procedure RecalculateTotals()
    var
        LeaseProposalRec: Record "Contract Renewal"; // Replace with your actual Lease Proposal table name
        TotalAnnualAmount: Decimal;
        TotalRoundOff: Decimal;
        TotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        TempRecord: Record "CR Merge SameSqure SubPage";
        vatPer: Integer;
    begin
        TotalAnnualAmount := 0;
        TotalRoundOff := 0;
        TotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records by the current Proposal ID
        TempRecord.SetRange("ID", Rec."ID");

        // Sum up the values for the filtered records
        if TempRecord.FindSet() then
            repeat
                TotalAnnualAmount += TempRecord."MS_Annual Amount";
                TotalRoundOff += TempRecord."MS_Round off";
                TotalFinalAmount += TempRecord."MS_Final Annual Amount";

                // Check for the first year and assign its Final Annual Amount
                if TempRecord.MS_Year = 1 then
                    FirstYearAnnualAmount := TempRecord."MS_Final Annual Amount";
            until TempRecord.Next() = 0;

        // Assign the calculated totals to the respective fields
        Rec.TotalAnnualAmount := TotalAnnualAmount;
        Rec.TotalRoundOff := TotalRoundOff;
        Rec.TotalFinalAmount := TotalFinalAmount;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount;

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("ID", Rec."ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := TotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        // Update the page
        CurrPage.Update();
    end;

    //-----------------Calculate No. Of Days -----------------//

    local procedure RecalculateNumberOfDays()
    var
        CurrentDate: Date;
        TotalDays: Integer;
    begin
        // Check if Start Date and End Date are valid
        if Rec."MS_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."MS_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."MS_End Date" < Rec."MS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."MS_Start Date";
        while CurrentDate <= Rec."MS_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."MS_Number of Days" := Rec."MS_End Date" - Rec."MS_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."MS_Number of Days" += TotalDays;

        Rec.Modify();
    end;

    //-----------------Calculate No. Of Days -----------------//

    //-----------------Calculate Leap Year -----------------//

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-----------------Calculate Leap Year -----------------//

    //-----------------Calculate Annual Amount -----------------//

    local procedure RecalculateAnnualAmount()
    begin
        if Rec.MS_Year = 1 then begin
            if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
            else
                Rec."MS_Annual Amount" := 0;
        end else begin
            if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
            else
                Rec."MS_Annual Amount" := 0;
        end;
        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Annual Amount -----------------//

    //-----------------Calculate Final Annual Amount -----------------//

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
        LeapDay: Date;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."MS_Start Date" = 0D) or (Rec."MS_End Date" = 0D) then begin
            Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount" + Rec."MS_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."MS_End Date" < Rec."MS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."MS_Start Date", 3);
        YearEnd := Date2DMY(Rec."MS_End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."MS_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."MS_End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                if IsLeapYear(CurrYear) then begin
                    LeapDay := DMY2Date(29, 2, CurrYear);
                    if (OverlapStart <= LeapDay) and (OverlapEnd >= LeapDay) then
                        DaysInYear := 366
                    else
                        DaysInYear := 365;
                end else
                    DaysInYear := 365;

                ProratedAmount += (Rec."MS_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."MS_Final Annual Amount" := ProratedAmount + Rec."MS_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Final Annual Amount -----------------//

    //-----------------Calculate Per Day Rent -----------------//

    local procedure RecalculatePerDayRent()
    begin
        if Rec."MS_Number of Days" > 0 then
            Rec."MS_Per Day Rent" := Rec."MS_Final Annual Amount" / Rec."MS_Number of Days"
        else
            Rec."MS_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Per Day Rent -----------------//

    procedure SetContractIDs(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;

    end;

    var
        ContractID: Integer;

}
