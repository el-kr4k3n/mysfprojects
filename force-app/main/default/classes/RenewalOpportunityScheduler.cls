global class RenewalOpportunityScheduler implements Schedulable {
    /*  Class Name : RenewalOpportunityScheduler
     *   Author : Kartik
     *  Descrition: Scedule apex class to Clone opportunities and related list
     *  Date: 11/07/2025.
     * 
     * String cronExpr = '0 0 0 * * ?'; // 0 seconds, 0 minutes, 0 hours = 12:00 AM every day
	 * System.schedule('Daily Renewal Opportunity Job', cronExpr, new RenewalOpportunityScheduler());
	 */
    global void execute(SchedulableContext sc){
        Date targetDate = Date.today().addDays(-7);
        
        //Retrieving closedwon opportunity
        List<Opportunity> closedWonOpportunity = [Select Id,Name,LeadSource,Opportunity__c,Amount,CloseDate,NextStep,CampaignId,
                                                  OwnerId,AccountId,Subscription_Period_in_Years__c
                                                  From Opportunity 
                                                  where StageName = :System.label.PICKLISTVAL_CLOSED_WON 
                                                  AND CloseDate = :targetDate
                                                  AND Subscription_Period_in_Years__c != null
                                                 ];
        System.debug('closedWonOpportunity'+closedWonOpportunity);
        if(closedWonOpportunity.isEmpty()) return;
        
        List<Opportunity> renewalOpportunityList = new List<Opportunity>();
        Set<Id> oppIds = new Set<Id>();        
        //Create Renewal Opportunity 
        for(Opportunity oldRec : closedWonOpportunity){
            Opportunity newRec = new Opportunity();
            newRec.Name 	   = oldRec.Name + ' - Renewal';
            newRec.Type 	   = 'Renewal';
            newRec.StageName   = System.label.PICKLISTVAL_PRESENTATION;
            newRec.LeadSource  = oldRec.LeadSource;
            newRec.Subscription_Period_in_Years__c   = oldRec.Subscription_Period_in_Years__c;
            newRec.Opportunity__c   = oldRec.Id;
            newRec.Amount   = oldRec.Amount;
            newRec.CloseDate   = oldRec.CloseDate.addYears((Integer)oldRec.Subscription_Period_in_Years__c);
            newRec.NextStep   = oldRec.NextStep;
            newRec.CampaignId  = oldRec.CampaignId;
            newRec.OwnerId  = oldRec.OwnerId ;
            newRec.AccountId  = oldRec.AccountId;
            //newRec.MainCompetitors__c  = oldRec.MainCompetitors__c;
            
            renewalOpportunityList.add(newRec);
            oppIds.add(oldRec.Id);
        }
        System.debug('renewalOpportunityList'+renewalOpportunityList);
        if(!renewalOpportunityList.isEmpty()) insert renewalOpportunityList;
        
        //Retrieving related records - opportunity line items
        Map<Id, List<OpportunityLineItem>> mapOfRecurringLineItems = new Map<Id, List<OpportunityLineItem>>();
        List<OpportunityLineItem> relatedLineItems = [select id,Name,OpportunityId,Quantity,UnitPrice, PricebookEntryId,Product2Id,Product2.Is_Recurring__c 
                                                      from OpportunityLineItem
                                                      where OpportunityId IN :oppIds
                                                      AND Product2.Is_Recurring__c = true
                                                     ];
		System.debug('relatedLineItems product recurring is true'+relatedLineItems);
        for(OpportunityLineItem lineItem : relatedLineItems){
            if(!mapOfRecurringLineItems.containsKey(lineItem.OpportunityId)){
                mapOfRecurringLineItems.put(lineItem.OpportunityId,new List<OpportunityLineItem>()); //{lineItem}
            }
            mapOfRecurringLineItems.get(lineItem.OpportunityId).add(lineItem);
        }
        
        //Creating related opportunity line items
        List<OpportunityLineItem> newOpportunityLineItemList = new List<OpportunityLineItem>();
        Map<Id,Id> mapOfOldToNewIds = new Map<Id,Id>();
        for(Integer i=0; i < closedWonOpportunity.size(); i++){
            mapOfOldToNewIds.put(closedWonOpportunity[i].Id,renewalOpportunityList[i].Id);
        }
        for(Opportunity oldRec : closedWonOpportunity){
            if(mapOfRecurringLineItems.containsKey(oldRec.Id)){
                Id newOppId = mapOfOldToNewIds.get(oldRec.id);
                for(OpportunityLineItem oliOldRec : mapOfRecurringLineItems.get(oldRec.id)){
                    OpportunityLineItem oliNewRec = new OpportunityLineItem();
                    oliNewRec.OpportunityId = newOppId;
                    oliNewRec.Quantity = oliOldRec.Quantity;
                    oliNewRec.UnitPrice = oliOldRec.UnitPrice;
                    oliNewRec.PricebookEntryId = oliOldRec.PricebookEntryId;
                    newOpportunityLineItemList.add(oliNewRec);
                }
            }
        }
        System.debug('newOpportunityLineItemList: '+newOpportunityLineItemList);
        if(!newOpportunityLineItemList.isEmpty()) insert newOpportunityLineItemList;

        
        //Retrieving related records - Contact Roles
        Map<Id, List<OpportunityContactRole>> mapOfOppContactRoles = new Map<Id, List<OpportunityContactRole>>();
        for (OpportunityContactRole ocrRec : [SELECT Id, OpportunityId, ContactId, Role, IsPrimary
                                           FROM OpportunityContactRole
                                           WHERE OpportunityId IN :oppIds]){
            if(!mapOfOppContactRoles.containsKey(ocrRec.OpportunityId)){
                mapOfOppContactRoles.put(ocrRec.OpportunityId, new List<OpportunityContactRole>());  //{ocrRec}
            }
            mapOfOppContactRoles.get(ocrRec.OpportunityId).add(ocrRec);
        }        
        System.debug('mapOfOppContactRoles: '+mapOfOppContactRoles);

        // Creating related list - Contact Roles
        List<OpportunityContactRole> newContactRoles = new List<OpportunityContactRole>();
        for(Opportunity oldRec : closedWonOpportunity){
            if(mapOfOppContactRoles.containsKey(oldRec.Id)){
                Id newOppId = mapOfOldToNewIds.get(oldRec.id);
                for(OpportunityContactRole ocrOldRec: mapOfOppContactRoles.get(oldRec.Id)){
                    OpportunityContactRole ocrNewRec = new OpportunityContactRole();
                    ocrNewRec.OpportunityId = newOppId;
                    ocrNewRec.ContactId = ocrOldRec.ContactId;
                    ocrNewRec.Role = ocrOldRec.Role;
                    ocrNewRec.IsPrimary = ocrOldRec.IsPrimary;
                    newContactRoles.add(ocrNewRec);
                }
            }
        }
        System.debug('newContactRoles: '+newContactRoles);
        if(!newContactRoles.isEmpty()) insert newContactRoles;
        
        //Sending email notification
        List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [select id from EmailTemplate where DeveloperName = 'Renewal_Opportunity_Created' limit 1];
        for(Opportunity oppRec : renewalOpportunityList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(oppRec.OwnerId);
            mail.setTemplateId(template.id);	//
            mail.setSaveAsActivity(false);
            listOfMail.add(mail);
        }
        System.debug('newContactRoles: '+newContactRoles);
        if(!listOfMail.isEmpty()) Messaging.sendEmail(listOfMail);
    }
}