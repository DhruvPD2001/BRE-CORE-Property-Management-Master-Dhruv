page 50139 "Unearned Revenue Report Card"
{
    PageType = Card;
    SourceTable = "Unearned Revenue Report";
    ApplicationArea = All;
    Caption = 'Unearned Revenue Report';

    layout
    {
        area(Content)
        {
            group("Unearned Revenue Report")
            {
                Caption = 'Unearned Revenue Report';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     if xRec."No." <> Rec."No." then
                    //         ClearSubgridData();
                    // end;
                }
                field("Starting Date Year"; Rec."Starting Date Year")
                {
                    ApplicationArea = All;
                }
                field("Ending Date Year"; Rec."Ending Date Year")
                {
                    ApplicationArea = All;
                }
            }
            group("Unearned Revenue Report Report Details")
            {
                Caption = 'Unearned Revenue Report Details';
                part("Unearned Revenue Report Details"; "Sub Unearned Revenue Card")
                {
                    SubPageLink = "Header No." = field("No.");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Filter Contracts")
            {
                ApplicationArea = All;
                Caption = 'Filter Contracts by Date Range';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FilterContractsByDateRange();
                end;
            }
        }
    }

    procedure FilterContractsByDateRange()
    var
        tenancyContract: Record "Tenancy Contract";
        NewLineNo: Integer;
        unearnedRevenueBuffer: Record "Sub Unearned Revenue Report"; // your buffer table
        StartDate, EndDate : Date;

    begin
        ClearSubgridData(); // Always clear before inserting

        StartDate := Rec."Starting Date Year";
        EndDate := Rec."Ending Date Year";

        tenancyContract.Reset();
        tenancyContract.SetFilter("Tenant Contract Status", '%1|%2|%3|%4',
            tenancyContract."Tenant Contract Status"::Active,
            tenancyContract."Tenant Contract Status"::Terminated,
            tenancyContract."Tenant Contract Status"::"Active-Contract Renewed",
            tenancyContract."Tenant Contract Status"::"Contract Renewed");

        // ✅ Filter contracts that fall within OR span the date range
        tenancyContract.SetFilter("Contract Start Date", '..%1', EndDate); // starts on or before end date
        tenancyContract.SetFilter("Contract End Date", '%1..', StartDate); // ends on or after start date

        if tenancyContract.FindSet() then begin
            repeat
                Clear(unearnedRevenueBuffer);

                NewLineNo := GetNextLineNo();

                unearnedRevenueBuffer.Init();
                unearnedRevenueBuffer."Header No." := Rec."No."; // ✅ Set Header No. correctly
                unearnedRevenueBuffer."Line No." := NewLineNo;
                unearnedRevenueBuffer."Contract ID" := tenancyContract."Contract ID";
                unearnedRevenueBuffer."Start Date" := tenancyContract."Contract Start Date";
                unearnedRevenueBuffer."End Date" := tenancyContract."Contract End Date";
                unearnedRevenueBuffer."Customer Name" := tenancyContract."Customer Name";
                unearnedRevenueBuffer.Property := tenancyContract."Property Name";
                unearnedRevenueBuffer."Owner Name" := tenancyContract."Owner's Name";
                unearnedRevenueBuffer."Contract Value" := tenancyContract."Annual Rent Amount";
                unearnedRevenueBuffer."Contract Status" := Format(tenancyContract."Tenant Contract Status");

                if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Single Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Unit Name"
                else if tenancyContract."Praposal Type Selected" = tenancyContract."Praposal Type Selected"::"Merge Unit" then
                    unearnedRevenueBuffer."Unit Name" := tenancyContract."Single Unit Name"
                else
                    unearnedRevenueBuffer."Unit Name" := '';
                // Add more fields as required

                unearnedRevenueBuffer.Insert();
            until tenancyContract.Next() = 0;
        end;
    end;

    procedure GetNextLineNo(): Integer
    var
        unearnedRevenueBuffer: Record "Sub Unearned Revenue Report";
        LastLineNo: Integer;
    begin
        unearnedRevenueBuffer.Reset();
        unearnedRevenueBuffer.SetRange("Header No.", Rec."No."); // ✅ filter by Header No.
        if unearnedRevenueBuffer.FindLast() then
            LastLineNo := unearnedRevenueBuffer."Line No."
        else
            LastLineNo := 0;

        exit(LastLineNo + 1);
    end;

    procedure ClearSubgridData()
    var
        RevenueItemDetail: Record "Sub Unearned Revenue Report";
    begin
        RevenueItemDetail.SetRange("Header No.", Rec."No."); // ✅ Clear only for this header
        RevenueItemDetail.DeleteAll(true);
    end;
}