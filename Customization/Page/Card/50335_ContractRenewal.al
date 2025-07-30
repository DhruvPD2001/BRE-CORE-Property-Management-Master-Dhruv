page 50335 "Contract Renewal Card"
{
    PageType = Card;
    SourceTable = "Contract Renewal";
    ApplicationArea = All;
    Caption = 'Contract Renewal Card';

    layout
    {
        area(content)
        {



            group("General Info")
            {
                Caption = 'General Information';

                field("Id"; rec.Id)

                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                }

                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal Date';
                    Editable = true;
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."Owner's Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Lessor's Name"; rec."Lessor's Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Lessor's Emirates ID"; rec."Lessor's Emirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("License No."; rec."License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Licensing Authority"; rec."Licensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Lessor's Email"; rec."Lessor's Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Lessor's Phone"; rec."Lessor's Phone")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Tenant Full Name"; rec."Tenant Full Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false; // The ID is not editable since it's auto-incrementing
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
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Praposal Type Selected"; rec."Praposal Type Selected")
                {
                    ApplicationArea = All;
                    // Lookup = true; // Enable lookup for Property ID
                    Caption = 'Unit Category';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateUnitEnableState();
                    end;

                }
                field("Unit Name"; rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
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


                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                }


                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("UnitID"; Rec."UnitID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                // field("Uniq Unit ID"; Rec.UnitID) // Auto-generated Unit ID
                // {
                //     ApplicationArea = All;
                //     Caption = 'Uniq Unit ID';
                //     Editable = false;
                // }


                field("Ejari Name"; Rec."Ejari Name")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
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
            }


            group("Lease Terms")
            {
                Caption = 'Lease Terms';
                field("Contract Start Date"; rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease Start Date';
                }
                field("Contract End Date"; rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease End Date';

                }
                field("Contract Tenor"; rec."Contract Tenor")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease Duration';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Contract Amount"; rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing

                }

                field("Rent VAT Amount"; rec."Rent VAT Amount")
                {
                    ApplicationArea = All;


                }

                field("Rent Amount VAT %"; rec."Rent Amount VAT %")
                {
                    ApplicationArea = All;


                }

                field("Rent Amount Including VAT"; rec."Rent Amount Including VAT")
                {
                    ApplicationArea = All;


                }


                // field("Annual Rent Amount"; Rec."Annual Rent Amount")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }

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
                    Editable = false;
                    // Visible = false;
                }

                field("Rera"; Rec."Rera")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Ejari Processing Charges"; Rec."Ejari Processing Charges")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Renewal Charges"; Rec."Renewal Charges")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }



            group("Deposit and Fees")
            {
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Other Fees"; rec."Other Fees")
                {
                    ApplicationArea = All;
                }
                field("Refund Conditions"; rec."Refund Conditions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }


            }



            group("Responsibilities")
            {
                field("Maintenance Responsibilities"; rec."Maintenance Responsibilities")
                {
                    ApplicationArea = All;
                }
                field("Utility Bills Responsibility"; rec."Utility Bills Responsibility")
                {
                    ApplicationArea = All;
                }
                field("Insurance Requirements"; rec."Insurance Requirements")
                {
                    ApplicationArea = All;
                }
            }

            group("Conditions for Renewal")
            {

                field("Rent Escalation Clause"; rec."Rent Escalation Clause")
                {
                    ApplicationArea = All;
                }
            }


            group("Special Conditions")
            {
                Caption = 'Special Conditions';

                field("Early Termination Conditions"; rec."Early Termination Conditions")
                {
                    ApplicationArea = All;
                }
                field("Restrictions"; rec."Restrictions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Legal Jurisdiction"; rec."Legal Jurisdiction")
                {
                    ApplicationArea = All;
                }


                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Approval For Renewal"; rec."Approval For Renewal")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                }
                field("Renewal Contract Status"; rec."Renewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Original Contract ID"; rec."Original Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
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

                field("Final Status"; rec."Final Status")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    Caption = 'Contract Renewal Proposal Status';
                }



                field("Contract Status"; rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                }



            }

            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "CR Sub Lease Merged Units Card")
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

                part("Single Unit lumpsum Rent"; "CR Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                part("Single Unit Rent"; "CR Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }

            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent"; "CR Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent"; "CR Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent"; "CR Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';
                part("Per Day Rent for Revenue"; "CR PerDayRent for Revenue Card")
                {
                    SubPageLink = "Contract Renewal Id" = FIELD(Id); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }


            group("Other Payments")
            {
                part("ContractRenewal"; "Contract Renewal SubPage Card")
                {
                    SubPageLink = Id = FIELD(Id),
                  "TenantID" = FIELD("Tenant ID");
                    //    "PS ID" = field("PS Id"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            field("Is any Broker Involved?"; Rec."Is any Broker Involved?")
            {
                ApplicationArea = All;
            }

            group("Brokers and Commission Agent Details")
            {
                Visible = Rec."Is any Broker Involved?";

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;

                    // Trasfer from Table Start 
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorProfileRec: Record "Vendor Profile";
                        AnnualAmount: Decimal;
                    begin
                        VendorProfileRec.SetRange("Vendor Category", 'Brokers and Commission Agent');
                        VendorProfileRec.SetRange("Contract Status", Rec."Contract Status"::"Active"); // 👈 Add this line
                        if Page.RunModal(Page::"Vendor Profile List", VendorProfileRec) = Action::LookupOK then begin
                            Rec."Vendor ID" := VendorProfileRec."Vendor ID";
                            Rec."Vendor Name" := VendorProfileRec."Vendor Name";
                            Rec."Start Date" := VendorProfileRec."Start Date";
                            Rec."End Date" := VendorProfileRec."End Date";
                            Rec."Contract Status" := VendorProfileRec."Contract Status";
                            Rec."Calculation Method" := VendorProfileRec."Calculation Method";
                            Rec."Percentage Type" := VendorProfileRec."Percentage Type";
                            Rec.Percentage := VendorProfileRec.Percentage;
                            Rec."Base Amount Type" := VendorProfileRec."Base Amount Type";

                            case Rec."Base Amount Type" of
                                Rec."Base Amount Type"::"Annual Rent":
                                    AnnualAmount := Rec."Rent Amount";
                                Rec."Base Amount Type"::"Monthly Rent":
                                    AnnualAmount := Rec."Rent Amount" / 12;
                            end;

                            Rec.Amount := AnnualAmount;
                            Rec."Frequency Of Payment" := VendorProfileRec."Frequency Of Payment";
                        end else begin
                            Rec."Vendor ID" := '';
                            Rec."Vendor Name" := '';
                            Rec."Start Date" := 0D;
                            Rec."End Date" := 0D;
                            Rec."Contract Status" := Rec."Contract Status"::" ";
                            Rec."Calculation Method" := ' ';
                            Rec."Percentage Type" := Rec."Percentage Type"::" ";
                            Rec.Percentage := 0;
                            Rec.Amount := 0;
                            Rec."Base Amount Type" := Rec."Base Amount Type"::" ";
                            Rec."Frequency Of Payment" := Rec."Frequency Of Payment"::" ";
                        end;
                    end;
                    // Trasfer from Table End
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
                // field("Percentage/Amount"; Rec."Percentage/Amount")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }

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

                field("ContractStatus"; Rec."ContractStatus")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }




        }
    }


    var
        EnableSingleUnit: Boolean;
        EnableMergeUnit: Boolean;

    // Update the enable logic based on "Proposal Type Selected"
    trigger OnAfterGetRecord()
    begin

        CurrPage."Single Unit Rent".Page.Update();
        CurrPage."Merge SameSqure Rent".Page.Update();
        // CurrPage."Merge DifferentSqure Rent".Page.Update();
        CurrPage."Merge Lum_AnnualAmount Rent".Page.Update();
        CurrPage."Single Unit lumpsum Rent".Page.Update();
        // CurrPage."Unit all Details".Page.Update();


        CurrPage."ContractRenewal".Page.SetId(Rec."ID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."Tenant ID");


    end;



    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."ContractRenewal".Page.SetId(Rec."ID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."Tenant ID");


    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."ContractRenewal".Page.SetId(Rec."ID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."Tenant ID");


    end;



    // Function to update enabled state of Unit fields
    local procedure UpdateUnitEnableState()
    begin
        case Rec."Praposal Type Selected" of
            Rec."Praposal Type Selected"::"Single Unit":
                begin
                    EnableSingleUnit := true;
                    EnableMergeUnit := false;
                end;
            Rec."Praposal Type Selected"::"Merge Unit":
                begin
                    EnableSingleUnit := false;
                    EnableMergeUnit := true;
                end;
            else
                EnableSingleUnit := false; // Keep Single Unit enabled by default
                EnableMergeUnit := false;
        end;
        CurrPage.Update(); // Refresh the page to apply changes
    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;

        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;

        ShowLegalReasonFields4: Boolean;

        ShowLegalReasonFields5: Boolean;

    trigger OnOpenPage()
    begin
        UpdateVisibility();
        // SetRange("Merge Unit ID", Rec."Merge Unit ID");
    end;

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

}
