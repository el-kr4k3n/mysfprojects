public class OpportunityTriggerService {
        /*  Class Name : OpportunityTriggerService
        *   Author : Kartik
        *   Description: This is a Service Class for Opportunity Trigger Handler
        *   Date: 14/07/2025.
        * 
        */
    public static void updateLatestClosedWon(Set<Id> setOfAccountstoUpdate){
        List<Opportunity> closedWonOpportunity = [Select Id, AccountId, Amount, CloseDate
                                                  from Opportunity
                                                  where AccountId In :setOfAccountstoUpdate 
                                                  and StageName = :System.label.PICKLISTVAL_CLOSED_WON
                                                  Order By CloseDate Desc];
        System.debug('closedWonOpportunity: ' + closedWonOpportunity);
        
        Map<Id,Opportunity> mapOfAccountsToUpdate = new Map<Id,Opportunity>();
        for(Opportunity oppRec: closedWonOpportunity){
            if(!mapOfAccountsToUpdate.containsKey(oppRec.AccountId))
                mapOfAccountsToUpdate.put(oppRec.AccountId,oppRec);
        }
        System.debug('mapOfAccountsToUpdate: '+ mapOfAccountsToUpdate);
        
        //update acc field
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accRec : mapOfAccountsToUpdate.keySet()){
            Opportunity latestOpportunity = mapOfAccountsToUpdate.get(accRec);
            Account newAcc = new Account(Id=accRec, Latest_Closed_Won_Amount__c = latestOpportunity.Amount);
            accountsToUpdate.add(newAcc);            
        }
        if(!accountsToUpdate.isEmpty()) upsert accountsToUpdate;
    }
}