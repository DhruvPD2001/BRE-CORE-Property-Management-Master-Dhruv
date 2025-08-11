// page 50972 "Revenue Recognition Main"
// {
//     PageType = Card;
//     SourceTable = "Revenue Recognition Main";
//     ApplicationArea = All;
//     Caption = 'Revenue Recognition Card';

//     layout
//     {
//         area(content)
//         {
//             group("Revenue Allocation Details")
//             {
//                 field("RR_No."; Rec."RR_No.")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field(Month; Rec.Month)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Financial Year"; Rec."Financial Year")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             group("Revenue Recognition Item")
//             {
//                 Caption = 'Revenue Item Details';
//                 part("Revenue Recognition Item Details"; "Revenue Recognition Item Sub")
//                 {
//                     SubPageLink = "RR_No." = field("RR_No.");
//                 }
//             }

//             group("Revenue Recognition Detail")
//             {
//                 Caption = 'Revenue Recognition Details';
//                 part("Revenue Recognition Details"; "Revenue Recognition Detail Sub")
//                 {
//                     SubPageLink = "RR_No." = field("RR_No.");
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action("Process Selected Items")
//             {
//                 Caption = 'Process Selected Items';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     SourceRec: Record "Revenue Item Breakdown";
//                     TargetRec: Record "Revenue Recognition Item";
//                 begin
//                     if TargetRec.FindSet() then begin
//                         repeat
//                             // Find matching Revenue Item Breakdown by Item Type
//                             SourceRec.Reset();
//                             SourceRec.SetRange("Item Type", TargetRec."Item Type");

//                             if SourceRec.FindFirst() then begin
//                                 // Store RI_No from SourceRec to Link field
//                                 //  TargetRec.Link := SourceRec."RI_No.";

//                                 // Store header record RR_No. to current line
//                                 TargetRec."RR_No." := Rec."RR_No."; // Rec is header/page context
//                                 TargetRec.Modify(true); // ✅ This keeps record visible
//                             end;
//                         until TargetRec.Next() = 0;

//                         Message('Selected records processed successfully.');
//                     end else
//                         Message('No selected records found.');
//                 end;
//             }
//             action(FilterSubgrid)
//             {

//                 Caption = 'Revenue Details';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     FetchContracts();
//                 end;
//             }
//         }
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         ClearSubgridData();
//     end;

//     procedure ClearSubgridData()
//     var
//         revenueitem: Record "Revenue Recognition Item";
//         revenueitemdetail: Record "Revenue Recognition Details";
//     begin
//         revenueitem.Reset();
//         revenueitem.SetRange("RR_No.", Rec."RR_No.");
//         revenueitem.DeleteAll();
//         revenueitemdetail.Reset();
//         revenueitemdetail.SetRange("RR_No.", Rec."RR_No.");
//         revenueitemdetail.DeleteAll();
//     end;


//     procedure CalculateDaysInSelectedMonth(
//        ContractStartDate: Date;
//        ContractEndDate: Date;
//        MultiYearStartDate: Date;
//        MultiYearEndDate: Date;
//        SelectedMonth: Integer;
//        SelectedYear: Integer): Integer
//     var
//         StartDate: Date;
//         EndDate: Date;
//         MonthStartDate: Date;
//         MonthEndDate: Date;
//     begin
//         // Get first day of selected month
//         MonthStartDate := DMY2Date(1, SelectedMonth + 1, SelectedYear);
//         // Get last day of selected month
//         MonthEndDate := CALCDATE('<+1M-1D>', MonthStartDate);

//         // Check if selected month falls in multi-year start date month
//         if (Date2DMY(MultiYearStartDate, 2) = (SelectedMonth + 1)) and
//            (Date2DMY(MultiYearStartDate, 3) = SelectedYear) then begin
//             // Use contract start date if it falls in same month
//             if (Date2DMY(ContractStartDate, 2) = (SelectedMonth + 1)) and
//                (Date2DMY(ContractStartDate, 3) = SelectedYear) then
//                 StartDate := ContractStartDate
//             else
//                 StartDate := MultiYearStartDate;

//             EndDate := MonthEndDate;
//         end
//         // Check if selected month falls in multi-year end date month
//         else if (Date2DMY(MultiYearEndDate, 2) = (SelectedMonth + 1)) and
//                 (Date2DMY(MultiYearEndDate, 3) = SelectedYear) then begin
//             StartDate := MonthStartDate;

