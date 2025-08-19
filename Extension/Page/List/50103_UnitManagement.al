pageextension 50103 ItemListExtension extends "Item List"
{
    Caption = 'Unit list';


    layout
    {
        modify("No.")
        {
            Caption = 'Unit ID';
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Assembly BOM")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Vendor No.")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify(Type)
        {
            Visible = false;
        }

        addbefore(Description)
        {
            field("Unit Name"; Rec."Unit Name")
            {
                ApplicationArea = All;
                Caption = 'Unit Name';
            }
            field("Property Name"; Rec."Property Name")
            {
                ApplicationArea = All;
                Caption = 'Property Name';
            }
            field("Usage Type"; Rec."Usage Type")
            {
                ApplicationArea = All;
                Caption = 'Usage Type';
            }
            field("Unit Status"; Rec."Unit Status")
            {
                ApplicationArea = All;
                Caption = 'Unit Status';
            }

            field("Merging/Splitting"; rec."MergeSplitOption")
            {
                ApplicationArea = All;
            }

            field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
            {
                ApplicationArea = All;
            }


            field("Amount"; Rec."Amount")
            {
                ApplicationArea = All;
                Caption = 'Amount';
            }

            // field("Selected"; Rec.Selected)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Select';
            //     Editable = true;
            //     // Show only if Status is Free
            //     //   Visible = (Rec."Unit Status" = Rec."Unit Status" := Free);
            // }

            field("Unit Registration Date"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                Caption = 'Last Date Modified';
            }

            field("Merged Unit ID"; Rec."Merged Unit ID")
            {
                ApplicationArea = All;
                Caption = 'Merged Unit ID';
            }

        }


    }








    var
        Selected: Boolean; // Variable to store whether the unit is selected

    // Function to retrieve selected Unit IDs
    procedure GetSelectedUnitIDs(): Text
    var
        UnitRec: Record "Item";
        SelectedUnits: Text[250];
    begin
        SelectedUnits := '';
        if Rec.FindSet() then begin
            repeat
                if Selected then begin
                    if SelectedUnits <> '' then
                        SelectedUnits := SelectedUnits + ',';
                    SelectedUnits := SelectedUnits + Rec."No.";
                end;
            until Rec.Next() = 0;
        end;
        exit(SelectedUnits);
    end;
}