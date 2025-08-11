// page 50975 "Revenue Item Breakdown Card"
// {
//     PageType = Card;
//     SourceTable = "Revenue Item Breakdown";
//     ApplicationArea = All;
//     Caption = 'Revenue Recognition-Other Charges';

//     layout
//     {
//         area(content)
//         {
//             group("General")
//             {
//                 field("RI_No."; Rec."RI_No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Item Type"; Rec."Item Type")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             group("Revenue Item Breakdown")
//             {
//                 Caption = 'Revenue Item Breakdown Details';
//                 part("Revenue Item Breakdown Details"; "Revenue Item Breakdown Sub")
//                 {
//                     SubPageLink = "RI_No." = field("RI_No.");
//                 }

//             }
//         }
//     }


//     actions
//     {
//         area(processing)
//         {
//             action(FetchBreakdownDetails)
//             {
//                 Caption = 'Fetch Breakdown Details';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     RevenueStruct: Record "Revenue Structure";
//                     rentcalculation: Record "Rent Calculation";
//                     TenancyCont: Record "Tenancy Contract";
//                     BreakdownRec: Record "Revenue Item Breakdown Details";
//                     SuspensionRec: Record SuspendReasonTable;
//                     CurrentItemType: Text[100];
//                     LastEntryNo: Integer;
//                     TotalDays: Integer;
//                     CurrentDate: Date;
//                     DailyRate: Decimal;
//                     ContractStartMonth: Integer;
//                     ContractStartYear: Integer;
//                     LastDayOfContractStartMonth: Date;
//                     DaysInContractStartMonth: Integer;
//                     RemainingDaysInStartMonth: Integer;
//                 begin
//                     // Validate and assign current date
//                     CurrentDate := Today;

//                     // Get current item type from page
//                     CurrentItemType := Rec."Item Type";

//                     // Clear existing breakdowns if needed
//                     BreakdownRec.Reset();
//                     BreakdownRec.SetRange("RI_No.", Rec."RI_No.");
//                     BreakdownRec.DeleteAll();

//                     // Find the highest Entry No. to ensure uniqueness
//                     LastEntryNo := GetNextLineNo();
//                     // if BreakdownRec.FindLast() then
//                     //     LastEntryNo := BreakdownRec."Entry No."
//                     // else
//                     //     LastEntryNo := 0;

//                     // Filter Revenue Structure by item type
//                     RevenueStruct.SetRange("Secondary Item Type", CurrentItemType);
//                     if RevenueStruct.FindSet() then begin
//                         repeat
//                             // Get contract based on structure
//                             TenancyCont.Reset();
//                             TenancyCont.SetRange("Contract ID", RevenueStruct."Contract ID");

//                             if TenancyCont.FindFirst() then begin
//                                 // Initialize breakdown entry
//                                 BreakdownRec.Init();
//                                 LastEntryNo += 1;
//                                 BreakdownRec."Entry No." := LastEntryNo;
//                                 BreakdownRec."RI_No." := Rec."RI_No.";
//                                 BreakdownRec."Contract ID" := TenancyCont."Contract ID";
//                                 BreakdownRec."Item Type" := CurrentItemType;
//                                 BreakdownRec."Property Name" := TenancyCont."Property Name";
//                                 BreakdownRec."Customer Name" := TenancyCont."Customer Name";
//                                 BreakdownRec."Owner Name" := TenancyCont."Owner's Name";
//                                 BreakdownRec."Contract Tenure" := TenancyCont."Contract tenor";
//                                 BreakdownRec."Contract Start Date" := TenancyCont."Contract Start Date";
//                                 BreakdownRec."Contract End Date" := TenancyCont."Contract End Date";
//                                 BreakdownRec."Grace Days" := TenancyCont."Grace Period";
//                                 BreakdownRec."Contract Amount" := RevenueStruct."Amount Including VAT";
//                                 BreakdownRec."Annual Amount" := RevenueStruct."Amount";

