namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using System.Text;
using Microsoft.Sales.Customer;

report 50113 "Termination Template"
{
    ApplicationArea = All;
    Caption = 'Termination Template';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "TerminationTemplate.docx";
    dataset
    {
        dataitem(FinalCalculation; "Final Calculation")
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPostcode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCountry; CompanyInfo."Country/Region Code")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyTRN; CompanyInfo."VAT Registration No.")
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Intimation_Date; "Intimation Date")
            {
            }
            column(Termination_Date; "Termination Date")
            {
            }
            column(Original_Contract_Tenure; "Original Contract Tenure")
            {
            }
            column(Actual_Contract_Tenure; "Actual Contract Tenure")
            {
            }
            column(T_I_R; GetTotalReceiptsAmount("Contract ID"))
            {
            }
            column(TRA_IV; GetTotalReceiptsAmountIncludingVAT("Contract ID"))
            {
            }
            column(TIR_TRAIV; GetTotalReceiptsAmount("Contract ID") - GetTotalReceiptsAmountIncludingVAT("Contract ID"))
            {
            }
            column(Sec_De; "Security Deposit")
            {
            }
            column(Ad_Sec_De; "Adjustment Security Deposit")
            {
            }
            column(Net_Ba; "Net Balance")
            {
            }
            column(Oth_De; "Chiller Deposit" + "Other Deposit")
            {
            }
            column(T_Deposit; "Net Balance" + "Chiller Deposit" + "Other Deposit")
            {
            }
            column(T_RE_Deposit; -("Net Balance" + "Chiller Deposit" + "Other Deposit"))
            {
            }
            column(Total_Settlement;
            GetRentBalancePending("Contract ID") +
                GetTotalReceiptsAmount("Contract ID") - GetTotalReceiptsAmountIncludingVAT("Contract ID") +
                GetTotalAdditionalCharges("Contract ID") +
                -("Net Balance" + "Chiller Deposit" + "Other Deposit")
            )
            {
            }
            column(Final_Settlement;
            -(GetRentBalancePending("Contract ID") +
                GetTotalReceiptsAmount("Contract ID") - GetTotalReceiptsAmountIncludingVAT("Contract ID") +
                GetTotalAdditionalCharges("Contract ID") +
                -("Net Balance" + "Chiller Deposit" + "Other Deposit"))
            )
            {
            }
            column(Final_Settlement_Words;
            ConvertFinalSettlementToWords(
                    -(GetRentBalancePending("Contract ID") +
                      GetTotalReceiptsAmount("Contract ID") - GetTotalReceiptsAmountIncludingVAT("Contract ID") +
                      GetTotalAdditionalCharges("Contract ID") +
                      -("Net Balance" + "Chiller Deposit" + "Other Deposit"))
                )
            )
            {
            }
            column(Total_AdC; GetTotalAdditionalCharges("Contract ID"))
            {
            }
            column(Settlement_Status; GetSettlementStatus())
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant ID");
                column(Name; Name)
                {
                }
                column(Address; Address)
                {
                }
                column(Phone_No_; "Phone No.")
                {
                }
                column(E_Mail; "E-Mail")
                {
                }
                column(VAT_Registration_No_; "VAT Registration No.")
                {
                }
            }
            dataitem("Tenancy Contract"; "Tenancy Contract")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Property_Name; "Property Name")
                {
                }
                column(Unit_Name; "Unit Name")
                {
                }
                column(Contract_Tenor; "Contract Tenor")
                {
                }
            }
            dataitem("Rent Calculate Sub"; "Rent Calculate Sub")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Year; Year)
                {
                }
                column(Period_Start_Date; "Period Start Date")
                {
                }
                column(Period_End_Date; "Period End Date")
                {
                }
                column(Final_Annual_Amount; "Final Annual Amount")
                {
                }
                column(Per_Day_Rent; "Per Day Rent")
                {
                }
                column(Total_F_A_A; "Total Final Annual Amount")
                {
                }
            }
            dataitem("Pending Receviable Grid"; "Pending Receviable Grid")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                DataItemTableView = where(RevenueDescription = filter('Rent'));
                column(Rev_AIV; RevisedAmountInclVAT)
                {
                }
                column(Rec_AIV; ReceiptsAmountInclVAT)
                {
                }
                column(Rent_BP; RevisedAmountInclVAT - ReceiptsAmountInclVAT)
                {
                }
            }
            dataitem("Additional Charges Sub"; "Additional Charges Sub")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Secondary_Item_Type; "Secondary Item Type")
                {
                }
                column(Amount_IV; "Amount Including VAT")
                {
                }

            }

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
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
    rendering
    {
        layout("TerminationTemplate.docx")
        {
            Type = Word;
            LayoutFile = './TerminationTemplate.docx';
            Caption = 'TerminationTemplate (Word)';
            Summary = 'The TerminationTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }

    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then begin
            Error('Company Information not found.');
        end else begin
            // CompanyAddress := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
            CompanyInfo.CalcFields(Picture);
        end;
    end;

    // NEW PROCEDURE: Returns "Claim" or "Refund" based on Final Calculation fields
    procedure GetSettlementStatus(): Text
    begin
        // Check Total Receivable field
        if FinalCalculation."Net Receivable From The Tenant" > 0 then
            exit('Claim');

        // Check Total Refundable field
        if FinalCalculation."Amount Refundable" > 0 then
            exit('Refund');

        // If both are zero
        exit(' ');
    end;

    // ---------------------- For total receipt amount --------------------------//
    procedure GetTotalReceiptsAmount(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "Pending Receviable Grid";
        TotalAmount: Decimal;
    begin
        // Clear any previous filters
        PendingReceivableGrid.Reset();

        // Filter by Contract ID
        PendingReceivableGrid.SetRange("Contract ID", ContractID);
        PendingReceivableGrid.SetRange("Payment Type", 'Installment');

        // Ensure you're calculating the total amount correctly
        if PendingReceivableGrid.FindSet() then begin
            repeat
                // Log each record's details for debugging
                // Message('Contract ID: %1, Description: %2, Amount: %3',
                //     PendingReceivableGrid."Contract ID",
                //     PendingReceivableGrid.RevenueDescription,
                //     PendingReceivableGrid.ReceiptsAmount);

                // Add the receipts amount
                TotalAmount += PendingReceivableGrid.RevisedAmountInclVAT;
            until PendingReceivableGrid.Next() = 0;
        end;

        // Return the total amount
        exit(TotalAmount);
    end;



    // ----------------------- For total receipt amount including VAT ---------------------------- //
    procedure GetTotalReceiptsAmountIncludingVAT(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "Pending Receviable Grid";
        TotalAmount: Decimal;
    begin
        // Clear any previous filters
        PendingReceivableGrid.Reset();

        // Filter by Contract ID
        PendingReceivableGrid.SetRange("Contract ID", ContractID);
        PendingReceivableGrid.SetRange("Payment Type", 'Installment');

        // Ensure you're calculating the total amount correctly
        if PendingReceivableGrid.FindSet() then begin
            repeat
                // Log each record's details for debugging
                // Message('Contract ID: %1, Description: %2, Amount: %3',
                //     PendingReceivableGrid."Contract ID",
                //     PendingReceivableGrid.RevenueDescription,
                //     PendingReceivableGrid.ReceiptsAmountInclVAT);

                // Add the receipts amount
                TotalAmount += PendingReceivableGrid.ReceiptsAmountInclVAT;
            until PendingReceivableGrid.Next() = 0;
        end;

        // Return the total amount
        exit(TotalAmount);
    end;



    // -------------------------------- For Early Termination Fee ---------------------------------//
    // procedure GetEarlyTerminationFeeAmount(ContractID: Integer): Decimal
    // var
    //     AdditionalChargesGrid: Record "Additional Charges Sub";
    //     EarlyTerminationFeeAmount: Decimal;
    // begin
    //     // Clear any previous filters
    //     AdditionalChargesGrid.Reset();

    //     // Filter by Contract ID and Secondary Item Type
    //     AdditionalChargesGrid.SetRange("Contract ID", ContractID);
    //     AdditionalChargesGrid.SetRange("Secondary Item Type", 'Early Termination Fee');

    //     // Find the first matching record and get its amount including VAT
    //     if AdditionalChargesGrid.FindFirst() then begin
    //         EarlyTerminationFeeAmount := AdditionalChargesGrid."Amount Including VAT";
    //     end;

    //     // Return the Early Termination Fee amount
    //     exit(EarlyTerminationFeeAmount);
    // end;



    // -------------------------------- For Late Intimation Fee ---------------------------------//
    // procedure GetLateIntimationFeeAmount(ContractID: Integer): Decimal
    // var
    //     AdditionalChargesGrid: Record "Additional Charges Sub";
    //     LateIntimationFeeAmount: Decimal;
    // begin
    //     // Clear any previous filters
    //     AdditionalChargesGrid.Reset();

    //     // Filter by Contract ID and Secondary Item Type
    //     AdditionalChargesGrid.SetRange("Contract ID", ContractID);
    //     AdditionalChargesGrid.SetRange("Secondary Item Type", 'Late Intimation Fee');

    //     // Find the first matching record and get its amount including VAT
    //     if AdditionalChargesGrid.FindFirst() then begin
    //         LateIntimationFeeAmount := AdditionalChargesGrid."Amount Including VAT";
    //     end;

    //     // Return the Early Termination Fee amount
    //     exit(LateIntimationFeeAmount);
    // end;



    // -------------------------------- For Restoration Charges Fee ---------------------------------//
    // procedure GetRestorationChargesAmount(ContractID: Integer): Decimal
    // var
    //     AdditionalChargesGrid: Record "Additional Charges Sub";
    //     RestorationChargesAmount: Decimal;
    // begin
    //     // Clear any previous filters
    //     AdditionalChargesGrid.Reset();

    //     // Filter by Contract ID and Secondary Item Type
    //     AdditionalChargesGrid.SetRange("Contract ID", ContractID);
    //     AdditionalChargesGrid.SetRange("Secondary Item Type", 'Restoration Charges');

    //     // Find the first matching record and get its amount including VAT
    //     if AdditionalChargesGrid.FindFirst() then begin
    //         RestorationChargesAmount := AdditionalChargesGrid."Amount Including VAT";
    //     end;

    //     // Return the Early Termination Fee amount
    //     exit(RestorationChargesAmount);
    // end;

    // ---------------------------- Total Additional Charges --------------------------------//
    procedure GetTotalAdditionalCharges(ContractID: Integer): Decimal
    var
        AdditionalChargesGrid: Record "Additional Charges Sub";
        TotalAmount: Decimal;
    begin
        // Clear any previous filters
        AdditionalChargesGrid.Reset();

        // Filter by Contract ID
        AdditionalChargesGrid.SetRange("Contract ID", ContractID);

        // Calculate the total amount for all additional charges
        if AdditionalChargesGrid.FindSet() then begin
            repeat
                TotalAmount += AdditionalChargesGrid."Amount Including VAT";
            until AdditionalChargesGrid.Next() = 0;
        end;

        // Return the total amount
        exit(TotalAmount);
    end;


    // ------------------------------ Total Refund / Claim -------------------------- //
    procedure GetRentBalancePending(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "Pending Receviable Grid";
        TotalPending: Decimal;
    begin
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("Contract ID", ContractID);
        PendingReceivableGrid.SetRange(RevenueDescription, 'Rent');

        if PendingReceivableGrid.FindFirst() then begin
            TotalPending := PendingReceivableGrid.RevisedAmountInclVAT - PendingReceivableGrid.ReceiptsAmountInclVAT;
        end;

        exit(TotalPending);
    end;

    // procedure GetTotalAdditionalCharges(ContractID: Integer): Decimal
    // begin
    //     exit(
    //         GetEarlyTerminationFeeAmount(ContractID) +
    //         GetLateIntimationFeeAmount(ContractID) +
    //         GetRestorationChargesAmount(ContractID)
    //     );
    // end;

    procedure ConvertFinalSettlementToWords(Amount: Decimal): Text
    var
        WholeNumber: Integer;
        Decimals: Integer;
        WholePart: Text;
        DecimalPart: Text;
        FinalText: Text;
    begin
        // Take absolute value to handle negative amounts
        Amount := Abs(Amount);

        // Split into whole number and decimal parts
        WholeNumber := Round(Amount, 1, '<');  // Rounds down to nearest integer
        Decimals := Round((Amount - WholeNumber) * 100, 1);

        // Convert whole number to words
        WholePart := ConvertNumberToWords(WholeNumber);

        // Convert decimal part to words if exists
        if Decimals > 0 then begin
            DecimalPart := ' and ' + ConvertNumberToWords(Decimals) + ' fils';
        end;

        // Combine whole and decimal parts, and add 'Only'
        FinalText := WholePart + DecimalPart + ' Only';

        // Ensure first letter is capitalized
        exit(UpperCaseFirstLetter(FinalText));
    end;

    local procedure UpperCaseFirstLetter(InputText: Text): Text
    var
        FirstChar: Text[1];
        RemainingText: Text;
    begin
        if StrLen(InputText) = 0 then
            exit(InputText);

        FirstChar := UpperCase(InputText[1]);
        RemainingText := CopyStr(InputText, 2);

        exit(FirstChar + RemainingText);
    end;

    local procedure ConvertNumberToWords(Number: Integer): Text
    var
        Ones: array[20] of Text;
        Tens: array[10] of Text;
        Thousands: array[5] of Text;
        N: Integer;
        Result: Text;
    begin
        // Initialize arrays for number words
        Ones[1] := 'One';
        Ones[2] := 'Two';
        Ones[3] := 'Three';
        Ones[4] := 'Four';
        Ones[5] := 'Five';
        Ones[6] := 'Six';
        Ones[7] := 'Seven';
        Ones[8] := 'Eight';
        Ones[9] := 'Nine';
        Ones[10] := 'Ten';
        Ones[11] := 'Eleven';
        Ones[12] := 'Twelve';
        Ones[13] := 'Thirteen';
        Ones[14] := 'Fourteen';
        Ones[15] := 'Fifteen';
        Ones[16] := 'Sixteen';
        Ones[17] := 'Seventeen';
        Ones[18] := 'Eighteen';
        Ones[19] := 'Nineteen';

        Tens[2] := 'Twenty';
        Tens[3] := 'Thirty';
        Tens[4] := 'Forty';
        Tens[5] := 'Fifty';
        Tens[6] := 'Sixty';
        Tens[7] := 'Seventy';
        Tens[8] := 'Eighty';
        Tens[9] := 'Ninety';

        Thousands[1] := '';
        Thousands[2] := 'Thousand';
        Thousands[3] := 'Million';
        Thousands[4] := 'Billion';

        N := Number;

        // Handle zero
        if N = 0 then
            exit('Zero');

        // Process billions
        if N div 1000000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000000) + ' Billion ';
            N := N mod 1000000000;
        end;

        // Process millions
        if N div 1000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000) + ' Million ';
            N := N mod 1000000;
        end;

        // Process thousands
        if N div 1000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000) + ' Thousand ';
            N := N mod 1000;
        end;

        // Process hundreds
        if N div 100 > 0 then begin
            Result += Ones[N div 100] + ' Hundred ';
            N := N mod 100;
        end;

        // Process tens and ones
        if N > 0 then begin
            if N <= 19 then
                Result += Ones[N]
            else begin
                Result += Tens[N div 10];
                if N mod 10 > 0 then
                    Result += ' ' + Ones[N mod 10];
            end;
        end;

        exit(Result.Trim());
    end;

    var
        CompanyInfo: Record "Company Information";
        TotalAmountInclVAT: Decimal;
        AutoFormat: Codeunit "Auto Format";




}
