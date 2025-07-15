trigger OpportunityTrigger on Opportunity (after insert, before update, after update, after delete, after undelete){
    System.debug('Operation Type :'+Trigger.operationType);
    System.debug('Is Executing :'+Trigger.isExecuting);
    System.debug('Size :'+Trigger.size);
    
    switch on Trigger.operationType{
        when AFTER_INSERT{
            OpportunityTriggerHandler.updateLatestClosedWonAmount(Trigger.newMap.keySet());
        }
        when BEFORE_UPDATE{
            OpportunityTriggerHandler.setCloseDate(Trigger.new, Trigger.oldMap);		
        }
        when AFTER_UPDATE{
            OpportunityTriggerHandler.postOnFeed(Trigger.new, Trigger.oldMap);
            OpportunityTriggerHandler.updateLatestClosedWonAmount(Trigger.newMap.keySet());
        }
        when AFTER_DELETE{
            //OpportunityTriggerHandler.updateLatestClosedWonAmountForDelete(Trigger.oldMap.keySet());
			OpportunityTriggerHandler.updateLatestClosedWonAmountForDelete(Trigger.oldMap);

        }
        when AFTER_UNDELETE{
            OpportunityTriggerHandler.postOnFeedForUndelete(Trigger.new);
            OpportunityTriggerHandler.updateLatestClosedWonAmount(Trigger.newMap.keySet());
        }
    }
}