//                                 // Get month and year from contract start date
//                                 ContractStartMonth := Date2DMY(TenancyCont."Contract Start Date", 2); // Month
//                                 ContractStartYear := Date2DMY(TenancyCont."Contract Start Date", 3);  // Year

//                                 // Calculate the last day of the month in which the contract starts
//                                 LastDayOfContractStartMonth := CalcDate('<CM>', DMY2Date(1, ContractStartMonth, ContractStartYear));

//                                 // Calculate total days in contract start month
//                                 DaysInContractStartMonth := Date2DMY(LastDayOfContractStartMonth, 1);

//                                 // Calculate remaining days in start month (including the start date)
//                                 RemainingDaysInStartMonth := LastDayOfContractStartMonth - TenancyCont."Contract Start Date" + 1;

//                                 // Set the calculated days to No Of Days
//                                 BreakdownRec."No Of Days" := RemainingDaysInStartMonth;

//                                 // Calculate total contract days
//                                 TotalDays := TenancyCont."Contract End Date" - TenancyCont."Contract Start Date" + 1;
//                                 if TotalDays <= 0 then
//                                     Error('Invalid contract dates. End date must be after start date.');

//                                 // Calculate per day amount and value
//                                 DailyRate := BreakdownRec."Contract Amount" / TotalDays;
//                                 BreakdownRec."Per Day Amount" := Round(DailyRate);
//                                 BreakdownRec."Total Value" := BreakdownRec."Per Day Amount" * RemainingDaysInStartMonth;
//                                 BreakdownRec."Owner Share" := BreakdownRec."Total Value";

//                                 // Insert record
//                                 BreakdownRec.Insert();
//                             end;
//                         until RevenueStruct.Next() = 0;

//                         Message('Breakdown data fetched successfully.');
//                         // end else begin
//                         //     // Existing logic for non-rent item types (from Rent Calculation)
//                         //     rentcalculation.SetRange("Secondary Item Type", CurrentItemType);
//                         //     if rentcalculation.FindSet() then begin
//                         //         repeat
//                         //             TenancyCont.Reset();
//                         //             TenancyCont.SetRange("Contract ID", rentcalculation."Contract ID");

//                         //             if TenancyCont.FindFirst() then begin
//                         //                 BreakdownRec.Init();
//                         //                 LastEntryNo += 1;
//                         //                 BreakdownRec."Entry No." := LastEntryNo;
//                         //                 BreakdownRec."RI_No." := Rec."RI_No.";
//                         //                 BreakdownRec."Contract ID" := TenancyCont."Contract ID";
//                         //                 BreakdownRec."Item Type" := CurrentItemType;
//                         //                 BreakdownRec."Property Name" := TenancyCont."Property Name";
//                         //                 BreakdownRec."Customer Name" := TenancyCont."Customer Name";
//                         //                 BreakdownRec."Owner Name" := TenancyCont."Owner's Name";
//                         //                 BreakdownRec."Contract Tenure" := TenancyCont."Contract tenor";
//                         //                 BreakdownRec."Contract Start Date" := TenancyCont."Contract Start Date";
//                         //                 BreakdownRec."Contract End Date" := TenancyCont."Contract End Date";
//                         //                 BreakdownRec."Grace Days" := TenancyCont."Grace Period";
//                         //                 BreakdownRec."Contract Amount" := TenancyCont."Contract Amount Including VAT";
//                         //                 BreakdownRec."Annual Amount" := TenancyCont."Rent Amount";

//                         //                 // Get month and year from contract start date
//                         //                 ContractStartMonth := Date2DMY(TenancyCont."Contract Start Date", 2); // Month
//                         //                 ContractStartYear := Date2DMY(TenancyCont."Contract Start Date", 3);  // Year

//                         //                 // Calculate the last day of the month in which the contract starts
//                         //                 LastDayOfContractStartMonth := CalcDate('<CM>', DMY2Date(1, ContractStartMonth, ContractStartYear));

//                         //                 // Calculate remaining days in start month (including the start date)
//                         //                 RemainingDaysInStartMonth := LastDayOfContractStartMonth - TenancyCont."Contract Start Date" + 1;

