public with sharing class AccountPdfController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAccountWithContacts(Id accountId) {
        Map<String, Object> result = new Map<String, Object>();

        Account acc = [
            SELECT Id, Name, Phone, Industry 
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];

        List<Contact> cons = [
            SELECT Id, FirstName, LastName, Email, CreatedDate 
            FROM Contact 
            WHERE AccountId = :accountId
            ORDER BY CreatedDate ASC
        ];

        result.put('account', acc);
        result.put('contacts', cons);
        return result;
    }

    @AuraEnabled
    public static void generateAccountPdf(Id accountId) {
        PageReference pdfPage = Page.AccountPdfPage;
        pdfPage.getParameters().put('id', accountId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        ContentVersion cv = new ContentVersion();
        cv.Title = 'AccountDetails_' + System.now().format('yyyyMMdd_HHmmss');
        cv.PathOnClient = cv.Title + '.pdf';
        cv.VersionData = pdfBlob;
        insert cv;

        Id contentDocId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id = :cv.Id
        ].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = accountId,
            ContentDocumentId = contentDocId,
            ShareType = 'V'
        );
        insert cdl;
    }
}