page 50928 "Payment Mode Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Mode2";
    ApplicationArea = All;
    Caption = 'Payment Details';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }


                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }


                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = IsApproved; // The ID is not editable since it's auto-incrementing
                }



                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;  // The ID is not editable since it's auto-incrementing
                }



                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = IsApproved AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"

                }



                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  // The ID is not editable since it's auto-incrementing
                                                                                                                                              //Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                                                                                                                                              //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));

                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = IsApproved AND (Rec."Payment Mode" <> 'Cash');
                    // Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  
                    //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    trigger OnValidate()
                    var
                    paymentschedul2grid : Record "Payment Schedule2";
                    begin
                        paymentschedul2grid.SetRange("Contract ID", Rec."Contract ID");
                        paymentschedul2grid.SetRange("Payment Series", Rec."Payment Series");
                        paymentschedul2grid.SetRange(Invoiced, true);
                        if paymentschedul2grid.FindSet() then
                            repeat
                                paymentschedul2grid.Validate("Payment Status", Format(Rec."Payment Status"));;
                                paymentschedul2grid.Modify();
                            until paymentschedul2grid.Next() = 0;
                    end;
                }

                field("Cheque Status"; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    //Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  
                    //Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                    //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));
                    // trigger OnValidate()
                    // begin
                    //     if Rec."Payment Mode" <> 'Cheque' then
                    //         Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    // end;
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Invoice #"; Rec."Invoice #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                }

                field("Receipt #"; Rec."Receipt #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"

                }

                field("Old Cheque #"; Rec."Old Cheque #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);
                    // Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                    // Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);
                    // Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));




                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Upload Cheque"; Rec."Upload Cheque")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('Upload Cheque cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        // Check if the Payment Mode is 'Cheque'
                        if Rec."Payment Mode" <> 'Cheque' then begin
                            Error('Cheque upload is only allowed when Payment Mode is "Cheque".');
                        end;
                  
                        folderName := 'PropertyDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Upload Cheque" := fileName;
                            Rec."View Document URL" := uploadResult;
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                   
                }


                field("View"; Rec."View")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                         // Check if the Payment Mode is 'Cheque'
                        if Rec."Payment Mode" <> 'Cheque' then begin
                          Error('Cheque upload is only allowed when Payment Mode is "Cheque".');
                        end;
                        // Get the URL of the uploaded document
                        FileURL := Rec."View Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("View Revenue Details"; Rec."View Revenue Details")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        PaymentModeRec: Record "Payment Mode2";
                        PaymentScheduleRec: Record "Payment Schedule2";
                        FilteredSchedulePage: Page "Payment Schedule Card2"; // Replace with your actual page name
                    begin
                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View Revenue Details cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
                        // PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
                        PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentScheduleRec.SetRange("Due Date", Rec."Due Date");
                        PaymentScheduleRec.SetRange("Payment Series", Rec."Payment Series");

                        // Hide other data and show the filtered records
                        if PaymentScheduleRec.FindFirst() then
                            FilteredSchedulePage.SetTableView(PaymentScheduleRec);

                        // Open the filtered page
                        PAGE.Run(PAGE::"Payment Schedule Card2", PaymentScheduleRec);

                    end;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND IsFinanceManager;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    // Editable = IsFinanceManager;
                }
                field(IsUpdated; Rec.IsUpdated)
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                }
                field("Approve/Decline Status"; Rec."Approve/Decline Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                }


                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Payment Received Date"; Rec."Payment Received Date")
                {
                    Caption = 'Payment Received Date';
                    Editable = false;
                }   

            field("View Invoice"; Rec."View Invoice")
            {
                ApplicationArea = All;
                Caption = 'View Receipt Document';
               // Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."View Reciept document URL";


                    if FileURL = '' then
                        Error('No document is available to view.');


                    OpenFileInBrowser1(FileURL);
                end;

            }
            field("View Reciept document URL";Rec."View Reciept document URL")
            {
                ApplicationArea = All;
                Caption = 'View Reciept document URL';
            }
                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                }

                  field("Credit Note Amount"; Rec."Credit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                }

                field("Final Rent Amount"; Rec."Final Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                   field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field(FinalRentAmountIncludingVAT;Rec.FinalRentAmountIncludingVAT)
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount Including VAT"';
                    Editable = false;
                }


            }



            group(TotalAmountCalculation)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                }
                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                }

              

            }


        }
    }




    actions
    {
        area(processing)
        {
            action(InsertData)
            {
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument;
                Visible = IsLeaseManager AND IsApproved;
                
                trigger OnAction()
                var
                    approvalflow: Codeunit 50510;
                    PaymentModeRec: Record "Payment Mode2";
                    PrePDCTransRec: Record "PDC Transaction";
                    PDCTransRec: Record "PDC Transaction";
                    paymentRec: Record "Payment Mode";
                    paymentTransRec: Record "Payment Transaction";
                    PrePaymentTransRec: Record "Payment Transaction";
                    paymentGridRec: Record "Payment Series Details";
                    PrePaymentGridRec: Record "Payment Series Details";
                    IsPaymentTransactionCreated: Boolean;
                    Isupdate: Boolean;
                begin
                    Isupdate := false;

                   
                    // Update Approval Status in the grid
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PaymentModeRec."Approval Status" := PaymentModeRec."Approval Status"::Pending; // Set Approval Status to Pending

                            PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;
                    end;

                    paymentRec.SetRange("Contract ID", Rec."Contract ID");
                    paymentRec.SetRange("Tenant Id", Rec."Tenant Id");
                    if paymentRec.FindSet() then begin
                        paymentRec."Approval Status" := paymentRec."Approval Status"::Pending;
                        paymentRec."On-hold" := paymentRec."On-hold"::"True";
                        paymentRec.Modify();
                    end;

                    // Insert records into PDC Transaction for Payment Modes with "Cheque"
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id"); // Filter by Tenant ID
                    PaymentModeRec.SetRange("Payment Mode", 'Cheque'); // Filter by Payment Mode = Cheque

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            //  **Validation: Check if Cheque Number is blank**
                            if DelChr(PaymentModeRec."Cheque Number", '=', ' ') = '' then
                                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
                            // Check for duplicate PDC Transaction record
                            // PrePDCTransRec.SetRange("Cheque Number", PaymentModeRec."Cheque Number");
                            PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            PrePDCTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                            PrePDCTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                // Insert record into PDC Transaction
                                PDCTransRec.Init();
                                PDCTransRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                PDCTransRec."Bank Name" := PaymentModeRec."Deposit Bank";
                                PDCTransRec."Cheque Date" := PaymentModeRec."Due Date";
                                PDCTransRec.Amount := PaymentModeRec."Amount Including VAT";
                                PDCTransRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                PDCTransRec."Contract ID" := PaymentModeRec."Contract ID";
                                PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::"Cheque Received";
                                PDCTransRec."Approval Status" := PDCTransRec."Approval Status"::Pending;
                                PDCTransRec."View Document URL" := PaymentModeRec."View Document URL";
                                PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;

                        until PaymentModeRec.Next() = 0;
                        // CreateChequeEntry();
                        Message('PDC Transaction records successfully created for Cheque payment modes.');
                    end else
                        Message('No payment modes with "Cheque" found for the given Contract ID and Tenant ID.');

                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);

                end;
            }

            action(UpdateData)
            {
                ApplicationArea = All;
                Caption = 'Update Data';
                Image = NewDocument;
                Visible = IsLeaseManager;

                trigger OnAction()
                var
                    approvalflow: Codeunit 50510;
                    PaymentModeRec: Record "Payment Mode2";
                    paymentRec: Record "Payment Mode";
                    Isupdate: Boolean;
                    PDCTransRec : Record "PDC Transaction";
                    PrePDCTransRec: Record "PDC Transaction";
                    approvalEnum : Enum "Approval Status Enum";
                begin
                    Isupdate := true;
                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);

                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("Approval Status", approvalEnum::Pending);
                    if PaymentModeRec.FindSet() then begin
                        repeat
                        PaymentModeRec."Approval Status" := approvalEnum::Pending;
                        PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;
                        Message('Approval Status updated successfully.');
                    end;

                    PaymentModeRec.Reset();
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id");
                    PaymentModeRec.SetRange("Payment Mode", 'Cheque');

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            PrePDCTransRec.SetRange("Contract ID",PaymentModeRec."Contract ID");
                            PrePDCTransRec.SetRange("payment Series",PaymentModeRec."Payment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                PDCTransRec.Init();
                                PDCTransRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                PDCTransRec."Bank Name" := PaymentModeRec."Deposit Bank";
                                PDCTransRec."Cheque Date" := PaymentModeRec."Due Date";
                                PDCTransRec.Amount := PaymentModeRec."Amount Including VAT";
                                PDCTransRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                PDCTransRec."Contract ID" := PaymentModeRec."Contract ID";
                                PDCTransRec."Cheque Status" := PaymentModeRec."Cheque Status";
                                PDCTransRec."Approval Status" := PaymentModeRec."Approval Status";
                                PDCTransRec."View Document URL" := PaymentModeRec."View Document URL";
                                PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;
                        until PaymentModeRec.Next() = 0;
                        Message('PDC Transaction Updated successfully.');
                    end
                    else
                        Message('No new cheque payments found.');
                end;
            }
        }
    }



    trigger OnAfterGetRecord()
    var
        paymentschedul2grid : Record "Payment Schedule2";
        paymentTypeRec: Record "Payment Type";
        paymentschedulegrid1: Record "Payment Schedule2"; // Record variable for Payment Type
    begin
        IsApproved:= (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // If the field is blank, assign '-'
        if Rec."Cheque Number" = '' then
            Rec."Cheque Number" := '-';

        if Rec."Old Cheque #" = '' then
            Rec."Old Cheque #" := '-';

        if Rec."Receipt #" = '' then
            Rec."Receipt #" := '-';

        if Rec."Invoice #" = '' then
            Rec."Invoice #" := '-';
       

        if Rec."Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;
        // if Rec."Due Date" <> xRec."Due Date" then begin
        //         if Rec."Due Date" = Today() then
        //             Rec."Payment Status" := Rec."Payment Status"::"Due"
        //         else if Rec."Due Date" < Today() then
        //             Rec."Payment Status" := Rec."Payment Status"::"Overdue"
        //         else
        //             Rec."Payment Status" := Rec."Payment Status";

        //      //   Modify();
        //     end;

        paymentschedul2grid.SetRange("Contract ID", Rec."Contract ID");
        paymentschedul2grid.SetRange("Payment Series", Rec."Payment Series");
        paymentschedul2grid.SetRange(Invoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."Invoice #" := paymentschedul2grid."Invoice ID";
                Rec.Modify();
            until paymentschedul2grid.Next() = 0;

            Rec."Final Rent Amount" := Rec."Amount" - Rec."Credit Note Amount";
            Rec.FinalRentAmountIncludingVAT := 0;
            paymentschedulegrid1.SetRange("Contract ID", Rec."Contract ID");
            paymentschedulegrid1.SetRange("Payment Series", Rec."Payment Series");
            if paymentschedulegrid1.FindSet() then
                repeat
                    Rec.FinalRentAmountIncludingVAT += paymentschedulegrid1."Final RentAmountIncludingVAT";
                until paymentschedulegrid1.Next() = 0;
            Rec.Modify();   
    end;

    trigger OnAfterGetCurrRecord()
    var
    paymentschedul2grid : Record "Payment Schedule2";
    begin
         paymentschedul2grid.SetRange("Contract ID", Rec."Contract ID");
        paymentschedul2grid.SetRange("Payment Series", Rec."Payment Series");
         paymentschedul2grid.SetRange(Invoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."Invoice #" := paymentschedul2grid."Invoice ID";
                Rec.Modify();
            until paymentschedul2grid.Next() = 0;
    end;
    
    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
        
    end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;

    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


    procedure OpenFileInBrowser1(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;
    procedure SetDetails(pTenantName: Text[100]; pTenantEmail: Text[80])
    begin
        tenantName := pTenantName;
        tenantEmail := pTenantEmail;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Tenant ID" := tenantID;
        Rec."Contract ID" := ContractID;
        Rec."Tenant Name" := tenantName;
        Rec."Tenant Email" := tenantEmail;  

    end;

    var
        proposalID: Integer;
        tenantID: Code[20];

        tenantName: Text[100];
        tenantEmail: Text[80];
        ContractID: Integer;
        IsApproved: Boolean;
        IsLeaseManager: Boolean;
        IsFinanceManager: Boolean;

    
    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
         paymentschedul2grid : Record "Payment Schedule2";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        IsFinanceManager :=false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
                IsLeaseManager := true;
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;
        end;
        
        // else if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
        //         IsFinanceManager := true;
       
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IsApproved:= (Rec."Approval Status" <> Rec."Approval Status"::Approved);
    end;

// procedure CreateChequeEntry()
// var
//     NextEntryNo: Integer;
//     GenJournalLine: Record "Gen. Journal Line";
//     GenJournalAccountType: Enum "Gen. Journal Account Type";
//     GenJournalDocumentType: Enum "Gen. Journal Document Type";
//     ChequeStatus: Enum "PDC Status Type Enum";
//     GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
// begin
//     if Rec."Cheque Status" <> ChequeStatus::"Cheque Received" then
//         exit;


//     // Filter to specific batch
//     GenJournalLine.Reset();
//     GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
//     GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');

//     if GenJournalLine.FindLast() then
//         NextEntryNo := GenJournalLine."Line No." + 1
//     else
//         NextEntryNo := 1;

//     Clear(GenJournalLine);
//     GenJournalLine.Init();
//     GenJournalLine."Journal Template Name" := 'CASH RECE';
//     GenJournalLine."Journal Batch Name" := 'DEFAULT';
//     GenJournalLine."Line No." := NextEntryNo;
//     GenJournalLine."Posting Date" := Today;
//     GenJournalLine."Document Type" := GenJournalDocumentType::Payment;
//     GenJournalLine."Document No." := Rec."Cheque Number";
//     GenJournalLine."Account Type" := GenJournalAccountType::Customer;
//     GenJournalLine."Account No." := Rec."Tenant Id";
//     GenJournalLine."Description" := Rec."Tenant Name";
//     GenJournalLine.Amount := -(Rec."Amount Including VAT");
//     GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
//     GenJournalLine."Bal. Account Type" := GenJournalAccountType::"G/L Account";
//     GenJournalLine."Bal. Account No." := '2001';
//     GenJournalLine.Insert(true);


//     // Optional: Post line
//     GenJnlPostLine.RunWithCheck(GenJournalLine);

// // **Delete the Journal Line After Posting**
//                         GenJournalLine.Reset();
//                         GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
//                         GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                       

//                         if GenJournalLine.FindSet() then begin
//                             GenJournalLine.DeleteAll();
//                         end;

//     Message('Cash Receipt journal created successfully.');
// end;


procedure CreateChequeEntry()
var
    NextEntryNo: Integer;
    GenJournalLine: Record "Gen. Journal Line";
    GenJournalAccountType: Enum "Gen. Journal Account Type";
                               GenJournalDocumentType: Enum "Gen. Journal Document Type";
                               ChequeStatus: Enum "PDC Status Type Enum";
                               GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
begin
    // Filter all records with Cheque Status = 'Cheque Received'
    Rec.SetRange("Cheque Status", ChequeStatus::"Cheque Received");
     
    if Rec.FindSet() then
        repeat
            // Get next line number for journal
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
            GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');

            if GenJournalLine.FindLast() then
                NextEntryNo := GenJournalLine."Line No." + 1
            else
                NextEntryNo := 1;

            Clear(GenJournalLine);
            GenJournalLine.Init();
            GenJournalLine."Journal Template Name" := 'CASH RECE';
            GenJournalLine."Journal Batch Name" := 'DEFAULT';
            GenJournalLine."Line No." := NextEntryNo;
            GenJournalLine."Posting Date" := Today;
            GenJournalLine."Document Type" := GenJournalDocumentType::Payment;
            GenJournalLine."Document No." := Rec."Cheque Number";
            GenJournalLine."Account Type" := GenJournalAccountType::Customer;
            GenJournalLine."Account No." := Rec."Tenant Id";
            GenJournalLine."Description" := Rec."Tenant Name";
            GenJournalLine.Amount := -Rec."Amount Including VAT";
            GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
            GenJournalLine."Bal. Account Type" := GenJournalAccountType::"G/L Account";
            GenJournalLine."Bal. Account No." := '2001';
            GenJournalLine.Insert(true);

            // Optional: Post line
            GenJnlPostLine.RunWithCheck(GenJournalLine);
        until Rec.Next() = 0;

    // Optional: Delete all posted lines in the batch
    GenJournalLine.Reset();
    GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
    GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
    if GenJournalLine.FindSet() then
        GenJournalLine.DeleteAll();
  
    Message('Cash Receipt journal entries created successfully for all cheques received.');
    Rec.SetRange("Cheque Status");

// Refresh the page so all records are visible again
CurrPage.Update(false);
end;

}
    












