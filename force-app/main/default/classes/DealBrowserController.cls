public with sharing class DealBrowserController {
    /*  Class Name : DealBrowserController
    *   Author : Kartik
    *   Description: This apex class is controller for the dealBrowser LWC
    *   Date: 11/07/2025
    *  
    */

    @AuraEnabled(cacheable = false)
    public static List<Deal__c> getFilterdDeals(String category, Integer minPrice, Integer maxPrice){
        System.debug(' Category :'+ category + ' minPrice : '+ minPrice + ' maxPrice : ' + maxPrice);

        String categoryFilter = category != null && category != 'All' ? category : null;

        String filterQuery = 'Select ID, Name, Price__c, Status__c, Is_Promoted__c, Category__c from Deal__c where Id != null';    
        
        if (categoryFilter !=null) filterQuery += ' AND Category__c = :categoryFilter';
        if (minPrice != null) filterQuery += ' AND Price__c >= :minPrice';
        if (maxPrice != null) filterQuery += ' AND Price__c <= :maxPrice';
        
        filterQuery += ' ORDER BY CreatedDate DESC LIMIT 100';

        return Database.query(filterQuery);
    }

    @AuraEnabled(cacheable = false)
    public static void showInterest(Id dealId){
        System.debug('show Interest method entered');
            Deal__c dealRec = [Select Id,Status__c from Deal__c where Id = :dealId];
            if(dealRec.Status__c == System.label.PICKLISTVAL_AVAILABLE){
                System.debug('show Interest if execution');
                dealRec.Status__c = System.label.PICKLISTVAL_INTERESTED;
                update dealRec;
            }
            else{
                throw new AuraHandledException('Deal is not Available to Show Interest.');
            }
    }
}