//             // Use contract end date if it falls in same month
//             if (Date2DMY(ContractEndDate, 2) = (SelectedMonth + 1)) and
//                (Date2DMY(ContractEndDate, 3) = SelectedYear) then
//                 EndDate := ContractEndDate
//             else
//                 EndDate := MultiYearEndDate;
//         end
//         // For months between start and end dates
//         else begin
//             StartDate := MonthStartDate;
//             EndDate := MonthEndDate;
//         end;

//         // Calculate and return the number of days
//         exit(EndDate - StartDate + 1);
//     end;

//     procedure GetNextLineNo(): Integer
//     var
//         FilteredContractRec: Record "Revenue Recognition Details";
//         LastLineNo: Integer;
//     begin
//         FilteredContractRec.Reset();
//         FilteredContractRec.SetRange("RR_No.", Rec."RR_No.");
//         if FilteredContractRec.FindLast() then
//             LastLineNo := FilteredContractRec."Entry No."
//         else
//             LastLineNo := 0;
//         exit(LastLineNo + 1);
//     end;

//     procedure ShouldKeepEntry(StartDate: Date; EndDate: Date): Boolean
//     var
//         CheckDate: Date;
//         LastDayOfMonth: Date;
//         FirstDayOfMonth: Date;
//     begin
//         // Get first day of selected month
//         FirstDayOfMonth := DMY2Date(1, Rec.Month + 1, Rec."Financial Year");

//         // Get last day of selected month
//         LastDayOfMonth := CALCDATE('<+1M-1D>', FirstDayOfMonth);

//         // Check if selected month's date range overlaps with the given date range
//         // A period overlaps if:
//         // 1. The start date is before or equal to the last day of the month AND
//         // 2. The end date is after or equal to the first day of the month
//         if (StartDate <= LastDayOfMonth) and (EndDate >= FirstDayOfMonth) then
//             exit(true);


//         exit(false);
//     end;

//     // Helper procedure to insert allocation line
//     procedure InsertAllocationLine(
//       ContractRec: Record "Tenancy Contract";
//       MultiYearStartDate: Date;
//       MultiYearEndDate: Date;
//       NoOfDays: Integer;
//       PerDayRent: Decimal;
//       TotalAnnualAmount: Decimal;
//       OwnerShareAmount: Decimal;
//     TerminationDate: Date; // New parameter for Termination Date
//       LineNo: Integer;
//       MonthNo: Integer;
//       FinancialYear: Integer)
//     var
//         FilteredContractRec: Record "Revenue Recognition Details";
//         SuspensionRec: Record SuspendReasonTable;
//         CalculatedDays: Integer;
//         NewLineNo: Integer;
//         TotalDays: Integer;
//         DailyRate: Decimal;
//         RevenueItemRec: Record "Revenue Item Breakdown Details";
//         TotalMergedAmount: Decimal;
//         PerDayMergedAmount: Decimal;
//         revenueitem: Record "Revenue Recognition Item";
//     // CalculatedTotalValue: Decimal;
//     // CalculatedOwnerShare: Decimal;
//     begin
//         // Check if December 2024 falls within multi year date range
//         if not ShouldKeepEntry(MultiYearStartDate, MultiYearEndDate) then
//             exit;

//         // 🚨 Prevent inserting duplicate Contract ID + RR_No. combination
//         FilteredContractRec.Reset();
//         FilteredContractRec.SetRange("RR_No.", Rec."RR_No.");
//         FilteredContractRec.SetRange("Contract Id", ContractRec."Contract ID");

//         if FilteredContractRec.FindFirst() then
//             exit; // Record already exists, so skip inserting

//         // Get new line number
//         NewLineNo := GetNextLineNo();

//         // Calculate the actual number of days for the selected month
//         CalculatedDays := CalculateDaysInSelectedMonth(
//             ContractRec."Contract Start Date",
//             ContractRec."Contract End Date",
//             MultiYearStartDate,
//             MultiYearEndDate,
//             MonthNo - 1,
//             FinancialYear
//         );

//         // Calculate Total Value and Owner Share with exact multiplication
//         // CalculatedTotalValue := PerDayRent * CalculatedDays;  // Direct multiplication without rounding
//         // CalculatedOwnerShare := CalculatedTotalValue; // Setting Owner Share equal to Total Value

