page 50903 "Final Calculation Card"
{
    PageType = Card;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the Final Calculation or related reference for the contract.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }
                field("Intimation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Intimation Date';
                    ToolTip = 'Enter the Initmation Date.';
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';

                    trigger OnValidate()
                    var
                        FinalCalculation: Record "Final Calculation";
                        TerminateDate: Date;
                        DaysCal: Integer;
                        StartDate: Date;
                    begin
                        FinalCalculation.SetRange("FC ID", Rec."FC ID");
                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if not FinalCalculation.IsEmpty() then begin

                            StartDate := Rec."Contract Start Date";
                            TerminateDate := Rec."Termination Date";
                            DaysCal := TerminateDate - StartDate + 1;
                            Rec."Actual Contract Tenure" := DaysCal;
                            Rec.Modify();

                        end;
                        // CurrPage.Update();

                        GetContractTerminationYear();
                        Fetchperdayrent();
                        PopulateRevenueCalculationGrid();
                        GetDataTenancyContract();
                        BillingCalcGridRentCalc();
                        BillingCalcridTenancyContractSubpge();
                        ReciveableCalcGridRentCalc();
                        ReciveableCalcridTenancyContractSubpge();
                        RentCalculate();
                        OtherPaymentCalculate();
                        RevenueCalculateOneTime();
                        RevenueCalculate();
                        PaymentDetailsFromPaymentSchedule2();

                    end;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier of the tenant associated with the contract.';
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                    ToolTip = 'Displays the email address of the tenant.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                    ToolTip = 'Shows the full name of the tenant.';
                }
                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                    Editable = false;
                }

                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    ToolTip = 'Enter the Actual Contract Tenure.';
                    Editable = false;
                }
                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent(Termination Year)';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    ToolTip = 'Displays the annual rent amount applicable for the year of termination.';
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Indicates the current status of the record.';
                }

                field("Termination Status"; Rec."Termination Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Termination Type';
                    ToolTip = 'Shows the type of termination for the contract.';
                }
                field("Final Calculation Document"; Rec."Final Calculation Document")
                {
                    ApplicationArea = All;
                    Caption = 'Final Calculation Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Click to upload or view the final calculation document related to this record.';

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'finalcalculationdocument';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Final Calculation Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."Final Calculation URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("Credit Note Document"; Rec."Credit Note Document")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Click to view the credit note document in your browser.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."Credit Note URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("Credit Note URL"; Rec."Credit Note URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Stores the URL for the credit note document.';
                }

                // field("Credit Note"; Rec."Credit Note")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     DrillDown = true;
                //     trigger OnDrillDown()
                //     var
                //         finalcalculation: Record "Final Calculation";
                //         creditnote: Record "Credit Note";
                //         creditnoteid: Integer;
                //         creditnotecard: Page "Credit Note Card";
                //     begin
                //         creditnote.SetRange("Contract ID", Rec."Contract ID");

                //         if creditnote.FindSet() then begin
                //             creditnote."Contract ID" := Rec."Contract ID";
                //             creditnote."FC ID" := Rec."FC ID";
                //             creditnote."Contract Start Date" := Rec."Contract Start Date";
                //             creditnote."Contract End Date" := Rec."Contract End Date";
                //             creditnote."Contract Amount" := Rec."Contract Amount";
                //             creditnote."Unit Type" := Rec."Unit Type";
                //             creditnote."Tenant ID" := Rec."Tenant ID";
                //             creditnote."Tenant Email" := Rec."Tenant Email";
                //             creditnote."Tenant Name" := Rec."Tenant Name";
                //             creditnote."Credit Note Type" := creditnote."Credit Note Type"::"Termination Credit Note";
                //             creditnote.Modify();
                //             Message('Credit Note Modify Successfully');
                //             creditnote."FC ID" := Rec."FC ID";
                //         end else begin
                //             creditnote.Init();
                //             creditnote."Contract ID" := Rec."Contract ID";
                //             creditnote."FC ID" := Rec."FC ID";
                //             creditnote."Contract Start Date" := Rec."Contract Start Date";
                //             creditnote."Contract End Date" := Rec."Contract End Date";
                //             creditnote."Contract Amount" := Rec."Contract Amount";
                //             creditnote."Unit Type" := Rec."Unit Type";
                //             creditnote."Tenant ID" := Rec."Tenant ID";
                //             creditnote."Tenant Email" := Rec."Tenant Email";
                //             creditnote."Tenant Name" := Rec."Tenant Name";
                //             creditnote."Credit Note Type" := creditnote."Credit Note Type"::"Termination Credit Note";
                //             creditnote.Insert();
                //             Message('Credit Note Insert Successfully');
                //             Clear(creditnote);

                //             if creditnote.FindLast() then begin
                //                 // If found, get the latest RS ID
                //                 creditnoteid := creditnote."ID";
                //             end else begin
                //                 // If no record is found, create a new Revenue Structure record
                //                 creditnote.Init();
                //                 creditnote.Insert(true);
                //                 creditnote.Modify(true);  // Insert the new record and generate the RS ID
                //             end;
                //             Rec."Credit Note ID" := creditnoteid;
                //         end;
                //     end;
                // }
                // field("Credit Note ID"; Rec."Credit Note ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     DrillDown = true;
                //     trigger OnDrillDown()
                //     var
                //         creditnote: Record "Credit Note";
                //     begin
                //         if creditnote.Get(Rec."Credit Note ID") then
                //             PAGE.RUN(PAGE::"Credit Note Card", creditnote)
                //         else
                //             Message('The related Credit Note does not exist.');
                //     end;
                // }
            }

            // group("Final Revenue Calculation")
            // {
            //     part("FinalRevenueCalculation"; "Final Revenue Calculation Grid")
            //     {
            //         SubPageLink = "Contract ID" = FIELD("Contract ID");
            //         ApplicationArea = All;
            //     }
            // }
            part("FinalRevenueCalculation"; "Final Revenue Calculation Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }

            part("BillingCalculation"; "Final Billing Calculation")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }



            part("Pendingreceivable/Payable"; "Pending Recevieable Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }

            group("Termination Additional Charges")
            {
                part("Additional Charges"; "Additional Charges Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Rent-Calculation")
            {
                part("Rent Calculation"; "Rent Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue-structure")
            {
                part("Other Payment"; "OtherPayment Calculate SubCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue structure - Yearly break-down")
            {
                part("Revenue Structure"; "Revenue Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            // part("PaymentSchedule"; "Payment Schedule Card2")
            // {
            //     SubPageLink = "Contract ID" = FIELD("Contract ID"),
            //   "Tenant ID" = FIELD("Tenant ID");
            //     ApplicationArea = All;
            // }
            part(PaymentDetails; "Payment Details")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }
            group("Adjust Security Deposit")
            {
                group("Carry Forward the Security Deposit From")
                {
                    field("ContractID"; Rec."Contract ID")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the unique identifier for the contract.';
                        // trigger OnValidate()
                        // begin
                        //     FetchSecurityDepositInfo();
                        // end;
                    }
                    field("Security Deposit"; Rec."Security Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Shows the amount of the carried forward security deposit.';
                    }
                    field("Adjustment Security Deposit"; Rec."Adjustment Security Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Displays the adjusted security deposit amount.';
                    }
                    field("Net Balance"; Rec."Net Balance")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Shows the net balance after adjustments.';
                    }
                }
                group("Carry Forward the Security Deposit To")
                {
                    part("Carry Forward"; "Carry Forward Grid")
                    {
                        SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                        ApplicationArea = All;
                        // Visible = isVisible;
                    }
                }
                group("Refundable Deposits")
                {
                    field("NetBalance"; Rec."Net Balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Security Deposit';
                        Editable = false;
                        ToolTip = 'Displays the refundable security deposit amount.';
                    }
                    field("Chiller Deposit"; Rec."Chiller Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Shows the refundable chiller deposit amount.';
                    }
                    field("Other Deposit"; Rec."Other Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Displays other refundable deposits.';
                    }
                    field("Total Net Balance"; Rec."Total Refundable Deposit")
                    {
                        ApplicationArea = All;
                        Caption = 'Total Refundable Deposit';
                        Editable = false;
                        ToolTip = 'Shows the total amount of refundable deposits.';
                    }
                }

            }
            group("Summary")
            {
                field("Total Claim"; Rec."Total Claim")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total claim amount.';
                }
                field("Total Adjustment"; Rec."Total Adjustment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Shows the total adjustment amount.';
                }
                field("Total Refund"; Rec."Total Refund")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total refund amount to the tenant.';
                }
                field("Total Receive"; Rec."Total Receive")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the total amount received from the tenant.';
                }
                field("Summery Net Balance"; Rec."Summery Net Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the final net balance summary.';
                }
                field("Amount Refundable"; Rec."Amount Refundable")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the amount refundable to the tenant.';
                    trigger OnValidate()
                    begin
                        if Rec."Amount Refundable" <> 0 then
                            IsRefundable := true
                        else
                            IsReceivable := true;
                        UpdateCanPost();
                    end;
                }
                field("Net Receivable From The Tenant"; Rec."Net Receivable From The Tenant")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the amount receivable from the tenant.';

                    trigger OnValidate()
                    begin
                        if Rec."Net Receivable From The Tenant" <> 0 then
                            IsReceivable := true
                        else
                            IsRefundable := true;
                        UpdateCanPost();
                    end;
                }
            }

            group("FinalSettlemt")
            {
                Caption = 'Final Settlement';
                Visible = IsReceivable;
                part("FinalSettelemts"; "FinalSettlemtCard")
                {
                    SubPageLink = "FC ID" = FIELD("FC ID");
                    //  "Tenant ID" = FIELD("Tenant ID");
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("FinalSettlemts")
            {
                Caption = 'Final Settlement';
                Visible = IsRefundable;
                part("FinalSettelemtss"; "FinalSettlemtRefundCard")
                {
                    SubPageLink = "FC ID" = FIELD("FC ID");
                    // "Tenant ID" = FIELD("Tenant ID");
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FinalCalculation)
            {
                ApplicationArea = All;
                Caption = 'Final Calculation';
                Image = PostDocument;
                Enabled = CanPost;
                ToolTip = 'Perform the final calculation for this record before posting.';

                trigger OnAction()
                var
                    ApprovalFinalCalculation: Record "Approval Final Calculation";
                    FinalCalculation: Record "Final Calculation";
                    FinalCalculationid: Integer;
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    ApprovalFinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                    ApprovalFinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                    if ApprovalFinalCalculation.FindSet() then begin
                        ApprovalFinalCalculation."FC ID" := Rec."FC ID";
                        ApprovalFinalCalculation."Contract ID" := Rec."Contract ID";
                        ApprovalFinalCalculation."Tenant ID" := Rec."Tenant ID";
                        ApprovalFinalCalculation."Status" := Rec."Status";
                        ApprovalFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                        ApprovalFinalCalculation."Contract End Date" := Rec."Contract End Date";
                        ApprovalFinalCalculation."Termination Date" := Rec."Termination Date";
                        ApprovalFinalCalculation."Contract Amount" := Rec."Contract Amount";
                        ApprovalFinalCalculation.Modify();
                        Message('Approval Request Modify successfully!');
                    end else begin

                        // Create new entry
                        ApprovalFinalCalculation.Init();
                        ApprovalFinalCalculation."FC ID" := Rec."FC ID";
                        ApprovalFinalCalculation."Contract ID" := Rec."Contract ID";
                        ApprovalFinalCalculation."Tenant ID" := Rec."Tenant ID";
                        ApprovalFinalCalculation."Status" := Rec."Status";
                        ApprovalFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                        ApprovalFinalCalculation."Contract End Date" := Rec."Contract End Date";
                        ApprovalFinalCalculation."Termination Date" := Rec."Termination Date";
                        ApprovalFinalCalculation."Contract Amount" := Rec."Contract Amount";


                        if FinalCalculation.FindSet() then
                            // If found, get the latest RS ID
                            FinalCalculationid := ApprovalFinalCalculation."FC ID"
                        else
                            // If no record is found, create a new Revenue Structure record
                            FinalCalculation.Init();
                        FinalCalculation.Insert(true);
                        FinalCalculation.Modify(true);  // Insert the new record and generate the RS ID

                        // Get the newly created RS ID
                        FinalCalculationid := ApprovalFinalCalculation."FC ID";

                        ApprovalFinalCalculation."Link" := FinalCalculationid;
                        ApprovalFinalCalculation.Insert(true);

                        Message('Approval Request Send successfully!');
                    end;
                end;
            }
        }
        area(Reporting)
        {
            action("Run Report")
            {
                ApplicationArea = All;
                Image = Report;
                ToolTip = 'Execute the selected report to view or analyze the related data.';
                trigger OnAction()
                var
                    Finalcalculation: Record "Final Calculation";
                    TerminationReport: Report "Termination Template";
                begin
                    Finalcalculation.SetRange("Contract ID", Rec."Contract ID");  // Set appropriate filters
                    TerminationReport.SetTableView(Finalcalculation);
                    TerminationReport.RunModal();
                end;
            }
        }
    }

    //////////////////  START Final Revenue Calculation Grid ////////////////////
    procedure PopulateRevenueCalculationGrid()
    var
        FinalRevCalcGrid: Record "Final Revenue Calculation Grid";
        RentCalc: Record "Rent Calculation";
    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        FinalRevCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if FinalRevCalcGrid.FindSet() then
            FinalRevCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc.FindSet() then
            repeat
                FinalRevCalcGrid.Init();
                FinalRevCalcGrid."Contract ID" := RentCalc."Contract ID";
                FinalRevCalcGrid."Revenue Description" := RentCalc."Secondary Item Type";
                FinalRevCalcGrid."Original Amount" := RentCalc."Amount";
                FinalRevCalcGrid."Original VAT" := RentCalc."VAT Amount";
                FinalRevCalcGrid."Original Amount Incl." := RentCalc."Amount Including VAT";
                FinalRevCalcGrid."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                // FinalRevCalcGrid."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                // FinalRevCalcGrid."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid.Insert();
                Clear(FinalRevCalcGrid);
            until RentCalc.Next() = 0;
    end;


    procedure GetDataTenancyContract()
    var
        FinalRevCalcGrid1: Record "Final Revenue Calculation Grid";
        TenancyContractLine1: Record "Tenancy Contract Subpage";

    begin

        // TenancyContractLine.Reset();
        TenancyContractLine1.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine1.FindSet() then
            repeat
                FinalRevCalcGrid1.Init();
                FinalRevCalcGrid1."Contract ID" := Rec."Contract ID";
                FinalRevCalcGrid1."Revenue Description" := TenancyContractLine1."Secondary Item Type";
                FinalRevCalcGrid1."Original Amount" := TenancyContractLine1.Amount;

                // Calculate VAT amount based on percentage
                FinalRevCalcGrid1."Original VAT" := TenancyContractLine1."VAT Amount";

                FinalRevCalcGrid1."Original Amount Incl." := TenancyContractLine1."Amount Including VAT";
                FinalRevCalcGrid1."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                //   FinalRevCalcGrid1."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid1."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                //  FinalRevCalcGrid1."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid1."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid1."Payment Type" := Format(TenancyContractLine1."Payment Type");
                FinalRevCalcGrid1.Insert();
                Clear(FinalRevCalcGrid1);
            until TenancyContractLine1.Next() = 0;
    end;

    procedure GetContractTerminationYear()
    var
        RentCalculationSub: Record "Rent Calculation Subpage";
        UserYear: Integer;
        Terminationdate: Date;
    begin
        UserYear := 0;
        Terminationdate := Rec."Termination Date";
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        if RentCalculationSub.FindSet() then
            repeat
                if (Terminationdate >= RentCalculationSub."Period Start Date") and (Terminationdate <= RentCalculationSub."Period End Date") then
                    UserYear := RentCalculationSub.Year;
            until (RentCalculationSub.Next() = 0) or (UserYear <> 0);

        Rec."ContractYear(Termination Date)" := UserYear;
        Rec.Modify();
    end;

    procedure Fetchperdayrent()
    var
        RentCalculation1: Record "Rent Calculation Subpage";
        DifferenceDays: Integer;
    begin
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Year", Rec."ContractYear(Termination Date)");

        if RentCalculation1.FindSet() then
            repeat
                Rec."Per Day Rent" := RentCalculation1."Per Day Rent";
                DifferenceDays := Rec."Termination Date" - RentCalculation1."Period Start Date";
                Rec."Total No. Of Days" := DifferenceDays + 1;
                Rec."Annual Rent Amount TermiYear" := RentCalculation1."Final Annual Amount";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;

    procedure RentCalculate()
    var
        RentCalculationSub: Record "Rent Calculation Subpage";
        RentCalculates: Record "Rent Calculate Sub";
    begin


        RentCalculates.SetRange("Contract ID", Rec."Contract ID");
        if RentCalculates.FindSet() then
            RentCalculates.DeleteAll();

        // TenancyContractLine.Reset();
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        RentCalculationSub.SetRange("Tenant ID", Rec."Tenant ID");
        if RentCalculationSub.FindSet() then
            repeat
                RentCalculates.Init();
                RentCalculates."Contract ID" := Rec."Contract ID";
                RentCalculates."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                RentCalculates."Year" := RentCalculationSub."Year";
                RentCalculates."Period Start Date" := RentCalculationSub."Period Start Date";
                RentCalculates."Period End Date" := RentCalculationSub."Period End Date";
                RentCalculates."Number Of Days" := RentCalculationSub."Number Of Days";
                RentCalculates."Final Annual Amount" := RentCalculationSub."Final Annual Amount";
                RentCalculates."Per Day Rent" := RentCalculationSub."Per Day Rent";
                RentCalculates.Insert();
                Clear(RentCalculates);
            until RentCalculationSub.Next() = 0;
    end;

    procedure OtherPaymentCalculate()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        OtherPaymentCalculateSub: Record "Other Payment Calculate Sub";

    begin
        OtherPaymentCalculateSub.SetRange("Contract ID", Rec."Contract ID");
        if OtherPaymentCalculateSub.FindSet() then
            OtherPaymentCalculateSub.DeleteAll();


        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractSub.FindSet() then
            repeat
                OtherPaymentCalculateSub.Init();
                OtherPaymentCalculateSub."Contract ID" := Rec."Contract ID";
                OtherPaymentCalculateSub."Tenant ID" := Rec."Tenant ID";
                OtherPaymentCalculateSub."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                OtherPaymentCalculateSub."Amount" := TenancyContractSub."Amount";
                OtherPaymentCalculateSub."VAT Amount" := TenancyContractSub."VAT Amount";
                OtherPaymentCalculateSub."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                OtherPaymentCalculateSub."Start Date" := TenancyContractSub."Start Date";
                OtherPaymentCalculateSub."End Date" := TenancyContractSub."End Date";
                OtherPaymentCalculateSub.Insert();
                Clear(OtherPaymentCalculateSub);
            until TenancyContractSub.Next() = 0;

    end;

    procedure RevenueCalculateOneTime()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        //PaymentSchedule2: Record "Payment Schedule2";
        RevenueCalculates: Record "Revenue Calculate Sub";

    begin

        RevenueCalculates.SetRange("Contract ID", Rec."Contract ID");
        if RevenueCalculates.FindSet() then
            RevenueCalculates.DeleteAll();


        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        TenancyContractSub.SetRange("TenantID", Rec."Tenant ID");

        TenancyContractSub.SetRange("Payment Type", 1);
        if TenancyContractSub.FindSet() then
            repeat
                RevenueCalculates.Init();
                RevenueCalculates."Contract ID" := TenancyContractSub."ContractID";
                RevenueCalculates."Tenant ID" := TenancyContractSub."TenantId";
                RevenueCalculates."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                RevenueCalculates.Amount := TenancyContractSub.Amount;
                RevenueCalculates."VAT Amount" := TenancyContractSub."VAT Amount";
                RevenueCalculates."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                RevenueCalculates."Installment Start Date" := TenancyContractSub."Start Date";
                RevenueCalculates."Installment End Date" := TenancyContractSub."End Date";
                RevenueCalculates.Insert();
                Clear(RevenueCalculates);
            until TenancyContractSub.Next() = 0;
    end;

    procedure RevenueCalculate()
    var
        RevenueStructureSub: Record "Revenue Structure Subpage";
        RevenueCalculateSub: Record "Revenue Calculate Sub";
    begin

        // TenancyContractLine.Reset();
        RevenueStructureSub.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSub.SetRange("Tenant ID", Rec."Tenant ID");
        if RevenueStructureSub.FindSet() then
            repeat
                RevenueCalculateSub.Init();
                RevenueCalculateSub."Contract ID" := Rec."Contract ID";
                RevenueCalculateSub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                RevenueCalculateSub."Secondary Item Type" := RevenueStructureSub."Secondary Item Type";
                RevenueCalculateSub."Amount" := RevenueStructureSub."Final Annual Amount";
                RevenueCalculateSub."VAT Amount" := RevenueStructureSub."VAT Amount";
                RevenueCalculateSub."Amount Including VAT" := RevenueStructureSub."Amount Including VAT";
                RevenueCalculateSub."Installment Start Date" := RevenueStructureSub."Period Start Date";
                RevenueCalculateSub."Installment End Date" := RevenueStructureSub."Period End Date";
                RevenueCalculateSub.Insert();
                Clear(RevenueCalculateSub);
            until RevenueStructureSub.Next() = 0;

    end;

    //----------------------------------Fetch Security Deposit-------------------------------//
    // procedure FetchSecurityDepositInfo()
    // var
    //     ContractRec: Record "Tenancy Contract";
    // begin
    //     if Rec."Contract ID" <> 0 then begin
    //         ContractRec.Reset();
    //         ContractRec.SetRange("Contract ID", Rec."Contract ID");

    //         if ContractRec.FindFirst() then begin
    //             // Update the fields without showing messages (this is automatic)
    //             Rec."Security Deposit" := ContractRec."Security Deposit Amount";
    //             Rec."Adjustment Security Deposit" := ContractRec."Security Balanced Amount";
    //             Rec."Net Balance" := ContractRec."Security Deposit Amount" - ContractRec."Security Balanced Amount";
    //             Rec.Modify(false);  // false means don't trigger validation
    //         end;
    //     end;
    // end;

    //-----------------------------------Fetch total claim---------------------------------//

    // Add this procedure to calculate the total from the Additional Charges grid
    // procedure UpdateTotalClaim()
    // var
    //     AdditionalCharges: Record "Additional Charges Sub";
    //     TotalAmount: Decimal;
    // begin
    //     AdditionalCharges.Reset();
    //     AdditionalCharges.SetRange("Contract ID", Rec."Contract ID");

    //     if AdditionalCharges.FindSet() then begin
    //         repeat
    //             TotalAmount += AdditionalCharges."Amount Including VAT";
    //         until AdditionalCharges.Next() = 0;
    //     end;

    //     Rec."Total Claim" := TotalAmount;
    //     Rec.Modify(false);
    //     CurrPage.Update(false);
    // end;

    // Also add a method that the subpage can call when its data changes
    // procedure UpdateTotalsFromSubpage()
    // begin
    //     UpdateTotalClaim();
    // end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        // FetchSecurityDepositInfo();
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
        UpdateCanPost();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
    end;

    procedure BillingCalcGridRentCalc()
    var

        BillinCalcGrid: Record "Final Billing Calculation Grid";
        RentCalc1: Record "Rent Calculation";
        vatper: Integer;

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        BillinCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if BillinCalcGrid.FindSet() then
            BillinCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc1.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc1.FindSet() then
            repeat
                BillinCalcGrid.Init();
                BillinCalcGrid."Contract ID" := RentCalc1."Contract ID";
                BillinCalcGrid."RevenueDescription" := RentCalc1."Secondary Item Type";
                BillinCalcGrid."Termination Date" := Rec."Termination Date";
                BillinCalcGrid."Property Classification" := Rec."Unit Type";
                BillinCalcGrid."Tenant ID" := Rec."Tenant ID";
                // BillinCalcGrid."VAT %" := RentCalc1."VAT %";
                if RentCalc1."VAT %" = RentCalc1."VAT %"::"5" then
                    vatper := 5
                else
                    vatper := 0;
                BillinCalcGrid."VAT %" := vatper;
                BillinCalcGrid.Insert();
                Clear(BillinCalcGrid);
            until RentCalc1.Next() = 0;

    end;


    procedure BillingCalcridTenancyContractSubpge()
    var
        BillingCalc1: Record "Final Billing Calculation Grid";
        TenancyContractLine2: Record "Tenancy Contract Subpage";
        vatper: Integer;

    begin
        // TenancyContractLine.Reset();
        TenancyContractLine2.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine2.FindSet() then
            repeat
                BillingCalc1.Init();
                BillingCalc1."Contract ID" := Rec."Contract ID";
                BillingCalc1."RevenueDescription" := TenancyContractLine2."Secondary Item Type";
                BillingCalc1."Termination Date" := Rec."Termination Date";
                BillingCalc1."Payment Type" := Format(TenancyContractLine2."Payment Type");
                BillingCalc1."Property Classification" := Rec."Unit Type";
                BillingCalc1."Tenant ID" := Rec."Tenant ID";
                // BillingCalc1."VAT %" := TenancyContractLine2."VAT %";
                if TenancyContractLine2."VAT %" = TenancyContractLine2."VAT %"::"5%" then
                    vatper := 5
                else
                    vatper := 0;
                BillingCalc1."VAT %" := vatper;
                BillingCalc1.Insert();
                Clear(BillingCalc1);
            until TenancyContractLine2.Next() = 0;
    end;



    /////// START POPULATED DATA IN PENDING RECIVEABLE //////////////////////

    procedure ReciveableCalcGridRentCalc()
    var

        RecvieableCalcGrid: Record "Pending Receviable Grid";
        RentCalc2: Record "Rent Calculation";

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        RecvieableCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if RecvieableCalcGrid.FindSet() then
            RecvieableCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc2.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc2.FindSet() then
            repeat
                RecvieableCalcGrid.Init();
                RecvieableCalcGrid."Contract ID" := RentCalc2."Contract ID";
                RecvieableCalcGrid."RevenueDescription" := RentCalc2."Secondary Item Type";
                RecvieableCalcGrid."Termination Date" := Rec."Termination Date";
                RecvieableCalcGrid."Tenant ID" := Rec."Tenant ID";
                RecvieableCalcGrid."Unit Type" := Rec."Unit Type";
                RecvieableCalcGrid.Insert();
                Clear(RecvieableCalcGrid);
            until RentCalc2.Next() = 0;
    end;


    procedure ReciveableCalcridTenancyContractSubpge()
    var
        RecvieableCalcGrid1: Record "Pending Receviable Grid";
        TenancyContractLine3: Record "Tenancy Contract Subpage";

    begin
        // TenancyContractLine.Reset();
        TenancyContractLine3.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine3.FindSet() then
            repeat
                RecvieableCalcGrid1.Init();
                RecvieableCalcGrid1."Contract ID" := Rec."Contract ID";
                RecvieableCalcGrid1."RevenueDescription" := TenancyContractLine3."Secondary Item Type";
                RecvieableCalcGrid1."Termination Date" := Rec."Termination Date";
                RecvieableCalcGrid1."Payment Type" := Format(TenancyContractLine3."Payment Type");
                RecvieableCalcGrid1.Insert();
                Clear(RecvieableCalcGrid1);
            until TenancyContractLine3.Next() = 0;
    end;

    ////////////////// END /////////////////////////


    ///////////// START Payment Details Grid ////////////////////////////

    procedure PaymentDetailsFromPaymentSchedule2()
    var
        paymentschedule2Card: Record "Payment Schedule2";
        paymentdetail: Record "Payment Details";
    begin
        paymentdetail.SetRange("Contract ID", Rec."Contract ID");
        if paymentdetail.FindSet() then
            paymentdetail.DeleteAll();


        paymentschedule2Card.SetRange("Contract ID", Rec."Contract ID");
        if paymentschedule2Card.FindSet() then
            repeat
                paymentdetail.Init();
                paymentdetail."Contract ID" := paymentschedule2Card."Contract ID";
                paymentdetail."Item Description" := paymentschedule2Card."Secondary Item Type";
                paymentdetail.Amount := paymentschedule2Card.Amount;
                paymentdetail."VAT Amount" := paymentschedule2Card."VAT Amount";
                paymentdetail."Amount Including VAT" := paymentschedule2Card."Amount Including VAT";
                paymentdetail."Payment Status" := paymentschedule2Card."Payment Status";
                paymentdetail."Payment Date" := paymentschedule2Card."Due Date";
                paymentdetail."Termination Date" := Rec."Termination Date";
                paymentdetail.Insert();
                Clear(paymentdetail);
            until paymentschedule2Card.Next() = 0;

    end;

    //////////// END //////////////////////////////////////////


    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure UpdateCanPost()
    begin
        CanPost := (Rec."Amount Refundable" <> 0) or (Rec."Net Receivable From The Tenant" <> 0);
    end;

    procedure FinalSettlementVisible()
    begin
        if (Rec."Amount Refundable" = 0) and (Rec."Net Receivable From The Tenant" = 0) then begin
            IsReceivable := false;
            IsRefundable := false;
        end;
    end;

    var
        IsReceivable: Boolean;
        IsRefundable: Boolean;
        CanPost: Boolean;
}