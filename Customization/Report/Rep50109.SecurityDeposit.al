namespace PropertyManagement.PropertyManagement;

report 50109 "Security Deposit"
{
    ApplicationArea = All;
    Caption = 'Security Deposit';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Security Deposit.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            DataItemTableView = SORTING("Customer Name", "Contract ID");
            column(CustomDateRange; CustomDateRangeText)
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Property_Name; "Property Name")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Opening_Balance; OpeningBalance)
            {
            }
            column(Additions; Additions)
            {
            }
            column(CarriedForwardIn; CarriedForwardInAmount)
            {
            }
            column(CarriedForwardOut; CarriedForwardOutAmount)
            {
            }
            column(Adjustment; AdjustmentAmount)
            {
            }
            column(Refund; RefundAmount)
            {
            }
            column(Closing_Balance; ClosingBalance)
            {
            }
            // column(TotalAdditionalCharges; TotalAdditionalCharges)
            // {
            // }
            // column(NetBalance; NetBalance)
            // {
            // }

            trigger OnAfterGetRecord()
            var
                StartDateIsInRange: Boolean;
                EndDateIsInRange: Boolean;
                SecurityDepositAmount: Decimal;
                SecurityDepositTransferRec: Record "Security Deposit";
                SecurityDepositTransfer: Record "Security Deposit";
                AdditionalCharges: Record "Additional Charges Sub";
                FinalCalculation: Record "Final Calculation";
            begin
                // ------------------------------------custome start & end date ----------------------------------------------------------/

                // Set the custom date range text
                CustomDateRangeText :=
                     Format(CustomStartDate, 0, '<Day,2>/<Month,2>/') + Format(Date2DMY(CustomStartDate, 3)) + ' - ' +
                     Format(CustomEndDate, 0, '<Day,2>/<Month,2>/') + Format(Date2DMY(CustomEndDate, 3));

                // Check if Contract Start Date or Contract End Date is in the specified range
                StartDateIsInRange := ("Contract Start Date" >= CustomStartDate) and ("Contract Start Date" <= CustomEndDate);
                EndDateIsInRange := ("Contract End Date" >= CustomStartDate) and ("Contract End Date" <= CustomEndDate);

                if not (StartDateIsInRange or EndDateIsInRange) then
                    CurrReport.SKIP();

                // --------------------------------Opening balance and Additions --------------------------------------------------------/

                // Retrieve the Security Deposit Amount from the Tenancy Contract
                SecurityDepositAmount := "Security Deposit Amount";

                // If Contract Start Date is before or equal to Custom Start Date, assign to Opening Balance
                if "Contract Start Date" <= CustomStartDate then
                    OpeningBalance := SecurityDepositAmount
                else
                    OpeningBalance := 0;

                // If Contract Start Date is after Custom Start Date, assign to Additions
                if "Contract Start Date" > CustomStartDate then
                    Additions := SecurityDepositAmount
                else
                    Additions := 0;

                // Assign values to the report columns
                "OpeningBalance" := OpeningBalance;
                "Additions" := Additions;

                // -------------------------------------- carriedforwardin & carriedforwardout -------------------------------------------------------/
                CarriedForwardInAmount := 0;
                CarriedForwardOutAmount := 0;

                // Calculate Carried Forward Out - Security deposits transferred FROM this contract
                SecurityDepositTransfer.Reset();
                SecurityDepositTransfer.SetRange("Contract ID", "Contract ID");  // This is the source contract
                if SecurityDepositTransfer.FindSet() then
                    repeat
                        CarriedForwardOutAmount += SecurityDepositTransfer."Carry Forward Amount";
                    until SecurityDepositTransfer.Next() = 0;

                // Calculate Carried Forward In - Security deposits transferred TO this contract
                SecurityDepositTransfer.Reset();
                SecurityDepositTransfer.SetRange("New_Contract ID", "Contract ID");  // This is the destination contract
                if SecurityDepositTransfer.FindSet() then
                    repeat
                        CarriedForwardInAmount += SecurityDepositTransfer."Carry Forward Amount";
                    until SecurityDepositTransfer.Next() = 0;


                // --------------------------------- Get Total Amount from Additional Charges and Net Balance from Final Calculation -----------------------/

                TotalAdditionalCharges := 0;
                AdditionalCharges.Reset();
                AdditionalCharges.SetRange("Contract ID", "Contract ID");
                if AdditionalCharges.FindSet() then
                    repeat
                        TotalAdditionalCharges += AdditionalCharges."Amount Including VAT";
                    until AdditionalCharges.Next() = 0;

                // Get Net Balance from Final Calculation
                NetBalance := 0;
                FinalCalculation.Reset();
                FinalCalculation.SetRange("Contract ID", "Contract ID");
                if FinalCalculation.FindFirst() then
                    NetBalance := FinalCalculation."Net Balance";

                // --------------------------------- Calculate Adjustment and Refund based on the rules -----------------------/

                // Calculate Adjustment and Refund using the specified rules
                if TotalAdditionalCharges > NetBalance then begin
                    AdjustmentAmount := NetBalance;
                    RefundAmount := 0;
                end else if TotalAdditionalCharges < NetBalance then begin
                    AdjustmentAmount := TotalAdditionalCharges;
                    RefundAmount := NetBalance - TotalAdditionalCharges;
                end else if TotalAdditionalCharges = NetBalance then begin
                    AdjustmentAmount := NetBalance;
                    RefundAmount := 0;
                end else begin
                    // When TotalAdditionalCharges equals NetBalance
                    AdjustmentAmount := 0;
                    RefundAmount := 0;
                end;

                // ------------------------------------------ Closing Balance -----------------------------------------------------------/

                // Closing Balance condition
                // if CustomEndDate < "Contract End Date" then begin
                //     ClosingBalance := SecurityDepositAmount;
                //     RefundAmount := 0;
                //     AdjustmentAmount := 0;
                // end
                // else
                //     ClosingBalance := 0;

                // Assign value to the ClosingBalance column
                "ClosingBalance" := ClosingBalance;

                // Closing Balance condition
                if CustomEndDate < "Contract End Date" then begin
                    ClosingBalance := SecurityDepositAmount;
                    // RefundAmount := 0
                end
                else
                    ClosingBalance := 0;

                // // Assign value to the ClosingBalance column
                // "ClosingBalance" := ClosingBalance;

                // // Calculate Refund amount - the remaining amount after transfers out
                // RefundAmount := SecurityDepositAmount - CarriedForwardOutAmount;
                // if RefundAmount < 0 then
                //     RefundAmount := 0;

                // -------------------------------------- Refund & carriedforwardout -------------------------------------------------------/
                // SecurityDepositAmount := "Security Deposit Amount";
                // if SecurityDepositAmount = 0 then begin
                //     CarriedForwardOutAmount := 0;
                //     RefundAmount := 0;
                //     exit;
                // end;

                // if CustomEndDate >= "Contract End Date" then begin
                //     // CarriedForwardOutAmount := 0;
                //     // RefundAmount := 0;

                //     SecurityDepositTransferRec.Reset();
                //     SecurityDepositTransferRec.SetRange("Contract ID", "Contract ID");  // Add this filter

                //     if SecurityDepositTransferRec.FindFirst() then begin  // Changed to FindFirst since we only need one match
                //         CarriedForwardOutAmount := SecurityDepositAmount;
                //         RefundAmount := 0;
                //     end else begin
                //         CarriedForwardOutAmount := 0;
                //         RefundAmount := SecurityDepositAmount;
                //     end;
                // end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DateFilter)
                {
                    field(CustomStartDate; CustomStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Custom Start Date';
                    }
                    field(CustomEndDate; CustomEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Custom End Date';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        CustomStartDate: Date;
        CustomEndDate: Date;
        CustomDateRangeText: Text;
        OpeningBalance: Decimal;
        Additions: Decimal;
        AdjustmentAmount: Decimal;
        ClosingBalance: Decimal;
        RefundAmount: Decimal;
        CarriedForwardOutAmount: Decimal;
        CarriedForwardInAmount: Decimal;
        TotalAdditionalCharges: Decimal;
        NetBalance: Decimal;
}
