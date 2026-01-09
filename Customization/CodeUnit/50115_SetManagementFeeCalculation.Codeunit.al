codeunit 50115 "SetManagementFeeCalculation"
{
    procedure BuildPropertyFilter(PropertyText: Text): Text
    var
        PropertyArr: List of [Text];
        Prop: Text;
        FilterTxt: Text;
    begin
        PropertyArr := PropertyText.Split(',');

        foreach Prop in PropertyArr do begin
            Prop := DelChr(Prop, '<>', ' ');
            // trim spaces

            if FilterTxt = '' then
                FilterTxt := Prop
            else
                FilterTxt := FilterTxt + '|' + Prop;
        end;

        exit(FilterTxt);
    end;

    procedure PopulateManagementFeeLines(MgtFeeHeader: Record "Management Fee Calc. Header")
    var
        MgtFeeGrid: Record "Management Fee Grid";
        MgtFeeLine: Record "Management Fee Calc. Line";
        monthFilter: Text;
    begin
        monthFilter := GetMonthFilter(MgtFeeHeader."Period From", MgtFeeHeader."Period To");

        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("Primary Key", MgtFeeHeader."Primary Key");
        if MgtFeeLine.FindSet() then
            MgtFeeLine.DeleteAll();


        MgtFeeGrid.Reset();

        if not MgtFeeHeader."All Owners" then
            MgtFeeGrid.SetRange("Owner ID", MgtFeeHeader."Owner ID");

        if not MgtFeeHeader."All Properties" then
            MgtFeeGrid.SetFilter("Property Name", BuildPropertyFilter(MgtFeeHeader.Property));


        MgtFeeGrid.SetFilter("Valid From", '<=%1', MgtFeeHeader."Period To");

        MgtFeeGrid.SetFilter("Valid To", '>=%1', MgtFeeHeader."Period From");


        if MgtFeeGrid.FindSet() then
            repeat
                InsertMgtFeeLine(MgtFeeHeader, MgtFeeGrid, monthFilter);
            until MgtFeeGrid.Next() = 0;
    end;

    procedure InsertMgtFeeLine(MgtFeeHeader: Record "Management Fee Calc. Header"; MgtFeeGrid: Record "Management Fee Grid"; pMonthFilter: Text)
    var
        MgtFeeCalcLine: Record "Management Fee Calc. Line";
    begin
        MgtFeeCalcLine.Init();
        MgtFeeCalcLine."Primary Key" := MgtFeeHeader."Primary Key";
        MgtFeeCalcLine."Entry No." := GetNextLineNo(MgtFeeHeader."Primary Key");
        // Copy fields
        MgtFeeCalcLine."Property Management Company" := MgtFeeGrid."Property Management Company";
        MgtFeeCalcLine."Owner ID" := MgtFeeGrid."Owner ID";
        MgtFeeGrid.CalcFields("Company/Owner Name");
        MgtFeeCalcLine."Company/Owner Name" := MgtFeeGrid."Company/Owner Name";
        MgtFeeCalcLine."Property Name" := MgtFeeGrid."Property Name";
        MgtFeeCalcLine."Property Type" := MgtFeeGrid."Property Type";
        MgtFeeCalcLine."Calculation Method" := MgtFeeGrid."Calculation Method";
        MgtFeeCalcLine."Calculation Sub-Type" := MgtFeeGrid."Calculation Sub-Type";
        MgtFeeCalcLine."Percentage Type" := MgtFeeGrid."Percentage Type";
        MgtFeeCalcLine."Percentage" := MgtFeeGrid."Percentage";
        MgtFeeCalcLine."Amount" := MgtFeeGrid."Amount";
        MgtFeeCalcLine."Base Amount Source" := MgtFeeGrid."Base Amount Source";
        MgtFeeCalcLine."Base Amount" := FetchBaseAmount(MgtFeeCalcLine, MgtFeeHeader, pMonthFilter);
        MgtFeeCalcLine."Management Fee" := CalculateManagementFee(MgtFeeCalcLine, MgtFeeHeader);
        MgtFeeCalcLine.Insert();
    end;

    procedure GetNextLineNo(PrimaryKeyNo: Code[20]): Integer
    var
        MgtFeeLine: Record "Management Fee Calc. Line";
    begin
        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("Primary Key", PrimaryKeyNo);
        if MgtFeeLine.FindLast() then
            exit(MgtFeeLine."Entry No." + 10000);

        exit(10000);
    end;

    procedure FetchBaseAmount(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pMonthFilter: Text): Decimal
    var
        baseAmount: Decimal;
    begin
        case
            MgtFeeCalcLine."Base Amount Source" of
            MgtFeeCalcLine."Base Amount Source"::Revenue:
                baseAmount := FetchBaseAmountFromRevenue(MgtFeeCalcLine, MgtFeeHeader, pMonthFilter);
            MgtFeeCalcLine."Base Amount Source"::"Annual Rent":
                baseAmount := FetchBaseAmountFromAnnualRent(MgtFeeCalcLine, MgtFeeHeader, pMonthFilter);
            MgtFeeCalcLine."Base Amount Source"::Collections:
                baseAmount := FetchBaseAmountFromCollections(MgtFeeCalcLine, MgtFeeHeader, pMonthFilter);
        end;
        exit(baseAmount);
    end;

    procedure FetchBaseAmountFromRevenue(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "Revenue Allocation SubGrid";
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        revenueAllocationSubGrid.SetRange("Owner Name", MgtFeeCalcLine."Company/Owner Name");
        revenueAllocationSubGrid.SetRange(Description, 'Regular');
        revenueAllocationSubGrid.SetRange("Posting Year", MgtFeeHeader."Financial Year");
        revenueAllocationSubGrid.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        revenueAllocationSubGrid.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        revenueAllocationSubGrid.SetFilter("Posting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                totalAmount += revenueAllocationSubGrid."Total Value";
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromAnnualRent(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "Revenue Allocation SubGrid";
        annualRentPerMonth: Decimal;
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        revenueAllocationSubGrid.SetRange("Owner Name", MgtFeeCalcLine."Company/Owner Name");
        revenueAllocationSubGrid.SetRange(Description, 'Regular');
        revenueAllocationSubGrid.SetRange("Posting Year", MgtFeeHeader."Financial Year");
        revenueAllocationSubGrid.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        revenueAllocationSubGrid.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        revenueAllocationSubGrid.SetFilter("Posting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                annualRentPerMonth := revenueAllocationSubGrid."Annual Amount" / 12;
                totalAmount += annualRentPerMonth;
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromCollections(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pMonthFilter: Text): Decimal
    var
        Tenancycontract: Record "Tenancy Contract";
        PaymentShceduleLine: Record "Payment Schedule2";
        paymentmode2: Record "Payment Mode2";
        totalamount: Decimal;
        paymentSeries: Text;
    begin
        totalamount := 0;
        Tenancycontract.Reset();
        Tenancycontract.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        if Tenancycontract.FindSet() then
            repeat
                paymentmode2.SetRange("Contract ID", Tenancycontract."Contract ID");
                paymentmode2.SetFilter("Receipt Date", '%1..%2', MgtFeeHeader."Period From", MgtFeeHeader."Period To");
                if paymentmode2.FindSet() then
                    repeat

                        // Sum amounts from Payment Schedule lines for this series where Secondary Item Type = 'Rent'
                        PaymentShceduleLine.Reset();
                        PaymentShceduleLine.SetRange("Contract ID", Tenancycontract."Contract ID");
                        PaymentShceduleLine.SetRange("Payment Series", paymentmode2."Payment Series");
                        PaymentShceduleLine.SetRange("Secondary Item Type", 'Rent');
                        if PaymentShceduleLine.FindSet() then
                            repeat
                                totalamount += PaymentShceduleLine.Amount;
                            until PaymentShceduleLine.Next() = 0;

                    // Mark series as processed
                    until paymentmode2.Next() = 0;

            until Tenancycontract.Next() = 0;
        exit(totalamount);
    end;

    procedure CalculateManagementFee(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"): Decimal
    var
        finalMgtFee: Decimal;
    begin
        case
            MgtFeeCalcLine."Calculation Method" of
            MgtFeeCalcLine."Calculation Method"::"Percentage of Annual Rent", MgtFeeCalcLine."Calculation Method"::"Percentage of Collections", MgtFeeCalcLine."Calculation Method"::"Percentage of Monthly Revenue":
                finalMgtFee := (MgtFeeCalcLine."Base Amount" * MgtFeeCalcLine.Percentage) / 100;
            MgtFeeCalcLine."Calculation Method"::"Per Unit Fee":
                finalMgtFee := CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader);
            MgtFeeCalcLine."Calculation Method"::Hybrid:
                finalMgtFee := ((MgtFeeCalcLine."Base Amount" * MgtFeeCalcLine.Percentage) / 100) + CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader);
        end;
        exit(finalMgtFee);
    end;

    procedure GetMonthFilter(pStartDate: Date; pEndDate: Date): Text
    var
        fetchMonth: Codeunit "Fetch Month";
        tempDate: Date;
        monthFilter: Text;
    begin
        tempDate := pStartDate;

        while tempDate <= pEndDate do begin
            if monthFilter = '' then
                monthFilter := fetchMonth.GetMonthName(Date2DMY(tempDate, 2))
            else
                monthFilter := monthFilter + '|' + fetchMonth.GetMonthName(Date2DMY(tempDate, 2));
            tempDate := CalcDate('<1M>', tempDate);
        end;
        exit(monthFilter);
    end;

    procedure CalculateMgtFeeFromFixedAmount(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"): Decimal
    var
        tenancyContract: Record "Tenancy Contract";
        fetchMonth: Codeunit "Fetch Month";
        unitCount: Integer;
        totalAmount: Decimal;
    begin
        unitCount := 0;
        tenancyContract.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        tenancyContract.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        tenancyContract.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        if tenancyContract.FindSet() then
            repeat
                if tenancyContract."Unit ID" <> '' then
                    unitCount += 1
                else
                    unitCount += MergeUnitCount(tenancyContract."Unit Number");
            until tenancyContract.Next() = 0;

        totalAmount := unitCount * MgtFeeCalcLine.Amount * fetchMonth.GetNoOfMonths(MgtFeeCalcLine."Valid From", MgtFeeCalcLine."Valid To", MgtFeeHeader."Period From", MgtFeeHeader."Period To");
        exit(totalAmount);
    end;

    procedure MergeUnitCount(pUnitNumber: Text[50]): Integer
    var
        UnitArr: List of [Text];
        Unit: Text;
        unitCount: Integer;
    begin
        if pUnitNumber = '' then
            exit(0);

        UnitArr := pUnitNumber.Split(',');
        unitCount := 0;

        foreach Unit in UnitArr do begin
            Unit := DelChr(Unit, '<>', ' ');
            if Unit <> '' then
                unitCount += 1;
        end;

        exit(unitCount);
    end;
}