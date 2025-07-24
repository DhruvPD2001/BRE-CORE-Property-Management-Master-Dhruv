report 50118 "Unearned Rent Revenue"
{
    ApplicationArea = All;
    Caption = 'Unearned Rent Revenue';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Unearned Rent Revenue.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem("Sub Unearned Revenue Report"; "Sub Unearned Revenue Report")
        {
            column(Contract_ID; "Contract ID")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(Property; Property)
            {
            }
            column(Owner_Name; "Owner Name")
            {
            }
            column(Start_Date; "Start Date")
            {
            }
            column(End_Date; "End Date")
            {
            }
            column(Termination_Date; "Termination Date")
            {
            }
            column(Suspension_Date; "Suspension Date")
            {
            }
            column(Contract_Value; "Contract Value")
            {
            }
            column(Contract_Status; "Contract Status")
            {
            }
            column(Opening_Balance; "Opening Balance")
            {
            }
            column(Invoice_Raised_During_the_Year; "Invoice Raised During the Year")
            {
            }
            column(RevenueAllocated_DuringtheYear; "RevenueAllocated DuringtheYear")
            {
            }
            column(Unearned_Revenue_Balance; "Unearned Revenue Balance")
            {
            }
            column(CalculatedUnearnedRevBalance; CalculatedUnearnedRevBalance)
            {
            }
            column(Shortfall_Excess; "Shortfall/Excess")
            {
            }
        }
    }
}