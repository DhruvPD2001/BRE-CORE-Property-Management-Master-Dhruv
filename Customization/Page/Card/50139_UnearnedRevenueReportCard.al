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
                Caption = 'Filter Contracts by Date Range';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UnearnedRevenueRent();
                    UnearnedRevenueParking();
                    Message('Unearned Rent Revenue and Parking Revenue Data Fetch');
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
        SuspendedReasonText: Text[100];
        SuspendedDate: Date;
        TerminationDate: Date;
        paymentSchedule: Record "Payment Schedule2"; // Assumed name
        TotalPaidAmount: Decimal;
        TotalInvoicedAmount: Decimal;
        TotalNoofDays: Integer;
        UnearnedNoofday: Integer;
        PerDayrent: Decimal;
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
                SuspendedReasonText := '';
                SuspendedDate := 0D;
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Suspended then begin
                    SuspendedReasonRec.Reset();
                    SuspendedReasonRec.SetRange("Contract ID", tenancyContract."Contract ID"); // Assuming this link exists
                    if SuspendedReasonRec.FindLast() then begin // Get latest suspended reason
                        SuspendedDate := SuspendedReasonRec.SuspensionEffectiveDate; // Replace with actual field name
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

                unearnedRevenueBuffer.Insert();
            until tenancyContract.Next() = 0;
        end;
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



    procedure UnearnedRevenueParking()
    var
        tenancyContract: Record "Tenancy Contract";
        NewLineNo: Integer;
        unearnedRevenueBuffer: Record "Sub Unearned Parking Report"; // your buffer table
        StartDate, EndDate : Date;
        SuspendedReasonRec: Record SuspendReasonTable; // Replace with actual table name
        FinalCalculationRec: Record "Final Calculation"; // Replace with actual table name
        SuspendedReasonText: Text[100];
        SuspendedDate: Date;
        TerminationDate: Date;
        paymentSchedule: Record "Payment Schedule2"; // Assumed name
        TotalPaidAmount: Decimal;
        TotalInvoicedAmount: Decimal;

    begin
        ClearSubgridDataParking(); // Always clear before inserting

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



                // 🔹1. Calculate Total Paid before Start Date
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetRange("Secondary Item Type", 'Parking Charges');
                paymentSchedule.SetRange("Due Date", tenancyContract."Contract Start Date", StartDate - 1);
                paymentSchedule.SetRange("Invoiced", true);

                if paymentSchedule.FindSet() then
                    repeat
                        TotalPaidAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                // 🔹2. Calculate Invoiced Amount between StartDate and EndDate
                paymentSchedule.Reset();
                paymentSchedule.SetRange("Contract ID", tenancyContract."Contract ID");
                paymentSchedule.SetRange("Secondary Item Type", 'Parking Charges');
                paymentSchedule.SetRange("Due Date", StartDate, EndDate);
                paymentSchedule.SetRange("Invoiced", true);

                if paymentSchedule.FindSet() then
                    repeat
                        TotalInvoicedAmount += paymentSchedule."Amount Including VAT";
                    until paymentSchedule.Next() = 0;

                NewLineNo := GetNextLineNum();

                // ✅ Fetch suspended reason from separate table
                SuspendedReasonText := '';
                SuspendedDate := 0D;
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Suspended then begin
                    SuspendedReasonRec.Reset();
                    SuspendedReasonRec.SetRange("Contract ID", tenancyContract."Contract ID"); // Assuming this link exists
                    if SuspendedReasonRec.FindLast() then begin // Get latest suspended reason
                        SuspendedDate := SuspendedReasonRec.SuspensionEffectiveDate; // Replace with actual field name
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
                unearnedRevenueBuffer."Other Charges Value" := tenancyContract."Annual Rent Amount";
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
                // Add more fields as required

                unearnedRevenueBuffer.Insert();
            until tenancyContract.Next() = 0;
        end;
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