//         FilteredContractRec.Init();
//         FilteredContractRec."Entry No." := NewLineNo;
//         FilteredContractRec."RR_No." := Rec."RR_No.";
//         FilteredContractRec."Property Name" := ContractRec."Property Name";
//         FilteredContractRec."Contract Id" := ContractRec."Contract ID";
//         FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
//         FilteredContractRec."Customer Name" := ContractRec."Customer Name";
//         FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
//         FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
//         FilteredContractRec."Grace Days" := ContractRec."Grace Period";
//         FilteredContractRec."Contract Amount" := ContractRec."Contract Amount Including VAT";
//         // FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
//         FilteredContractRec."Owner Name" := ContractRec."Owner's Name";


//         RevenueItemRec.Reset();
//         RevenueItemRec.SetRange("Contract ID", ContractRec."Contract ID");
//         RevenueItemRec.SetRange("Item Type", revenueitem."Item Type");
//         if RevenueItemRec.FindSet() then begin
//             repeat
//                 // Sum all charges (adjust field name as per your table)
//                 PerDayMergedAmount += RevenueItemRec."Per Day Amount"; // Replace "Amount" with your actual charge field
//                 TotalMergedAmount += RevenueItemRec."Total Value";
//             until RevenueItemRec.Next() = 0;
//         end;
//         // FilteredContractRec."No Of Days" := RevenueItemRec."No Of Days";
//         FilteredContractRec."Per Day Rent" := PerDayMergedAmount;
//         FilteredContractRec."Total Value" := TotalMergedAmount;
//         FilteredContractRec."Owner Share" := TotalMergedAmount; // If same as Total Value
//         // TotalDays := FilteredContractRec."Contract End Date" - FilteredContractRec."Contract Start Date" + 1;
//         // if TotalDays <= 0 then
//         //     Error('Invalid contract dates. End date must be after start date.');

//         // // Calculate per day amount and value
//         // DailyRate := FilteredContractRec."Contract Amount" / TotalDays;
//         // // FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
//         // // FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
//         // FilteredContractRec."No Of Days" := CalculatedDays;
//         // FilteredContractRec."Per Day Amount" := Round(DailyRate);
//         // FilteredContractRec."Total Value" := CalculatedDays * FilteredContractRec."Per Day Amount";
//         // FilteredContractRec."Owner Share" := CalculatedDays * FilteredContractRec."Per Day Amount";

//         // // Add this line to store the Final Annual Amount
//         // // FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
//         // // FilteredContractRec."Posting Month" := MonthNo - 1;
//         // // FilteredContractRec."Posting Year" := FinancialYear;
//         // // FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
//         // //     ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
//         // //     Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
//         // FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
//         FilteredContractRec.Insert();
//     end;

//     // Then modify the FetchContracts procedure to use this
//     procedure FetchContracts()
//     var
//         FilterHeader: Record "Revenue Allocation Details";
//         ContractRec: Record "Tenancy Contract";
//         FilteredContractRec: Record "Revenue Recognition Details";
//         SuspensionRec: Record SuspendReasonTable;
//         SingleUnitRent: Record "TC Single Unit Rent SubPage";
//         MultiUnitRent: Record "TC Single LumAnnualAmnt SP";
//         MergedSingleRent: Record "TC Merge SameSqure SubPage";
//         MergedMultiRent: Record "TC Merge DifferentSq SubPage";
//         SpecialRent: Record "TC Merge LumAnnualAmount SP";
//         FinalCalculationRec: Record "Final Calculation"; // New record for Final Calculation
//         SelectedMonthStart: Date;
//         SelectedMonthEnd: Date;
//         MonthNo: Integer;
//         FinancialYear: Integer;
//         LineNo: Integer;
//         TerminationDate: Date; // Variable to store Termination Date

//     begin
//         ClearSubgridData();

//         MonthNo := Rec.Month + 1;
//         FinancialYear := Rec."Financial Year";


//         SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear);
//         SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

//         if ContractRec.FindSet() then begin
//             repeat
//                 if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
//                     (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin

//                     // Retrieve Termination Date from Final Calculation
//                     FinalCalculationRec.Reset();
//                     FinalCalculationRec.SetRange("Contract ID", ContractRec."Contract ID");
//                     if FinalCalculationRec.FindFirst() then
//                         TerminationDate := FinalCalculationRec."Termination Date"
//                     else
//                         TerminationDate := 0D; // Default to blank if no termination date

