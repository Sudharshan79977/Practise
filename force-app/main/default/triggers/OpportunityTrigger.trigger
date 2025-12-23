trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
        handler.run(Trigger.new, Trigger.old);
    }
}