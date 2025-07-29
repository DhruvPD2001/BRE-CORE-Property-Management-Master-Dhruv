codeunit 53752 "SendListPendingCreditNoteInv"
{
    trigger OnRun()
    var
        UserPersonalizationRec: Record "User Personalization";
        RequestCreditNoteGrid: Record "Request Credit Note Grid";
        CompanyInfo: Record "Company Information";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        EmailBody: Text;
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        UserRec: Record User;
        BCCMail: List of [Text];
        InvoicesExist: Boolean;
        CreditNotelink: Text;
    begin
        InvoicesExist := false;
        UserPersonalizationRec.SetRange("Profile ID", 'FINANCE MANAGER');
        if UserPersonalizationRec.FindSet() then
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then
                    if UserRec."Contact Email" <> '' then
                        EmailAddress.Add(UserRec."Contact Email");
            until UserPersonalizationRec.Next() = 0;
        if EmailAddress.Count() = 0 then
            Error('No users with the "Property Manager" profile have a valid email address.');

        CreditNotelink := GETURL(ClientType::Current, COMPANYNAME, ObjectType::Page, PAGE::"Request Credit Note List");

        EmailBody := SendListPendingAdjustCredtNoteList(InvoicesExist);
        if InvoicesExist then begin
            EmailMessage.Create(EmailAddress,
                                'Pending Adjustment Credit Notes',
                                '<html>' +
                                '<body>' +
                                '<p>Dear Finance Manager,</p>' +
                                '<p>The following credit note requests are pending adjustment with their respective invoices:</p>' +
                                EmailBody +
                                '<br/><p>Please take the necessary action.</p>' +
                                 '<p><a href="' + CreditNotelink + '" target="_blank">Click here to view the Request Credit Note List</a></p>' +
                               '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                                '</body>' +
                                '</html>', true, CCMail, BCCMail);
            EmailMessage.SetBodyHTMLFormatted(true);
            Email.Send(EmailMessage)
        end;
    end;

    procedure SendListPendingAdjustCredtNoteList(var InvoicesExist: Boolean): Text
    var
        RequestCreditNoteGridRec: Record "Request Credit Note Grid";
        RequestCreditNoteRec: Record "Request Credit Note";
        UserRec: Record User;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        TempEmailBody: Text;
    begin
        RequestCreditNoteGridRec.SetFilter("Invoiced", '=true');
        RequestCreditNoteGridRec.SetFilter("Credit Memo Generated", '=false');
        if RequestCreditNoteGridRec.FindSet() then begin
            InvoicesExist := True;
            TempEmailBody := '<table border = "1" style="width:100%; text-align:center;"><tr><th>Request Credit Note No.</th><th>Contract ID</th><th>Tenant No.</th><th>Amount Including VAT</th><th>Total Reduction Amount</th></tr>';
            repeat
                TempEmailBody += StrSubstNo(
      '<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td>%5</td></tr>',
      RequestCreditNoteGridRec."Request No.",
      RequestCreditNoteGridRec."Contract ID",
      RequestCreditNoteGridRec."Tenant No.",
      RequestCreditNoteGridRec."Payment Series",
      Format(RequestCreditNoteGridRec."Total Reduction"));
            until RequestCreditNoteGridRec.Next() = 0;
            TempEmailBody += '</table>';
        end;
        exit(TempEmailBody);
    end;
}