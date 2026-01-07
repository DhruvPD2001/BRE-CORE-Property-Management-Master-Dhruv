page 50987 "Management Fee Grid ListPart"
{
    PageType = ListPart;
    SourceTable = "Management Fee Grid";
    ApplicationArea = All;
    Caption = 'Management Fee Agreements';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'System-generated entry number for the management fee record.';
                    Editable = false;
                    Visible = false;

                }

                field("Management Fee Number"; Rec."Management Fee Number")
                {
                    ApplicationArea = All;
                    Caption = 'Management Fee No.';
                    ToolTip = 'Specifies the management fee master or PMC reference number.';
                    Editable = false;
                    Visible = false;
                }

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Caption = 'PMC Vendor ID';
                    ToolTip = 'Specifies the vendor ID of the property management company.';
                    Editable = false;
                    Visible = false;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                }

                field("Company/Owner Name"; Rec."Company/Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company / Owner Name';
                    ToolTip = 'Specifies the legal owner of the property.';
                    Editable = false;


                }

                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property for which the management fee is defined.';
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies whether the property is Residential or Commercial.';
                    Editable = false;
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Method';
                    ToolTip = 'Specifies how the management fee is calculated, such as percentage of revenue, annual rent, collections, per unit, or hybrid.';
                    trigger OnValidate()
                    begin
                        Percentageeditablevalidation := AccessiblePercentagefields();
                        Amounteditablevalidation := AccessibleAmountfield();
                    end;


                }

                field("Calculation Sub-Type"; Rec."Calculation Sub-Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Sub-Type';
                    ToolTip = 'Specifies whether the calculation is percentage-based or a fixed amount.';
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage Type';
                    ToolTip = 'Specifies whether the percentage applied is fixed or variable.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                    ToolTip = 'Specifies the agreed Percentage for management fee calculation.';
                    Editable = Percentageeditablevalidation;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the agreed fixed amount for management fee calculation.';
                    Editable = Amounteditablevalidation;
                }

                field("Base Amount Source"; Rec."Base Amount Source")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Source';
                    ToolTip = 'Specifies the base amount used for fee calculation, such as revenue, collections, or annual rent.';
                }

                field("Payment Frequency"; Rec."Payment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Frequency';
                    ToolTip = 'Specifies how often the management fee is calculated, such as monthly, quarterly, half-yearly, or yearly.';
                }

                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = All;
                    Caption = 'Valid From';
                    ToolTip = 'Specifies the start date from which this management fee agreement is applicable.';
                }

                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = All;
                    Caption = 'Valid To';
                    ToolTip = 'Specifies the end date until which this management fee agreement is applicable.';
                    trigger OnValidate()
                    begin
                        Rec."Validity Period" := Format(Rec."Valid From", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(Rec."Valid To", 0, '<Day,2>/<Month,2>/<Year4>');
                    end;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'Indicates whether the management fee contract is active or expired.';
                    Editable = false;
                }
                field("Contract Document"; Rec."Contract Document")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Document';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin

                        folderName := 'ManagementFeeDocument';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."View Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."URL Document" := uploadResult;
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }
                field("View Document"; Rec."View Document")
                {
                    ApplicationArea = All;
                    Caption = 'View Document';
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."URL Document";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser(FileURL);
                    end;

                }
                field("Validity Period"; Rec."Validity Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    trigger OnAfterGetRecord()

    begin
        Percentageeditablevalidation := AccessiblePercentagefields();
        Amounteditablevalidation := AccessibleAmountfield();
    end;

    procedure AccessiblePercentagefields(): Boolean
    var
    begin
        if Rec."Calculation Method" <> Rec."Calculation Method"::"Per Unit Fee" then
            exit(true)
        else
            exit(false);
    end;

    procedure AccessibleAmountfield(): Boolean
    begin
        if (Rec."Calculation Method" = Rec."Calculation Method"::Hybrid) OR (Rec."Calculation Method" = Rec."Calculation Method"::"Per Unit Fee") then
            exit(true)
        else
            exit(false);
    end;


    var
        Percentageeditablevalidation: Boolean;
        Amounteditablevalidation: Boolean;

}