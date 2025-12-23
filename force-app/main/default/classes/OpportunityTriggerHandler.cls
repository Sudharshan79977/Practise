public class OpportunityTriggerHandler {
    
    public void run(List<Opportunity> newList, List<Opportunity> oldList) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            OpportunityTriggerHelper.updateLastOpportunityDate(newList);
        } 
        else if (Trigger.isDelete) {
            OpportunityTriggerHelper.updateLastOpportunityDate(oldList);
        } 
        else if (Trigger.isUndelete) {
            OpportunityTriggerHelper.updateLastOpportunityDate(newList);
        }
    }
}