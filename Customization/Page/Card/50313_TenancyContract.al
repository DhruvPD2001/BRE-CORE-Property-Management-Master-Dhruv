page 50313 "Tenancy Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Tenancy Contract";
    Caption = 'Tenancy Contract';

    layout
    {
        area(content)
        {
            // Group for General Information
            group("General Info")
            {
                Caption = 'General Information';


                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract Type"; rec."Contract Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                        UpdateFieldsEnable();
                        //  CurrPage.SaveRecord();
                    end;
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = ProposalIDEnabled;
                    trigger OnValidate()
                    begin
                        // CurrPage.SaveRecord();
                    end;

                }

                field("Renewal Proposal ID"; rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = RenewalProposalIDEnabled;
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."Owner's Name")
                {
                    ApplicationArea = All;
                }
                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Lessor's Name"; rec."Lessor's Name")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Emirates ID"; rec."Lessor's Emirates ID")
                {
                    ApplicationArea = All;
                }

                field("License No."; rec."License No.")
                {
                    ApplicationArea = All;
                }

                field("Licensing Authority"; rec."Licensing Authority")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Email"; rec."Lessor's Email")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Phone"; rec."Lessor's Phone")
                {
                    ApplicationArea = All;
                }
                field("Lessor's Address"; Rec."Lessor's Address")
                {
                    ApplicationArea = All;
                }
                field("Lessor's Nationality"; Rec."Lessor's Nationality")
                {
                    ApplicationArea = All;
                }
            }

            // Group for Tenant and Customer Information
            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Emirates ID"; rec."Emirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contact Number"; rec."Contact Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Email Address"; rec."Email Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant_License No."; Rec."Tenant_License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant_Licensing Authority"; Rec."Tenant_Licensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
            }

            // Group for Property Information
            group("Property Info")
            {
                Caption = 'Property Information';
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Classification"; rec."Property Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Property Type"; rec."Property Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Praposal Type Selected"; rec."Praposal Type Selected")
                {
                    ApplicationArea = All;
                    // Lookup = true; // Enable lookup for Property ID
                    Caption = 'Unit Category';
                    Editable = false;

                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit Address"; rec."Unit Address")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Unit Classification"; rec."Usage Type")
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("Unit Type"; rec."Unit Type")
                {
                    ApplicationArea = All;
                    Editable = false;

                }



                field("Uniq Unit ID"; Rec.UnitID) // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Uniq Unit ID';
                    Editable = false;
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Ejari Name"; Rec."Ejari Name")
                {
                    ApplicationArea = All;
                }
                field("Unit Sq. Feet"; Rec."Unit Sq. Feet")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Size"; Rec."Property Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Emirate; Rec.Emirate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Community; Rec.Community)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Facilities/Amenities"; rec."Facilities/Amenities")
                {
                    ApplicationArea = All;
                }
            }

            // Group for Contract Information
            group("Contract Details")
            {
                Caption = 'Contract Details';
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Contract Tenor"; Rec."Contract Tenor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract VAT %"; Rec."Contract VAT %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract VAT Amount"; Rec."Contract VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract Amount Including VAT"; Rec."Contract Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Annual Rent Amount"; Rec."Annual Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Payment Frequency"; rec."Payment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';
                    Editable = false;
                }
                field("Payment Method"; rec."Payment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                }
                field("No of Installments"; rec."No of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    // Visible = false;
                }
            }
            group("Security Deposit")
            {
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Balance Amount"; Rec."Security Deposit Amt. Received")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Received';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }
                field("Security Amount Received"; Rec."Security Amount Pending")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Pending';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }

                field("Security Balanced Amount"; Rec."Security Balanced Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Balance';
                }
            }

            // Group for Grace Period Information
            group("Grace Period Info")
            {
                Caption = 'Grace Period Information';

                field("Grace Start Date"; Rec."Grace Start Date")
                {
                    ApplicationArea = All;
                }
                field("Grace End Date"; Rec."Grace End Date")
                {
                    ApplicationArea = All;
                }
                field("Grace Period"; Rec."Grace Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Handover is Completed"; rec."Handover is Completed")
                {
                    ApplicationArea = All;
                }

                field("Handover of PDC"; rec."Handover of PDC")
                {
                    ApplicationArea = All;
                }
                field("Signed TC Document"; rec."Signed TC Document")
                {
                    ApplicationArea = All;
                }
                field("Handover Unit"; rec."Handover Unit")
                {
                    ApplicationArea = All;
                }

                field("Single Rent Calculation"; Rec."Single Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Single Unit";

                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Merge Rent Calculation"; Rec."Merge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit";

                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }


                field("Upload Document"; Rec."Upload Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'TenancyContractDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Upload Document" := fileName;
                            Rec."view Document" := uploadResult;
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("view Document"; Rec."view Document")
                {
                    ApplicationArea = All;
                    Editable = true;
                    DrillDown = true;
                    Visible = false;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."view Document";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }
                // field("Update Contract Status"; Rec."Update Contract Status")
                // {
                //     ApplicationArea = All;
                //     trigger OnValidate()
                //     begin
                //         // Check if "Update Contract Status" has a value other than its default (e.g., <Blank>)
                //         if Rec."Update Contract Status" <> Rec."Update Contract Status"::" " then
                //             Rec."Yes/No" := true
                //         else
                //             Rec."Yes/No" := false;
                //     end;
                // }

                // field("Yes/No"; rec."Yes/No")
                // {
                //     ApplicationArea = All;
                //     Editable = true;
                // }


                field("Renewal Contract Status"; rec."Renewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                }

                field("Renewal Notification to Tenant"; rec."Renewal Notification to Tenant")
                {
                    ApplicationArea = All;
                }

                field("Tenant Loyalty Check Reminder"; rec."Tenant Loyalty Check Reminder")
                {
                    ApplicationArea = All;
                }

                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                }





                // field("Suspended Reason list"; Rec."Suspended Reason list")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Click to open the Suspended Reason List.';
                //     Style = Strong; // Makes the field look like a hyperlink
                //     StyleExpr = true;

                //     trigger OnAssistEdit()
                //     var
                //         SuspendedReasonRec: Record "SuspendReasonTable";
                //     begin
                //         // Filter the Suspended Reason List page by the current Contract ID
                //         SuspendedReasonRec.SetRange("Contract ID", Rec."Contract ID");
                //         Page.Run(Page::"SuspendReasonList", SuspendedReasonRec);
                //     end;
                // }


                // field("Tenant Contract Status"; rec."Tenant Contract Status")
                // {
                //     ApplicationArea = All;
                //     Editable = false;

                //     trigger OnValidate()
                //     begin
                //         // Check if the contract status is either "Terminated" or "Renewed"
                //         if (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Terminated") or
                //            (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Contract Renewed") then
                //             IsVisible := true  // Link should be visible
                //         else
                //             IsVisible := false; // Link should be hidden
                //     end;
                // }
                // field("Termination Of Contract"; rec."Termination Of Contract")
                // {
                //     ApplicationArea = All;

                //     trigger OnValidate()
                //     begin

                //         if Rec."Termination Of Contract" = Rec."Termination Of Contract"::" " then
                //             IsVisible := false  // Link should be visible
                //         else
                //             IsVisible := true; // Link should be hidde

                //     end;
                // }


                // field("Status"; Rec."Status")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Visible = IsVisible; // Show the Status field only when it is not blank

                //     trigger OnValidate()
                //     begin
                //         if Rec."Status" = '' then
                //             IsVisible := false  // Hide all fields when status is blank
                //         else
                //             IsVisible := true;  // Show fields when status is not blank

                //         if Rec.Status = 'End Contract' then
                //             Rec."Termination Of Contract" := Rec."Termination Of Contract"::"Regular Termination";
                //         Rec.Modify();
                //     end;

                // }

                // group(FinalCalculation)
                // {
                //     Visible = IsVisible;
                //     ShowCaption = false;
                //     field("Final Calculation"; rec."Final Calculation")
                //     {
                //         ApplicationArea = All;
                //         DrillDown = true;
                //         // Show or hide based on status
                //         //Visible = Status = Status::Approved; // This will show the field only if status is "Approved"

                //         trigger OnDrillDown()
                //         var
                //             TenancyRecord: Record "Tenancy Contract"; // Replace with the actual table name
                //             FinalCalculation: Record "Final Calculation";
                //             InstallmentStructure: Record "Revenue Structure Subpage1"; // Second Table
                //                                                                        //CarryForwardGrid: Record "Carry Forward Grid";
                //                                                                        // SecurityDeposit: Record "Security Deposit";
                //             StartDate: Date;
                //             EndDate: Date;
                //             DaysDiff: Integer;
                //             DaysCal: Integer;
                //             TerminateDate: Date;
                //             FinalCalculationid: Integer;
                //         begin
                //             FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                //             FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                //             if FinalCalculation.FindSet() then begin
                //                 FinalCalculation."Contract ID" := Rec."Contract ID";
                //                 FinalCalculation."Tenant ID" := Rec."Tenant ID";
                //                 FinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                //                 FinalCalculation."Contract End Date" := Rec."Contract End Date";
                //                 FinalCalculation."Unit Type" := Rec."Usage Type";
                //                 FinalCalculation."Contract Amount" := Rec."Annual Rent Amount";
                //                 // Add security deposit information
                //                 // FinalCalculation."Security Deposit" := Rec."Security Deposit Amount";
                //                 // FinalCalculation."Adjustment Security Deposit" := Rec."Security Balanced Amount";
                //                 // FinalCalculation."Net Balance" := Rec."Security Deposit Amount" - Rec."Security Balanced Amount";
                //                 FinalCalculation.Modify();
                //                 Message('Record Modifyed Successfully');
                //             end else begin
                //                 FinalCalculation.Init();
                //                 FinalCalculation."Contract ID" := Rec."Contract ID";
                //                 FinalCalculation."Tenant ID" := Rec."Tenant ID";
                //                 FinalCalculation."Unit Type" := Rec."Usage Type";
                //                 FinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                //                 FinalCalculation."Contract End Date" := Rec."Contract End Date";
                //                 FinalCalculation."Contract Amount" := Rec."Annual Rent Amount";
                //                 // Add security deposit information
                //                 // FinalCalculation."Security Deposit" := Rec."Security Deposit Amount";
                //                 // FinalCalculation."Adjustment Security Deposit" := Rec."Security Balanced Amount";
                //                 // FinalCalculation."Net Balance" := Rec."Security Deposit Amount" - Rec."Security Balanced Amount";
                //                 FinalCalculation.Insert();
                //                 Message('Record Created Successfully');
                //             end;

                //             StartDate := Rec."Contract Start Date";
                //             EndDate := Rec."Contract End Date";
                //             DaysDiff := EndDate - StartDate + 1;
                //             FinalCalculation."Original Contract Tenure" := DaysDiff;
                //             FinalCalculation.Modify(true);

                //             FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                //             FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                //             if FinalCalculation.FindSet() then begin
                //                 // If found, get the latest RS ID
                //                 FinalCalculationid := FinalCalculation."FC ID";
                //             end else begin
                //                 // If no record is found, create a new Revenue Structure record
                //                 FinalCalculation.Init();
                //                 FinalCalculation.Insert(true);
                //                 FinalCalculation.Modify(true);  // Insert the new record and generate the RS ID

                //                 // Get the newly created RS ID
                //                 FinalCalculationid := FinalCalculation."FC ID";
                //             end;
                //             Rec."Link" := FinalCalculationid;

                //             // Handle carry forward grid for security deposits
                //             // SecurityDeposit.Reset();
                //             // SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

                //             // if SecurityDeposit.FindSet() then begin
                //             //     repeat
                //             //         // Check if a Carry Forward Grid record already exists
                //             //         CarryForwardGrid.Reset();
                //             //         CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
                //             //         CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
                //             //         CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."New_Security Deposit Amount"); // Additional Check

                //             //         if not CarryForwardGrid.FindFirst() then begin
                //             //             // Create new record only if it doesn't exist
                //             //             CarryForwardGrid.Init();
                //             //             // Get the next available Entry No.
                //             //             CarryForwardGrid."Entry No." := GetNextEntryNo();
                //             //             CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
                //             //             CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
                //             //             CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                //             //             CarryForwardGrid."Security Deposit" := 'Security Deposit';
                //             //             CarryForwardGrid.Insert();
                //             //         end else begin
                //             //             // Update existing record
                //             //             CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                //             //             CarryForwardGrid."Security Deposit" := 'Security Deposit';
                //             //             CarryForwardGrid.Modify();
                //             //         end;
                //             //     until SecurityDeposit.Next() = 0;
                //             // end else begin
                //             //     // If no Security Deposit records exist, create a basic Carry Forward Grid record
                //             //     CarryForwardGrid.Reset();
                //             //     CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

                //             //     if not CarryForwardGrid.FindFirst() then begin
                //             //         CarryForwardGrid.Init();
                //             //         // Get the next available Entry No.
                //             //         CarryForwardGrid."Entry No." := GetNextEntryNo();
                //             //         CarryForwardGrid."Contract ID" := Rec."Contract ID";
                //             //         // You'll need to determine the New Contract ID from elsewhere
                //             //         CarryForwardGrid."Total Amount" := Rec."Security Deposit Amount";
                //             //         CarryForwardGrid."Security Deposit" := 'Security Deposit';
                //             //         CarryForwardGrid.Insert();
                //             //     end;
                //             // end;
                //         end;
                //     }



                //     field("Link"; Rec."Link")
                //     {
                //         ApplicationArea = All;
                //         DrillDown = true;


                //         trigger OnDrillDown()
                //         var
                //             FinalCalculation: Record "Final Calculation";
                //             FinalCalculationid: Integer;
                //         begin
                //             // Navigate to the Revenue Structure Card page
                //             if FinalCalculation.Get(Rec."Link") then
                //                 PAGE.RUN(PAGE::"Final Calculation Card", FinalCalculation)
                //             else
                //                 Message('The related Revenue Structure does not exist.')
                //         end;

                //     }
                // }

                // field("Update Data"; Rec."Update Data")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     DrillDown = true;


                //     trigger OnDrillDown()
                //     var
                //         SingleUnitName: Text;
                //         CommaPos: Integer;
                //         RentRecord: Record "Rent Calculation";
                //         Tenancycontract: Record "Tenancy Contract";
                //         SU_samesquare: Record "TC Single Unit Rent SubPage";
                //         SU_lumpsum: Record "TC Single LumAnnualAmnt SP";
                //         MU_samesquare: Record "TC Merge SameSqure SubPage";
                //         MU_differentsquare: Record "TC Merge DifferentSq SubPage";
                //         MU_lumpsum: Record "TC Merge LumAnnualAmount SP";
                //         RentSubpage: Record "Rent Calculation Subpage";
                //         InstallmentAmount: Decimal;
                //         TotalCalculatedAmount: Decimal;
                //         LastInstallmentAmount: Decimal;
                //         Lastyear: Integer;
                //         InstallmentAmount2: Decimal;
                //         Year: Integer;
                //     begin
                //         // Find the Tenancy Contract record
                //         Tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                //         Tenancycontract.SetRange("Tenant ID", Rec."Tenant ID");
                //         if Tenancycontract.FindFirst() then begin
                //             // Set fields for RentCalculation record
                //             RentRecord."Contract ID" := Tenancycontract."Contract ID";
                //             RentRecord."Property Classification" := Tenancycontract."Property Classification";
                //             RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                //             RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                //             RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                //             RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                //             RentRecord."Secondary Item Type" := 'Rent';
                //             RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                //             RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                //             RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                //             RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                //             // Check if Rent Calculation exists, then modify or insert
                //             RentRecord.SetRange("Contract ID", Rec."Contract ID"); // Ensure you're looking for the correct Contract ID

                //             if RentRecord.FindFirst() then begin
                //                 // If Rent Calculation exists, modify it
                //                 RentRecord.Modify();
                //                 Message('Record Modified Successfully');
                //                 exit;
                //             end else begin
                //                 // If Rent Calculation doesn't exist, insert a new one
                //                 RentRecord.Init();
                //                 RentRecord."Contract ID" := Tenancycontract."Contract ID";
                //                 RentRecord."Property Classification" := Tenancycontract."Property Classification";
                //                 RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                //                 RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                //                 RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                //                 RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                //                 RentRecord."Secondary Item Type" := 'Rent';
                //                 RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                //                 RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                //                 RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                //                 RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                //                 // Handle Rent Calculation Type assignment
                //                 if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then
                //                     RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                //                 else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then
                //                     RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                //                 else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then
                //                     RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                //                 else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then
                //                     RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                //                 else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then
                //                     RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                //                 else
                //                     Error('No valid Rent Calculation Type found in Tenancy Contract.');

                //                 // Insert the new Rent Calculation record
                //                 RentRecord.Insert();
                //             end;
                //             // Update data in Revenue Structure Subpage for Single Rent Calculation
                //             if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                //                 SU_lumpsum.SetRange("Contract Id", Tenancycontract."Contract Id");
                //                 if SU_lumpsum.FindSet() then begin
                //                     repeat
                //                         if not RentSubpage.Get(RentRecord."RC ID", SU_lumpsum.SL_Year) then begin
                //                             RentSubpage.Init();
                //                             RentSubpage."RC ID" := RentRecord."RC ID";
                //                             RentSubpage."Contract ID" := RentRecord."Contract ID";
                //                             RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                //                             RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                //                             RentSubpage."VAT %" := RentRecord."VAT %";
                //                             RentSubpage."Propety Classification" := RentRecord."Property Classification";
                //                             RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                //                             RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                //                             RentSubpage.Year := SU_lumpsum.SL_Year;
                //                             RentSubpage."Period Start Date" := SU_lumpsum."SL_Start Date";
                //                             RentSubpage."Period End Date" := SU_lumpsum."SL_End Date";
                //                             RentSubpage."Number of Days" := SU_lumpsum."SL_Number of Days";
                //                             RentSubpage."Per Day Rent" := SU_lumpsum."SL_Per Day Rent";
                //                             RentSubpage."Final Annual Amount" := SU_lumpsum."SL_Final Annual Amount";
                //                             RentSubpage.Insert();
                //                             Clear(RentSubpage);
                //                         end
                //                     until SU_lumpsum.Next() = 0;
                //                 end else
                //                     Error('No data found in Single Unit with lumpsum square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                //             end
                //             else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then begin
                //                 SU_samesquare.SetRange("Contract Id", Tenancycontract."Contract ID");
                //                 if SU_samesquare.FindSet() then begin
                //                     repeat
                //                         if not RentSubpage.Get(RentRecord."RC ID", SU_samesquare.Year) then begin
                //                             RentSubpage.Init();
                //                             RentSubpage."RC ID" := RentRecord."RC ID";
                //                             RentSubpage."Contract ID" := RentRecord."Contract ID";
                //                             RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                //                             RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                //                             RentSubpage."VAT %" := RentRecord."VAT %";
                //                             RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                //                             RentSubpage."Propety Classification" := RentRecord."Property Classification";
                //                             RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                //                             RentSubpage.Year := SU_samesquare.Year;
                //                             RentSubpage."Period Start Date" := SU_samesquare."Start Date";
                //                             RentSubpage."Period End Date" := SU_samesquare."End Date";
                //                             RentSubpage."Number of Days" := SU_samesquare."Number of Days";
                //                             RentSubpage."Per Day Rent" := SU_samesquare."Per Day Rent";
                //                             RentSubpage."Final Annual Amount" := SU_samesquare."Final Annual Amount";
                //                             RentSubpage.Insert();
                //                             Clear(RentSubpage);
                //                         end
                //                     until SU_samesquare.Next() = 0;
                //                 end else
                //                     Error('No data found in Single Unit with square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                //             end

                //             else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                //                 // Find the Tenancy Contract record
                //                 Tenancycontract.SetRange("Contract Id", Rec."Contract Id");
                //                 if Tenancycontract.FindFirst() then begin
                //                     // Extract the first unit name by trimming at the first comma
                //                     begin
                //                         SingleUnitName := Tenancycontract."Single Unit Name";
                //                         CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                //                         if CommaPos > 0 then
                //                             SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                //                         else
                //                             SingleUnitName := SingleUnitName; // No comma, use the whole name

                //                         // Find the first unit's details in Merge DifferentSquare table
                //                         MU_differentsquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                //                         MU_differentsquare.SetRange("MD_Unit ID", SingleUnitName); // Filter by the first unit name
                //                         if MU_differentsquare.FindSet() then begin
                //                             repeat
                //                                 // Update Revenue Structure Subpage
                //                                 if not RentSubpage.Get(RentRecord."RC ID", MU_differentsquare.MD_Year) then begin
                //                                     RentSubpage.Init();
                //                                     RentSubpage."RC ID" := RentRecord."RC ID";
                //                                     RentSubpage."Contract ID" := RentRecord."Contract ID";
                //                                     RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                //                                     RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                //                                     RentSubpage."VAT %" := RentRecord."VAT %";
                //                                     RentSubpage."Propety Classification" := RentRecord."Property Classification";
                //                                     RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                //                                     RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                //                                     RentSubpage.Year := MU_differentsquare.MD_Year;
                //                                     RentSubpage."Period Start Date" := MU_differentsquare."MD_Start Date";
                //                                     RentSubpage."Period End Date" := MU_differentsquare."MD_End Date";
                //                                     RentSubpage."Number of Days" := MU_differentsquare."MD_Number of Days";
                //                                     RentSubpage."Per Day Rent" := MU_differentsquare."MD_Per Day Rent";
                //                                     RentSubpage."Final Annual Amount" := MU_differentsquare."MD_Final Annual Amount";
                //                                     RentSubpage.Insert();
                //                                     Clear(RentSubpage);
                //                                 end
                //                             until MU_differentsquare.Next() = 0;
                //                         end else
                //                             Error('No data found for Unit Name: %1 in Contract ID: %2.', SingleUnitName, Tenancycontract."Contract ID");
                //                     end;
                //                 end else
                //                     Error('Tenancy Contract not found for Contract ID: %1.', Rec."Contract ID");
                //             end
                //             else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                //                 MU_lumpsum.SetRange("Contract ID", Tenancycontract."Contract ID");
                //                 if MU_lumpsum.FindSet() then begin
                //                     repeat
                //                         if not RentSubpage.Get(RentRecord."RC ID", MU_lumpsum.ML_Year) then begin
                //                             RentSubpage.Init();
                //                             RentSubpage."RC ID" := RentRecord."RC ID";
                //                             RentSubpage."Contract ID" := RentRecord."Contract ID";
                //                             RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                //                             RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                //                             RentSubpage."VAT %" := RentRecord."VAT %";
                //                             RentSubpage."Propety Classification" := RentRecord."Property Classification";
                //                             RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                //                             RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                //                             RentSubpage.Year := MU_lumpsum.ML_Year;
                //                             RentSubpage."Period Start Date" := MU_lumpsum."ML_Start Date";
                //                             RentSubpage."Period End Date" := MU_lumpsum."ML_End Date";
                //                             RentSubpage."Number of Days" := MU_lumpsum."ML_Number of Days";
                //                             RentSubpage."Per Day Rent" := MU_lumpsum."ML_Per Day Rent";
                //                             RentSubpage."Final Annual Amount" := MU_lumpsum."ML_Final Annual Amount";
                //                             RentSubpage.Insert();
                //                             Clear(RentSubpage);
                //                         end
                //                     until MU_lumpsum.Next() = 0;
                //                 end else
                //                     Error('No data found in Merged Unit with lumpsum annual amount subpage for Contract ID %1.', Tenancycontract."Contract ID");
                //             end
                //             else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then begin
                //                 MU_samesquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                //                 if MU_samesquare.FindSet() then begin
                //                     repeat
                //                         if not RentSubpage.Get(RentRecord."RC ID", MU_samesquare.MS_Year) then begin
                //                             RentSubpage.Init();
                //                             RentSubpage."RC ID" := RentRecord."RC ID";
                //                             RentSubpage."Contract ID" := RentRecord."Contract ID";
                //                             RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                //                             RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                //                             RentSubpage."VAT %" := RentRecord."VAT %";
                //                             RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                //                             RentSubpage."Propety Classification" := RentRecord."Property Classification";
                //                             RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                //                             RentSubpage.Year := MU_samesquare.MS_Year;
                //                             RentSubpage."Period Start Date" := MU_samesquare."MS_Start Date";
                //                             RentSubpage."Period End Date" := MU_samesquare."MS_End Date";
                //                             RentSubpage."Number of Days" := MU_samesquare."MS_Number of Days";
                //                             RentSubpage."Per Day Rent" := MU_samesquare."MS_Per Day Rent";
                //                             RentSubpage."Final Annual Amount" := MU_samesquare."MS_Final Annual Amount";
                //                             RentSubpage.Insert();
                //                             Clear(RentSubpage);
                //                         end
                //                     until MU_samesquare.Next() = 0;
                //                 end else
                //                     Error('No data found in Merged Unit with same square feet subpage for Contract ID %1.', Tenancycontract."Contract ID");
                //             end;
                //             RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                //             RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                //             RentSubpage.SetCurrentKey(Year);
                //             if RentSubpage.FindLast() then begin
                //                 Lastyear := RentSubpage.Year;
                //                 Clear(RentSubpage);
                //                 RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                //                 RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                //                 if RentSubpage.FindSet() then
                //                     repeat
                //                         Year := RentSubpage.Year;
                //                         RentSubpage."Yearly No. of Installment" := RentRecord."Number of Installments" / Lastyear;
                //                         //InstallmentAmount := Round(RentRecord.Amount / Lastyear);
                //                         // TotalCalculatedAmount := InstallmentAmount * Lastyear;  // 1666.67*3 = 5000.01
                //                         // LastInstallmentAmount := TotalCalculatedAmount - RentRecord.Amount; // 5000.01 - 5000 = 0.01
                //                         // InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;

                //                         // if Year = Lastyear then begin
                //                         //     RentSubpage."Final Annual Amount" := InstallmentAmount2;
                //                         // end else begin
                //                         //     RentSubpage."Final Annual Amount" := InstallmentAmount;
                //                         // end;

                //                         RentSubpage.Modify(true);
                //                     until RentSubpage.Next() = 0;
                //             end;
                //             Message('New record has been created in Rent Calculation and subpage updated successfully.');
                //         end;
                //     end;

                // }

            }
            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "Sub Lease Merged Units Card")
                {
                    SubPageLink = "Merge Unit ID" = FIELD("Merge Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }

            group("Single Unit with lumpsum square feet rate")
            {
                Caption = 'Single Unit with lumpsum square feet rate';
                Visible = ShowLegalReasonFields3;

                part("Single Unit lumpsum Rent (Renewal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                    // Visible = isVisible;
                }
                part("Single Unit lumpsum Rent (Proposal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                    // Visible = isVisible;
                }
            }


            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                // ✅ Part for Renewal Proposal ID
                part("Single Unit Rent (Renewal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Uses Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                }

                // ✅ Part for Proposal ID (Fallback)
                part("Single Unit Rent (Proposal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Uses Proposal ID if Renewal is empty
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                }
            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent (Renewal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                    // Visible = isVisible;
                }

                part("Merge SameSqure Rent (Proposal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                    // Visible = isVisible;
                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent (Renewal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);
                    // Visible = isVisible;
                }

                part("Merge DifferentSqure Rent (Proposal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);

                    // Visible = isVisible;
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent (Renewal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);
                    // Visible = isVisible;
                }

                part("Merge Lum_AnnualAmount Rent (Proposal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);
                    // Visible = isVisible;
                }
            }

            // group("Per Day Rent for Revenue Allocation")
            // {
            //     Caption = 'Per Day Rent for Revenue Allocation';
            //     part("Per Day Rent for Revenue"; "TC PerDayRent for Revenue Card")
            //     {
            //         SubPageLink = "Contract Renewal Id" = FIELD(Id); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
            //     }

            // }
            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';

                // ✅ Show for Renewal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Renewal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Contract Renewal Id" = FIELD("Renewal Proposal ID"); // Link to Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }

                // ✅ Show for Normal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Proposal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Proposal Id" = FIELD("Proposal ID"); // Link to Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }
            }
            group("Rent Calculation")
            {
                field("Update Data"; Rec."Update Data")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        SingleUnitName: Text;
                        CommaPos: Integer;
                        RentRecord: Record "Rent Calculation";
                        Tenancycontract: Record "Tenancy Contract";
                        SU_samesquare: Record "TC Single Unit Rent SubPage";
                        SU_lumpsum: Record "TC Single LumAnnualAmnt SP";
                        MU_samesquare: Record "TC Merge SameSqure SubPage";
                        MU_differentsquare: Record "TC Merge DifferentSq SubPage";
                        MU_lumpsum: Record "TC Merge LumAnnualAmount SP";
                        RentSubpage: Record "Rent Calculation Subpage";
                        InstallmentAmount: Decimal;
                        TotalCalculatedAmount: Decimal;
                        LastInstallmentAmount: Decimal;
                        Lastyear: Integer;
                        InstallmentAmount2: Decimal;
                        Year: Integer;
                        RentRecordid: Integer;
                    begin
                        // Find the Tenancy Contract record
                        Tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                        Tenancycontract.SetRange("Tenant ID", Rec."Tenant ID");
                        if Tenancycontract.FindFirst() then begin
                            // Set fields for RentCalculation record
                            RentRecord."Contract ID" := Tenancycontract."Contract ID";
                            RentRecord."Property Classification" := Tenancycontract."Property Classification";
                            RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                            RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                            RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                            RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                            RentRecord."Secondary Item Type" := 'Rent';
                            RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                            RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                            RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                            RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                            // Check if Rent Calculation exists, then modify or insert
                            RentRecord.SetRange("Contract ID", Rec."Contract ID"); // Ensure you're looking for the correct Contract ID

                            if RentRecord.FindFirst() then begin
                                // If Rent Calculation exists, modify it
                                RentRecord.Modify();
                                Message('Record Modified Successfully');
                                exit;
                            end else begin
                                // If Rent Calculation doesn't exist, insert a new one
                                RentRecord.Init();
                                RentRecord."Contract ID" := Tenancycontract."Contract ID";
                                RentRecord."Property Classification" := Tenancycontract."Property Classification";
                                RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                                RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                                RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                                RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                                RentRecord."Secondary Item Type" := 'Rent';
                                RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                                RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                                RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                                RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                                // Handle Rent Calculation Type assignment
                                if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                                else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                                else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                else
                                    Error('No valid Rent Calculation Type found in Tenancy Contract.');

                                // Insert the new Rent Calculation record
                                RentRecord.Insert();
                            end;
                            // Update data in Revenue Structure Subpage for Single Rent Calculation
                            if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                                SU_lumpsum.SetRange("Contract Id", Tenancycontract."Contract Id");
                                if SU_lumpsum.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", SU_lumpsum.SL_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := SU_lumpsum.SL_Year;
                                            RentSubpage."Period Start Date" := SU_lumpsum."SL_Start Date";
                                            RentSubpage."Period End Date" := SU_lumpsum."SL_End Date";
                                            RentSubpage."Number of Days" := SU_lumpsum."SL_Number of Days";
                                            RentSubpage."Per Day Rent" := SU_lumpsum."SL_Per Day Rent";
                                            RentSubpage."Final Annual Amount" := SU_lumpsum."SL_Final Annual Amount";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until SU_lumpsum.Next() = 0;
                                end else
                                    Error('No data found in Single Unit with lumpsum square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end
                            else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then begin
                                SU_samesquare.SetRange("Contract Id", Tenancycontract."Contract ID");
                                if SU_samesquare.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", SU_samesquare.Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := SU_samesquare.Year;
                                            RentSubpage."Period Start Date" := SU_samesquare."Start Date";
                                            RentSubpage."Period End Date" := SU_samesquare."End Date";
                                            RentSubpage."Number of Days" := SU_samesquare."Number of Days";
                                            RentSubpage."Per Day Rent" := SU_samesquare."Per Day Rent";
                                            RentSubpage."Final Annual Amount" := SU_samesquare."Final Annual Amount";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until SU_samesquare.Next() = 0;
                                end else
                                    Error('No data found in Single Unit with square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end

                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                                // Find the Tenancy Contract record
                                Tenancycontract.SetRange("Contract Id", Rec."Contract Id");
                                if Tenancycontract.FindFirst() then begin
                                    // Extract the first unit name by trimming at the first comma
                                    begin
                                        SingleUnitName := Tenancycontract."Single Unit Name";
                                        CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                                        if CommaPos > 0 then
                                            SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                                        else
                                            SingleUnitName := SingleUnitName; // No comma, use the whole name

                                        // Find the first unit's details in Merge DifferentSquare table
                                        MU_differentsquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                        MU_differentsquare.SetRange("MD_Unit ID", SingleUnitName); // Filter by the first unit name
                                        if MU_differentsquare.FindSet() then begin
                                            repeat
                                                // Update Revenue Structure Subpage
                                                if not RentSubpage.Get(RentRecord."RC ID", MU_differentsquare.MD_Year) then begin
                                                    RentSubpage.Init();
                                                    RentSubpage."RC ID" := RentRecord."RC ID";
                                                    RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                    RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                    RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                    RentSubpage."VAT %" := RentRecord."VAT %";
                                                    RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                                    RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                    RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                    RentSubpage.Year := MU_differentsquare.MD_Year;
                                                    RentSubpage."Period Start Date" := MU_differentsquare."MD_Start Date";
                                                    RentSubpage."Period End Date" := MU_differentsquare."MD_End Date";
                                                    RentSubpage."Number of Days" := MU_differentsquare."MD_Number of Days";
                                                    RentSubpage."Per Day Rent" := MU_differentsquare."MD_Per Day Rent";
                                                    RentSubpage."Final Annual Amount" := MU_differentsquare."MD_Final Annual Amount";
                                                    RentSubpage.Insert();
                                                    Clear(RentSubpage);
                                                end
                                            until MU_differentsquare.Next() = 0;
                                        end else
                                            Error('No data found for Unit Name: %1 in Contract ID: %2.', SingleUnitName, Tenancycontract."Contract ID");
                                    end;
                                end else
                                    Error('Tenancy Contract not found for Contract ID: %1.', Rec."Contract ID");
                            end
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                                MU_lumpsum.SetRange("Contract ID", Tenancycontract."Contract ID");
                                if MU_lumpsum.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", MU_lumpsum.ML_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := MU_lumpsum.ML_Year;
                                            RentSubpage."Period Start Date" := MU_lumpsum."ML_Start Date";
                                            RentSubpage."Period End Date" := MU_lumpsum."ML_End Date";
                                            RentSubpage."Number of Days" := MU_lumpsum."ML_Number of Days";
                                            RentSubpage."Per Day Rent" := MU_lumpsum."ML_Per Day Rent";
                                            RentSubpage."Final Annual Amount" := MU_lumpsum."ML_Final Annual Amount";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until MU_lumpsum.Next() = 0;
                                end else
                                    Error('No data found in Merged Unit with lumpsum annual amount subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then begin
                                MU_samesquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                if MU_samesquare.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", MU_samesquare.MS_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := MU_samesquare.MS_Year;
                                            RentSubpage."Period Start Date" := MU_samesquare."MS_Start Date";
                                            RentSubpage."Period End Date" := MU_samesquare."MS_End Date";
                                            RentSubpage."Number of Days" := MU_samesquare."MS_Number of Days";
                                            RentSubpage."Per Day Rent" := MU_samesquare."MS_Per Day Rent";
                                            RentSubpage."Final Annual Amount" := MU_samesquare."MS_Final Annual Amount";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until MU_samesquare.Next() = 0;
                                end else
                                    Error('No data found in Merged Unit with same square feet subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end;
                            RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                            RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                            RentSubpage.SetCurrentKey(Year);
                            if RentSubpage.FindLast() then begin
                                Lastyear := RentSubpage.Year;
                                Clear(RentSubpage);
                                RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                                RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                                if RentSubpage.FindSet() then
                                    repeat
                                        Year := RentSubpage.Year;
                                        RentSubpage."Yearly No. of Installment" := RentRecord."Number of Installments" / Lastyear;
                                        //InstallmentAmount := Round(RentRecord.Amount / Lastyear);
                                        // TotalCalculatedAmount := InstallmentAmount * Lastyear;  // 1666.67*3 = 5000.01
                                        // LastInstallmentAmount := TotalCalculatedAmount - RentRecord.Amount; // 5000.01 - 5000 = 0.01
                                        // InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;

                                        // if Year = Lastyear then begin
                                        //     RentSubpage."Final Annual Amount" := InstallmentAmount2;
                                        // end else begin
                                        //     RentSubpage."Final Annual Amount" := InstallmentAmount;
                                        // end;

                                        RentSubpage.Modify(true);
                                    until RentSubpage.Next() = 0;
                            end;
                            Message('New record has been created in Rent Calculation and subpage updated successfully.');
                        end;

                        RentRecord.SetRange("Contract ID", Rec."Contract ID");
                        RentRecord.SetRange("Tenant ID", Rec."Tenant ID");

                        if RentRecord.FindSet() then begin
                            // If found, get the latest RS ID
                            RentRecordid := RentRecord."RC ID";
                        end else begin
                            // If no record is found, create a new Revenue Structure record
                            RentRecord.Init();
                            RentRecord.Insert(true);
                            RentRecord.Modify(true);  // Insert the new record and generate the RS ID

                            // Get the newly created RS ID
                            RentRecordid := RentRecord."RC ID";
                        end;
                        Rec."Rent Calculation Link" := RentRecordid;
                    end;

                }

                field("Rent Calculation Link"; Rec."Rent Calculation Link")
                {
                    ApplicationArea = All;
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        RentCalculation: Record "Rent Calculation";
                        RentCalculationid: Integer;
                    begin
                        // Navigate to the Revenue Structure Card page
                        if RentCalculation.Get(Rec."Rent Calculation Link") then
                            PAGE.RUN(PAGE::"Rent Calculation Card", RentCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }




            }
            group("Other Payments")
            {
                part("Revenues"; "Tenancy Contract SubPage Card")
                {
                    SubPageLink = ContractID = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Contract Status")  // Add a separate group for clarity
            {
                field("Update Contract Status"; Rec."Update Contract Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        // Check if "Update Contract Status" has a value other than its default (e.g., <Blank>)
                        if Rec."Update Contract Status" <> Rec."Update Contract Status"::" " then
                            Rec."Yes/No" := true
                        else
                            Rec."Yes/No" := false;
                    end;
                }

                field("Tenant Contract Status"; rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    var
                        PaymentSchedule: Record "Payment Schedule";

                    begin
                        // Check if the contract status is either "Terminated" or "Renewed"
                        if (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Terminated") or
                           (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Contract Renewed") then
                            IsVisible := true  // Link should be visible
                        else
                            IsVisible := false; // Link should be hidden


                    end;
                }

                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                }




                group(FinalCalculation)
                {
                    Visible = IsVisible;
                    ShowCaption = false;
                    field("Final Calculation"; rec."Final Calculation")
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        // Show or hide based on status
                        //Visible = Status = Status::Approved; // This will show the field only if status is "Approved"

                        trigger OnDrillDown()
                        var
                            TenancyRecord: Record "Tenancy Contract"; // Replace with the actual table name
                            FinalCalculation: Record "Final Calculation";
                            InstallmentStructure: Record "Revenue Structure Subpage1";
                            FinalSettlementRefund: Record FinalSettlementRefund;
                            FinalSettlement: Record FinalSettlement;
                            //CarryForwardGrid: Record "Carry Forward Grid";
                            // SecurityDeposit: Record "Security Deposit";
                            StartDate: Date;
                            EndDate: Date;
                            DaysDiff: Integer;
                            DaysCal: Integer;
                            TerminateDate: Date;
                            FinalCalculationid: Integer;
                        begin
                            FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                            FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                            if FinalCalculation.FindSet() then begin
                                FinalCalculation."Contract ID" := Rec."Contract ID";
                                FinalCalculation."Tenant ID" := Rec."Tenant ID";
                                FinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                                FinalCalculation."Contract End Date" := Rec."Contract End Date";
                                FinalCalculation."Unit Type" := Rec."Usage Type";
                                FinalCalculation."Contract Amount" := Rec."Annual Rent Amount";
                                FinalCalculation."Tenant Email" := Rec."Email Address";
                                FinalCalculation."Tenant Name" := Rec."Customer Name";
                                // Add security deposit information
                                // FinalCalculation."Security Deposit" := Rec."Security Deposit Amount";
                                // FinalCalculation."Adjustment Security Deposit" := Rec."Security Balanced Amount";
                                // FinalCalculation."Net Balance" := Rec."Security Deposit Amount" - Rec."Security Balanced Amount";
                                FinalCalculation.Modify();
                                Message('Record Modifyed Successfully');
                            end else begin
                                FinalCalculation.Init();
                                FinalCalculation."Contract ID" := Rec."Contract ID";
                                FinalCalculation."Tenant ID" := Rec."Tenant ID";
                                FinalCalculation."Unit Type" := Rec."Usage Type";
                                FinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                                FinalCalculation."Contract End Date" := Rec."Contract End Date";
                                FinalCalculation."Contract Amount" := Rec."Annual Rent Amount";
                                FinalCalculation."Tenant Email" := Rec."Email Address";
                                FinalCalculation."Tenant Name" := Rec."Customer Name";
                                // Add security deposit information
                                // FinalCalculation."Security Deposit" := Rec."Security Deposit Amount";
                                // FinalCalculation."Adjustment Security Deposit" := Rec."Security Balanced Amount";
                                // FinalCalculation."Net Balance" := Rec."Security Deposit Amount" - Rec."Security Balanced Amount";
                                FinalCalculation.Insert();
                                Message('Record Created Successfully');
                            end;

                            StartDate := Rec."Contract Start Date";
                            EndDate := Rec."Contract End Date";
                            DaysDiff := EndDate - StartDate + 1;
                            FinalCalculation."Original Contract Tenure" := DaysDiff;
                            FinalCalculation.Modify(true);

                            FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                            FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                            if FinalCalculation.FindSet() then begin
                                // If found, get the latest RS ID
                                FinalCalculationid := FinalCalculation."FC ID";
                            end else begin
                                // If no record is found, create a new Revenue Structure record
                                FinalCalculation.Init();
                                FinalCalculation.Insert(true);
                                FinalCalculation.Modify(true);  // Insert the new record and generate the RS ID

                                // Get the newly created RS ID
                                FinalCalculationid := FinalCalculation."FC ID";
                            end;
                            Rec."Link" := FinalCalculationid;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlementRefund.SetRange("FC ID", FinalCalculationid);
                            if FinalSettlementRefund.FindSet() then begin
                                repeat
                                    FinalSettlementRefund."Contract ID" := Rec."Contract ID";
                                    FinalSettlementRefund.Modify(true);
                                until FinalSettlementRefund.Next() = 0;
                            end else begin
                                // If you want to create a new record when none exists
                                FinalSettlementRefund.Init();
                                FinalSettlementRefund."FC ID" := FinalCalculationid;
                                FinalSettlementRefund."Contract ID" := Rec."Contract ID";
                                FinalSettlementRefund.Insert(true);
                                Clear(FinalSettlementRefund);
                            end;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlement.SetRange("FC ID", FinalCalculationid);
                            if FinalSettlement.FindSet() then begin
                                repeat
                                    FinalSettlement."Contract ID" := Rec."Contract ID";
                                    FinalSettlement."Tenant Email" := Rec."Email Address";
                                    FinalSettlement."Tenant Name" := Rec."Customer Name";
                                    FinalSettlement.Modify(true);
                                until FinalSettlement.Next() = 0;
                            end else begin
                                // If you want to create a new record when none exists
                                FinalSettlement.Init();
                                FinalSettlement."FC ID" := FinalCalculationid;
                                FinalSettlement."Contract ID" := Rec."Contract ID";
                                FinalSettlement."Tenant Email" := Rec."Email Address";
                                FinalSettlement."Tenant Name" := Rec."Customer Name";
                                FinalSettlement.Insert(true);
                                Clear(FinalSettlement);
                            end;

                            // Handle carry forward grid for security deposits
                            // SecurityDeposit.Reset();
                            // SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

                            // if SecurityDeposit.FindSet() then begin
                            //     repeat
                            //         // Check if a Carry Forward Grid record already exists
                            //         CarryForwardGrid.Reset();
                            //         CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
                            //         CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
                            //         CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."New_Security Deposit Amount"); // Additional Check

                            //         if not CarryForwardGrid.FindFirst() then begin
                            //             // Create new record only if it doesn't exist
                            //             CarryForwardGrid.Init();
                            //             // Get the next available Entry No.
                            //             CarryForwardGrid."Entry No." := GetNextEntryNo();
                            //             CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
                            //             CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
                            //             CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                            //             CarryForwardGrid."Security Deposit" := 'Security Deposit';
                            //             CarryForwardGrid.Insert();
                            //         end else begin
                            //             // Update existing record
                            //             CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                            //             CarryForwardGrid."Security Deposit" := 'Security Deposit';
                            //             CarryForwardGrid.Modify();
                            //         end;
                            //     until SecurityDeposit.Next() = 0;
                            // end else begin
                            //     // If no Security Deposit records exist, create a basic Carry Forward Grid record
                            //     CarryForwardGrid.Reset();
                            //     CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

                            //     if not CarryForwardGrid.FindFirst() then begin
                            //         CarryForwardGrid.Init();
                            //         // Get the next available Entry No.
                            //         CarryForwardGrid."Entry No." := GetNextEntryNo();
                            //         CarryForwardGrid."Contract ID" := Rec."Contract ID";
                            //         // You'll need to determine the New Contract ID from elsewhere
                            //         CarryForwardGrid."Total Amount" := Rec."Security Deposit Amount";
                            //         CarryForwardGrid."Security Deposit" := 'Security Deposit';
                            //         CarryForwardGrid.Insert();
                            //     end;
                            // end;
                        end;
                    }



                    field("Link"; Rec."Link")
                    {
                        ApplicationArea = All;
                        DrillDown = true;


                        trigger OnDrillDown()
                        var
                            FinalCalculation: Record "Final Calculation";
                            FinalCalculationid: Integer;
                        begin
                            // Navigate to the Revenue Structure Card page
                            if FinalCalculation.Get(Rec."Link") then
                                PAGE.RUN(PAGE::"Final Calculation Card", FinalCalculation)
                            else
                                Message('The related Revenue Structure does not exist.')
                        end;

                    }


                }
                field("Suspended Reason list"; Rec."Suspended Reason list")
                {
                    ApplicationArea = All;
                    ToolTip = 'Click to open the Suspended Reason List.';
                    Style = Strong; // Makes the field look like a hyperlink
                    StyleExpr = true;

                    trigger OnAssistEdit()
                    var
                        SuspendedReasonRec: Record "SuspendReasonTable";
                    begin
                        // Filter the Suspended Reason List page by the current Contract ID
                        SuspendedReasonRec.SetRange("Contract ID", Rec."Contract ID");
                        Page.Run(Page::"SuspendReasonList", SuspendedReasonRec);
                    end;
                }


            }

            group("WorkflowFrequencys")
            {
                Visible = false;
                part("Workflow Frequency"; "Workflow Frequency PR Card")
                {
                    SubPageLink = "Property ID" = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Brokers and Commission Agent Details")
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("ContractStatus"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            field(IsCarryForwarded; Rec.IsCarryForwarded)
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        area(Reporting)
        {

            action("Run Report")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    TenancyContract: Record "Tenancy Contract";
                    ReportDubai: Report "Tenancy Contract";
                    ReportAbuDhabi: Report UmmAlQuwainContract;
                    Emirate: Enum Emirates;
                    CurrentEmirateValue: Enum Emirates;
                begin
                    TenancyContract.SetRange("Contract ID", Rec."Contract ID");

                    // Convert Code[50] to Enum for comparison
                    if Evaluate(CurrentEmirateValue, Rec.Emirate) then begin
                        case CurrentEmirateValue of
                            Emirate::"Umm Al Quwain":
                                begin
                                    ReportAbuDhabi.SetTableView(TenancyContract);
                                    ReportAbuDhabi.UseRequestPage(false);
                                    ReportAbuDhabi.RunModal();
                                end;
                            Emirate::Dubai, Emirate::"Abu Dhabi", Emirate::Sharjah, Emirate::Ajman, Emirate::Fujairah, Emirate::"Ras Al Khaimah":
                                begin
                                    ReportDubai.SetTableView(TenancyContract);
                                    ReportDubai.UseRequestPage(false);
                                    ReportDubai.RunModal();
                                end;
                            else
                                Error('Unsupported emirate: %1', Rec.Emirate);
                        end;
                    end else begin
                        Error('Invalid emirate value: %1', Rec.Emirate);
                    end;
                end;
            }
        }
    }

    // local procedure GetNextEntryNo(): Integer
    // var
    //     CarryForwardGrid: Record "Carry Forward Grid";
    // begin
    //     CarryForwardGrid.Reset();
    //     if CarryForwardGrid.FindLast() then
    //         exit(CarryForwardGrid."Entry No." + 1)
    //     else
    //         exit(1);
    // end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    var
        unitId: code[20];
        documentattachment: Codeunit UploadAttachment;

    var
        ProposalIDEnabled: Boolean;
        RenewalProposalIDEnabled: Boolean;


    // trigger OnAfterGetRecord()
    // begin
    //     // EnableSingleUnit := true;
    //     // UpdateUnitEnableState();
    //     CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
    //     // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
    //     CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");

    // end;

    trigger OnAfterGetRecord()

    var
        workflowfrequency: Record "Workflow Frequency PR";

    begin

        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateFieldsEnable();
        UpdateVisibility();
        UpdateSecurityAmountReceived();

        if Rec."Termination Of Contract" = Rec."Termination Of Contract"::" " then
            IsVisible := false  // Link should be visible
        else
            IsVisible := true; // Link should be hidde


        // Check if the contract status is either "Terminated" or "Renewed"
        if (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Terminated") or
           (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Contract Renewed") then
            IsVisible := true  // Link should be visible
        else
            IsVisible := false; // Link should be hidden

        // if Rec."Status" = '' then
        //     IsVisible := false  // Hide all fields when status is blank
        // else
        //     IsVisible := true;  // Show fields when status is not blank

        // if Rec.Status = 'End Contract' then
        //     Rec."Termination Of Contract" := Rec."Termination Of Contract"::"Regular Termination";
        // Rec.Modify();

        workflowfrequency.SetRange("Property ID", Rec."Property ID");
        workflowfrequency.SetFilter(Workflow, '%1|%2|%3',
            workflowfrequency.Workflow::"Payment Reminder",
            workflowfrequency.Workflow::"Renewal Notification to Tenant",
            workflowfrequency.Workflow::"Tenant Loyalty Check Reminder");

        if workflowfrequency.FindSet() then begin
            repeat
                case workflowfrequency.Workflow of
                    workflowfrequency.Workflow::"Payment Reminder":
                        Rec."Payment Reminder" := workflowfrequency."No. of Days";

                    workflowfrequency.Workflow::"Renewal Notification to Tenant":
                        Rec."Renewal Notification to Tenant" := workflowfrequency."No. of Days";

                    workflowfrequency.Workflow::"Tenant Loyalty Check Reminder":
                        Rec."Tenant Loyalty Check Reminder" := workflowfrequency."No. of Days";
                end;
            until workflowfrequency.Next() = 0;

            Rec.Modify();
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();
        UpdateSecurityAmountReceived();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        //CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();

    end;


    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"Renewal Contract";

        CurrPage.Update(false);
    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;

        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;

        ShowLegalReasonFields4: Boolean;

        ShowLegalReasonFields5: Boolean;
        IsVisible: Boolean;

    // trigger OnAfterge
    // begin

    //     // SetRange("Merge Unit ID", Rec."Merge Unit ID");
    // end;

    // Procedure to update visibility dynamically
    procedure UpdateVisibility()
    begin
        ShowLegalReasonFields := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with square feet rate");
        ShowBusinessReasonFields := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with same square feet");
        ShowLegalReasonFields1 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with differential square feet rate");
        ShowBusinessReasonFields2 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount");
        ShowLegalReasonFields3 := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with lumpsum square feet rate");
        ShowLegalReasonFields4 := (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
    end;

    // local procedure UpdateSecurityAmountReceived()
    // begin
    //     if Rec."Security Deposit Amount" = Rec."Balance Amount" then
    //         Rec."Security Amount Received" := 0

    //     else
    //         Rec."Security Amount Received" := Rec."Security Deposit Amount" - Rec."Balance Amount";
    // end;

    local procedure UpdateSecurityAmountReceived()
    begin
        // Update Security Amount Received
        if Rec."Security Deposit Amount" = Rec."Security Deposit Amt. Received" then
            Rec."Security Amount Pending" := 0
        else
            Rec."Security Amount Pending" := Rec."Security Deposit Amount" - Rec."Security Deposit Amt. Received";

        // // If Balance Amount has any value (non-zero), update Security Balanced Amount
        // if Rec."Balance Amount" <> 0 then
        //     Rec."Security Balanced Amount" := Rec."Balance Amount";
    end;



    trigger OnOpenPage()
    var
        TenancyContractSubpage: Record "Tenancy Contract Subpage";
    begin
        TenancyContractSubpage.SetRange(ContractID, 0);
        if TenancyContractSubpage.FindSet() then begin
            TenancyContractSubpage.DeleteAll();
        end;
    end;


}
