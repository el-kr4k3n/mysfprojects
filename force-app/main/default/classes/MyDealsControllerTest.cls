@isTest(SeeAllData=false)

public class MyDealsControllerTest {
        /*  Class Name : MyDealsControllerTest
        *   Author : Kartik
        *   Description: This is a test class for My Deals Controller 
        *   Date: 14/07/2025.
        * 
        */
    @isTest
    static void TestData(){
        //create test user
        User testUser = [select Id,name,Profile.Name from User where Profile.Name = 'System Administrator' limit 1];
        
        System.runAs(testUser){
            List<Deal__c> listOfDeals = new List<Deal__c>{
                new Deal__c(Name = 'Deal 1',Price__c = 800000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = true, Category__c = System.label.CATEGORY_ELECTRONICS,OwnerId = testUser.Id),
                    new Deal__c(Name = 'Deal 2',Price__c = 850000, Status__c = System.label.PICKLISTVAL_AVAILABLE, Is_Promoted__c = true, Category__c = System.label.CATEGORY_BOOKS)
                    };
                insert listOfDeals;
            
            Test.startTest();
            List<Deal__c> result = MyDealsController.getMyDeals();
            Test.stopTest();
            
            System.assertEquals(2, result.size(), 'Expected 2');
        }
    }
}