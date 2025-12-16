namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
report 50112 PaymentReceipt
{
    ApplicationArea = All;
    Caption = 'Payment Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "PaymentReceipt.docx";
    dataset
    {

        dataitem("Payment Mode2"; "Payment Mode2")
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Receipt__; "Receipt #")
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
            column(Contract_ID; "Contract ID")
            {
            }
            column(Tenant_Name; "Tenant Name")
            {
            }
            column(Tenant_Email; "Tenant Email")
            {
            }
            column(Receipt_Date; Format("Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            // column(Pay_S; "Payment Series")
            // {
            // }
            // column(Inv; "Invoice #")
            // {
            // }
            // column(Pay_M; "Payment Mode")
            // {
            // }
            // column(Ch_N; "Cheque Number")
            // {
            // }
            dataitem("Payment Schedule2"; "Payment Schedule2")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                DataItemTableView = SORTING("Payment Series");

                column(Pay_S; "Payment Mode2"."Payment Series")
                {
                }
                column(I_ID; "Payment Mode2"."Invoice #")  // Add this if it exists
                {
                }
                column(Pay_M; "Payment Mode2"."Payment Mode")  // Add this if it exists
                {
                }
                column(Che_N; "Payment Mode2"."Cheque Number")  // Add this if it exists
                {
                }
                column(Secondary_Item_Type; "Secondary Item Type")  // Changed from "Secondary Item Type"
                {
                }
                // column(Payment_Method; "Payment Method")  // Add this field
                // {
                // }
                // column(Cheque_No; "Cheque No")  // Add this field
                // {
                // }
                column(Amount; Amount)
                {
                }
                column(V_A; "VAT Amount")
                {
                }
                column(A_I_V; "Amount Including VAT")
                {
                }

                trigger OnPreDataItem()
                begin
                    // Filter to only show Payment Schedule entries that match the received Payment Series
                    SetRange("Payment Series", "Payment Mode2"."Payment Series");
                end;

                trigger OnAfterGetRecord()
                begin
                    // Calculate running totals
                    TotalAmount += Amount;
                    TotalVATAmount += "VAT Amount";
                    TotalAmountIncludingVAT += "Amount Including VAT";
                end;
            }
            dataitem(TotalSection; System.Utilities.Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(T_A; TotalAmount)
                {
                }
                column(T_V_A; TotalVATAmount)
                {
                }
                column(T_AIV; TotalAmountIncludingVAT)
                {
                }
                column(AmountInWords; AmountInWordsText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    // Convert amount to words and store in variable
                    AmountToWords(TotalAmountIncludingVAT);
                end;
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant Id");
                column(Address; Address)
                {
                }
                column(Phone_No_; "Phone No.")
                {
                }
                column(Cus_TRN; "VAT Registration No.")
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
                column(Contract_Start_Date; "Contract Start Date")
                {
                }
                column(Contract_End_Date; "Contract End Date")
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
        layout("PaymentReceipt.docx")
        {
            Type = Word;
            LayoutFile = './PaymentReceipt.docx';
            Caption = 'PaymentReceipt (Word)';
            Summary = 'The PaymentReceipt (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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

    var
        CompanyInfo: Record "Company Information";
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
        AmountInWordsText: Text;
        NoText: array[2] of Text[80];

    // Function to convert number to words
    procedure AmountToWords(Amount: Decimal)
    var
        AmtInWords: Text;
        Ones: array[20] of Text[30];
        Tens: array[10] of Text[30];
        Thousands: array[5] of Text[30];
        DecimalPart: Integer;
        IntegerPart: Integer;
        TensValue: Integer;
        OnesValue: Integer;
        ExponentVal: Integer;
        Hundreds: Integer;
        TensOnes: Integer;
        DecimalText: Text;
        FinalText: Text;
    begin
        // Initialize the arrays with text representations (Changed to Title Case)
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

        // Handle zero amount
        if Amount = 0 then begin
            AmountInWordsText := 'Zero AED Only';
            exit;
        end;

        AmtInWords := '';

        // Split into integer and decimal parts
        IntegerPart := Round(Amount, 1, '<');
        DecimalPart := Round((Amount - IntegerPart) * 100, 1);

        // Process billions
        if IntegerPart >= 1000000000 then begin
            ExponentVal := IntegerPart div 1000000000;
            IntegerPart := IntegerPart mod 1000000000;

            // Get hundreds
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;

            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';

            if ExponentVal > 0 then begin
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;

                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            end;

            AmtInWords += 'Billion ';
        end;

        // Process millions
        if IntegerPart >= 1000000 then begin
            ExponentVal := IntegerPart div 1000000;
            IntegerPart := IntegerPart mod 1000000;

            // Get hundreds
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;

            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';

            if ExponentVal > 0 then begin
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;

                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            end;

            AmtInWords += 'Million ';
        end;

        // Process thousands
        if IntegerPart >= 1000 then begin
            ExponentVal := IntegerPart div 1000;
            IntegerPart := IntegerPart mod 1000;

            // Get hundreds
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;

            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';

            if ExponentVal > 0 then begin
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;

                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            end;

            AmtInWords += 'Thousand ';
        end;

        // Process hundreds
        Hundreds := IntegerPart div 100;
        TensOnes := IntegerPart mod 100;

        if Hundreds > 0 then
            AmtInWords += Ones[Hundreds] + ' Hundred ';

        // Process tens and ones
        if TensOnes > 0 then begin
            if TensOnes < 20 then
                AmtInWords += Ones[TensOnes] + ' '
            else begin
                TensValue := TensOnes div 10;
                OnesValue := TensOnes mod 10;

                AmtInWords += Tens[TensValue];
                if OnesValue > 0 then
                    AmtInWords += ' ' + Ones[OnesValue];
                AmtInWords += ' ';
            end;
        end;

        // Format the final text - ensure there's no trailing space
        FinalText := DelChr(AmtInWords, '>', ' ');

        // Add decimal part if any, using the word "Fils" instead of fractions
        // Adding a space before "and"
        if DecimalPart > 0 then begin
            if DecimalPart < 20 then
                FinalText += ' and ' + Ones[DecimalPart] + ' Fils'
            else begin
                TensValue := DecimalPart div 10;
                OnesValue := DecimalPart mod 10;

                FinalText += ' and ' + Tens[TensValue];
                if OnesValue > 0 then
                    FinalText += ' ' + Ones[OnesValue];
                FinalText += ' Fils';
            end;
        end;

        // Finalize the text
        AmountInWordsText := FinalText + ' Only';
    end;
}
