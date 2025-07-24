page 50139 "Unearned Revenue Report Card"
{
    PageType = Card;
    SourceTable = "Unearned Revenue Report";
    ApplicationArea = All;
    Caption = 'Unearned Revenue Report';

    layout
    {
        area(Content)
        {
            group("Unearned Revenue Report")
            {
                Caption = 'Unearned Revenue Report';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     if xRec."No." <> Rec."No." then
                    //         ClearSubgridData();
                    // end;
                }
                field("Starting Date Year"; Rec."Starting Date Year")
                {
                    ApplicationArea = All;
                }
                field("Ending Date Year"; Rec."Ending Date Year")
                {
                    ApplicationArea = All;
                }
            }
            group("Unearned Rent Revenue Report Report Details")
            {
                Caption = 'Unearned Rent Revenue Report Details';
                part("Unearned Rent Revenue Report Details"; "Sub Unearned Revenue Card")
                {
                    SubPageLink = "Header No." = field("No.");
                }
            }

            group("Other Charges Details")
            {
                Caption = 'Other Charges Details';
                part("Other Charges Unearned Revenue"; "OtherCharges-UnearnedRevenue")
                {
                    SubPageLink = "No." = field("No.");
                }
            }
            group("Unearned Parking Revenue Report Report Details")
            {
                Caption = 'Unearned Parking Revenue Report Details';
                part("Unearned Parking Revenue Report Details"; "Sub Unearned Prking Card")
                {
                    SubPageLink = "Header No." = field("No.");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Filter Contracts")
            {
                ApplicationArea = All;
                Caption = 'Unearned Revenue Report';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UnearnedRevenueRent();
                    UnearnedRevenueOtherCharges();
                    Message('All data for Unearned Rent Revenue and Other Charges Revenue has been fetched.');
                end;
            }
        }
    }

    procedure UnearnedRevenueRent()
    var
        tenancyContract: Record "Tenancy Contract";
        NewLineNo: Integer;
        unearnedRevenueBuffer: Record "Sub Unearned Revenue Report"; // your buffer table
        StartDate, EndDate : Date;
        SuspendedReasonRec: Record SuspendReasonTable; // Replace with actual table name
        FinalCalculationRec: Record "Final Calculation"; // Replace with actual table name
        SuspendedDate: Date;
        TerminationDate: Date;
        paymentSchedule: Record "Payment Schedule2"; // Assumed name
        TotalPaidAmount: Decimal;
        TotalInvoicedAmount: Decimal;
        TotalNoofDays: Integer;
        UnearnedNoofday: Integer;
        PerDayrent: Decimal;
        MonthlyRevenueAmount: Decimal;
        TotalMonthlyRevenue: Decimal;
        CurrentDate: Date;
        MonthsInRange: Integer;
        ActualStartDate: Date;
        ActualEndDate: Date;
        RevenueAllocatedDuringYear: Decimal;
        RevenueAllocation: Decimal;
    begin
        ClearSubgridData(); // Always clear before inserting

        StartDate := Rec."Starting Date Year";
        EndDate := Rec."Ending Date Year";

        tenancyContract.Reset();
        tenancyContract.SetFilter("Tenant Contract Status", '%1|%2|%3|%4',
            tenancyContract."Tenant Contract Status"::Active,
            tenancyContract."Tenant Contract Status"::Terminated,
            tenancyContract."Tenant Contract Status"::Suspended,
            tenancyContract."Tenant Contract Status"::"Active-Contract Renewed",
            tenancyContract."Tenant Contract Status"::"Contract Renewed");

        // ✅ Filter contracts that fall within OR span the date range
        tenancyContract.SetFilter("Contract Start Date", '..%1', EndDate); // starts on or before end date
        tenancyContract.SetFilter("Contract End Date", '%1..', StartDate); // ends on or after start date

        if tenancyContract.FindSet() then begin
            repeat
                Clear(unearnedRevenueBuffer);
                Clear(SuspendedReasonRec);
                Clear(FinalCalculationRec);
                TotalPaidAmount := 0;
                TotalInvoicedAmount := 0;
                TotalMonthlyRevenue := 0;
                RevenueAllocatedDuringYear := 0;


                // 🔹1. Calculate Total Paid before Start Date
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetRange("Secondary Item Type", 'Rent');
                paymentSchedule.SetRange("Due Date", tenancyContract."Contract Start Date", StartDate - 1);
                paymentSchedule.SetRange("Invoiced", true);

                if paymentSchedule.FindSet() then
                    repeat
                        TotalPaidAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                // 🔹2. Calculate Invoiced Amount between StartDate and EndDate
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetRange("Secondary Item Type", 'Rent');
                paymentSchedule.SetRange("Due Date", StartDate, EndDate);
                paymentSchedule.SetRange("Invoiced", true);

                if paymentSchedule.FindSet() then
                    repeat
                        TotalInvoicedAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                NewLineNo := GetNextLineNo();

                // ✅ Fetch suspended reason from separate table
                SuspendedDate := 0D;
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Suspended then begin
                    SuspendedReasonRec.Reset();
                    SuspendedReasonRec.SetRange("Contract ID", tenancyContract."Contract ID"); // Assuming this link exists
                    if SuspendedReasonRec.FindLast() then begin // Get latest suspended reason
                        SuspendedDate := SuspendedReasonRec.DateEffective; // Replace with actual field name
                    end;
                end;

                // ✅ Fetch termination date from final calculation table
                TerminationDate := 0D;
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Terminated then begin
                    FinalCalculationRec.Reset();
                    FinalCalculationRec.SetRange("Contract ID", tenancyContract."Contract ID"); // Assuming this link exists
                    if FinalCalculationRec.FindLast() then begin // Get latest calculation
                        TerminationDate := FinalCalculationRec."Termination Date"; // Replace with actual field name
                    end;
                end;

                unearnedRevenueBuffer.Init();
                unearnedRevenueBuffer."Header No." := Rec."No."; // ✅ Set Header No. correctly
                unearnedRevenueBuffer."Line No." := NewLineNo;
                unearnedRevenueBuffer."Contract ID" := tenancyContract."Contract ID";
                unearnedRevenueBuffer."Start Date" := tenancyContract."Contract Start Date";
                unearnedRevenueBuffer."End Date" := tenancyContract."Contract End Date";
                unearnedRevenueBuffer."Customer Name" := tenancyContract."Customer Name";
                unearnedRevenueBuffer.Property := tenancyContract."Property Name";
                unearnedRevenueBuffer."Owner Name" := tenancyContract."Owner's Name";
                unearnedRevenueBuffer."Contract Value" := tenancyContract."Annual Rent Amount";
                unearnedRevenueBuffer."Contract Status" := Format(tenancyContract."Tenant Contract Status");
                unearnedRevenueBuffer."Opening Balance" := TotalPaidAmount;
                unearnedRevenueBuffer."Invoice Raised During the Year" := TotalInvoicedAmount;
                unearnedRevenueBuffer."Suspension Date" := SuspendedDate;
                unearnedRevenueBuffer."Termination Date" := TerminationDate;

                TotalNoofDays := unearnedRevenueBuffer."End Date" - unearnedRevenueBuffer."Start Date" + 1;
                PerDayrent := unearnedRevenueBuffer."Contract Value" / TotalNoofDays;
                UnearnedNoofday := unearnedRevenueBuffer."End Date" - EndDate;

                unearnedRevenueBuffer.CalculatedUnearnedRevBalance := PerDayrent * UnearnedNoofday;

                if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Single Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Unit Name"
                else if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Merge Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Single Unit Name"
                else
                    unearnedRevenueBuffer."Unit Name" := '';
                // Add more fields as required
                RevenueAllocation := CalculateRevenueAllocation(tenancyContract."Contract ID", tenancyContract."Contract Start Date", tenancyContract."Contract End Date");

                unearnedRevenueBuffer."RevenueAllocated DuringtheYear" := RevenueAllocation;
                unearnedRevenueBuffer."Unearned Revenue Balance" := TotalPaidAmount + TotalInvoicedAmount - RevenueAllocation;
                // Message('Revenue allocation value : ' + Format(RevenueAllocation));
                unearnedRevenueBuffer."Shortfall/Excess" := unearnedRevenueBuffer."Unearned Revenue Balance" - unearnedRevenueBuffer.CalculatedUnearnedRevBalance;
                unearnedRevenueBuffer.Insert();
            until tenancyContract.Next() = 0;
        end;
    end;

    local procedure CalculateRevenueAllocation(ContractID: Integer; StartDate: Date; EndDate: Date): Decimal
    var
        RevenueAllocationRec: Record "Revenue Allocation SubGrid"; // Replace with your actual table name
        TotalRevenueAllocated: Decimal;
        CurrentMonth: Integer;
        CurrentYear: Integer;
        StartMonth: Integer;
        StartYear: Integer;
        EndMonth: Integer;
        EndYear: Integer;
        LoopDate: Date;
    begin
        TotalRevenueAllocated := 0;

        // Get start and end month/year
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);


        // Method 1: If Revenue Allocation table has Contract ID field
        RevenueAllocationRec.Reset();
        RevenueAllocationRec.SetRange("Contract ID", ContractID); // Assuming this field exists
        RevenueAllocationRec.SetRange("Posting Year", StartYear); // Assuming financial year matches

        // Filter for months within the date range
        RevenueAllocationRec.SetFilter("Posting Month", GetMonthFilter(Rec."Starting Date Year", Rec."Ending Date Year"));

        if RevenueAllocationRec.FindSet() then
            repeat
                // Sum up the revenue allocation for each month
                // You'll need to replace this with the actual field name that contains the allocated amount
                TotalRevenueAllocated += RevenueAllocationRec."Total Value"; // Replace with actual field name
            until RevenueAllocationRec.Next() = 0;

        exit(TotalRevenueAllocated);
    end;

    // ✅ Helper procedure to create month filter
    local procedure GetMonthFilter(StartDate: Date; EndDate: Date): Text
    var
        StartMonth: Integer;
        EndMonth: Integer;
        StartYear: Integer;
        EndYear: Integer;
        MonthFilter: Text;
        CurrentDate: Date;
        MonthName: Text;
        FetchMonth: Codeunit "Fetch Month";
    begin
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        MonthFilter := '';
        CurrentDate := StartDate;

        while CurrentDate <= EndDate do begin
            MonthName := FetchMonth.GetMonthName(Date2DMY(CurrentDate, 2));

            if MonthFilter = '' then
                MonthFilter := MonthName
            else
                MonthFilter += '|' + MonthName;

            // Move to next month
            CurrentDate := CalcDate('<1M>', DMY2Date(1, Date2DMY(CurrentDate, 2), Date2DMY(CurrentDate, 3)));

            // Break if we've gone past the end date
            if Date2DMY(CurrentDate, 2) > EndMonth then
                break;
        end;

        exit(MonthFilter);
    end;

    procedure GetNextLineNo(): Integer
    var
        unearnedRevenueBuffer: Record "Sub Unearned Revenue Report";
        LastLineNo: Integer;
    begin
        unearnedRevenueBuffer.Reset();
        unearnedRevenueBuffer.SetRange("Header No.", Rec."No."); // ✅ filter by Header No.
        if unearnedRevenueBuffer.FindLast() then
            LastLineNo := unearnedRevenueBuffer."Line No."
        else
            LastLineNo := 0;

        exit(LastLineNo + 1);
    end;

    procedure ClearSubgridData()
    var
        RevenueItemDetail: Record "Sub Unearned Revenue Report";
    begin
        RevenueItemDetail.SetRange("Header No.", Rec."No."); // ✅ Clear only for this header
        RevenueItemDetail.DeleteAll(true);
    end;


    procedure UnearnedRevenueOtherCharges()
    var
        tenancyContract: Record "Tenancy Contract";
        NewLineNo: Integer;
        unearnedRevenueBuffer: Record "Sub Unearned Parking Report"; // your buffer table
        StartDate, EndDate : Date;
        SuspendedReasonRec: Record SuspendReasonTable;
        FinalCalculationRec: Record "Final Calculation";
        SuspendedDate, TerminationDate : Date;
        paymentSchedule: Record "Payment Schedule2";
        revenueStructure: Record "Revenue Structure";
        TotalPaidAmount, TotalInvoicedAmount, otherchargesvalue : Decimal;
        ItemTypes: List of [Text];
        ItemTypeFilter: Text;
        HasMatchingData: Boolean;
        TotalNoofDays: Integer;
        UnearnedNoofday: Integer;
        PerDayrent: Decimal;
        MonthlyRevenueAmount: Decimal;
        TotalMonthlyRevenue: Decimal;
        CurrentDate: Date;
        MonthsInRange: Integer;
        ActualStartDate: Date;
        ActualEndDate: Date;
        RevenueAllocatedDuringYear: Decimal;
        RevenueAllocation: Decimal;
    begin
        ClearSubgridDataParking();

        StartDate := Rec."Starting Date Year";
        EndDate := Rec."Ending Date Year";

        GetSelectedItemTypes(ItemTypes);
        ItemTypeFilter := GetItemTypeFilter(ItemTypes);

        tenancyContract.Reset();
        tenancyContract.SetFilter("Tenant Contract Status", '%1|%2|%3|%4|%5',
            tenancyContract."Tenant Contract Status"::Active,
            tenancyContract."Tenant Contract Status"::Terminated,
            tenancyContract."Tenant Contract Status"::Suspended,
            tenancyContract."Tenant Contract Status"::"Active-Contract Renewed",
            tenancyContract."Tenant Contract Status"::"Contract Renewed");

        tenancyContract.SetFilter("Contract Start Date", '..%1', EndDate);
        tenancyContract.SetFilter("Contract End Date", '%1..', StartDate);

        if tenancyContract.FindSet() then begin
            repeat
                Clear(unearnedRevenueBuffer);
                Clear(SuspendedReasonRec);
                Clear(FinalCalculationRec);
                TotalPaidAmount := 0;
                TotalInvoicedAmount := 0;
                TotalMonthlyRevenue := 0;
                RevenueAllocatedDuringYear := 0;
                otherchargesvalue := 0;
                HasMatchingData := false;

                // 🔹 Check PaymentSchedule for valid item + date match
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetFilter("Secondary Item Type", ItemTypeFilter);
                paymentSchedule.SetRange("Due Date", StartDate, EndDate);
                paymentSchedule.SetRange("Invoiced", true);
                if paymentSchedule.FindFirst() then
                    HasMatchingData := true;

                // 🔹 If not found in payment schedule, check Revenue Structure
                if not HasMatchingData then begin
                    revenueStructure.Reset();
                    revenueStructure.SetRange("Contract ID", tenancyContract."Contract ID");
                    revenueStructure.SetFilter("Secondary Item Type", ItemTypeFilter);
                    if revenueStructure.FindFirst() then
                        HasMatchingData := true;
                end;

                // 🔹 Skip contract if no match found
                if not HasMatchingData then
                    continue;

                // 🔹 Sum Revenue Structure
                revenueStructure.Reset();
                revenueStructure.SetRange("Contract ID", tenancyContract."Contract ID");
                revenueStructure.SetFilter("Secondary Item Type", ItemTypeFilter);
                if revenueStructure.FindSet() then
                    repeat
                        otherchargesvalue += revenueStructure."Amount Including VAT";
                    until revenueStructure.Next() = 0;

                // 🔹 Sum Paid Amount before Start Date
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetFilter("Secondary Item Type", ItemTypeFilter);
                paymentSchedule.SetRange("Due Date", tenancyContract."Contract Start Date", StartDate - 1);
                paymentSchedule.SetRange("Invoiced", true);
                if paymentSchedule.FindSet() then
                    repeat
                        TotalPaidAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                // 🔹 Sum Invoiced Amount between StartDate and EndDate
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetFilter("Secondary Item Type", ItemTypeFilter);
                paymentSchedule.SetRange("Due Date", StartDate, EndDate);
                paymentSchedule.SetRange("Invoiced", true);
                if paymentSchedule.FindSet() then
                    repeat
                        TotalInvoicedAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                // 🔹 Suspension and Termination Logic
                SuspendedDate := 0D;
                TerminationDate := 0D;
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Suspended then begin
                    SuspendedReasonRec.Reset();
                    SuspendedReasonRec.SetRange("Contract ID", tenancyContract."Contract ID");
                    if SuspendedReasonRec.FindLast() then
                        SuspendedDate := SuspendedReasonRec.DateEffective;
                end;

                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Terminated then begin
                    FinalCalculationRec.Reset();
                    FinalCalculationRec.SetRange("Contract ID", tenancyContract."Contract ID");
                    if FinalCalculationRec.FindLast() then
                        TerminationDate := FinalCalculationRec."Termination Date";
                end;

                // 🔹 Insert into Buffer
                NewLineNo := GetNextLineNum();
                unearnedRevenueBuffer.Init();
                unearnedRevenueBuffer."Header No." := Rec."No.";
                unearnedRevenueBuffer."Line No." := NewLineNo;
                unearnedRevenueBuffer."Contract ID" := tenancyContract."Contract ID";
                unearnedRevenueBuffer."Start Date" := tenancyContract."Contract Start Date";
                unearnedRevenueBuffer."End Date" := tenancyContract."Contract End Date";
                unearnedRevenueBuffer."Customer Name" := tenancyContract."Customer Name";
                unearnedRevenueBuffer.Property := tenancyContract."Property Name";
                unearnedRevenueBuffer."Owner Name" := tenancyContract."Owner's Name";
                unearnedRevenueBuffer."Other Charges Value" := otherchargesvalue;
                unearnedRevenueBuffer."Contract Status" := Format(tenancyContract."Tenant Contract Status");
                unearnedRevenueBuffer."Opening Balance" := TotalPaidAmount;
                unearnedRevenueBuffer."Invoice Raised During the Year" := TotalInvoicedAmount;
                unearnedRevenueBuffer."Suspension Date" := SuspendedDate;
                unearnedRevenueBuffer."Termination Date" := TerminationDate;

                if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Single Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Unit Name"
                else if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Merge Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Single Unit Name"
                else
                    unearnedRevenueBuffer."Unit Name" := '';

                RevenueAllocation := CalculateRevenueAllocations(tenancyContract."Contract ID", tenancyContract."Contract Start Date", tenancyContract."Contract End Date");

                unearnedRevenueBuffer."RevenueAllocated DuringtheYear" := RevenueAllocation;
                unearnedRevenueBuffer."Unearned Revenue Balance" := TotalPaidAmount + TotalInvoicedAmount - RevenueAllocation;
                // Message('Revenue allocation value : ' + Format(RevenueAllocation));

                TotalNoofDays := unearnedRevenueBuffer."End Date" - unearnedRevenueBuffer."Start Date" + 1;
                PerDayrent := unearnedRevenueBuffer."Other Charges Value" / TotalNoofDays;
                UnearnedNoofday := unearnedRevenueBuffer."End Date" - EndDate;

                unearnedRevenueBuffer.CalculatedUnearnedRevBalance := PerDayrent * UnearnedNoofday;
                unearnedRevenueBuffer."Shortfall/Excess" := unearnedRevenueBuffer."Unearned Revenue Balance" - unearnedRevenueBuffer.CalculatedUnearnedRevBalance;

                unearnedRevenueBuffer.Insert();
            until tenancyContract.Next() = 0;
        end;
    end;

    local procedure CalculateRevenueAllocations(ContractID: Integer; StartDate: Date; EndDate: Date): Decimal
    var
        RevenueAllocationRec: Record "Revenue Recognition Details"; // Replace with your actual table name
        TotalRevenueAllocated: Decimal;
        CurrentMonth: Integer;
        CurrentYear: Integer;
        StartMonth: Integer;
        StartYear: Integer;
        EndMonth: Integer;
        EndYear: Integer;
        LoopDate: Date;
        ItemTypes: List of [Text];
        ItemTypeFilter: Text;
    begin
        TotalRevenueAllocated := 0;

        // Get start and end month/year
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        GetSelectedItemTypes(ItemTypes);
        ItemTypeFilter := GetItemTypeFilter(ItemTypes);


        // Method 1: If Revenue Allocation table has Contract ID field
        RevenueAllocationRec.Reset();
        RevenueAllocationRec.SetRange("Contract ID", ContractID); // Assuming this field exists
        RevenueAllocationRec.SetRange("Posting Year", StartYear); // Assuming financial year matches

        // Filter for months within the date range
        RevenueAllocationRec.SetFilter("Posting Month", GetMonthFilters(Rec."Starting Date Year", Rec."Ending Date Year"));
        RevenueAllocationRec.SetFilter("Item Type", ItemTypeFilter);

        if RevenueAllocationRec.FindSet() then
            repeat
                // Sum up the revenue allocation for each month
                // You'll need to replace this with the actual field name that contains the allocated amount
                TotalRevenueAllocated += RevenueAllocationRec."Total Value"; // Replace with actual field name
            until RevenueAllocationRec.Next() = 0;

        exit(TotalRevenueAllocated);
    end;

    // ✅ Helper procedure to create month filter
    local procedure GetMonthFilters(StartDate: Date; EndDate: Date): Text
    var
        StartMonth: Integer;
        EndMonth: Integer;
        StartYear: Integer;
        EndYear: Integer;
        MonthFilter: Text;
        CurrentDate: Date;
        MonthName: Text;
        FetchMonth: Codeunit "Fetch Month";
    begin
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        MonthFilter := '';
        CurrentDate := StartDate;

        while CurrentDate <= EndDate do begin
            MonthName := FetchMonth.GetMonthName(Date2DMY(CurrentDate, 2));

            if MonthFilter = '' then
                MonthFilter := MonthName
            else
                MonthFilter += '|' + MonthName;

            // Move to next month
            CurrentDate := CalcDate('<1M>', DMY2Date(1, Date2DMY(CurrentDate, 2), Date2DMY(CurrentDate, 3)));

            // Break if we've gone past the end date
            if Date2DMY(CurrentDate, 2) > EndMonth then
                break;
        end;

        exit(MonthFilter);
    end;

    local procedure GetSelectedItemTypes(var pItemTypes: List of [Text])
    var
        UnearnedRevenueItem: Record "Other Charges UnearnedRevenue";
    begin
        // Set filter to get all selected Item Types
        UnearnedRevenueItem.SetRange("No.", Rec."No.");

        // Find all records for this Revenue Recognition
        if UnearnedRevenueItem.FindSet() then begin
            repeat
                // Only add non-empty Item Types
                if UnearnedRevenueItem."Item Type" <> '' then begin
                    // Check if Item Type is not already in the list
                    if not pItemTypes.Contains(UnearnedRevenueItem."Item Type") then
                        pItemTypes.Add(UnearnedRevenueItem."Item Type");
                end;
            until UnearnedRevenueItem.Next() = 0;
        end;
    end;

    local procedure GetItemTypeFilter(pItemTypes: List of [Text]): Text
    var
        FilterText: Text;
        ItemType: Text;
    begin
        // Build filter text
        foreach ItemType in pItemTypes do begin
            if FilterText = '' then
                FilterText := ItemType
            else
                FilterText += '|' + ItemType;
        end;

        exit(FilterText);
    end;


    procedure GetNextLineNum(): Integer
    var
        unearnedRevenueBuffer: Record "Sub Unearned Parking Report";
        LastLineNo: Integer;
    begin
        unearnedRevenueBuffer.Reset();
        unearnedRevenueBuffer.SetRange("Header No.", Rec."No."); // ✅ filter by Header No.
        if unearnedRevenueBuffer.FindLast() then
            LastLineNo := unearnedRevenueBuffer."Line No."
        else
            LastLineNo := 0;

        exit(LastLineNo + 1);
    end;

    procedure ClearSubgridDataParking()
    var
        RevenueItemDetail: Record "Sub Unearned Parking Report";
    begin
        RevenueItemDetail.SetRange("Header No.", Rec."No."); // ✅ Clear only for this header
        RevenueItemDetail.DeleteAll(true);
    end;



    trigger OnAfterGetRecord()
    begin
        CurrPage."Other Charges Unearned Revenue".Page.SetNo(Rec."No.");
    end;


    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Other Charges Unearned Revenue".Page.SetNo(Rec."No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Other Charges Unearned Revenue".Page.SetNo(Rec."No.");
    end;
}