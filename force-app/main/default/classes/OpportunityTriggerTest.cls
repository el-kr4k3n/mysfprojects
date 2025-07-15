@isTest(SeeAllData=false)
public class OpportunityTriggerTest {
        /*  Class Name : OpportunityTriggerTest
        *   Author : Kartik
        *   Description: This is a test class for Opportunity Trigger 
        *   Date: 14/07/2025.
        * 
        */
    @isTest
    static void test_Method1(){
        // Triggering all operations
        Test.startTest();
        Opportunity oppTest = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today());
        insert oppTest;
        oppTest.StageName = System.label.PICKLISTVAL_PROSPECTING;
        upsert oppTest;
        delete oppTest;
        undelete oppTest;
        Test.stopTest();
        
    }
}