pageextension 50102 UnitManagement extends "O365 Activities"
{
    layout
    {

        modify("Sales This Month")
        {
            Visible = false;
        }
        modify("Overdue Sales Invoice Amount")
        {
            Visible = false;
        }
        modify("Overdue Purch. Invoice Amount")
        {
            Visible = false;
        }
        modify("Ongoing Sales")
        {
            Visible = false;
        }
        modify("Ongoing Purchases")
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
        modify("Incoming Documents")
        {
            Visible = false;
        }

        addafter("Ongoing Sales")
        {
            cuegroup("All")
            {
                Caption = 'All';
                field("All Property"; GetAllPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Property';
                    ToolTip = 'Count of all properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Property Registration List");
                    end;
                }
                field("All Unit"; GetAllUnitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Unit';
                    ToolTip = 'Count of all units.';

                    trigger OnDrillDown()
                    var
                        item: Record Item; // Replace with your actual Property Table
                        itemListPage: Page "Item List"; // Replace with your actual Item List Page
                    begin
                        item.SetRange("Item Template", item."Item Template"::Service); // Assuming you have a field to filter units
                        item.SetRange("Item type template", item."Item type template"::"Unit Service"); // Filter by Free status
                        // Drill down to the vacant property list page
                        itemListPage.SetTableView(item); // Set the filtered view
                        // PAGE.RUN(PAGE::"Item List");
                        itemListPage.Run(); // Open the Item List page with the filtered view
                    end;
                }
            }
            cuegroup("Property Type")
            {
                Caption = 'Property Type';
                field("Residential Property Count"; GetResidentialPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Residential property';
                    ToolTip = 'Count of Residential properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Residential Property List");
                    end;
                }
                field("Commercial Property Count"; GetCommercialPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commercial property';
                    ToolTip = 'Count of Commercial properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Commercial Property List");
                    end;
                }
                field("Common Property Count"; GetCommonPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Common property';
                    ToolTip = 'Count of Common properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Common Property List");
                    end;
                }
            }
            cuegroup("Unit Type")
            {
                Caption = 'Unit Type';
                field("Residential Unit Count"; GetResidentialunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Residential units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Residential Unit List");
                    end;
                }
                field("Commercial Unit Count"; GetCommercialunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commercial units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Commercial Unit List");
                    end;
                }
                field("Common Unit Count"; GetCommonunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Common units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Common Unit List");
                    end;
                }
            }
            cuegroup("Unit Status")
            {
                Caption = 'Unit Status'; // Adjust the caption as needed
                field("Free units Count"; GetFreeunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Free units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Free Unit List");
                    end;
                }
                field("Selected units Count"; GetSelectedunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selected units';
                    ToolTip = 'Count of selected units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Selected Unit List");
                    end;
                }
                field("Occupied units Count"; GetOccupiedunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Occupied units';
                    ToolTip = 'Count of occupied units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"Occupied Unit List");
                    end;
                }
            }
            cuegroup("Tenancy Contracts Statistics")
            {
                field("All Proposals Count"; GetAllProposalsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Proposals';
                    ToolTip = 'Count of all proposals.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the proposals list page
                        PAGE.RUN(PAGE::"Lease Proposal List");
                    end;
                }
                field("Active Contracts Count"; GetActiveContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Active Contracts';
                    ToolTip = 'Count of currently active contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"Active Contract List");
                    end;
                }
                field("Suspended Contracts Count"; GetSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suspended Contracts';
                    ToolTip = 'Count of currently suspended contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"Suspended Contract List");
                    end;
                }
                field("Contracts Expiring Soon"; GetExpiringContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contracts Expiring Soon';
                    ToolTip = 'Count of contracts expiring within 1 month.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the expiring contracts list page
                        PAGE.RUN(PAGE::"Expiring Contract List");
                    end;
                }
            }
            cuegroup("Sales Credit Memo")
            {
                field("Sales Credit Memo Count"; GetSalesCreditMemoCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memo';
                    ToolTip = 'Count of Posted Sales Credit Memos.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the Sales Credit Memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
                field("Full Adjusted Credit Memo Count"; GefulladjustedCreditMemoCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Full Adjusted Credit Memo';
                    ToolTip = 'Count of Sales Credit Memos with remaining amount 0.';
                    //  StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the fully adjusted credit memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
                field("Unpaid Credit Memo Count"; Getunpaidcreditmemo())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unpaid Credit Memo';
                    ToolTip = 'Count of Sales Credit Memos that are unpaid.';
                    StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the unpaid credit memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
            }
            cuegroup("Payments ")
            {
                field("Payments Due Within 10 Days"; GetPaymentsDueCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payments Due Within 10 Days';
                    ToolTip = 'Count of tenant payments due within the next 10 days.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the upcoming payments list page
                        PAGE.RUN(PAGE::"Upcoming Payments List");
                    end;
                }
                field("Overdue Payments"; GetOverduePaymentsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overdue Payments';
                    ToolTip = 'Count of tenant payments that are overdue (due date earlier than today).';
                    StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the overdue payments list page
                        PAGE.RUN(PAGE::"Overdue Payments List");
                    end;
                }
            }
            cuegroup("Suspended Contracts")
            {
                field("All Suspended Contracts Count"; GetSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Suspended Contracts';
                    ToolTip = 'Count of currently suspended contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"Suspended Contract List");
                    end;
                }
                field("Legally Suspended Contracts"; GetLegallySuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suspended Contracts-Legal';
                    ToolTip = 'Count of contracts suspended for legal reasons.';
                    StyleExpr = 'Attention';  // This will highlight the count to show it needs attention

                    trigger OnDrillDown()
                    begin
                        // Drill down to the legally suspended contracts list page
                        PAGE.RUN(PAGE::"Legal Suspended Contracts");
                    end;
                }
                field("Business Suspended Contracts"; GetBusinessSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Temporarily Suspended Contracts';
                    ToolTip = 'Count of contracts suspended for business reasons.';
                    StyleExpr = 'Ambiguous';  // This will highlight the count in a different color from legal suspensions

                    trigger OnDrillDown()
                    begin
                        // Drill down to the business suspended contracts list page
                        PAGE.RUN(PAGE::"Business Suspended Contracts");
                    end;
                }

            }
        }
    }

    procedure GetAllPropertiesCount(): Integer;
    var
        PropertyRec: Record "Property Registration"; // Replace with your actual Property Table
    begin
        // PropertyRec.SetRange(, 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetAllUnitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Item Template", PropertyRec."Item Template"::Service); // Assuming you have a field to filter units
        propertyRec.SetRange("Item type template", PropertyRec."Item type template"::"Unit Service"); // Filter by Free status
        // PropertyRec.SetRange(, 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetResidentialPropertiesCount(): Integer;
    var
        PropertyRec: Record "Property Registration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Property Classification", 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetCommercialPropertiesCount(): Integer;
    var
        PropertyRec: Record "Property Registration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Property Classification", 'Commercial'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetCommonPropertiesCount(): Integer;
    var
        PropertyRec: Record "Property Registration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Property Classification", 'Common'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetResidentialunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Usage Type", 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetCommercialunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Usage Type", 'Commercial'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetCommonunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("Usage Type", 'Common'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetFreeunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        // PropertyRec.SetRange("Unit Status", 'Free'); // Filter by Vacant status
        PropertyRec.SetRange("Unit Status", PropertyRec."Unit Status"::Free);

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetSelectedunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        // PropertyRec.SetRange("Unit Status", 'Selected'); // Filter by Vacant status
        PropertyRec.SetRange("Unit Status", PropertyRec."Unit Status"::Selected);

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetOccupiedunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        // PropertyRec.SetRange("Unit Status", 'Occupied'); // Filter by Vacant status
        PropertyRec.SetRange("Unit Status", PropertyRec."Unit Status"::Occupied);

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure GetAllProposalsCount(): Integer;
    var
        ProposalRec: Record "Lease Proposal Details"; // Replace with your actual Proposal Table
    begin
        // You can add filters here if needed
        exit(ProposalRec.Count()); // Return the count of all proposals
    end;

    procedure GetActiveContractsCount(): Integer;
    var
        ContractRec: Record "Tenancy Contract"; // Replace with your actual Contract Table
    begin
        ContractRec.SetRange("Tenant Contract Status", ContractRec."Tenant Contract Status"::Active); // Using the Option value instead of text
        exit(ContractRec.Count()); // Return the count of active contracts
    end;

    procedure GetSuspendedContractsCount(): Integer;
    var
        ContractRec: Record SuspendReasonTable; // Replace with your actual Contract Table
    begin
        ContractRec.SetRange("Tenant Contract Status", ContractRec."Tenant Contract Status"::Suspended); // Using the Option value instead of text
        ContractRec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count()); // Return the count of active contracts
    end;

    procedure GetExpiringContractsCount(): Integer;
    var
        ContractRec: Record "Tenancy Contract";
        CurrentDate: Date;
        OneMonthLater: Date;
    begin
        CurrentDate := TODAY;
        OneMonthLater := CALCDATE('<+1M>', CurrentDate);

        ContractRec.SetRange("Tenant Contract Status", ContractRec."Tenant Contract Status"::Active);
        ContractRec.SetFilter("Contract End Date", '%1..%2', CurrentDate, OneMonthLater);
        exit(ContractRec.Count());
    end;

    procedure GetPaymentsDueCount(): Integer;
    var
        PaymentRec: Record "Payment Mode2"; // Replace with your actual payment table name
        CurrentDate: Date;
        TenDaysLater: Date;
    begin
        CurrentDate := TODAY;
        TenDaysLater := CALCDATE('<+10D>', CurrentDate);

        // Only filter by due date, ignore payment status
        PaymentRec.SetFilter("Due Date", '%1..%2', CurrentDate, TenDaysLater);
        exit(PaymentRec.Count());
    end;

    procedure GetOverduePaymentsCount(): Integer;
    var
        PaymentRec: Record "Payment Mode2"; // Replace with your actual payment table name
    begin
        // Filter for payments with status Overdue
        PaymentRec.SetRange("Payment Status", PaymentRec."Payment Status"::Overdue);
        exit(PaymentRec.Count());
    end;

    procedure GetLegallySuspendedContractsCount(): Integer;
    var
        ContractRec: Record SuspendReasonTable;
    begin
        ContractRec.SetRange("Tenant Contract Status", ContractRec."Tenant Contract Status"::Suspended);
        ContractRec.SetRange(Reason, ContractRec.Reason::"Legal Reason"); // Adjust the field name and value as per your table structure
        ContractRec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count());
    end;

    procedure GetBusinessSuspendedContractsCount(): Integer;
    var
        ContractRec: Record SuspendReasonTable;
    begin
        ContractRec.SetRange("Tenant Contract Status", ContractRec."Tenant Contract Status"::Suspended);
        ContractRec.SetRange(Reason, ContractRec.Reason::"Business Reason"); // Adjust the field name and value as per your table structure
        ContractRec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count());
    end;

    procedure GetSalesCreditMemoCount(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos
    end;

    procedure GefulladjustedCreditMemoCount(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        SalesCreditMemoRec.SetRange("Remaining Amount", 0);
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos with remaining amount 0
    end;

    procedure Getunpaidcreditmemo(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        SalesCreditMemoRec.SetRange(Paid, false); // Assuming 'Paid' is a boolean field indicating if the credit memo is paid
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos with remaining amount 0
    end;
}

