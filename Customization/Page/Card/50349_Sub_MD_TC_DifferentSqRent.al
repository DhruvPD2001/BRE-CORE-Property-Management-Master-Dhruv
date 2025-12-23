page 50349 "TC Merge DifferentSq SubPage"
{
    PageType = ListPart;
    SourceTable = "TC Merge DifferentSq SubPage";
    ApplicationArea = All;
    Caption = 'Merge DifferentSqure SubPage';

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
                field("MD_Merged Unit ID"; rec."MD_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                }
                field("MD_Unit ID"; rec."MD_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                }
                field("MD_Year"; rec.MD_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                }
                field("MD_Start Date"; rec."MD_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                }
                field("MD_End Date"; rec."MD_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                }
                field("MD_Number of Days"; rec."MD_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RecalculateNumberOfDays();
                    end;
                }
                field("MD_Unit Sq Ft"; rec."MD_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                field("MD_Rate per Sq.Ft"; rec."MD_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "CR Merge DifferentSq SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."MD_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("ID", Rec."ID");
                        PreviousYearRecord.SetRange("MD_Year", Rec.MD_Year - 1);
                        PreviousYearRecord.SetRange("MD_Unit ID", Rec."MD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."MD_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."MD_Rent Increase %" :=
                                    ((Rec."MD_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."MD_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."MD_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                            Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
                        else
                            Rec."MD_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount";

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

                field("MD_Rent Increase %"; rec."MD_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "CR Merge DifferentSq SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."MD_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec.MD_Year = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("ID", Rec."ID");
                        PreviousYearRecord.SetRange("MD_Year", Rec.MD_Year - 1);
                        PreviousYearRecord.SetRange("MD_Unit ID", Rec."MD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."MD_Rent Increase %" / 100);
                            Rec."MD_Rate per Sq.Ft" := PreviousYearRecord."MD_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount";

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
                field("MD_Annual Amount"; rec."MD_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                }
                field("MD_Round off"; rec."MD_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Final Annual Amount"; rec."MD_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Per Day Rent"; rec."MD_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    DecimalPlaces = 2 : 2;
                }

                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                // field("Merge DifferentSqure Rent1"; Rec."Merge DifferentSqure Rent1")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Merge DifferentSqure Rent Details';
                //     ToolTip = 'Click Here For Get Data.';
                //     DrillDown = true;

                //     trigger OnDrillDown()
                //     var
                //         LeaseProposal: Record "Lease Proposal Details"; // Replace with actual table name
                //         ExistingRecords: Record "Merge DifferentSqure SubPage"; // Target table
                //         PeriodStartDate, PeriodEndDate : Date;
                //         TotalDays, NumDays : Integer;
                //         YearCounter, LineNoCounter : Integer;
                //         SubLeaseGrid: Record "Sub Lease Merged Units";

                //     begin
                //         if Rec."Proposal ID" = 0 then
                //             Error('Proposal ID is missing or not assigned.');

                //         // Message('Debug: Proposal ID = %1', Rec."Proposal ID");

                //         LeaseProposal.Reset();
                //         LeaseProposal.SetRange("Proposal ID", Rec."Proposal ID");

                //         // if LeaseProposal.Get(Rec."Proposal ID") then begin
                //         if not LeaseProposal.FindFirst() then
                //             ExistingRecords.SetRange("Proposal ID", LeaseProposal."Proposal ID");
                //         if ExistingRecords.FindSet() then
                //             repeat
                //                 ExistingRecords.Delete();
                //             until ExistingRecords.Next() = 0;

                //         // Initialize variables
                //         PeriodStartDate := LeaseProposal."Lease Start Date";
                //         TotalDays := LeaseProposal."Lease End Date" - LeaseProposal."Lease Start Date" + 1;

                //         if TotalDays <= 0 then
                //             Error('Invalid Start Date and End Date in Lease Proposal.');

                //         YearCounter := 1;
                //         LineNoCounter := 1;

                //         // Loop to divide the period into yearly chunks and create records
                //         while PeriodStartDate <= LeaseProposal."Lease End Date" do begin
                //             ExistingRecords.Init();
                //             ExistingRecords."Proposal ID" := LeaseProposal."Proposal ID";
                //             ExistingRecords."MD_Line No." := LineNoCounter;
                //             ExistingRecords.MD_Year := YearCounter;
                //             ExistingRecords."MD_Unit ID" := LeaseProposal."Single Unit Name";
                //             ExistingRecords."MD_Start Date" := PeriodStartDate;

                //             if PeriodStartDate + 365 > LeaseProposal."Lease End Date" then
                //                 ExistingRecords."MD_End Date" := LeaseProposal."Lease End Date"
                //             else
                //                 ExistingRecords."MD_End Date" := PeriodStartDate + 365 - 1;

                //             NumDays := ExistingRecords."MD_End Date" - ExistingRecords."MD_Start Date" + 1;
                //             ExistingRecords."MD_Number of Days" := NumDays;

                //             ExistingRecords."MD_Merged Unit ID" := LeaseProposal."Unit Name";
                //             ExistingRecords."MD_Unit Sq Ft" := LeaseProposal."Unit Size";

                //             if YearCounter = 1 then
                //                 ExistingRecords."MD_Rate per Sq.Ft" := LeaseProposal."Market Rate per Sq. Ft."
                //             else
                //                 ExistingRecords."MD_Rate per Sq.Ft" := 0;

                //             ExistingRecords."MD_Final Annual Amount" :=
                //                 Round(LeaseProposal."Rent Amount" / TotalDays * NumDays, 2);

                //             ExistingRecords.Insert();

                //             PeriodStartDate := ExistingRecords."MD_End Date" + 1;
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
                    MergeDiffSquareRec: Record "CR Merge DifferentSq SubPage";
                    SubLeaseMergeRec: Record "CR Sub Lease Merged Units";
                    PerDayRevnue: Record "CR Per Day Rent for Revenue";
                    YearList: List of [Integer];
                    YearItem: Integer;
                begin
                    if Rec."ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch distinct years from the Merge DifferentSqure SubPage table
                    MergeDiffSquareRec.SetRange("ID", Rec."ID");
                    if MergeDiffSquareRec.FindSet() then begin
                        repeat
                            if not YearList.Contains(MergeDiffSquareRec."MD_Year") then
                                YearList.Add(MergeDiffSquareRec."MD_Year");
                        until MergeDiffSquareRec.Next() = 0;
                    end else
                        Error('No matching records found in Merge DifferentSqure SubPage for the given Proposal ID.');

                    // Loop through each year and fetch corresponding data
                    foreach YearItem in YearList do begin
                        MergeDiffSquareRec.SetRange("ID", Rec."ID");
                        MergeDiffSquareRec.SetRange("MD_Year", YearItem);

                        if MergeDiffSquareRec.FindSet() then begin
                            repeat
                                // Loop through Sub Lease Merged Units and fetch relevant data
                                SubLeaseMergeRec.SetRange("ID", Rec."ID");
                                if SubLeaseMergeRec.FindSet() then begin
                                    repeat
                                        PerDayRevnue.Init();

                                        // Initialize the record in the current grid with data from both tables
                                        PerDayRevnue."Contract Renewal Id" := MergeDiffSquareRec."ID";
                                        PerDayRevnue."Year" := MergeDiffSquareRec."MD_Year"; // From Merge DifferentSquare SubPage
                                        PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                        PerDayRevnue."Unit ID" := SubLeaseMergeRec."Single Unit Name"; // From Sub Lease Merged Units

                                        MergeDiffSquareRec.SetRange("MD_Unit ID", PerDayRevnue."Unit ID");
                                        if MergeDiffSquareRec.FindFirst() then
                                            // Directly assign the Per Day Rent value from MergeDiffSquareRec table to PerDayRevnue
                                            PerDayRevnue."Per Day Rent Per Unit" := MergeDiffSquareRec."MD_Per Day Rent";

                                        // Check if the record already exists to prevent duplicates
                                        PerDayRevnue.SetRange(Year, PerDayRevnue.Year);
                                        PerDayRevnue.SetRange("ID", PerDayRevnue."ID");
                                        PerDayRevnue.SetRange("Unit ID", PerDayRevnue."Unit ID");
                                        if not PerDayRevnue.FindFirst() then begin
                                            // Insert the new record only if it doesn't exist
                                            PerDayRevnue.Insert();
                                            Clear(PerDayRevnue);
                                        end;

                                    until SubLeaseMergeRec.Next() = 0;
                                end;
                            until MergeDiffSquareRec.Next() = 0;
                        end;
                    end;

                    // Refresh the current page to display updated data
                    CurrPage.Update();
                end;


            }
        }
    }




    // local procedure RecalculateTotals()
    // var
    //     LeaseProposalRec: Record "Lease Proposal Details"; // Replace with your actual Lease Proposal table name
    //     TotalAnnualAmount: Decimal;
    //     TotalRoundOff: Decimal;
    //     TotalFinalAmount: Decimal;
    //     FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
    //     TempRecord: Record "Merge DifferentSqure SubPage";
    // begin
    //     TotalAnnualAmount := 0;
    //     TotalRoundOff := 0;
    //     TotalFinalAmount := 0;
    //     FirstYearAnnualAmount := 0; // Initialize to 0

    //     // Filter records by the current Proposal ID
    //     TempRecord.SetRange("Proposal ID", Rec."Proposal ID");

    //     // Sum up the values for the filtered records
    //     if TempRecord.FindSet() then
    //         repeat
    //             TotalAnnualAmount += TempRecord."MD_Annual Amount";
    //             TotalRoundOff += TempRecord."MD_Round off";
    //             TotalFinalAmount += TempRecord."MD_Final Annual Amount";

    //             // Check for the first year and assign its Final Annual Amount
    //             if TempRecord.MD_Year = 1 then
    //                 FirstYearAnnualAmount := TempRecord."MD_Final Annual Amount";
    //         until TempRecord.Next() = 0;

    //     // Assign the calculated totals to the respective fields
    //     Rec.TotalAnnualAmount := TotalAnnualAmount;
    //     Rec.TotalRoundOff := TotalRoundOff;
    //     Rec.TotalFinalAmount := TotalFinalAmount;
    //     Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount;

    //     // Update Lease Proposal Details with calculated totals
    //     LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
    //     if LeaseProposalRec.FindSet() then begin
    //         LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
    //         LeaseProposalRec."Annual Rent Amount" := TotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount
    //         LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
    //     end;

    //     // Update the page
    //     CurrPage.Update();
    // end;


    local procedure RecalculateTotals()
    var
        LeaseProposalRec: Record "Contract Renewal"; // Replace with your actual Lease Proposal table name
        TotalAnnualAmount: Decimal;
        TotalRoundOff: Decimal;
        TotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        TempRecord: Record "CR Merge DifferentSq SubPage";
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
                TotalAnnualAmount += TempRecord."MD_Annual Amount";
                TotalRoundOff += TempRecord."MD_Round off";
                TotalFinalAmount += TempRecord."MD_Final Annual Amount";

                // Check for the first year and add its Final Annual Amount to FirstYearAnnualAmount
                if TempRecord.MD_Year = 1 then
                    FirstYearAnnualAmount += TempRecord."MD_Final Annual Amount"; // Sum all Final Annual Amounts for 1st Year
            until TempRecord.Next() = 0;

        // Assign the calculated totals to the respective fields
        Rec.TotalAnnualAmount := TotalAnnualAmount;
        Rec.TotalRoundOff := TotalRoundOff;
        Rec.TotalFinalAmount := TotalFinalAmount;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount;
        rec.Modify();

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("ID", Rec."ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the sum of first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := TotalFinalAmount; // Update Annual Rent Amount with the total of all years' Final Annual Amounts


            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        // Update the page to reflect changes
        CurrPage.Update();
    end;




    local procedure RecalculateNumberOfDays()
    var
        CurrentDate: Date;
        TotalDays: Integer;
    begin
        // Check if Start Date and End Date are valid
        if Rec."MD_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."MD_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."MD_End Date" < Rec."MD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."MD_Start Date";
        while CurrentDate <= Rec."MD_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."MD_Number of Days" := Rec."MD_End Date" - Rec."MD_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."MD_Number of Days" += TotalDays;

        Rec.Modify();
    end;

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    local procedure RecalculateAnnualAmount()
    begin
        if Rec.MD_Year = 1 then begin
            if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
            else
                Rec."MD_Annual Amount" := 0;
        end else begin
            if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
            else
                Rec."MD_Annual Amount" := 0;
        end;
        Rec.Modify();
        CurrPage.Update();
    end;

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
        if (Rec."MD_Start Date" = 0D) or (Rec."MD_End Date" = 0D) then begin
            Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount" + Rec."MD_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."MD_End Date" < Rec."MD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."MD_Start Date", 3);
        YearEnd := Date2DMY(Rec."MD_End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."MD_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."MD_End Date";
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

                ProratedAmount += (Rec."MD_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."MD_Final Annual Amount" := ProratedAmount + Rec."MD_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."MD_Number of Days" > 0 then
            Rec."MD_Per Day Rent" := Rec."MD_Final Annual Amount" / Rec."MD_Number of Days"
        else
            Rec."MD_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

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

