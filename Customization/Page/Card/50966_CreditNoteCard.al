page 50966 "Credit Note Card"
{
    PageType = Card;
    SourceTable = "Credit Note";
    ApplicationArea = All;
    Caption = 'Credit Note Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Credit Note Type"; Rec."Credit Note Type")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Type';
                    ToolTip = 'Enter the Credit Note Type.';
                    Editable = false;
                }
                // field("TerminationCreditNoteType"; Rec."TerminationCreditNoteType")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Credit Note Type';
                //     ToolTip = 'Enter the Credit Note Type.';
                //     Editable = false;
                //     Visible = ShowTermination;
                // }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                }
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    TableRelation = "Final Calculation"."Contract ID";


                    trigger OnValidate()
                    var
                        finalcalculation: Record "Final Calculation";
                        creditnote: Record "Credit Note";

                    begin
                        creditnote.Reset();
                        creditnote.SetRange("Contract ID", Rec."Contract ID");
                        if creditnote.FindFirst() then
                            Error('This Contract ID %1 is already used in another record.', Rec."Contract ID");

                        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
                        if finalcalculation.FindSet() then begin
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Termination Credit Note";
                            Rec."Contract Start Date" := finalcalculation."Contract Start Date";
                            Rec."Contract End Date" := finalcalculation."Contract End Date"; // Convert Integer to Text
                            Rec."Unit Type" := finalcalculation."Unit Type";
                            Rec."Contract Amount" := finalcalculation."Contract Amount";
                            Rec."Tenant ID" := finalcalculation."Tenant ID";
                            Rec."Tenant Name" := finalcalculation."Tenant Name";
                            Rec."Tenant Email" := finalcalculation."Tenant Email"; // Convert Integer to Text
                            Rec."FC ID" := finalcalculation."FC ID";
                            BillingCalculationSub();

                        end else begin // Clear the fields if no record is found
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Termination Credit Note";
                            Rec."Contract Start Date" := 0D;
                            Rec."Contract End Date" := 0D; // Convert Integer to Text
                            Rec."Unit Type" := '';
                            Rec."Contract Amount" := 0;
                            Rec."Tenant ID" := '';
                            Rec."Tenant Name" := '';
                            Rec."Tenant Email" := ''; // Convert Integer to Text
                            Rec."FC ID" := 0;
                        end;

                    end;
                }

                field("Credit Note Document"; Rec."Credit Note Document")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Document';
                    DrillDown = true;
                    Editable = false;

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
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            group("Customer Details")
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
            }
            field("Reason for Rejection"; Rec."Reason for Rejection")
            {
                Caption = 'Reason for Rejection';
                Editable = false;
            }
            group("Billing-Calculation")
            {
                part("Billing-Calculations"; "Billing Calculation CN Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }

            }
            // group("Invoice Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     field("Invoice ID"; Rec."Invoice ID")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Invoice ID';
            //     }
            //     field("Amount"; Rec."Amount")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Credit Note Amount';
            //     }
            // }
            // group("Credit-Note Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     part("Invoice-CreditNote"; "Invoice-Credit Note Card")
            //     {
            //         SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         // Visible = isVisible;
            //     }
            // }
            // group("Generate Credit-Note Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     part("Final Invoice-CreditNote"; "Filtered Invoice Detail Card")
            //     {
            //         SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         // Visible = isVisible;
            //     }
            // }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CreditNote)
            {
                ApplicationArea = All;
                Caption = 'Credit Note Approval';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = Rec.Status = Rec.Status::Pending;


                trigger OnAction()
                var
                    ApprovalCreditNote: Record "Credit Note Approval";
                    CreditNote: Record "Credit Note";
                    billingcalculation: Record "Billing Calculation CN";
                    creditnoteamount: Decimal;
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Get the actual Credit Note record
                    if not CreditNote.Get(Rec."ID") then
                        Error('Credit Note record not found.');

                    ApprovalCreditNote.SetRange("Contract ID", Rec."Contract ID");

                    if ApprovalCreditNote.FindSet() then begin
                        // Modify existing approval record
                        ApprovalCreditNote."ID" := CreditNote."ID";
                        ApprovalCreditNote."FC ID" := CreditNote."FC ID";
                        ApprovalCreditNote."Contract ID" := CreditNote."Contract ID";
                        ApprovalCreditNote."Tenant ID" := CreditNote."Tenant ID";
                        ApprovalCreditNote."Status" := CreditNote."Status";
                        ApprovalCreditNote."Contract Start Date" := CreditNote."Contract Start Date";
                        ApprovalCreditNote."Contract End Date" := CreditNote."Contract End Date";
                        ApprovalCreditNote."Tenant Name" := CreditNote."Tenant Name";
                        ApprovalCreditNote."Credit Note Type" := CreditNote."Credit Note Type"::"Termination Credit Note";
                        ApprovalCreditNote.Modify();

                        billingcalculation.SetRange("Contract ID", Rec."Contract ID");
                        if billingcalculation.FindSet() then begin
                            // Modify existing approval record
                            repeat
                                creditnoteamount += billingcalculation."Amount Including VAT";
                            until billingcalculation.Next() = 0;

                            ApprovalCreditNote."Credit Note Amount" := creditnoteamount;
                            ApprovalCreditNote.Modify();
                        end;
                        Message('Approval Request Modified successfully!');
                    end else begin
                        // Insert new approval record
                        ApprovalCreditNote.Init();
                        ApprovalCreditNote."ID" := CreditNote."ID";
                        ApprovalCreditNote."FC ID" := CreditNote."FC ID";
                        ApprovalCreditNote."Contract ID" := CreditNote."Contract ID";
                        ApprovalCreditNote."Tenant ID" := CreditNote."Tenant ID";
                        ApprovalCreditNote."Status" := CreditNote."Status";
                        ApprovalCreditNote."Contract Start Date" := CreditNote."Contract Start Date";
                        ApprovalCreditNote."Contract End Date" := CreditNote."Contract End Date";
                        ApprovalCreditNote."Tenant Name" := CreditNote."Tenant Name";
                        ApprovalCreditNote."Credit Note Type" := CreditNote."Credit Note Type"::"Termination Credit Note";
                        ApprovalCreditNote.Insert(true);
                        //  Message('Approval Request Sent successfully!');

                        billingcalculation.SetRange("Contract ID", Rec."Contract ID");
                        if billingcalculation.FindSet() then begin
                            // Modify existing approval record
                            repeat
                                creditnoteamount += billingcalculation."Amount Including VAT";
                            until billingcalculation.Next() = 0;

                            ApprovalCreditNote."Credit Note Amount" := creditnoteamount;
                            ApprovalCreditNote.Modify();
                        end;
                        Message('Approval Request Sent successfully!');
                    end;
                end;

            }

            action("Create Credit Note")
            {
                Caption = 'Credit Note Document';
                ApplicationArea = All;
                Image = NewDocument; // Use an appropriate icon for the action
                Promoted = true; // Make the action visible in the header
                PromotedCategory = Process; // Place it in the "Process" category
                PromotedIsBig = true; // Make it a prominent action

                trigger OnAction()
                var
                    CreditNotetable: Record "Credit Note";
                    CreditNoteReport: Report "Terminated Credit Note";
                    azureBlobUploader: Codeunit "Azure AD Blob Storage";
                    fileName: Text;
                    uploadResult: Text;
                    folderName: Text;
                    inStream: InStream;
                    Billingcalculationgrid: Record "Final Billing Calculation Grid";
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                begin
                    // Credit Note table માં filter set કરો
                    CreditNotetable.Reset();
                    CreditNotetable.SetRange(ID, Rec.ID);

                    if not CreditNotetable.FindFirst() then
                        Error('Credit Note record not found for ID: %1', Rec.ID);

                    // Report માં table view set કરો
                    CreditNoteReport.SetTableView(CreditNotetable);
                    CreditNoteReport.UseRequestPage(false);

                    // PDF generate કરો
                    TempBlob.CreateOutStream(OutStream);
                    CreditNoteReport.SaveAs('', ReportFormat::Pdf, OutStream);
                    TempBlob.CreateInStream(InStream);

                    FileName := 'CreditNote_' + Format(Rec.ID) + '.pdf';

                    folderName := 'Payment Receipt';
                    uploadResult := azureBlobUploader.UploadDocumentToBlob(inStream, fileName, folderName);

                    if uploadResult <> '' then begin
                        Rec."Credit Note Document" := fileName;
                        Rec."Credit Note URL" := uploadResult;
                        Rec.Modify();
                        Message('File uploaded successfully: %1', fileName);
                    end else
                        Error('File upload failed');

                    // Update Billing Calculation Grid
                    Billingcalculationgrid.SetRange("Contract ID", Rec."Contract ID");
                    if Billingcalculationgrid.FindSet() then begin
                        Billingcalculationgrid."Credit Note Document" := Rec."Credit Note Document";
                        Billingcalculationgrid."Credit Note Document URL" := Rec."Credit Note URL";
                        Billingcalculationgrid.Modify(true);
                    end;
                end;
            }
        }
    }

    // var
    //     IsStandardCreditNoteType: Boolean;

    // trigger OnAfterGetRecord()
    // begin
    //     if Rec."Credit Note Type" = Rec."Credit Note Type"::"Standard Credit Note" then begin
    //         IsStandardCreditNoteType := true;
    //     end else begin
    //         IsStandardCreditNoteType := false;
    //     end;
    // end;

    // trigger OnNewRecord(BelowxRec: Boolean)
    // var
    //     CreditNoteRec: Record "Credit Note";
    //     NextID: Integer;
    // begin
    //     if Rec.ID = 0 then begin
    //         if CreditNoteRec.FindLast() then
    //             NextID := CreditNoteRec.ID + 1
    //         else
    //             NextID := 1;

    //         Rec.ID := NextID;

    //     end;
    // end;


    procedure BillingCalculationSub()
    var
        BillingCalculationSubCN: Record "Billing Calculation CN";
        BillingCalculationSubFC: Record "Final Billing Calculation Grid";
    begin


        BillingCalculationSubCN.SetRange("Contract ID", Rec."Contract ID");
        if BillingCalculationSubCN.FindSet() then begin
            BillingCalculationSubCN.DeleteAll();
        end;

        // TenancyContractLine.Reset();
        BillingCalculationSubFC.SetRange("Contract ID", Rec."Contract ID");
        if BillingCalculationSubFC.FindSet() then begin
            repeat
                if BillingCalculationSubFC."DifferenceAmount" > 0 then begin
                    BillingCalculationSubCN.Init();
                    BillingCalculationSubCN."Credit Note ID" := Rec."ID";
                    BillingCalculationSubCN."Contract ID" := Rec."Contract ID";
                    BillingCalculationSubCN."Tenant ID" := Rec."Tenant ID";
                    BillingCalculationSubCN."Item" := BillingCalculationSubFC."RevenueDescription";
                    BillingCalculationSubCN."Amount" := BillingCalculationSubFC."DifferenceAmount";
                    BillingCalculationSubCN."VAT Amount" := BillingCalculationSubFC."DifferenceVAT";
                    BillingCalculationSubCN."Amount Including VAT" := BillingCalculationSubFC."DifferenceAmountInclVAT";
                    BillingCalculationSubCN.Insert();
                    Clear(BillingCalculationSubCN);
                end;
            until BillingCalculationSubFC.Next() = 0;
        end;

    end;

    procedure ShowCreditNoteInBillingCalculationGrid()
    var
        Billingcalculationgrid: Record "Final Billing Calculation Grid";
    begin
        Billingcalculationgrid.SetRange("Contract ID", Rec."Contract ID");
        if Billingcalculationgrid.FindSet() then begin
            Billingcalculationgrid."Credit Note ID" := Rec."Credit Note No.";
            // Billingcalculationgrid."Credit Note Document" := Rec."Credit Note Document";
            // Billingcalculationgrid."Credit Note Document URL" := Rec."Credit Note URL";
            Billingcalculationgrid.Modify();
        end;
    end;

    procedure ShowCreditNoteInBillingCalculationSubGrid()
    var
        Billingcalculationgrid: Record "Billing Calculation CN";
    begin
        Billingcalculationgrid.SetRange("Contract ID", Rec."Contract ID");
        if Billingcalculationgrid.FindSet() then begin
            repeat
                Billingcalculationgrid."Credit Note ID" := Rec.ID;
                Billingcalculationgrid.Modify();
            until Billingcalculationgrid.Next() = 0;

        end;
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    trigger OnAfterGetRecord()
    var
    begin
        ShowCreditNoteInBillingCalculationGrid();
        ShowCreditNoteInBillingCalculationSubGrid();
    end;
}



