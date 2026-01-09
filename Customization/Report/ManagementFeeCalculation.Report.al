report 50119 "Management Fee Calculation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "ManagementFeeCalculation.docx";

    dataset
    {
        dataitem("Management Fee Calc. Header"; "Management Fee Calc. Header")
        {
            column(Report_Date; "Report Date")
            { }
            column(Owner_Name; OwnerName)
            { }
            column(Property; PropertyName)
            { }
            column(Financial_Year; "Financial Year")
            { }
            column(Period_From; "Period From")
            { }
            column(Period_To; "Period To")
            { }
            column(Total_Management_Fee; TotalMgtFee)
            { }

            dataitem("Management Fee Calc. Line"; "Management Fee Calc. Line")
            {
                DataItemLink = "Primary Key" = field("Primary Key");

                column(Property_Management_Company; "Property Management Company")
                { }
                column(Company_Owner_Name; "Company/Owner Name")
                { }
                column(Property_Name; "Property Name")
                { }
                column(Property_Type; "Property Type")
                { }
                column(Calculation_Method; "Calculation Method")
                { }
                column(Calculation_Sub_Type; "Calculation Sub-Type")
                { }
                column(Percentage_Type; "Percentage Type")
                { }
                column(Percentage; Percentage)
                { }
                column(Amount; Amount)
                { }
                column(Base_Amount_Source; "Base Amount Source")
                { }
                column(Base_Amount; "Base Amount")
                { }
                column(Management_Fee; "Management Fee")
                { }
                column(Validity_Period; "Validity Period")
                { }
                column(Contract_Status; "Contract Status")
                { }

                trigger OnAfterGetRecord()
                begin
                    TotalMgtFee += "Management Fee";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Owner Name");
                if "All Owners" then
                    OwnerName := 'All'
                else
                    OwnerName := "Owner Name";

                if "All Properties" then
                    PropertyName := 'All'
                else
                    PropertyName := Property;

                TotalMgtFee := 0;
            end;
        }

    }

    // requestpage
    // {
    //     AboutTitle = 'Teaching tip title';
    //     AboutText = 'Teaching tip content';
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(LayoutName)
    //             {

    //             }
    //         }
    //     }
    // }

    rendering
    {
        layout("ManagementFeeCalculation.docx")
        {
            Type = Word;
            LayoutFile = './ManagementFeeCalculation.docx';
            Caption = 'Management Fee Calculation (Word)';
            Summary = 'The Management Fee Calculation (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }

    var
        OwnerName: Text;
        PropertyName: Text;
        TotalMgtFee: Decimal;
}