page 50146 "Management Fee Calc."
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Management Fee Calc. Header";
    SourceTableTemporary = true;
    Caption = 'Management Fee Calculation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Report Date"; Rec."Report Date")
                {
                    ApplicationArea = All;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Editable = not Rec."All Owners";

                    trigger OnValidate()
                    begin
                        if Rec."Owner ID" <> 0 then
                            ownereditable := false
                        else
                            ownereditable := true;
                    end;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }
                field("All Owners"; Rec."All Owners")
                {
                    ApplicationArea = All;
                    Editable = ownereditable;

                    trigger OnValidate()
                    begin
                        if Rec."All Owners" = true then begin

                            allownereditable := false;
                            Rec."All Properties" := true;
                        end
                        else begin
                            allownereditable := true;
                            Rec."All Properties" := false;
                        end;
                    end;
                }
                field("All Properties"; Rec."All Properties")
                {
                    ApplicationArea = All;
                    Editable = propertyeditable;
                    // trigger OnValidate()
                    // begin
                    //     if Rec."All Properties" = true then
                    //         allpropertyeditable := false
                    //     else
                    //         allpropertyeditable := true;
                    // end;
                }
                field(Property; Rec.Property)
                {
                    ApplicationArea = All;
                    Editable = not Rec."All Properties";


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PropertyRegistrationRec: Record "Property Registration";
                        PropertyRegistrationListPage: Page "Property Registration List";
                        SelectedPropertyNames: Text[250];
                    // PropertyName: Text[100];
                    begin
                        PropertyRegistrationRec.Reset();
                        if Rec."Owner ID" = 0 then
                            PropertyRegistrationRec.FindSet()
                        else
                            PropertyRegistrationRec.SetRange("Owner ID", Rec."Owner ID");

                        PropertyRegistrationListPage.LookupMode(true);
                        PropertyRegistrationListPage.SetTableView(PropertyRegistrationRec);

                        if PropertyRegistrationListPage.RunModal() = ACTION::LookupOK then begin

                            //  Clear(PropertyName);
                            Clear(SelectedPropertyNames);

                            PropertyRegistrationListPage.SetSelectionFilter(PropertyRegistrationRec);
                            if PropertyRegistrationRec.FindSet() then begin
                                repeat
                                    if SelectedPropertyNames <> '' then
                                        SelectedPropertyNames := SelectedPropertyNames + ', ';
                                    SelectedPropertyNames := SelectedPropertyNames + PropertyRegistrationRec."Property Name";
                                until PropertyRegistrationRec.Next() = 0;
                                Rec.Property := SelectedPropertyNames;
                                if Rec.Property <> ''
                                then
                                    propertyeditable := false
                                else
                                    propertyeditable := true;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Rec.Property <> '' then
                            propertyeditable := false
                        else
                            propertyeditable := true;
                    end;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                }
                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                }
            }
            part(ManagementFeeGrid; "Management Fee Calc Grid")
            {
                SubPageLink = "Primary Key" = FIELD("Primary Key"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Management Fee Details';
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowCalculation)
            {
                Caption = 'Calculate Management Fee';
                Image = CalculateVAT;
                trigger OnAction()
                var
                    ManagementFeeCalcCodeunit: Codeunit "SetManagementFeeCalculation";
                begin
                    ManagementFeeCalcCodeunit.PopulateManagementFeeLines(Rec);
                end;

            }
        }

        area(Promoted)
        {
            actionref(ShowCalculation_; ShowCalculation)
            { }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert();
        end;
        allownereditable := true;
        allpropertyeditable := true;
        propertyeditable := true;
        ownereditable := true;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        allownereditable := not Rec."All Owners";
        allpropertyeditable := not Rec."All Properties";
    end;

    var
        allownereditable: Boolean;
        allpropertyeditable: Boolean;
        propertyeditable: Boolean;
        ownereditable: Boolean;


}