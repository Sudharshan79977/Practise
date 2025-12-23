public class BatchSimplae implements Database.Batchable<sobject>{
     public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id,LastName,Title from Contact limit 2]);
    }
    
     public void execute(Database.BatchableContext bc, List<Contact> conList){
        List<Contact> contactsToUpdate = new List<Contact>();
         for(Contact con : conList){
             con.LastName = con.LastName + 'simple';
             contactsToUpdate.add(con);
         }
         update contactsToUpdate;
         system.debug('updated in batch1');
        
     }
    
     public void finish(Database.BatchableContext bc){
         
       System.debug('Batch finished from batchsimple');
          Database.executeBatch(new BatchSimple2());

     }}