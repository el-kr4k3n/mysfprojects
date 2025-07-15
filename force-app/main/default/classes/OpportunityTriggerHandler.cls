public class OpportunityTriggerHandler {
        /*  Class Name : OpportunityTriggerHandler
        *   Author : Kartik
        *   Description: This is a Handler Class for Opportunity Trigger
        *   Date: 14/07/2025.
        * 
        */
    public static void setCloseDate(List<Opportunity> newOpportunityList, Map<ID,Opportunity> oldOpportunityMap){
        for(Opportunity oppRec : newOpportunityList){
            if(oppRec.StageName == System.label.PICKLISTVAL_CLOSED_WON && oppRec.StageName != oldOpportunityMap.get(oppRec.Id).StageName){
                System.debug('StageName changed to Closed Won');
                oppRec.CloseDate = Date.Today();
                System.debug('Close Date changed to today');
            }
        }
    }
    
    public static void postOnFeed(List<Opportunity> newOpportunityList, Map<ID,Opportunity> oldOpportunityMap){
        List<FeedItem> feedItemToInsert = new List<FeedItem>();
        for(Opportunity oppRec : newOpportunityList){
            if(oppRec.StageName == System.label.PICKLISTVAL_CLOSED_WON && oppRec.StageName != oldOpportunityMap.get(oppRec.id).StageName && oppRec.Amount >= 500000){
                FeedItem feedRec = new FeedItem();
                feedRec.ParentId = oppRec.Id;
                feedRec.Body     = 'High Networth Sales closed for $' + oppRec.Amount;
                feedItemToInsert.add(feedRec);
            }
        }
        if(!feedItemToInsert.isEmpty()) insert feedItemToInsert;
    }
    
    public static void postOnFeedForUndelete(List<Opportunity> newOpportunityList){
        List<FeedItem> feedItemToInsert = new List<FeedItem>();
        for(Opportunity oppRec : newOpportunityList){
            if(oppRec.StageName == System.label.PICKLISTVAL_CLOSED_WON && oppRec.Amount >= 500000){
                FeedItem feedRec = new FeedItem();
                feedRec.ParentId = oppRec.Id;
                feedRec.Body     = 'High Networth Sales closed for $' + oppRec.Amount;
                feedItemToInsert.add(feedRec);
            }
        }
        if(!feedItemToInsert.isEmpty()) insert feedItemToInsert;
        
    }
    public static void updateLatestClosedWonAmountForDelete(Map<Id,Opportunity> mapOfOldOpportunity){
        System.debug('mapOfOldOpportunity :'+ mapOfOldOpportunity);
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : mapOfOldOpportunity.values()){
        		if(opp.AccountId != null)	accountIds.add(opp.AccountId);
        }
        if(accountIds.isEmpty()) return;
        System.debug('accountIds: '+ accountIds);
        OpportunityTriggerService.updateLatestClosedWon(accountIds);
    }
    public static void updateLatestClosedWonAmount(Set<Id> opportunityIds){
        //get related account id
        System.debug('opportunityIds :'+ opportunityIds);
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : [Select Id, AccountId 
                               from opportunity 
                               where Id in :opportunityIds]){
                System.debug('opp :' + opp);
        		if(opp.AccountId != null)	accountIds.add(opp.AccountId);
        }
        if(accountIds.isEmpty()) return;
        System.debug('accountIds: '+ accountIds);
        OpportunityTriggerService.updateLatestClosedWon(accountIds);
    }
    
}