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
                        PopulateRevisedCalculationGrid();
                        BillingCalcGridRentCalc();
                        BillingCalcridTenancyContractSubpge();
                        PopulateBillingCalculationGrid();
                        ReciveableCalcGridRentCalc();
                        ReciveableCalcridTenancyContractSubpge();
                        PopulatePendingReceivableGrid();
                        RecevieablePositiveamount();
                        RentCalculate();
                        OtherPaymentCalculate();
                        RevenueCalculateOneTime();
                        RevenueCalculate();
                        PaymentDetailsFromPaymentSchedule2();


                        Rec.CalculateFinalSummary(Rec);
                        CurrPage.UPDATE(false);
                        CurrPage."FinalRevenueCalculation".Page.UPDATE();
                        CurrPage."BillingCalculation".Page.UPDATE();
                        CurrPage."Pendingreceivable/Payable".Page.UPDATE();
                        CurrPage."Rent Calculation".Page.UPDATE();
                        CurrPage."Other Payment".Page.UPDATE();
                        CurrPage."Revenue Structure".Page.UPDATE();
                        CurrPage.PaymentDetails.Page.UPDATE();

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
                UpdatePropagation = Both;
            }

            part("BillingCalculation"; "Final Billing Calculation")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }



            part("Pendingreceivable/Payable"; "Pending Recevieable Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }

            group("Termination Additional Charges")
            {
                part("Additional Charges"; "Additional Charges Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Rent-Calculation")
            {
                part("Rent Calculation"; "Rent Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Revenue-structure")
            {
                part("Other Payment"; "OtherPayment Calculate SubCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Revenue structure - Yearly break-down")
            {
                part("Revenue Structure"; "Revenue Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
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
                UpdatePropagation = Both;
            }
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
                // field("Adjustment Security Deposit"; Rec."Adjustment Security Deposit")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     ToolTip = 'Displays the adjusted security deposit amount.';
                // }
                // field("Net Balance"; Rec."Net Balance")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     ToolTip = 'Shows the net balance after adjustments.';
                // }
            }
            part("Carry Forward"; "Carry Forward Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Carry Forward the Security Deposit To';
                UpdatePropagation = Both;
                Editable = false;
            }
            group("Refundable Deposits")
            {
                field("NetBalance"; Rec."Security Deposit")
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
                field("Remaining Security Deposit"; Rec."Remaining Security Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining security deposit after adjustments.';
                    Visible = false;
                }
                field("Remaining Chiller Deposit"; Rec."Remaining Chiller Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining chiller deposit after adjustments.';
                    Visible = false;
                }
                field("Remaining Other Deposit"; Rec."Remaining Other Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining other deposit after adjustments.';
                    Visible = false;
                }
            }
            part("Adjustment Deposits"; "Adjustment Deposits")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
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
                    UpdatePropagation = Both;
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
                    UpdatePropagation = Both;
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
                    ApprovalFinalCalculation.SetRange("FC ID", Rec."FC ID");

                    if ApprovalFinalCalculation.FindSet() then begin
                        ApprovalFinalCalculation."FC ID" := Rec."FC ID";
                        ApprovalFinalCalculation."Contract ID" := Rec."Contract ID";
                        ApprovalFinalCalculation."Tenant ID" := Rec."Tenant ID";
                        ApprovalFinalCalculation."Status" := Rec."Status";
                        ApprovalFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                        ApprovalFinalCalculation."Contract End Date" := Rec."Contract End Date";
                        ApprovalFinalCalculation."Termination Date" := Rec."Termination Date";
                        ApprovalFinalCalculation."Contract Amount" := Rec."Contract Amount";
                        ApprovalFinalCalculation."Link" := Rec."FC ID";
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
                        ApprovalFinalCalculation."Link" := Rec."FC ID";
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
        TenancyContractLine1.SetFilter("Amount Including VAT", '<>%1', 0);
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
    /////////////////////////////// Revised Calculation /////////////////

    procedure PopulateRevisedCalculationGrid()
    var
        FinalRevCalcGridRec2: Record "Final Revenue Calculation Grid";
    begin
        FinalRevCalcGridRec2.SetRange("Contract ID", Rec."Contract ID");
        if FinalRevCalcGridRec2.FindSet() then
            repeat
                GetAnnualRentAmountOfTerminationDateFromRentCalculation(FinalRevCalcGridRec2);
                GetAnnualAmountFromRevenueStructure(FinalRevCalcGridRec2);
                OneTimePaymentTypeRevisedRecalculatedAmount(FinalRevCalcGridRec2);
                GetRentAmountFromRentCalculation(FinalRevCalcGridRec2);
                GetRevisedAmountcalculatrefromRevenueStructuresubpage(FinalRevCalcGridRec2);
                DifferenceAmountCalculation(FinalRevCalcGridRec2);

            until FinalRevCalcGridRec2.Next() = 0;
    end;

    procedure GetAnnualRentAmountOfTerminationDateFromRentCalculation(var FinalRevenueCalculationGridRec: Record "Final Revenue Calculation Grid")
    var
        RentCalculation2: Record "Rent Calculation Subpage";
    // FinalRevenueCalculationGridRec: Record "Final Revenue Calculation Grid";
    begin
        RentCalculation2.SetRange("Contract ID", FinalRevenueCalculationGridRec."Contract ID");
        RentCalculation2.SetRange("Year", FinalRevenueCalculationGridRec."ContractYear(Termination Date)");
        RentCalculation2.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec."Revenue Description");
        if RentCalculation2.FindSet() then
            FinalRevenueCalculationGridRec."Annual Rent Amount TermiYear" := 0;
        FinalRevenueCalculationGridRec."Per Day Rent" := 0;
        repeat
            FinalRevenueCalculationGridRec."Annual Rent Amount TermiYear" += RentCalculation2."Final Annual Amount";
            FinalRevenueCalculationGridRec."Per Day Rent" += RentCalculation2."Per Day Rent";
            FinalRevenueCalculationGridRec.Modify();
        until RentCalculation2.Next() = 0;
    end;

    procedure GetAnnualAmountFromRevenueStructure(var FinalRevenueCalculationGridRec1: Record "Final Revenue Calculation Grid")
    var
        RevenueStructureSubpage: Record "Revenue Structure Subpage";

    begin
        RevenueStructureSubpage.SetRange("Contract ID", FinalRevenueCalculationGridRec1."Contract ID");
        RevenueStructureSubpage.SetRange("Year", FinalRevenueCalculationGridRec1."ContractYear(Termination Date)");
        RevenueStructureSubpage.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec1."Revenue Description");

        if RevenueStructureSubpage.FindSet() then
            repeat

                FinalRevenueCalculationGridRec1."Annual Rent Amount TermiYear" := RevenueStructureSubpage."Final Annual Amount";
                FinalRevenueCalculationGridRec1."Per Day Rent" := RevenueStructureSubpage."Final Annual Amount" / RevenueStructureSubpage."Number of Days";
                FinalRevenueCalculationGridRec1.Modify();
            until RevenueStructureSubpage.Next() = 0;

    end;

    procedure OneTimePaymentTypeRevisedRecalculatedAmount(var FinalRevenueCalculationGridRec2: Record "Final Revenue Calculation Grid")
    var
        TenancyContractsubpage: Record "Tenancy Contract Subpage";
    begin
        TenancyContractsubpage.SetRange(ContractID, FinalRevenueCalculationGridRec2."Contract ID");
        TenancyContractsubpage.SetRange("Payment Type", 1);
        TenancyContractsubpage.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec2."Revenue Description");
        if TenancyContractsubpage.FindSet() then
            repeat
                FinalRevenueCalculationGridRec2."Revised Amount" := TenancyContractsubpage.Amount;
                FinalRevenueCalculationGridRec2."Revised VAT %" := TenancyContractsubpage."VAT %";
                if FinalRevenueCalculationGridRec2."Revised VAT %" = 1 then
                    FinalRevenueCalculationGridRec2."Revised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec2."Revised VAT %" := 0;
                FinalRevenueCalculationGridRec2."Revised VAT" := TenancyContractsubpage."VAT Amount";
                FinalRevenueCalculationGridRec2."Revised Amount Incl." := TenancyContractsubpage."Amount Including VAT";
                FinalRevenueCalculationGridRec2.Modify();
            //  Clear(FinalRevenueCalculation);
            until TenancyContractsubpage.Next() = 0;

    end;


    procedure GetRentAmountFromRentCalculation(var FinalRevenueCalculationGridRec3: Record "Final Revenue Calculation Grid")
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
        RentCalculation.SetRange("Contract ID", FinalRevenueCalculationGridRec3."Contract ID");
        RentCalculation.SetFilter(Year, '1..%1', FinalRevenueCalculationGridRec3."ContractYear(Termination Date)");

        if RentCalculation.FindSet() then begin
            repeat
                // Sum up Final Annual Amount values
                TotalAmount += RentCalculation."Final Annual Amount";
                TotalVATAmount += RentCalculation."VAT Amount"
            until RentCalculation.Next() = 0;
        end;
        RentCalculation1.SetRange("Contract ID", FinalRevenueCalculationGridRec3."Contract ID");
        RentCalculation1.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec3."Revenue Description");
        if RentCalculation1.FindSet() then
            repeat
                FinalReviseAmount := Totalamount - FinalRevenueCalculationGridRec3."Annual Rent Amount TermiYear";
                calculateteminationamount := FinalRevenueCalculationGridRec3."Per Day Rent" * FinalRevenueCalculationGridRec3."Total No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                FinalRevenueCalculationGridRec3."Revised Amount" := FinalReviseAmount + calculateteminationamount;
                FinalRevenueCalculationGridRec3."Revised VAT %" := RentCalculation1."VAT %";

                if FinalRevenueCalculationGridRec3."Revised VAT %" = 1 then
                    FinalRevenueCalculationGridRec3."Revised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec3."Revised VAT %" := 0;
                // TotalVATAmount := FinalRevenueCalculationGridRec3."Revised Amount" - (FinalRevenueCalculationGridRec3."Revised Amount" / (1 + (FinalRevenueCalculationGridRec3."Revised VAT %" / 100)));
                // TotalVATAmount := Round(TotalVATAmount, 0.01);
                TotalVATAmount := (FinalRevenueCalculationGridRec3."Revised Amount" * FinalRevenueCalculationGridRec3."Revised VAT %") / 100;

                FinalRevenueCalculationGridRec3."Revised VAT" := TotalVATAmount;
                FinalRevenueCalculationGridRec3."Revised Amount Incl." := FinalRevenueCalculationGridRec3."Revised Amount" + FinalRevenueCalculationGridRec3."Revised VAT";
                FinalRevenueCalculationGridRec3.Modify();
            until RentCalculation1.Next() = 0;
    end;

    procedure GetRevisedAmountcalculatrefromRevenueStructuresubpage(var FinalRevenueCalculationGridRec4: Record "Final Revenue Calculation Grid")
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
        RevenueStructureSubpage1.SetRange("Contract ID", FinalRevenueCalculationGridRec4."Contract ID");
        RevenueStructureSubpage1.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec4."Revenue Description");
        RevenueStructureSubpage1.SetFilter(Year, '1..%1', FinalRevenueCalculationGridRec4."ContractYear(Termination Date)");


        if RevenueStructureSubpage1.FindSet() then begin
            repeat
                // Sum up Final Annual Amount values
                ChargesItemTotalamount += RevenueStructureSubpage1."Final Annual Amount";
                ChargesItemTotalVATAmount += RevenueStructureSubpage1."VAT Amount"
            until RevenueStructureSubpage1.Next() = 0;
        end;
        RevenueStructureSubpage2.SetRange("Contract ID", FinalRevenueCalculationGridRec4."Contract ID");
        RevenueStructureSubpage2.SetRange("Secondary Item Type", FinalRevenueCalculationGridRec4."Revenue Description");
        if RevenueStructureSubpage2.FindSet() then
            repeat
                FinalReviseAmount := ChargesItemTotalamount - FinalRevenueCalculationGridRec4."Annual Rent Amount TermiYear";
                calculateteminationamount1 := FinalRevenueCalculationGridRec4."Per Day Rent" * FinalRevenueCalculationGridRec4."Total No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                FinalRevenueCalculationGridRec4."Revised Amount" := FinalReviseAmount + calculateteminationamount1;
                FinalRevenueCalculationGridRec4."Revised VAT %" := RevenueStructureSubpage2."VAT %";
                if FinalRevenueCalculationGridRec4."Revised VAT %" = 1 then
                    FinalRevenueCalculationGridRec4."Revised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec4."Revised VAT %" := 0;

                // ChargesItemTotalVATAmount := FinalRevenueCalculationGridRec4."Revised Amount" - (FinalRevenueCalculationGridRec4."Revised Amount" / (1 + (FinalRevenueCalculationGridRec4."Revised VAT %" / 100)));
                // ChargesItemTotalVATAmount := Round(ChargesItemTotalVATAmount, 0.01);
                ChargesItemTotalVATAmount := (FinalRevenueCalculationGridRec4."Revised Amount" * FinalRevenueCalculationGridRec4."Revised VAT %") / 100;

                FinalRevenueCalculationGridRec4."Revised VAT" := ChargesItemTotalVATAmount;
                FinalRevenueCalculationGridRec4."Revised Amount Incl." := FinalRevenueCalculationGridRec4."Revised Amount" + FinalRevenueCalculationGridRec4."Revised VAT";
                FinalRevenueCalculationGridRec4.Modify();

            until RevenueStructureSubpage2.Next() = 0;
    end;

    procedure DifferenceAmountCalculation(var FinalRevenueCalculationGridRec5: Record "Final Revenue Calculation Grid")
    var

    begin


        FinalRevenueCalculationGridRec5."Difference Amount" := FinalRevenueCalculationGridRec5."Original Amount" - FinalRevenueCalculationGridRec5."Revised Amount";
        FinalRevenueCalculationGridRec5."Difference VAT" := FinalRevenueCalculationGridRec5."Original VAT" - FinalRevenueCalculationGridRec5."Revised VAT";
        FinalRevenueCalculationGridRec5."Difference Amount Incl." := FinalRevenueCalculationGridRec5."Original Amount Incl." - FinalRevenueCalculationGridRec5."Revised Amount Incl.";
        FinalRevenueCalculationGridRec5.Modify();


    end;


    ////////////////////// END REVISED CALCULATION ////////////////////////














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
            Rec."Per Day Rent" := 0;
        Rec."Annual Rent Amount TermiYear" := 0;
        repeat
            Rec."Per Day Rent" += RentCalculation1."Per Day Rent";
            DifferenceDays := Rec."Termination Date" - RentCalculation1."Period Start Date";
            Rec."Total No. Of Days" := DifferenceDays + 1;
            Rec."Annual Rent Amount TermiYear" += RentCalculation1."Final Annual Amount";
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
                RevenueCalculates."Amount Including VAT" := RevenueCalculates.Amount + RevenueCalculates."VAT Amount";
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
                RevenueCalculateSub."Amount Including VAT" := RevenueCalculateSub."Amount" + RevenueStructureSub."VAT Amount";
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
        CurrPage."Carry Forward".Page.SetContractId(Rec."Contract ID");
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
        CurrPage."Carry Forward".Page.SetContractId(Rec."Contract ID");
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
        CurrPage."Carry Forward".Page.SetContractId(Rec."Contract ID");
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
        CurrPage."Carry Forward".Page.SetContractId(Rec."Contract ID");
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
        TenancyContractLine2.SetFilter("Amount Including VAT", '<>%1', 0);
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


    ////////////////// END /////////////////////////


    ///////////////////////// Billing Invoiced Calculation //////////////////////


    procedure PopulateBillingCalculationGrid()
    var
        FinalBillingGridRec: Record "Final Billing Calculation Grid";
    begin
        FinalBillingGridRec.SetRange("Contract ID", Rec."Contract ID");
        if FinalBillingGridRec.FindSet() then
            repeat
                FetchDataFromRevenueCalcGrid(FinalBillingGridRec);
                Invoiceamountfrompaymentscheule(FinalBillingGridRec);
                DifferenceAmountCalculationBilling(FinalBillingGridRec);
                CreditNoteTotalAmount(FinalBillingGridRec);
                InvoiceTotalAmount(FinalBillingGridRec);
            until FinalBillingGridRec.Next() = 0;
    end;

    procedure FetchDataFromRevenueCalcGrid(var BillingCalcGrid: Record "Final Billing Calculation Grid")
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        RevenueGrid.SetRange("Revenue Description", BillingCalcGrid.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                BillingCalcGrid.RevisedAmount := RevenueGrid."Revised Amount";
                BillingCalcGrid.RevisedVAT := RevenueGrid."Revised VAT";
                BillingCalcGrid.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
                BillingCalcGrid.Modify();
            until RevenueGrid.Next() = 0;

    end;


    procedure Invoiceamountfrompaymentscheule(var BillingCalcGrid: Record "Final Billing Calculation Grid")
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        //PaymentScheduleRec.SetFilter("Due Date", '<%1', Rec."Termination Date");
        PaymentScheduleRec.SetFilter("Workflow frequency date", '<=%1', BillingCalcGrid."Termination Date");
        PaymentScheduleRec.SetRange(Invoiced, true);
        PaymentScheduleRec.SetFilter("Invoice Approval Status", 'Approved');
        PaymentScheduleRec.SetRange("Secondary Item Type", BillingCalcGrid.RevenueDescription);

        if PaymentScheduleRec.FindSet() then begin
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

            until PaymentScheduleRec.Next() = 0;
        end;
        PaymentScheduleRec.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", BillingCalcGrid.RevenueDescription);

        if PaymentScheduleRec.FindSet() then
            repeat
                BillingCalcGrid.InvoicedAmount := Totalamount;
                BillingCalcGrid.InvoicedVAT := VATAmount;
                BillingCalcGrid.InvoicedAmountInclVAT := AmountIncVAT;
                BillingCalcGrid.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;




    procedure CreditNoteTotalAmount(var BillingCalcGrid: Record "Final Billing Calculation Grid")
    var
        TotalPositiveAmount: Decimal;
        billingcalculationgird1: Record "Final Billing Calculation Grid";
        billingcalculationgird2: Record "Final Billing Calculation Grid";
    begin
        // Calculate total positive difference for the whole contract
        TotalPositiveAmount := 0;
        billingcalculationgird1.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        billingcalculationgird1.SetFilter("DifferenceAmountInclVAT", '>%1', 0);
        if billingcalculationgird1.FindSet() then
            repeat
                TotalPositiveAmount += billingcalculationgird1."DifferenceAmountInclVAT";
            until billingcalculationgird1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        billingcalculationgird2.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        if billingcalculationgird2.FindSet() then
            repeat
                billingcalculationgird2."Credit Note To Be Raised" := Abs(TotalPositiveAmount);
                billingcalculationgird2."Credit Note Amount" := Abs(TotalPositiveAmount);
                billingcalculationgird2.Modify();
            until billingcalculationgird2.Next() = 0;
    end;


    procedure InvoiceTotalAmount(var BillingCalcGrid: Record "Final Billing Calculation Grid")
    var
        TotalNegativeDifference: Decimal;
        billingcalculationgird1: Record "Final Billing Calculation Grid";
        billingcalculationgird2: Record "Final Billing Calculation Grid";
    begin
        // Calculate total negative difference for the whole contract
        TotalNegativeDifference := 0;
        billingcalculationgird1.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        billingcalculationgird1.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
        if billingcalculationgird1.FindSet() then
            repeat
                TotalNegativeDifference += billingcalculationgird1."DifferenceAmountInclVAT";
            until billingcalculationgird1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        billingcalculationgird2.SetRange("Contract ID", BillingCalcGrid."Contract ID");
        if billingcalculationgird2.FindSet() then
            repeat
                // Keep already invoiced lines at zero (existing business rule)
                if billingcalculationgird2.Invoiced then
                    billingcalculationgird2."Invoice To Be Raised" := 0
                else
                    billingcalculationgird2."Invoice To Be Raised" := Abs(TotalNegativeDifference);
                billingcalculationgird2."Invoice Amount" := Abs(TotalNegativeDifference);
                billingcalculationgird2.Modify();
            until billingcalculationgird2.Next() = 0;
    end;

    procedure DifferenceAmountCalculationBilling(var BillingCalcGrid: Record "Final Billing Calculation Grid")
    var

    begin

        BillingCalcGrid."DifferenceAmount" := BillingCalcGrid.InvoicedAmount - BillingCalcGrid.RevisedAmount;
        BillingCalcGrid."DifferenceVAT" := BillingCalcGrid.InvoicedVAT - BillingCalcGrid.RevisedVAT;
        BillingCalcGrid.DifferenceAmountInclVAT := BillingCalcGrid.InvoicedAmountInclVAT - BillingCalcGrid.RevisedAmountInclVAT;
        BillingCalcGrid.Modify();

    end;



    ////////////////////// End Billing Invoiced Calculation //////////////////////


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
        TenancyContractLine3.SetFilter("Amount Including VAT", '<>%1', 0);
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

    //////////////////////// START PENDING RECIVEABLE CALCULATION //////////////////////

    procedure PopulatePendingReceivableGrid()
    var
        PendingReceivableGrid: Record "Pending Receviable Grid";
    begin
        PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
        if PendingReceivableGrid.FindSet() then
            repeat
                FetchDataFromRevenueCalcGrid(PendingReceivableGrid);
                Recvieableamountfrompaymentscheule(PendingReceivableGrid);
                DifferenceAmountCalculationReceivable(PendingReceivableGrid);
            //  RecevieablePositiveamount(PendingReceivableGrid);
            until PendingReceivableGrid.Next() = 0;


    end;

    procedure FetchDataFromRevenueCalcGrid(var pendingReceiveable: Record "Pending Receviable Grid")
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", pendingReceiveable."Contract ID");
        RevenueGrid.SetRange("Revenue Description", pendingReceiveable.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                pendingReceiveable.RevisedAmount := RevenueGrid."Revised Amount";
                pendingReceiveable.RevisedVAT := RevenueGrid."Revised VAT";
                pendingReceiveable.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
                pendingReceiveable.Modify();
            until RevenueGrid.Next() = 0;

    end;

    procedure Recvieableamountfrompaymentscheule(var pendingReceiveable: Record "Pending Receviable Grid")
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", pendingReceiveable."Contract ID");
        PaymentScheduleRec.SetFilter("Due Date", '<=%1', pendingReceiveable."Termination Date");
        PaymentScheduleRec.SetRange("Payment Status", 'Received');
        PaymentScheduleRec.SetRange("Secondary Item Type", pendingReceiveable.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

            until PaymentScheduleRec.Next() = 0;

        PaymentScheduleRec.SetRange("Contract ID", pendingReceiveable."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", pendingReceiveable.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                pendingReceiveable.ReceiptsAmount := Totalamount;
                pendingReceiveable.ReceiptsVAT := VATAmount;
                pendingReceiveable.ReceiptsAmountInclVAT := AmountIncVAT;
                pendingReceiveable.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;

    procedure DifferenceAmountCalculationReceivable(var RecvieableCalcGrid: Record "Pending Receviable Grid")

    begin

        RecvieableCalcGrid.DifferenceAmount := RecvieableCalcGrid.RevisedAmount - RecvieableCalcGrid.ReceiptsAmount;
        RecvieableCalcGrid.DifferenceVAT := RecvieableCalcGrid.RevisedVAT - RecvieableCalcGrid.ReceiptsVAT;
        RecvieableCalcGrid.DifferenceAmountInclVAT := RecvieableCalcGrid.RevisedAmountInclVAT - RecvieableCalcGrid.ReceiptsAmountInclVAT;
        RecvieableCalcGrid.Modify();

    end;

    procedure RecevieablePositiveamount()
    var
        pendingReceieableRecGrid: Record "Pending Receviable Grid";
    begin
        pendingReceieableRecGrid.SetRange("Contract ID", Rec."Contract ID");
        if pendingReceieableRecGrid.FindSet() then
            repeat
                pendingReceieableRecGrid.CalcFields("Total DifferenceAmountIncl.VAT");
                if pendingReceieableRecGrid."Total DifferenceAmountIncl.VAT" < 0 then begin
                    pendingReceieableRecGrid."Total Refundable" := Abs(pendingReceieableRecGrid."Total DifferenceAmountIncl.VAT");
                    pendingReceieableRecGrid.Modify();
                end else begin
                    pendingReceieableRecGrid."Total Receivable" := pendingReceieableRecGrid."Total DifferenceAmountIncl.VAT";
                    pendingReceieableRecGrid.Modify();

                end;
            until pendingReceieableRecGrid.Next() = 0;
    end;

    //////////////////////// END PENDING RECIVEABLE CALCULATION //////////////////////

    var
        carryForwardGrid: Page "Carry Forward Grid";
        IsReceivable: Boolean;
        IsRefundable: Boolean;
        CanPost: Boolean;
}