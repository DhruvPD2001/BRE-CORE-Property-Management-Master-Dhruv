namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;

using Microsoft.Sales.Document;
using System.Text;
using Microsoft.Bank.Check;

report 50104 InvoiceTemplate
{
    ApplicationArea = All;
    Caption = 'InvoiceTemplate';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "SalesInvoiceTemplate.docx";
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
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
            column(No_; "No.")
            {
            }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Bill_to_Address; "Bill-to Address")
            {
            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {
            }
            column(Sell_to_E_Mail; "Sell-to E-Mail")
            {
            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Document_Date; "Document Date")
            {

            }
            // column(Property_Name; "Property Name")
            // {
            // }
            // column(Unit_Name; "Unit Name")
            // {
            // }
            // column(Contract_Tenure; "Contract Tenure")
            // {
            // }
            column(BankAccountName; CompanyInfo."Bank Name")
            {
            }
            column(BankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(BankIBAN; CompanyInfo.IBAN)
            {
            }
            column(BankSwiftCode; CompanyInfo."SWIFT Code")
            {
            }
            column(BankBranch; CompanyInfo."Bank Branch No.")
            {
            }
            column(Customer_P_O; "Customer P.O")
            {

            }
            column(Customer_P_O_Date; "Customer P.O Date")
            {

            }
            column(Contract_Period; "Contract Period")
            {

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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Serial_No; SerialNo)
                {
                }
                column(SaleLineNo_; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(Amount; Amount)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    LineAmountText := Format("Line Amount");
                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := "Line Amount";
                    TotalDue += "Amount Including VAT";
                    TotalSubTotal += "Amount Including VAT";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                    SerialNo := SerialNo + 1;
                end;

                trigger OnPreDataItem()
                begin
                    // Initialize Serial No. at the start of the dataitem
                    SerialNo := 0;
                end;
            }
            dataitem(Totals; System.Utilities.Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalSubTotal; Format(TotalSubTotal, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalInvDiscAmount; Format(TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalAmountVAT; Format(TotalAmountVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalAmountInclVAT; Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column("TotalDue"; Format(TotalDue, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }

                column(AmountInWords; AmountInWordsText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    // Convert amount to words and store in variable
                    AmountToWords(TotalAmountInclVAT);
                end;

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
        layout("SalesInvoiceTemplate.docx")
        {
            Type = Word;
            LayoutFile = './SalesInvoiceTemplate.docx';
            Caption = 'SalesInvoiceTemplate (Word)';
            Summary = 'The SalesInvoiceTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
        //  AutoFormat: Codeunit "Auto Format";
        //TotalAmountText: array[2] of Text[80];


        CompanyInfo: Record "Company Information";
        AutoFormat: Codeunit "Auto Format";
        LineAmountText: Text;
        TransHeaderAmount: Decimal;
        PrevLineAmount: Decimal;
        TotalDue: Decimal;
        TotalSubTotal: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountVAT: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        SerialNo: Integer;
        AmountInWordsText: Text;
    // SalesLine: Record "Sales Line";


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
