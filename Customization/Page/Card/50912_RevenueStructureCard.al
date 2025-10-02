page 50912 "Revenue Structure Card"
{
    PageType = Card;
    SourceTable = "Revenue Structure";
    ApplicationArea = All;
    Caption = 'Revenue Structure Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {


                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }

                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false; // The ID is not editable since it's auto-incrementing
                //     Lookup = true;
                // }

                field("RS ID"; Rec."RS ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Enter the Number of Instalments.';
                    Editable = false;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                    // Visible = false;
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                    // Visible = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;

                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }
            }

            group("Payment Schedule")
            {
                part("Revenue Structure"; "Payment Schedule")
                {
                    SubPageLink = "RS ID" = FIELD("RS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue Payment Schedule")
            {
                part("Revenue Structure2";
                "Revenue Payment Schedule")
                {
                    SubPageLink = "RS ID" = FIELD("RS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Revenue Recognition Other Charges")
            {
                part("Revenue Recognition"; "RevenueRecognition Othercharge")
                {
                    SubPageLink = "RS ID" = FIELD("RS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CreditNote)
            {
                ApplicationArea = All;
                Caption = 'Revenue Recognition';
                Image = PostDocument;


                trigger OnAction()
                var
                begin
                    CalculateMonthlyRevenue();
                    Message('Revenue Other charges is Calculated');
                end;

            }
        }
    }

    // local procedure CalculateMonthlyRevenue()
    // var
    //     SubpageRec: Record "RevenueRecognition Othercharge";
    //     StartDate: Date;
    //     EndDate: Date;
    //     TotalDays: Integer;
    //     CurrentDate: Date;
    //     MonthDays: Integer;
    //     DailyRate: Decimal;
    //     MonthlyRate: Decimal;
    //     AllocatedAmount: Decimal;
    //     FirstDayNextMonth: Date;
    //     LastDayOfMonth: Date;
    //     DaysInMonth: Integer;
    //     Year: Integer;
    //     Month: Integer;
    //     Day: Integer;
    //     IsLeap: Boolean;
    //     MonthlyRate2: Decimal;
    //     TotalMonths: Integer;
    //     ActualDaysInMonth: Integer;
    //     LastEntryNo: Integer;
    // begin
    //     // Clear existing records in the subpage table
    //     SubpageRec.DeleteAll();

    //     // Ensure Start and End Dates are valid
    //     if (Rec."Contract Start Date" = 0D) or (Rec."Contract End Date" = 0D) then
    //         exit;

    //     TotalMonths := CalculateTotalMonths(Rec."Contract Start Date", Rec."Contract End Date");

    //     TotalDays := (Rec."Contract End Date" - Rec."Contract Start Date") + 1;
    //     DailyRate := Rec."Amount Including VAT" / TotalDays;

    //     CurrentDate := Rec."Contract Start Date";
    //     while CurrentDate <= Rec."Contract End Date" do begin
    //         SubpageRec.Init();
    //         LastEntryNo += 1; // Increment Entry No.
    //         SubpageRec."Entry No." := LastEntryNo; // Assign new Entry No.
    //         SubpageRec."RS Id" := Rec."RS Id";
    //         SubpageRec."Contract ID" := Rec."Contract ID";
    //         SubpageRec."Tenant Id" := Rec."Tenant Id";

    //         // Format Month-Year
    //         SubpageRec."Month" := FORMAT(CurrentDate, 0, '<Month Text>') + '-' + FORMAT(CurrentDate, 0, '<Year>');

    //         // Calculate the first day of the next month
    //         if DATE2DMY(CurrentDate, 2) = 12 then begin
    //             FirstDayNextMonth := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3) + 1); // January of next year
    //         end else begin
    //             FirstDayNextMonth := DMY2DATE(1, DATE2DMY(CurrentDate, 2) + 1, DATE2DMY(CurrentDate, 3)); // Next month of the same year
    //         end;

    //         LastDayOfMonth := FirstDayNextMonth - 1;


    //         if Rec."Contract End Date" < LastDayOfMonth then
    //             MonthDays := Rec."Contract End Date" - CurrentDate + 1
    //         else
    //             MonthDays := LastDayOfMonth - CurrentDate + 1;


    //         if CurrentDate = Rec."Contract Start Date" then
    //             if MonthDays > (Rec."Contract End Date" - CurrentDate + 1) then
    //                 MonthDays := (Rec."Contract End Date" - CurrentDate + 1);


    //         IsLeap := IsLeapYear(Year);

    //         if Month = 2 then begin
    //             if IsLeap then
    //                 DaysInMonth := 29
    //             else
    //                 DaysInMonth := 28;
    //         end else if (Month = 4) or (Month = 6) or (Month = 9) or (Month = 11) then begin
    //             DaysInMonth := 30;
    //         end else begin
    //             DaysInMonth := 31;
    //         end;

    //         ActualDaysInMonth := GetDaysInMonthss(CurrentDate);

    //         if MonthDays < ActualDaysInMonth then begin
    //             MonthlyRate2 := Round(Rec."Amount Including VAT" / TotalMonths);
    //             MonthlyRate := Round(MonthlyRate2 / ActualDaysInMonth * MonthDays);
    //         end else begin
    //             MonthlyRate := MonthlyRate2;
    //         end;

    //         AllocatedAmount := MonthDays * DailyRate;

    //         SubpageRec."No. of Days" := MonthDays;
    //         SubpageRec."RR - Method 1 (Day)" := AllocatedAmount;
    //         SubpageRec."RR - Method 2 (Month)" := MonthlyRate;
    //         SubpageRec.Insert();

    //         // Move to the first day of the next month
    //         CurrentDate := FirstDayNextMonth;
    //     end;
    // end;




    local procedure CalculateMonthlyRevenue()
    var
        SubpageRec: Record "RevenueRecognition Othercharge";
        StartDate: Date;
        EndDate: Date;
        TotalDays: Integer;
        CurrentDate: Date;
        MonthDays: Integer;
        DailyRate: Decimal;
        MonthlyRate: Decimal;
        AllocatedAmount: Decimal;
        FirstDayNextMonth: Date;
        LastDayOfMonth: Date;
        DaysInMonth: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        IsLeap: Boolean;
        MonthlyRate2: Decimal;
        TotalMonths: Integer;
        ActualDaysInMonth: Integer;
        LastEntryNo: Integer;
        Method1Total: Decimal;
        Method2Total: Decimal;
        TempSubpageRecs: array[1000] of Record "RevenueRecognition Othercharge" temporary;
        RecCount: Integer;
        RemainingAmount: Decimal;
    begin
        // Clear existing records in the subpage table
        SubpageRec.DeleteAll();

        // Ensure Start and End Dates are valid
        if (Rec."Contract Start Date" = 0D) or (Rec."Contract End Date" = 0D) then
            exit;

        TotalMonths := CalculateTotalMonths(Rec."Contract Start Date", Rec."Contract End Date");

        TotalDays := (Rec."Contract End Date" - Rec."Contract Start Date") + 1;
        DailyRate := Rec.Amount / TotalDays;

        CurrentDate := Rec."Contract Start Date";
        Method1Total := 0;
        Method2Total := 0;
        RecCount := 0;
        MonthlyRate2 := Round(Rec.Amount / TotalMonths);

        // First pass - calculate all monthly values
        while CurrentDate <= Rec."Contract End Date" do begin
            RecCount += 1;

            // Initialize temporary record to store calculations
            TempSubpageRecs[RecCount].Init();
            LastEntryNo += 1; // Increment Entry No.
            TempSubpageRecs[RecCount]."Entry No." := LastEntryNo;
            TempSubpageRecs[RecCount]."RS Id" := Rec."RS Id";
            TempSubpageRecs[RecCount]."Contract ID" := Rec."Contract ID";
            TempSubpageRecs[RecCount]."Tenant Id" := Rec."Tenant Id";

            // Format Month-Year
            TempSubpageRecs[RecCount]."Month" := FORMAT(CurrentDate, 0, '<Month Text>') + '-' + FORMAT(CurrentDate, 0, '<Year>');

            // Calculate the first day of the next month
            if DATE2DMY(CurrentDate, 2) = 12 then begin
                FirstDayNextMonth := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3) + 1); // January of next year
            end else begin
                FirstDayNextMonth := DMY2DATE(1, DATE2DMY(CurrentDate, 2) + 1, DATE2DMY(CurrentDate, 3)); // Next month of the same year
            end;

            LastDayOfMonth := FirstDayNextMonth - 1;


            if Rec."Contract End Date" < LastDayOfMonth then
                MonthDays := Rec."Contract End Date" - CurrentDate + 1
            else
                MonthDays := LastDayOfMonth - CurrentDate + 1;


            if CurrentDate = Rec."Contract Start Date" then
                if MonthDays > (Rec."Contract End Date" - CurrentDate + 1) then
                    MonthDays := (Rec."Contract End Date" - CurrentDate + 1);


            Year := DATE2DMY(CurrentDate, 3);
            Month := DATE2DMY(CurrentDate, 2);
            IsLeap := IsLeapYear(Year);

            if Month = 2 then begin
                if IsLeap then
                    DaysInMonth := 29
                else
                    DaysInMonth := 28;
            end else if (Month = 4) or (Month = 6) or (Month = 9) or (Month = 11) then begin
                DaysInMonth := 30;
            end else begin
                DaysInMonth := 31;
            end;

            ActualDaysInMonth := GetDaysInMonthss(CurrentDate);

            AllocatedAmount := MonthDays * DailyRate;
            TempSubpageRecs[RecCount]."RR - Method 1 (Day)" := AllocatedAmount;

            if MonthDays < ActualDaysInMonth then begin
                MonthlyRate := Round(MonthlyRate2 / ActualDaysInMonth * MonthDays);
            end else begin
                MonthlyRate := MonthlyRate2;
            end;

            Method2Total += MonthlyRate;

            TempSubpageRecs[RecCount]."RR - Method 2 (Month)" := MonthlyRate;
            TempSubpageRecs[RecCount]."No. of Days" := MonthDays;

            CurrentDate := FirstDayNextMonth;
        end;

        // Adjust the last month's amount for Method 2 to ensure total matches contract amount
        RemainingAmount := Rec.Amount - (Method2Total - TempSubpageRecs[RecCount]."RR - Method 2 (Month)");
        TempSubpageRecs[RecCount]."RR - Method 2 (Month)" := RemainingAmount;

        // Insert all records into the actual table
        for LastEntryNo := 1 to RecCount do begin
            SubpageRec.Init();
            SubpageRec."Entry No." := TempSubpageRecs[LastEntryNo]."Entry No.";
            SubpageRec."RS Id" := TempSubpageRecs[RecCount]."RS Id";
            SubpageRec."Contract ID" := TempSubpageRecs[LastEntryNo]."Contract ID";
            SubpageRec."Tenant Id" := TempSubpageRecs[LastEntryNo]."Tenant Id";
            SubpageRec."Month" := TempSubpageRecs[LastEntryNo]."Month";
            SubpageRec."No. of Days" := TempSubpageRecs[LastEntryNo]."No. of Days";
            SubpageRec."RR - Method 1 (Day)" := TempSubpageRecs[LastEntryNo]."RR - Method 1 (Day)";
            SubpageRec."RR - Method 2 (Month)" := TempSubpageRecs[LastEntryNo]."RR - Method 2 (Month)";
            SubpageRec.Insert();
        end;
    end;
    //-----------------Calculate Monthly Revenue-----------------//

    //-----------------Calculate Leap year-----------------//


    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-----------------Calculate Total Months-----------------//

    local procedure CalculateTotalMonths(StartDate: Date; EndDate: Date) Result: Integer
    var
        StartYear, StartMonth, StartDay : Integer;
        EndYear, EndMonth, EndDay : Integer;
        DaysInEndMonth: Integer;
        FirstDayOfNextMonth: Date;
    begin
        // Extract the year, month, and day from the start and end dates
        StartYear := DATE2DMY(StartDate, 3); // Year
        StartMonth := DATE2DMY(StartDate, 2); // Month
        StartDay := DATE2DMY(StartDate, 1); // Day

        EndYear := DATE2DMY(EndDate, 3); // Year
        EndMonth := DATE2DMY(EndDate, 2); // Month
        EndDay := DATE2DMY(EndDate, 1); // Day

        // Calculate the difference in months
        Result := ((EndYear - StartYear) * 12) + (EndMonth - StartMonth);

        // Calculate the number of days in the end month
        if EndMonth = 12 then
            FirstDayOfNextMonth := DMY2DATE(1, 1, EndYear + 1) // January of the next year
        else
            FirstDayOfNextMonth := DMY2DATE(1, EndMonth + 1, EndYear); // First day of the next month

        DaysInEndMonth := FirstDayOfNextMonth - DMY2DATE(1, EndMonth, EndYear);

        // Check if EndDate includes the full final month
        // DaysInEndMonth := CALCDATE('<CM+1>', DMY2DATE(1, EndMonth, EndYear)) - DMY2DATE(1, EndMonth, EndYear);
        if EndDay = DaysInEndMonth then
            Result := Result + 1;
    end;

    //-----------------Calculate Total Months-----------------//


    //-----------------Calculate Total Days in Months-----------------//
    local procedure GetDaysInMonth(CurrentDate: Date): Integer
    var
        FirstDayNextMonth: Date;
        FirstDayCurrentMonth: Date;
    begin
        // Calculate the first day of the next month
        FirstDayNextMonth := CALCDATE('<+CM>', CurrentDate);

        // Calculate the first day of the current month
        FirstDayCurrentMonth := CALCDATE('<-CM>', CurrentDate);

        // Return the difference between the first day of the next month and current month
        exit(FirstDayNextMonth - FirstDayCurrentMonth);
    end;
    //-----------------Calculate Total Days in Months-----------------//

    //-----------------Calculate Total Days in Months's-----------------//


    local procedure GetDaysInMonthss(CurrentDate: Date): Integer
    var
        Year: Integer;
        Month: Integer;
        IsLeap: Boolean;
    begin
        Year := DATE2DMY(CurrentDate, 3); // Extract Year from CurrentDate
        Month := DATE2DMY(CurrentDate, 2); // Extract Month from CurrentDate
        IsLeap := IsLeapYear(Year);

        case Month of
            1, 3, 5, 7, 8, 10, 12: // 31-day months
                exit(31);
            4, 6, 9, 11: // 30-day months
                exit(30);
            2: // February
                if IsLeap then
                    exit(29) // Leap year February has 29 days
                else
                    exit(28); // Non-leap year February has 28 days
        end;
    end;

    //-----------------Calculate Total Days in Months's-----------------//


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    procedure ClearSubgridData()
    var
        REVENUESTRUCTURE: Record "Revenue Structure Subpage1";
    begin
        REVENUESTRUCTURE.Reset();
        REVENUESTRUCTURE.SetRange("RS ID", Rec."RS ID");
        REVENUESTRUCTURE.DeleteAll();
    end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CalculateAndSetTotalAmount();
    // end;



    // local procedure CalculateTotals()
    // var
    //     RevenueStructureRec: Record "Revenue Structure Subpage"; // Ensure this matches the actual subpage table name
    //     TotalAmount: Integer;
    // begin
    //     // Initialize totals to zero
    //     TotalAmount := 0;
    //     // TotalAnnualAmount := 0;
    //     // TotalRoundOff := 0;

    //     // Filter records by Proposal ID
    //     RevenueStructureRec.SetRange("Proposal ID", Rec."Proposal ID");

    //     // Calculate totals for filtered records
    //     if RevenueStructureRec.FindSet() then
    //         repeat
    //             TotalAmount += RevenueStructureRec."Final Annual Amount"; // Replace with correct field names
    //                                                                       // TotalAnnualAmount += SingleUnitRentRec."Annual Amount";
    //                                                                       // TotalRoundOff += SingleUnitRentRec."Round Off";
    //         until RevenueStructureRec.Next() = 0;

    //     // Update the current record fields
    //     Rec."Total Amount" := TotalAmount;
    //     // Rec.TotalAnnualAmount := TotalAnnualAmount;
    //     // Rec.TotalRoundOff := TotalRoundOff;

    //     // Save changes
    //     Rec.Modify(false);
    // end;





}