//                         //                 // Set the calculated days to No Of Days
//                         //                 BreakdownRec."No Of Days" := RemainingDaysInStartMonth;

//                         //                 TotalDays := TenancyCont."Contract End Date" - TenancyCont."Contract Start Date" + 1;
//                         //                 if TotalDays <= 0 then
//                         //                     Error('Invalid contract dates. End date must be after start date.');

//                         //                 DailyRate := BreakdownRec."Contract Amount" / TotalDays;
//                         //                 BreakdownRec."Per Day Amount" := Round(DailyRate);
//                         //                 BreakdownRec."Total Value" := BreakdownRec."Per Day Amount" * RemainingDaysInStartMonth;
//                         //                 BreakdownRec."Owner Share" := BreakdownRec."Total Value";

//                         //                 BreakdownRec.Insert();
//                         //             end;
//                         //         until rentcalculation.Next() = 0;

//                         //         Message('Breakdown data fetched successfully.');
//                         //     end else
//                         //         Message('No data found for selected item type: %1', Format(CurrentItemType));
//                     end;
//                 end;

//             }
//         }
//     }

//     procedure GetNextLineNo(): Integer
//     var
//         BreakdownRec: Record "Revenue Item Breakdown Details";
//         LastLineNo: Integer;
//     begin
//         BreakdownRec.Reset();
//         BreakdownRec.SetRange("RI_No.", Rec."RI_No.");
//         if BreakdownRec.FindLast() then
//             LastLineNo := BreakdownRec."Entry No."
//         else
//             LastLineNo := 0;
//         exit(LastLineNo + 1);
//     end;

//     // trigger OnAction()
//     // var
//     //     RevenueStruct: Record "Revenue Structure";
//     //     rentcalculation: Record "Rent Calculation";
//     //     TenancyCont: Record "Tenancy Contract";
//     //     BreakdownRec: Record "Revenue Item Breakdown Details";
//     //     SuspensionRec: Record SuspendReasonTable;
//     //     CurrentItemType: Text[100];
//     //     LastEntryNo: Integer;
//     //     TotalDays: Integer;
//     //     CurrentDate: Date;
//     //     MonthDays: Integer;
//     //     DailyRate: Decimal;
//     //     FirstDayNextMonth: Date;
//     //     LastDayOfMonth: Date;
//     //     ActualDaysInMonth: Integer;
//     // begin
//     //     // Validate and assign current date
//     //     CurrentDate := Today;

//     //     // Get current item type from page
//     //     CurrentItemType := Rec."Item Type";
//     //     BreakdownRec.DeleteAll();
//     //     // Clear existing breakdowns if needed
//     //     BreakdownRec.SetRange("RI_No.", Rec."RI_No.");


//     //     // Get last entry number for incrementing
//     //     // if BreakdownRec.FindLast() then
//     //     //     LastEntryNo := BreakdownRec."Entry No."
//     //     // else
//     //     //     LastEntryNo := 0;

//     //     // Filter Revenue Structure by item type

//     //     if CurrentItemType <> 'Rent' then begin
//     //         RevenueStruct.SetRange("Secondary Item Type", CurrentItemType);
//     //         if RevenueStruct.FindSet() then begin
//     //             repeat
//     //                 // Get contract based on structure
//     //                 TenancyCont.Reset();
//     //                 TenancyCont.SetRange("Contract ID", RevenueStruct."Contract ID");

//     //                 if TenancyCont.FindFirst() then begin
//     //                     // Initialize breakdown entry
//     //                     BreakdownRec.Init();
//     //                     LastEntryNo += 1;
//     //                     BreakdownRec."Entry No." := LastEntryNo;
//     //                     BreakdownRec."RI_No." := Rec."RI_No.";
//     //                     BreakdownRec."Contract ID" := TenancyCont."Contract ID";
//     //                     BreakdownRec."Item Type" := CurrentItemType;
//     //                     BreakdownRec."Property Name" := TenancyCont."Property Name";
//     //                     BreakdownRec."Customer Name" := TenancyCont."Customer Name";
//     //                     BreakdownRec."Owner Name" := TenancyCont."Owner's Name";
//     //                     BreakdownRec."Contract Tenure" := TenancyCont."Contract tenor";
//     //                     BreakdownRec."Contract Start Date" := TenancyCont."Contract Start Date";
//     //                     BreakdownRec."Contract End Date" := TenancyCont."Contract End Date";
//     //                     BreakdownRec."Grace Days" := TenancyCont."Grace Period";
//     //                     BreakdownRec."Contract Amount" := TenancyCont."Contract Amount Including VAT";
//     //                     BreakdownRec."Annual Amount" := TenancyCont."Rent Amount";

