codeunit 50114 "Update Management Fee Status"
{


    trigger OnRun()
    begin
        UpdateContractStatus();
    end;

    local procedure UpdateContractStatus()
    var
        MgmtFeeLine: Record "Management Fee Grid";
        TodayDate: Date;
    begin
        TodayDate := Today;

        MgmtFeeLine.Reset();

        if MgmtFeeLine.FindSet() then
            repeat
                if (MgmtFeeLine."Valid From" <= TodayDate) and
                   (MgmtFeeLine."Valid To" >= TodayDate) then begin

                    if MgmtFeeLine."Contract Status" <>
                       MgmtFeeLine."Contract Status"::Active then begin
                        MgmtFeeLine."Contract Status" :=
                            MgmtFeeLine."Contract Status"::Active;
                        MgmtFeeLine.Modify();
                    end;

                end else begin

                    if MgmtFeeLine."Contract Status" <>
                       MgmtFeeLine."Contract Status"::Expired then begin
                        MgmtFeeLine."Contract Status" :=
                            MgmtFeeLine."Contract Status"::Expired;
                        MgmtFeeLine.Modify();
                    end;

                end;
            until MgmtFeeLine.Next() = 0;
    end;
}
