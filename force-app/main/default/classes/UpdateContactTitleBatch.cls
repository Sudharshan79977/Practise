public class UpdateContactTitleBatch implements Database.Batchable<sobject>,Database.stateful {
    
    private List<Batch_Error_Log__c> errorLogs = new List<Batch_Error_Log__c>();
    private Integer successCount = 0;
    private Integer failureCount = 0;
    private String newTitle;
    
     public UpdateContactTitleBatch() {
        Contact_Title__mdt ct = [
            SELECT Title_Value__c 
            FROM Contact_Title__mdt 
            LIMIT 1
        ];
        newTitle = ct.Title_Value__c;
    }
  
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id,Title from Contact where Title=null]);
    }
    
    
    public void execute(Database.BatchableContext bc, List<Contact> conList){
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact con : ConList){
            con.Title = newTitle;
            contactsToUpdate.add(con);
        }
        
        
        if(!contactsToUpdate.isEmpty()){
            Database.SaveResult[] result = Database.update(contactsToUpdate,false);
            
            for(Integer i =0;i<result.size();i++){
                if(result[i].isSuccess()){
                    successCount++;}
                else{
                    failureCount++;
                    for(Database.Error err :result[i].getErrors()){
                        errorLogs.add(new Batch_Error_Log__c(
                            Record_Id__c = contactsToUpdate[i].Id,
                            Error_Message__c = err.getMessage(),
                            Name = 'UpdateContactTitleBatch'));
                    }
                }
            }}}
    public void finish(Database.BatchableContext bc){
        System.debug('Batch finished. Success Record are :'+successCount+' and failed record are :'+ failureCount);
        if(!errorLogs.isEmpty()){
            insert errorLogs;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ Label.Recipient_Email });
        mail.setSubject('Contact Tilte Batch Completed');
        mail.setPlainTextBody('Batch finished. Success Record are :'+successCount+' and failed record are :'+ failureCount);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        
        
    }
    
}