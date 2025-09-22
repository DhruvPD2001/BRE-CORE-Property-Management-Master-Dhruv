namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
report 50102 "Proposal Report"
{
    ApplicationArea = All;
    Caption = 'Proposal Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "LeaseProposal.docx";
    dataset
    {
        dataitem(LeaseProposalDetails; "Lease Proposal Details")
        {
            column(PropertyName; "Property Name")
            {
            }
            column(UnitNumber; "Unit Number")
            {
            }
            column(LeaseDuration; "Lease Duration")
            {
            }
            column(Unit_Size; "Unit Size")
            {
            }
            column(Annual_Rent_Amount; "Annual Rent Amount")
            {
            }
            column(Tenant_Full_Name; "Tenant Full Name")
            {
            }
            column(Property_Size; "Property Size")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
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
        layout("LeaseProposal.docx")
        {
            Type = Word;
            LayoutFile = './LeaseProposal.docx';
            Caption = 'LeaseProposal (Word)';
            Summary = 'The LeaseProposal (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
}