//     //                     // Get days in current month
//     //                     ActualDaysInMonth := GetDaysInMonth(CurrentDate);
//     //                     BreakdownRec."No Of Days" := ActualDaysInMonth;

//     //                     // Calculate total contract days
//     //                     TotalDays := TenancyCont."Contract End Date" - TenancyCont."Contract Start Date" + 1;
//     //                     if TotalDays <= 0 then
//     //                         Error('Invalid contract dates. End date must be after start date.');

//     //                     // Calculate per day amount and value
//     //                     DailyRate := BreakdownRec."Contract Amount" / TotalDays;
//     //                     BreakdownRec."Per Day Amount" := Round(DailyRate);
//     //                     BreakdownRec."Total Value" := BreakdownRec."Per Day Amount" * ActualDaysInMonth;
//     //                     BreakdownRec."Owner Share" := BreakdownRec."Total Value";

//     //                     // Insert record
//     //                     BreakdownRec.Insert();
//     //                 end;
//     //             until RevenueStruct.Next() = 0;

//     //             Message('Breakdown data fetched successfully.');
//     //         end else
//     //             Message('No data found for selected item type: %1', Format(CurrentItemType));
//     //         //end;
//     //     end else begin
//     //         // ▶ Existing logic for non-rent item types (from Revenue Structure)
//     //         rentcalculation.SetRange("Secondary Item Type", CurrentItemType);
//     //         if rentcalculation.FindSet() then begin
//     //             repeat
//     //                 TenancyCont.Reset();
//     //                 TenancyCont.SetRange("Contract ID", rentcalculation."Contract ID");

//     //                 if TenancyCont.FindFirst() then begin
//     //                     BreakdownRec.Init();
//     //                     LastEntryNo += 1;
//     //                     BreakdownRec."Entry No." := LastEntryNo;
//     //                     BreakdownRec."RI_No." := Rec."RI_No.";
//     //                     BreakdownRec."Contract ID" := TenancyCont."Contract ID";
//     //                     BreakdownRec."Item Type" := CurrentItemType;
//     //                     BreakdownRec."Property Name" := TenancyCont."Property Name";
//     //                     BreakdownRec."Customer Name" := TenancyCont."Customer Name";
//     //                     BreakdownRec."Owner Name" := TenancyCont."Owner's Name";
//     //                     BreakdownRec."Contract Tenure" := TenancyCont."Contract tenor";
//     //                     BreakdownRec."Contract Start Date" := TenancyCont."Contract Start Date";
//     //                     BreakdownRec."Contract End Date" := TenancyCont."Contract End Date";
//     //                     BreakdownRec."Grace Days" := TenancyCont."Grace Period";
//     //                     BreakdownRec."Contract Amount" := TenancyCont."Contract Amount Including VAT";
//     //                     BreakdownRec."Annual Amount" := TenancyCont."Rent Amount";

//     //                     ActualDaysInMonth := GetDaysInMonth(CurrentDate);
//     //                     BreakdownRec."No Of Days" := ActualDaysInMonth;

//     //                     TotalDays := TenancyCont."Contract End Date" - TenancyCont."Contract Start Date" + 1;
//     //                     if TotalDays <= 0 then
//     //                         Error('Invalid contract dates. End date must be after start date.');

