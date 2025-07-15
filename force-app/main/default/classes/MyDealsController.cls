public with sharing class MyDealsController {
    /*  Class Name : MyDealsController
    *   Author : Kartik
    *   Description: This apex class is controller for the myDeals LWC
    *   Date: 12/07/2025
    *  
    */

    @AuraEnabled(cacheable = true) 
    public static List<Deal__c> getMyDeals() {
        List<Deal__c> dealList = [Select Id,Name,Price__c,Status__c, Is_Promoted__c,Category__c 
                                from Deal__c 
                                where OwnerId =: UserInfo.getUserId()
                                Order By CreatedDate DESC
                                ];
        return dealList;
    }
    @AuraEnabled
    public static void updateDeals(List<Deal__c> listOfDealsToUpdate) {
        System.debug('listOfDealsToUpdate: '+listOfDealsToUpdate);
        if(!listOfDealsToUpdate.isEmpty()) update listOfDealsToUpdate;
    }
}