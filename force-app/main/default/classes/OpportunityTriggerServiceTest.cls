@isTest(SeeAllData=false)
public class OpportunityTriggerServiceTest {
        /*  Class Name : OpportunityTriggerServiceTest
        *   Author : Kartik
        *   Description: This is a test class for Renewal Opportunity Scheduler Apex Class
        *   Date: 14/07/2025.
        * 
        */
    	@isTest
        static void test_updateLatestClosedWonAmountForDelete(){
            Account acc = new Account(Name = 'Test Account');
            insert acc;
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today().addDays(10),Amount = 600000, AccountId = acc.Id);
            insert opp;
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{opp.Id => opp};
            Test.startTest();
            //OpportunityTriggerService.updateLatestClosedWon(oldMap);
            OpportunityTriggerService.updateLatestClosedWon(oldMap.keySet());
            Test.stopTest();
    }
        @isTest
        static void test_updateLatestClosedWonAmountForDelete2(){
        Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today().addDays(10),Amount = 600000);
        insert opp;
        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{opp.Id => opp};
        Test.startTest();
        //OpportunityTriggerService.updateLatestClosedWon(oldMap);
        OpportunityTriggerService.updateLatestClosedWon(oldMap.keySet());
        Test.stopTest();
    }
}