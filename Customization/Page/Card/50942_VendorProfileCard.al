page 50942 "Vendor Profile Card"
{
    PageType = Card;
    SourceTable = "Vendor Profile";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Identification")
            {
                Caption = 'Vendor Identification Details';

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    trigger OnValidate()
                    begin
                        brokeragesectionpopulated()
                    end;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Category"; Rec."Vendor Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        if UpperCase(Rec."Vendor Category") = 'BROKERS AND COMMISSION AGENT' then begin
                            ShowBrokerageGroup := true;
                            //   Message('Brokers and Commission Agent Section is Open');
                        end else begin
                            ShowBrokerageGroup := false;
                            //  Message('Vendor is NOT a Brokers and Commission Agent - Section remains Closed');
                        end;
                    end;
                }

                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Disable Search by Name"; Rec."Disable Search by Name")
                {
                    ApplicationArea = All;
                }
                field("Company Size Code"; Rec."Company Size Code")
                {
                    ApplicationArea = All;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                }
                // field("Balance Due (LCY) As Customer"; Rec."Balance Due (LCY) As Customer")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all completed purchase invoices and credit memos.';
                // }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = All;
                }
            }

            group("Brokers and Commission Agent Details")
            {
                Visible = ShowBrokerageGroup;
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        UpdateFieldEditability();
                    end;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageTypeEditable;
                }
                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = IsBaseamount;

                    trigger OnValidate()
                    begin
                        UpdateFieldEditability();
                    end;
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageEditable;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = IsAmountEditable;
                }

                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                }

            }

            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = All;
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = All;
                    }
                    // field("Country/Region Code"; Rec."Country/Region Code")
                    // {
                    //     ApplicationArea = All;
                    // }
                    // field(City; Rec.City)
                    // {
                    //     ApplicationArea = All;
                    // }
                    field(Country; Rec.Country)
                    {
                        ApplicationArea = All;
                    }
                    // field("Post Code"; Rec."Post Code")
                    // {
                    //     ApplicationArea = All;
                    // }
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Phone No.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                }
                field("Our Account No."; Rec."Our Account No.")
                {
                    ApplicationArea = All;
                }
                group(Contact)
                {
                    Caption = 'Contact';
                    field("Primary Contact Code"; Rec."Primary Contact Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Primary Contact Code';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Price Including VAT"; Rec."Price Including VAT")
                {
                    ApplicationArea = All;
                }

            }
            group(Payments)
            {
                Caption = 'Payments';

                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                }
                field("Partner Type"; Rec."Partner Type")
                {
                    ApplicationArea = All;
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = All;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = All;
                }
            }
            field("Over-Receipt Code"; Rec."Over-Receipt Code")
            {
                ApplicationArea = All;
            }
            field("Receive E-Document To"; Rec."Receive E-Document To")
            {
                ApplicationArea = All;
            }

            group("Calculation Details")
            {
                Caption = 'Calculation Details';
                Visible = IsVisibleCommission;
                part("Calculation Detail"; "Vendor Calculation Details Sub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Vendor Document")
            {
                Caption = 'Vendor Document';
                part("Vendor Documents"; "Vendor Document Sub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Contract Document")
            {
                Caption = 'Invoice/Receipt Documents';
                part("Contract Documents"; "Vendor I/R DocumentSub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }


    procedure brokeragesectionpopulated()
    begin
        if UpperCase(Rec."Vendor Category") = 'BROKERS AND COMMISSION AGENT' then begin
            ShowBrokerageGroup := true;
            //Message('Brokers and Commission Agent Section is Open');
        end else begin
            ShowBrokerageGroup := false;
            // Message('Vendor is NOT a Brokers and Commission Agent - Section remains Closed');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");

        if UpperCase(Rec."Vendor Category") = 'BROKERS AND COMMISSION AGENT' then begin
            ShowBrokerageGroup := true;
            //Message('Brokers and Commission Agent Section is Open');
        end else begin
            ShowBrokerageGroup := false;
            // Message('Vendor is NOT a Brokers and Commission Agent - Section remains Closed');
        end;
        UpdateFieldEditability();
        UpdateVisibility();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");
    end;


    var
        ShowBrokerageGroup: Boolean;
        IsAmountEditable: Boolean;
        IsPercentageEditable: Boolean;
        IsPercentageTypeEditable: Boolean;
        IsBaseamount: Boolean;
        IsVisibleCommission: Boolean;


    local procedure UpdateVisibility()
    begin
        IsVisibleCommission := (UpperCase(Rec."Vendor Category") <> 'BROKERS AND COMMISSION AGENT');
    end;


    procedure UpdateFieldEditability()
    begin
        case UpperCase(Rec."Calculation Method") of
            '':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                    IsBaseamount := false;
                end;

            'FIXED AMOUNT':
                begin
                    // if (Rec."Base Amount" = Rec."Base Amount"::Revenue) or
                    //    (Rec."Base Amount" = Rec."Base Amount"::Collection) then
                    IsAmountEditable := true;
                    // else
                    // IsAmountEditable := false;

                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                    IsBaseamount := false;
                end;

            'PERCENTAGE BASED':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := true;
                    IsPercentageTypeEditable := true;
                    IsBaseamount := true;
                end;

            'STANDARD RATE':
                begin
                    // Auto-populate 'Monthly Rent' if not already set
                    if Rec."Base Amount Type" <> Rec."Base Amount Type"::"Monthly Rent" then
                        Rec."Base Amount Type" := Rec."Base Amount Type"::"Monthly Rent";

                    // Now apply the logic
                    if Rec."Base Amount Type" = Rec."Base Amount Type"::"Monthly Rent" then begin
                        IsAmountEditable := false;
                        IsPercentageEditable := false;
                        IsPercentageTypeEditable := false;
                        IsBaseamount := false;
                    end;
                end;

            else begin
                // Default: Allow editing everything
                IsAmountEditable := false;
                IsPercentageEditable := false;
                IsPercentageTypeEditable := false;
                IsBaseamount := false;
            end;
        end;
    end;

}


