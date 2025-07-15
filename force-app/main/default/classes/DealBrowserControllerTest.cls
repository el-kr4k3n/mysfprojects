@isTest(SeeAllData=false)
public class DealBrowserControllerTest {
    /*  Class Name : DealBrowserControllerTest
    *   Author : Kartik
    *   Description: This is a test class for Deal Browser Controller 
    *   Date: 14/07/2025.
    * 
    */
    static void TestData(){
        List<Deal__c> listOfDeals = new List<Deal__c>{
            new Deal__c(Name = 'Deal 1',Price__c = 800000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = true, Category__c = System.label.CATEGORY_ELECTRONICS),
                new Deal__c(Name = 'Deal 2',Price__c = 850000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = true, Category__c = System.label.CATEGORY_BOOKS),
                new Deal__c(Name = 'Deal 3',Price__c = 900000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = true, Category__c = System.label.CATEGORY_FURNITURE),
                new Deal__c(Name = 'Deal 4',Price__c = 950000, Status__c = System.label.PICKLISTVAL_INTERESTED, Is_Promoted__c = true, Category__c = System.label.CATEGORY_OTHERS),
                new Deal__c(Name = 'Deal 5',Price__c = 1000000, Status__c = System.label.PICKLISTVAL_CLOSED, Is_Promoted__c = true, Category__c = System.label.CATEGORY_OTHERS)
                };
                    insert listOfDeals;
    }
    
    @isTest
    static void test_Method1() {
        //postive all data
        TestData();
        
        Test.startTest();
        List<Deal__c> results = DealBrowserController.getFilterdDeals(System.label.CATEGORY_ELECTRONICS, 600000, 1000000);
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Only Deal A1');
        System.assertEquals(System.label.CATEGORY_ELECTRONICS, results[0].Category__c);
    }
    @isTest
    static void test_Method2() {
        //no filters
        TestData();
        
        Test.startTest();
        List<Deal__c> results = DealBrowserController.getFilterdDeals(null, null, null);
        Test.stopTest();
        
        System.assertEquals(5, results.size(), 'All deals');
    }
    @isTest
    static void test_Method3() {
        //show interest button clicked
        Deal__c deal = new Deal__c(Name = 'Deal Interested', Price__c = 10000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = false, Category__c = System.label.CATEGORY_BOOKS);
        insert deal;
        
        Test.startTest();
        DealBrowserController.showInterest(deal.Id);
        Test.stopTest();
        
        Deal__c updated = [Select Status__c from Deal__c where Id = :deal.Id];
        System.assertEquals(System.label.PICKLISTVAL_INTERESTED, updated.Status__c);
    }
    /*
    @isTest
    static void test_Method4() {
        // throw exception for code coverage
        Deal__c deal = new Deal__c(Name = 'Not Available Deal', Price__c = 9999, Status__c = 'Closed', Category__c = 'Books');
        insert deal;
        
        Test.startTest();
            DealBrowserController.showInterest(deal.Id);
        Test.stopTest();
}
        */
    
}