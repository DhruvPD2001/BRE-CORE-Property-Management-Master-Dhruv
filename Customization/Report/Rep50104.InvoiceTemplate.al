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


    // SalesLine: Record "Sales Line";
}
