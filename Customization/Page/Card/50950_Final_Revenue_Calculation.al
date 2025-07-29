page 50950 "Final Revenue Calculation Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Revenue Calculation Grid';
    SourceTable = "Final Revenue Calculation Grid";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Revenue Description"; Rec."Revenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    Visible = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount';
                    ToolTip = 'Specifies the original amount';
                    Editable = false;
                }
                field("Original VAT"; Rec."Original VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Original VAT';
                    ToolTip = 'Specifies the original VAT amount';
                    Editable = false;
                }
                field("Original Amount Incl."; Rec."Original Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount Incl.';
                    ToolTip = 'Specifies the original amount including VAT';
                    Editable = false;
                }
                field("Revised Amount"; Rec."Revised Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    ToolTip = 'Specifies the revised amount after recalculation';
                    Editable = false;
                }
                field("Revised VAT"; Rec."Revised VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    ToolTip = 'Specifies the revised VAT amount';
                    Editable = false;
                }
                field("Revised Amount Incl."; Rec."Revised Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl.';
                    ToolTip = 'Specifies the revised amount including VAT';
                    Editable = false;
                }
                field("Difference Amount"; Rec."Difference Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    ToolTip = 'Specifies the difference in amount';
                    Editable = false;
                }
                field("Difference VAT"; Rec."Difference VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    ToolTip = 'Specifies the difference in VAT';
                    Editable = false;
                }
                field("Difference Amount Incl."; Rec."Difference Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl.';
                    ToolTip = 'Specifies the difference in amount including VAT';
                    Editable = false;
                }
                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    Editable = false;
                    Visible = false;

                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    Visible = false;
                }
                field("Revised VAT %"; Rec."Revised VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'Reviseed VAT %';
                    Editable = false;
                    Visible = false;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    Editable = false;
                    Visible = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    Visible = false;
                }
                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;
                }

            }
            group("")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Original Values")
                    {
                        field("Total Original Amount"; Rec."Total Original Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original Amount';
                            Editable = false;
                        }
                        field("Total Original VAT"; Rec."Total Original VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original VAT';
                            Editable = false;
                        }

                        field("Total Orgininal AmountIncl.VAT"; Rec."Total Orgininal AmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Orgininal Amount Incl. VAT';
                            Editable = false;

                        }
                    }
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount';
                            Editable = false;

                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised VAT';
                            Editable = false;

                        }
                        field("Total Revised AmountIncl.VAT"; Rec."Total Revised AmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount Incl. VAT';
                            Editable = false;
                        }
                    }
                    group("Difference Values")
                    {
                        field("Total Difference Amount"; Rec."Total Difference Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount';
                            Editable = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Differnece VAT';
                            Editable = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount Incl. VAT';
                            Editable = false;
                        }
                    }
                }



            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        GetAnnualRentAmountOfTerminationDateFromRentCalculation();
        GetAnnualAmountFromRevenueStructure();
        OneTimePaymentTypeRevisedRecalculatedAmount();
        GetRentAmountFromRentCalculation();
        GetRevisedAmountcalculatrefromRevenueStructuresubpage();
        DifferenceAmountCalculation();
    end;

    /// 1 : Only populate Annual Rent Amount for "Rent" item type from Rent calculation subpage in Annual Rent calculation field in the grid //
    procedure GetAnnualRentAmountOfTerminationDateFromRentCalculation()
    var

        RentCalculation2: Record "Rent Calculation Subpage";
    begin
        RentCalculation2.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation2.SetRange("Year", Rec."ContractYear(Termination Date)");
        RentCalculation2.SetRange("Secondary Item Type", Rec."Revenue Description");

        if RentCalculation2.FindSet() then
            repeat

                Rec."Annual Rent Amount TermiYear" := RentCalculation2."Final Annual Amount";
                Rec."Per Day Rent" := RentCalculation2."Per Day Rent";
                Rec.Modify();
            until RentCalculation2.Next() = 0;
    end;
    ///////////// END 1 ////////////////////////////////////


    //// 2 : Get Final annual amount from Revenue structure subpage //////////////

    procedure GetAnnualAmountFromRevenueStructure()
    var
        RevenueStructureSubpage: Record "Revenue Structure Subpage";

    begin
        RevenueStructureSubpage.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSubpage.SetRange("Year", Rec."ContractYear(Termination Date)");
        RevenueStructureSubpage.SetRange("Secondary Item Type", Rec."Revenue Description");

        if RevenueStructureSubpage.FindSet() then
            repeat

                Rec."Annual Rent Amount TermiYear" := RevenueStructureSubpage."Final Annual Amount";
                Rec."Per Day Rent" := RevenueStructureSubpage."Final Annual Amount" / RevenueStructureSubpage."Number of Days";
                Rec.Modify();
            until RevenueStructureSubpage.Next() = 0;

    end;

    ////// end 2 //////////////////////////

    ////////// 3 : only get One Time payment type data from Tenanacy contract ///////////////
    procedure OneTimePaymentTypeRevisedRecalculatedAmount()
    var
        TenancyContractsubpage: Record "Tenancy Contract Subpage";
        FinalRevenueCalculation: Record "Final Revenue Calculation Grid";
    begin
        TenancyContractsubpage.SetRange(ContractID, Rec."Contract ID");
        TenancyContractsubpage.SetRange("Payment Type", 1);
        TenancyContractsubpage.SetRange("Secondary Item Type", Rec."Revenue Description");
        if TenancyContractsubpage.FindSet() then
            repeat
                Rec."Revised Amount" := TenancyContractsubpage.Amount;
                Rec."Revised VAT %" := TenancyContractsubpage."VAT %";
                if Rec."Revised VAT %" = 1 then
                    Rec."Revised VAT %" := 5
                else
                    Rec."Revised VAT %" := 0;
                Rec."Revised VAT" := TenancyContractsubpage."VAT Amount";
                Rec."Revised Amount Incl." := TenancyContractsubpage."Amount Including VAT";
                Rec.Modify();
            //  Clear(FinalRevenueCalculation);
            until TenancyContractsubpage.Next() = 0;

    end;
    ////////////////////// END 3 ////////////////////////////

    /////////////////// 4 : Get data from Rent Calculation For RENT item type /////////////////
    procedure GetRentAmountFromRentCalculation()
    var
        RentCalculation: Record "Rent Calculation Subpage";
        Totalamount: Decimal;
        RentCalculation1: Record "Rent Calculation Subpage";
        TotalVATAmount: Decimal;
        calculateteminationamount: Decimal;
        FinalReviseAmount: Decimal;

    begin
        Totalamount := 0;
        RentCalculation.Reset();
        RentCalculation.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation.SetFilter(Year, '1..%1', Rec."ContractYear(Termination Date)");

        if RentCalculation.FindSet() then begin
            repeat
                // Sum up Final Annual Amount values
                TotalAmount += RentCalculation."Final Annual Amount";
                TotalVATAmount += RentCalculation."VAT Amount"
            until RentCalculation.Next() = 0;
        end;
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Secondary Item Type", Rec."Revenue Description");
        if RentCalculation1.FindSet() then
            repeat
                FinalReviseAmount := Totalamount - Rec."Annual Rent Amount TermiYear";
                calculateteminationamount := Rec."Per Day Rent" * Rec."Total No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                Rec."Revised Amount" := FinalReviseAmount + calculateteminationamount;
                Rec."Revised VAT %" := RentCalculation1."VAT %";

                if Rec."Revised VAT %" = 1 then
                    Rec."Revised VAT %" := 5
                else
                    Rec."Revised VAT %" := 0;
                // TotalVATAmount := Rec."Revised Amount" - (Rec."Revised Amount" / (1 + (Rec."Revised VAT %" / 100)));
                // TotalVATAmount := Round(TotalVATAmount, 0.01);
                TotalVATAmount := (Rec."Revised Amount" * Rec."Revised VAT %") / 100;

                Rec."Revised VAT" := TotalVATAmount;
                Rec."Revised Amount Incl." := Rec."Revised Amount" + Rec."Revised VAT";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;

    /////////////////// END 4 ////////////////////////////



    //////////// 5 : GET REVISED AMOUNT FOR CHARGES ITEM FROM REVENUE STRUCTURE SUBPAGE ///////////



    procedure GetRevisedAmountcalculatrefromRevenueStructuresubpage()
    var
        RevenueStructureSubpage1: Record "Revenue Structure Subpage";
        ChargesItemTotalamount: Decimal;
        RevenueStructureSubpage2: Record "Revenue Structure Subpage";
        ChargesItemTotalVATAmount: Decimal;
        calculateteminationamount1: Decimal;
        FinalReviseAmount: Decimal;

    begin
        ChargesItemTotalamount := 0;
        RevenueStructureSubpage1.Reset();
        RevenueStructureSubpage1.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSubpage1.SetRange("Secondary Item Type", Rec."Revenue Description");
        RevenueStructureSubpage1.SetFilter(Year, '1..%1', Rec."ContractYear(Termination Date)");


        if RevenueStructureSubpage1.FindSet() then begin
            repeat
                // Sum up Final Annual Amount values
                ChargesItemTotalamount += RevenueStructureSubpage1."Final Annual Amount";
                ChargesItemTotalVATAmount += RevenueStructureSubpage1."VAT Amount"
            until RevenueStructureSubpage1.Next() = 0;
        end;
        RevenueStructureSubpage2.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSubpage2.SetRange("Secondary Item Type", Rec."Revenue Description");
        if RevenueStructureSubpage2.FindSet() then
            repeat
                FinalReviseAmount := ChargesItemTotalamount - Rec."Annual Rent Amount TermiYear";
                calculateteminationamount1 := Rec."Per Day Rent" * Rec."Total No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                Rec."Revised Amount" := FinalReviseAmount + calculateteminationamount1;
                Rec."Revised VAT %" := RevenueStructureSubpage2."VAT %";
                if Rec."Revised VAT %" = 1 then
                    Rec."Revised VAT %" := 5
                else
                    Rec."Revised VAT %" := 0;

                // ChargesItemTotalVATAmount := Rec."Revised Amount" - (Rec."Revised Amount" / (1 + (Rec."Revised VAT %" / 100)));
                // ChargesItemTotalVATAmount := Round(ChargesItemTotalVATAmount, 0.01);
                ChargesItemTotalVATAmount := (Rec."Revised Amount" * Rec."Revised VAT %") / 100;

                Rec."Revised VAT" := ChargesItemTotalVATAmount;
                Rec."Revised Amount Incl." := Rec."Revised Amount" + Rec."Revised VAT";
                Rec.Modify();

            until RevenueStructureSubpage2.Next() = 0;
    end;



    /////////////// END 5 /////////////////////////

    /////////////// 6 : DIFFERENCE CALCULATION FOR ORIGINAL AMOUNT AND REVISED AMOUNT ///////////
    procedure DifferenceAmountCalculation()
    var

    begin

        Rec."Difference Amount" := Rec."Original Amount" - Rec."Revised Amount";
        Rec."Difference VAT" := Rec."Original VAT" - Rec."Revised VAT";
        Rec."Difference Amount Incl." := Rec."Original Amount Incl." - Rec."Revised Amount Incl.";
        Rec.Modify();

    end;

    ////////////// END 6 ///////////////////////
}