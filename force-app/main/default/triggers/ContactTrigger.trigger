trigger ContactTrigger on Contact (after insert,after update,after delete,after undelete) {

    if(Trigger.isinsert || Trigger.isupdate || Trigger.isdelete || Trigger.isundelete){
        ContactTriggerHandler.updateAccountContactCount(trigger.new,trigger.old);
    }
    
    if(Trigger.isinsert || Trigger.isupdate){
        ContactTriggerHandler.AccountRelatedContactsAlteastTwo(trigger.new,trigger.old);
    }
}