//                     // Check Single Unit Rent grid
//                     SingleUnitRent.Reset();
//                     SingleUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
//                     if SingleUnitRent.FindSet() then begin
//                         repeat
//                             InsertAllocationLine(
//                                 ContractRec,
//                                 SingleUnitRent."Start Date",
//                                 SingleUnitRent."End Date",
//                                 SingleUnitRent."Number of Days",
//                                 SingleUnitRent."Per Day Rent",
//                                 SingleUnitRent."Final Annual Amount",
//                                 SingleUnitRent."Final Annual Amount",
//                                 TerminationDate,
//                                 LineNo,  // Use sequential number
//                                 MonthNo,
//                                 FinancialYear);
//                         // LineNo += 1;  // Increment by 1
//                         until SingleUnitRent.Next() = 0;
//                     end;

//                     // Check Multi Unit Rent grid
//                     MultiUnitRent.Reset();
//                     MultiUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
//                     if MultiUnitRent.FindSet() then begin
//                         repeat
//                             InsertAllocationLine(
//                                 ContractRec,
//                                 MultiUnitRent."SL_Start Date",
//                                 MultiUnitRent."SL_End Date",
//                                 MultiUnitRent."SL_Number of Days",
//                                 MultiUnitRent."SL_Per Day Rent",
//                                 MultiUnitRent."SL_Final Annual Amount",
//                                 MultiUnitRent."SL_Final Annual Amount",
//                                 TerminationDate,
//                                 LineNo,  // Use sequential number
//                                 MonthNo,
//                                 FinancialYear);
//                         // LineNo += 1;  // Increment by 1
//                         until MultiUnitRent.Next() = 0;
//                     end;

//                     // Check Merged Single Rent grid
//                     MergedSingleRent.Reset();
//                     MergedSingleRent.SetRange("Contract ID", ContractRec."Contract ID");
//                     if MergedSingleRent.FindSet() then begin
//                         repeat
//                             InsertAllocationLine(
//                                 ContractRec,
//                                 MergedSingleRent."MS_Start Date",
//                                 MergedSingleRent."MS_End Date",
//                                 MergedSingleRent."MS_Number of Days",
//                                 MergedSingleRent."MS_Per Day Rent",
//                                 MergedSingleRent."MS_Final Annual Amount",
//                                 MergedSingleRent."MS_Final Annual Amount",
//                                 TerminationDate,
//                                 LineNo,  // Use sequential number
//                                 MonthNo,
//                                 FinancialYear);
//                         // LineNo += 1;  // Increment by 1
//                         until MergedSingleRent.Next() = 0;
//                     end;

//                     // Check Merged Multi Rent grid
//                     MergedMultiRent.Reset();
//                     MergedMultiRent.SetRange("Contract ID", ContractRec."Contract ID");
//                     if MergedMultiRent.FindSet() then begin
//                         repeat
//                             InsertAllocationLine(
//                                 ContractRec,
//                                 MergedMultiRent."MD_Start Date",
//                                 MergedMultiRent."MD_End Date",
//                                 MergedMultiRent."MD_Number of Days",
//                                 MergedMultiRent."MD_Per Day Rent",
//                                 MergedMultiRent."MD_Final Annual Amount",
//                                 MergedMultiRent."MD_Final Annual Amount",
//                                 TerminationDate,
//                                 LineNo,  // Use sequential number
//                                 MonthNo,
//                                 FinancialYear);
//                         // LineNo += 1;  // Increment by 1
//                         until MergedMultiRent.Next() = 0;
//                     end;

//                     // Check Special Rent grid
//                     SpecialRent.Reset();
//                     SpecialRent.SetRange("Contract ID", ContractRec."Contract ID");
//                     if SpecialRent.FindSet() then begin
//                         repeat
//                             InsertAllocationLine(
//                                 ContractRec,
//                                 SpecialRent."ML_Start Date",
//                                 SpecialRent."ML_End Date",
//                                 SpecialRent."ML_Number of Days",
//                                 SpecialRent."ML_Per Day Rent",
//                                 SpecialRent."ML_Final Annual Amount",
//                                 SpecialRent."ML_Final Annual Amount",
//                                 TerminationDate,
//                                 LineNo,  // Use sequential number
//                                 MonthNo,
//                                 FinancialYear);
//                         // LineNo += 1;  // Increment by 1
//                         until SpecialRent.Next() = 0;
//                     end;
//                 end;
//             until ContractRec.Next() = 0;
//         end;
//     end;





//     trigger OnAfterGetRecord()
//     begin
//         CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."RR_No.");
//         CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."RR_No.");
//     end;


//     trigger OnModifyRecord(): Boolean
//     begin
//         CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."RR_No.");
//         CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."RR_No.");
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."RR_No.");
//         CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."RR_No.");
//     end;
// }
