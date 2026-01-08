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
    begin
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
                InsertMgtFeeLine(MgtFeeHeader, MgtFeeGrid);
            until MgtFeeGrid.Next() = 0;
    end;

    procedure InsertMgtFeeLine(MgtFeeHeader: Record "Management Fee Calc. Header"; MgtFeeGrid: Record "Management Fee Grid")
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

}