page 50329 "Single Unit Rent SubPage"
{
    PageType = ListPart;
    SourceTable = "Single Unit Rent SubPage";
    ApplicationArea = All;
    Caption = 'Single Unit Rent SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Merged Unit ID"; rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Year"; rec.Year)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Number of Days"; Rec."Number of Days")
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
                field("Unit Sq Ft"; rec."Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                // field("Rate per Sq.Ft"; rec."Rate per Sq.Ft")
                // {
                //     ApplicationArea = All;
                //     Editable = true;

                //     trigger OnValidate()
                //     begin
                //         // Ensure the value is not negative
                //         if Rec."Rate per Sq.Ft" < 0 then
                //             Error('Rate per Sq.Ft cannot be negative.');

                //         // Recalculate Annual Amount
                //         if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                //             Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
                //         else
                //             Rec."Annual Amount" := 0;

                //         // Set Final Annual Amount equal to Annual Amount
                //         Rec."Final Annual Amount" := Rec."Annual Amount";

                //         // Recalculate Per Day Rent
                //         RecalculatePerDayRent();

                //         // Save changes
                //         Rec.Modify();
                //         CurrPage.Update();
                //     end;

                // }

                // field("Rate per Sq.Ft"; rec."Rate per Sq.Ft")
                // {
                //     ApplicationArea = All;
                //     Editable = true;

                //     trigger OnValidate()
                //     var
                //         PreviousYearRecord: Record "Single Unit Rent SubPage";
                //         PreviousRate: Decimal;
                //     begin
                //         // Ensure the value is not negative
                //         if Rec."Rate per Sq.Ft" < 0 then
                //             Error('Rate per Sq.Ft cannot be negative.');

                //         // Fetch the previous year's record to calculate Rent Increase %
                //         PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                //         PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                //         if PreviousYearRecord.FindFirst() then begin
                //             PreviousRate := PreviousYearRecord."Rate per Sq.Ft";

                //             // Ensure previous rate is greater than 0 to avoid division by zero
                //             if PreviousRate > 0 then
                //                 Rec."Rent Increase %" :=
                //                     ((Rec."Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                //             else
                //                 Rec."Rent Increase %" := 0; // No increase if previous rate is 0
                //         end else
                //             Rec."Rent Increase %" := 0; // No increase for the first year or no previous record

                //         // Recalculate Annual Amount
                //         if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                //             Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
                //         else
                //             Rec."Annual Amount" := 0;

                //         // Set Final Annual Amount equal to Annual Amount
                //         Rec."Final Annual Amount" := Rec."Annual Amount";

                //         // Recalculate Per Day Rent
                //         RecalculatePerDayRent();
                //         RecalculateTotals();

                //         // Save changes
                //         Rec.Modify();
                //         CurrPage.Update();
                //     end;
                // }

                field("Rate per Sq.Ft"; rec."Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Unit Rent SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."Rent Increase %" :=
                                    ((Rec."Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                            Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
                        else
                            Rec."Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."Final Annual Amount" := Rec."Annual Amount";

                        // Recalculate Per Day Rent
                        // RecalculatePerDayRent();

                        // Update totals
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent();
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                // field("Rent Increase %"; Rec."Rent Increase %")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Rent Increase %';
                //     ToolTip = 'Enter the rent increase percentage for this year.';

                //     trigger OnValidate()
                //     var
                //         PreviousYearRecord: Record "Single Unit Rent SubPage";
                //         IncreaseFactor: Decimal;
                //     begin
                //         // Ensure that Rent Increase % is not negative
                //         if Rec."Rent Increase %" < 0 then
                //             Error('Rent Increase % cannot be negative.');

                //         // Skip calculation for the first year
                //         if Rec."Year" = 1 then
                //             exit;

                //         // Fetch the previous year's record
                //         PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                //         PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                //         if PreviousYearRecord.FindFirst() then begin
                //             // Calculate the new rate for the current year
                //             IncreaseFactor := 1 + (Rec."Rent Increase %" / 100);
                //             Rec."Rate per Sq.Ft" := PreviousYearRecord."Rate per Sq.Ft" * IncreaseFactor;

                //             // Recalculate Annual Amount
                //             Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft";

                //             // Update Final Annual Amount to match Annual Amount
                //             Rec."Final Annual Amount" := Rec."Annual Amount";

                //             // Recalculate Per Day Rent
                //             RecalculatePerDayRent();
                //             // RecalculateTotals();

                //             // Save changes
                //             Rec.Modify();
                //             CurrPage.Update();
                //         end else
                //             Error('No record found for the previous year to base the calculation.');
                //     end;
                // }

                field("Rent Increase %"; Rec."Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Unit Rent SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."Year" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."Rent Increase %" / 100);
                            Rec."Rate per Sq.Ft" := PreviousYearRecord."Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."Final Annual Amount" := Rec."Annual Amount";

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


                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Annual Amount';
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }

                field("Round off"; rec."Round off")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';

                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }

                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Final Annual Amount';
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;
                }

                // field("Single Unit Rent1"; Rec."Single Unit Rent1")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Single Unit Rent Details';
                //     ToolTip = 'Click Here For Get Data.';
                //     DrillDown = true;

                //     trigger OnDrillDown()
                //     var
                //         LeaseProposal: Record "Lease Proposal Details"; // Replace with actual table name
                //         ExistingRecords: Record "Single Unit Rent SubPage"; // Target table
                //         PeriodStartDate: Date;
                //         PeriodEndDate: Date;
                //         LeaseEndDate: Date;
                //         TotalDays: Integer;
                //         DaysToAdd: Integer;
                //         LeapDays: Integer;
                //         CurrentYear: Integer;
                //         YearCounter: Integer;
                //         LineNoCounter: Integer;
                //     begin
                //         // Ensure Proposal ID exists
                //         if Rec."Proposal ID" = 0 then
                //             Error('Proposal ID is missing.');

                //         // Fetch Lease Proposal Details for the current Proposal ID
                //         if LeaseProposal.Get(Rec."Proposal ID") then begin
                //             // Delete existing records for the same Proposal ID to avoid duplication
                //             ExistingRecords.SetRange("Proposal ID", LeaseProposal."Proposal ID");
                //             if ExistingRecords.FindSet() then
                //                 repeat
                //                     ExistingRecords.Delete();
                //                 until ExistingRecords.Next() = 0;

                //             // Initialize variables
                //             PeriodStartDate := LeaseProposal."Lease Start Date";
                //             LeaseEndDate := LeaseProposal."Lease End Date";
                //             YearCounter := 1;
                //             LineNoCounter := 1;

                //             // Loop to divide the period into yearly chunks and create records
                //             while PeriodStartDate <= LeaseEndDate do begin
                //                 ExistingRecords.Init();
                //                 ExistingRecords."Proposal ID" := LeaseProposal."Proposal ID";
                //                 ExistingRecords."Line No." := LineNoCounter;
                //                 ExistingRecords."Year" := YearCounter;
                //                 ExistingRecords."Start Date" := PeriodStartDate;

                //                 // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                //                 DaysToAdd := 365; // Default to 365 days
                //                 LeapDays := 0;

                //                 // Check for leap years in the range from Start Date to Start Date + 364 days
                //                 for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                //                     if IsLeapYear(CurrentYear) then begin
                //                         // Ensure the leap day (Feb 29) falls within the range
                //                         if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                //                            (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                //                             LeapDays += 1;
                //                     end;
                //                 end;

                //                 // Adjust DaysToAdd to account for any leap days
                //                 DaysToAdd := DaysToAdd + LeapDays;

                //                 // Calculate the PeriodEndDate
                //                 PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                //                 // Ensure the End Date does not exceed the Lease End Date
                //                 if PeriodEndDate > LeaseEndDate then
                //                     PeriodEndDate := LeaseEndDate;

                //                 ExistingRecords."End Date" := PeriodEndDate;

                //                 // Calculate the number of days for this chunk
                //                 TotalDays := PeriodEndDate - PeriodStartDate + 1;
                //                 ExistingRecords."Number of Days" := TotalDays;

                //                 // Populate other fields
                //                 ExistingRecords."Unit ID" := LeaseProposal."Unit Name";
                //                 ExistingRecords."Unit Sq Ft" := LeaseProposal."Unit Size";

                //                 // Set default values for Rate per Sq.Ft and Annual Amount (to be manually entered)
                //                 ExistingRecords."Rate per Sq.Ft" := 0; // Initialize as 0; users will manually enter this
                //                 ExistingRecords."Annual Amount" := 0; // Calculated after manual input

                //                 // Set Final Annual Amount to match Annual Amount
                //                 ExistingRecords."Final Annual Amount" := ExistingRecords."Annual Amount";

                //                 // Calculate Per Day Rent
                //                 ExistingRecords."Per Day Rent" := 0; // Will be calculated after manual input

                //                 ExistingRecords.Insert();

                //                 // Move to the next period
                //                 PeriodStartDate := PeriodEndDate + 1;
                //                 YearCounter += 1;
                //                 LineNoCounter += 1;
                //             end;

                //             // Refresh the page to display all records
                //             CurrPage.Update();
                //         end else
                //             Error('No Lease Proposal Details found for the selected Proposal ID.');
                //     end;



                // trigger OnDrillDown()
                // var
                //     LeaseProposal: Record "Lease Proposal Details";
                //     ExistingRecords: Record "Single Unit Rent SubPage";
                //     PeriodStartDate: Date;
                //     TotalDays, NumDays : Integer;
                //     YearCounter, LineNoCounter : Integer;
                // begin
                //     // Ensure Proposal ID exists
                //     if Rec."Proposal ID" = 0 then
                //         Error('Proposal ID is missing.');

                //     // Fetch Lease Proposal Details for the current Proposal ID
                //     if LeaseProposal.Get(Rec."Proposal ID") then begin
                //         // Delete existing records for the same Proposal ID to avoid duplication
                //         ExistingRecords.SetRange("Proposal ID", LeaseProposal."Proposal ID");
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
                //             ExistingRecords."Line No." := LineNoCounter;
                //             ExistingRecords."Year" := YearCounter;
                //             ExistingRecords."Start Date" := PeriodStartDate;

                //             // Calculate End Date for the current chunk
                //             if PeriodStartDate + 365 > LeaseProposal."Lease End Date" then
                //                 ExistingRecords."End Date" := LeaseProposal."Lease End Date"
                //             else
                //                 ExistingRecords."End Date" := PeriodStartDate + 365 - 1;

                //             // Calculate the number of days for this chunk
                //             NumDays := ExistingRecords."End Date" - ExistingRecords."Start Date" + 1;
                //             ExistingRecords."Number of Days" := NumDays;

                //             // Copy other fields
                //             ExistingRecords."Unit ID" := LeaseProposal."Unit Name";
                //             ExistingRecords."Unit Sq Ft" := LeaseProposal."Unit Size";

                //             // Set default values for Rate per Sq.Ft and Annual Amount (to be manually entered)
                //             ExistingRecords."Rate per Sq.Ft" := 0; // Initialize as 0; users will manually enter this
                //             ExistingRecords."Annual Amount" := 0; // Calculated after manual input

                //             // Set Final Annual Amount to match Annual Amount
                //             ExistingRecords."Final Annual Amount" := ExistingRecords."Annual Amount";

                //             // Calculate Per Day Rent
                //             ExistingRecords."Per Day Rent" := 0; // Will be calculated after manual input

                //             ExistingRecords.Insert();

                //             // Move to the next period
                //             PeriodStartDate := ExistingRecords."End Date" + 1;
                //             YearCounter += 1;
                //             LineNoCounter += 1;
                //         end;

                //         // Refresh the page to display all records
                //         CurrPage.Update();
                //     end else
                //         Error('No Lease Proposal Details found for the selected Proposal ID.');
                // end;


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
    //                 SingleSquareRec: Record "Single Unit Rent SubPage";
    //                 SubLeaseMergeRec: Record "Sub Lease Merged Units";
    //                 PerDayRevnue: Record "Per Day Rent for Revenue";
    //             begin
    //                 if Rec."Proposal ID" = 0 then
    //                     Error('Proposal ID is missing or not assigned.');

    //                 // Fetch data from the Merge SameSqure SubPage table
    //                 SingleSquareRec.SetRange("Proposal ID", Rec."Proposal ID");

    //                 // Fetch data from the Sub Lease Merged Units table
    //                 SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");

    //                 // Fetch the first record from the Merge SameSqure SubPage table
    //                 if SingleSquareRec.FindSet() then begin
    //                     repeat
    //                         // Loop through Sub Lease Merged Units and fetch relevant data
    //                         if SubLeaseMergeRec.FindSet() then begin
    //                             repeat
    //                                 PerDayRevnue.Init();
    //                                 // Initialize the record in the current grid with data from both tables
    //                                 PerDayRevnue."Proposal ID" := SingleSquareRec."Proposal ID";
    //                                 PerDayRevnue."Year" := SingleSquareRec."Year"; // From Merge SameSqure SubPage
    //                                 PerDayRevnue."Per Day Rent Per Unit" := SingleSquareRec."Per Day Rent"; // From Merge SameSqure SubPage

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
    //                     until SingleSquareRec.Next() = 0;
    //                 end
    //                 else
    //                     Error('No matching records found in Merge SameSqure SubPage for the given Proposal ID.');

    //                 // Refresh the current page to display updated data
    //                 CurrPage.Update();
    //             end;
    //         }
    //     }
    // }

    // local procedure RecalculateTotals()
    // var
    //     TotalAnnualAmount: Decimal;
    //     TotalRoundOff: Decimal;
    //     TotalFinalAmount: Decimal;
    //     TempRecord: Record "Single Unit Rent SubPage";
    // begin
    //     TotalAnnualAmount := 0;
    //     TotalRoundOff := 0;
    //     TotalFinalAmount := 0;

    //     // Filter records based on the current Proposal ID
    //     TempRecord.SetRange("Proposal ID", Rec."Proposal ID");

    //     // Iterate over the filtered records
    //     if TempRecord.FindSet() then
    //         repeat
    //             TotalAnnualAmount += TempRecord."Annual Amount";
    //             TotalRoundOff += TempRecord."Round off";
    //             TotalFinalAmount += TempRecord."Final Annual Amount";
    //         until TempRecord.Next() = 0;

    //     // Assign calculated totals to the fields
    //     Rec.TotalAnnualAmount := TotalAnnualAmount;
    //     Rec.TotalRoundOff := TotalRoundOff;
    //     Rec.TotalFinalAmount := TotalFinalAmount;

    //     // Modify and refresh the page
    //     CurrPage.Update();
    // end;

    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "Lease Proposal Details";
        TotalAnnualAmount: Decimal;
        TotalRoundOff: Decimal;
        TotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        TempRecord: Record "Single Unit Rent SubPage";
        vatPer: Integer;
    begin
        TotalAnnualAmount := 0;
        TotalRoundOff := 0;
        TotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records based on the current Proposal ID
        TempRecord.SetRange("Proposal ID", Rec."Proposal ID");

        // Iterate over the filtered records
        if TempRecord.FindSet() then
            repeat
                TotalAnnualAmount += TempRecord."Annual Amount";
                TotalRoundOff += TempRecord."Round off";
                TotalFinalAmount += TempRecord."Final Annual Amount";

                // Check for the first year and assign its Annual Amount
                if TempRecord."Year" = 1 then
                    FirstYearAnnualAmount := TempRecord."Final Annual Amount";
            until TempRecord.Next() = 0;

        // Assign calculated totals to the fields
        Rec.TotalAnnualAmount := TotalAnnualAmount;
        Rec.TotalRoundOff := TotalRoundOff;
        Rec.TotalFinalAmount := TotalFinalAmount;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount; // Assign the first year's annual amount


        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
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

        // Modify and refresh the page
        CurrPage.Update();
    end;



    local procedure RecalculateNumberOfDays()
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentYear: Integer;
        TotalDays: Integer;
        IsLeapYearInRange: Boolean;
    begin
        // Validate Start Date and End Date
        if Rec."Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."End Date" < Rec."Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."End Date", 3);    // Extract year of End Date
        TotalDays := Rec."End Date" - Rec."Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do begin
            if IsLeapYear(CurrentYear) then begin
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;
            end;
        end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."Number of Days" := TotalDays;

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
        if Rec."Year" = 1 then begin
            if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
            else
                Rec."Annual Amount" := 0;
        end else begin
            if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
            else
                Rec."Annual Amount" := 0;
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
        LeapDay: Date; // date of Feb 29 for the current year (if applicable)
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."Start Date" = 0D) or (Rec."End Date" = 0D) then begin
            Rec."Final Annual Amount" := Rec."Annual Amount" + Rec."Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."End Date" < Rec."Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."Start Date", 3);
        YearEnd := Date2DMY(Rec."End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                // Use 366 only if the overlap for this calendar year actually includes Feb 29.
                if IsLeapYear(CurrYear) then begin
                    LeapDay := DMY2Date(29, 2, CurrYear);
                    if (OverlapStart <= LeapDay) and (OverlapEnd >= LeapDay) then
                        DaysInYear := 366
                    else
                        DaysInYear := 365;
                end else
                    DaysInYear := 365;

                ProratedAmount += (Rec."Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."Final Annual Amount" := ProratedAmount + Rec."Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."Number of Days" > 0 then
            Rec."Per Day Rent" := Rec."Final Annual Amount" / Rec."Number of Days"
        else
            Rec."Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;


}