//     //                     DailyRate := BreakdownRec."Contract Amount" / TotalDays;
//     //                     BreakdownRec."Per Day Amount" := Round(DailyRate);
//     //                     BreakdownRec."Total Value" := BreakdownRec."Per Day Amount" * ActualDaysInMonth;
//     //                     BreakdownRec."Owner Share" := BreakdownRec."Total Value";

//     //                     BreakdownRec.Insert();
//     //                 end;
//     //             until rentcalculation.Next() = 0;

//     //             Message('Breakdown data fetched successfully.');
//     //         end else
//     //             Message('No data found for selected item type: %1', Format(CurrentItemType));
//     //     end;
//     // end;

//     // Check if year is leap year
//     local procedure IsLeapYear(Year: Integer): Boolean
//     begin
//         exit((Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)));
//     end;




//     procedure CalculateAndStoreTotalRevenue()
//     var
//         revenueBreakdown: Record "Revenue Item Breakdown Details";
//         totalAmount: Decimal;
//         headerRecord: Record "Revenue Item Breakdown"; // Assuming you have a header table to store total
//     begin
//         totalAmount := 0;

//         // Calculate total from Revenue Breakdown Lines
//         revenueBreakdown.SetRange("RI_No.", Rec."RI_No.");
//         if revenueBreakdown.FindSet() then
//             repeat
//                 totalAmount += revenueBreakdown."Total Value";
//             until revenueBreakdown.Next() = 0;

//         revenueBreakdown."Total Amount" := totalAmount;
//         revenueBreakdown.Modify();
//     end;




//     // Get number of days in a month from a given date
//     // local procedure GetDaysInMonth(CurrentDate: Date): Integer
//     // var
//     //     Year: Integer;
//     //     Month: Integer;
//     // begin
//     //     Year := DATE2DMY(CurrentDate, 3);
//     //     Month := DATE2DMY(CurrentDate, 2);

//     //     case Month of
//     //         1, 3, 5, 7, 8, 10, 12:
//     //             exit(31);
//     //         4, 6, 9, 11:
//     //             exit(30);
//     //         2:
//     //             if IsLeapYear(Year) then
//     //                 exit(29)
//     //             else
//     //                 exit(28);
//     //     end;
//     // end;

//     // Calculate contract days in the current month
//     // Calculate contract days in the current month
//     // local procedure CalculateContractDaysInMonth(ContractStartDate: Date; ContractEndDate: Date; FirstDayOfMonth: Date; LastDayOfMonth: Date): Integer
//     // var
//     //     StartDate: Date;
//     //     EndDate: Date;
//     // begin
//     //     // Determine the effective start date for calculation
//     //     if ContractStartDate <= FirstDayOfMonth then
//     //         StartDate := FirstDayOfMonth
//     //     else
//     //         StartDate := ContractStartDate;

//     //     // Determine the effective end date for calculation
//     //     if ContractEndDate >= LastDayOfMonth then
//     //         EndDate := LastDayOfMonth
//     //     else
//     //         EndDate := ContractEndDate;

//     //     // If contract is not active in current month
//     //     if (ContractEndDate < FirstDayOfMonth) or (ContractStartDate > LastDayOfMonth) then
//     //         exit(0);

//     //     // Calculate days in current month that contract is active
//     //     exit(EndDate - StartDate + 1);
//     // end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         ClearSubgridData();
//     end;

//     procedure ClearSubgridData()
//     var
//         revenueitem: Record "Revenue Item Breakdown Details";
//     begin
//         revenueitem.Reset();
//         revenueitem.SetRange("RI_No.", Rec."RI_No.");
//         revenueitem.DeleteAll();
//     end;


//     trigger OnAfterGetRecord()
//     begin
//         CurrPage."Revenue Item Breakdown Details".Page.SetRIID(Rec."RI_No.");
//         CalculateAndStoreTotalRevenue();
//     end;


//     trigger OnModifyRecord(): Boolean
//     begin
//         CurrPage."Revenue Item Breakdown Details".Page.SetRIID(Rec."RI_No.");
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         CurrPage."Revenue Item Breakdown Details".Page.SetRIID(Rec."RI_No.");
//     end;

// }
