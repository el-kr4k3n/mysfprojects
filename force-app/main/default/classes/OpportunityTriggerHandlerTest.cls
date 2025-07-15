@isTest(SeeAllData=false)
public class OpportunityTriggerHandlerTest {
        /*  Class Name : OpportunityTriggerHandlerTest
        *   Author : Kartik
        *   Description: This is a test class for Opportunity Trigger 
        *   Date: 14/07/2025.
        * 
        */
    @isTest
    static void test_setCloseDate(){
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_PROSPECTING,CloseDate = Date.today().addDays(10));
            insert opp;
            Opportunity oldOpp = opp.clone(false,false,false,false);
            oldOpp.Id = opp.Id;
            oldOpp.StageName = System.label.PICKLISTVAL_CLOSED_WON;
            update oldOpp;
            List<Opportunity> newList = [Select Id, StageName, CloseDate from Opportunity where Id = :opp.Id];
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{oldOpp.Id=>oldOpp };
            Test.startTest();
            OpportunityTriggerHandler.setCloseDate(newList,oldMap);
            Test.stopTest();
    }
    
    @isTest
    static void test_postOnFeed(){
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_PROSPECTING,CloseDate = Date.today().addDays(10),Amount = 600000);
            insert opp;
            Opportunity oldOpp = opp.clone(false,false,false,false);
            oldOpp.Id = opp.Id;
            oldOpp.StageName = System.label.PICKLISTVAL_CLOSED_WON;
            update oldOpp;
            List<Opportunity> newList = [Select Id, StageName, CloseDate from Opportunity where Id = :opp.Id];
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{oldOpp.Id=>oldOpp };
            Test.startTest();
            OpportunityTriggerHandler.postOnFeed(newList,oldMap);
            Test.stopTest();
    }
        @isTest
        static void test_postOnFeedNegative(){
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_PROSPECTING,CloseDate = Date.today().addDays(10),Amount = 250);
            insert opp;
            Opportunity oldOpp = opp.clone(false,false,false,false);
            oldOpp.Id = opp.Id;
            oldOpp.StageName = System.label.PICKLISTVAL_CLOSED_WON;
            update oldOpp;
            List<Opportunity> newList = [Select Id, StageName, CloseDate from Opportunity where Id = :opp.Id];
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{oldOpp.Id=>oldOpp };
            Test.startTest();
            OpportunityTriggerHandler.postOnFeed(newList,oldMap);
            Test.stopTest();
    }
        @isTest
        static void test_postOnFeedForUndelete(){
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today().addDays(10),Amount = 600000);
            insert opp;
            List<Opportunity> newList = [Select Id, StageName,CloseDate,Amount from Opportunity where Id = :opp.Id];
            Test.startTest();
            OpportunityTriggerHandler.postOnFeedForUndelete(newList);
            Test.stopTest();
    }
    	@isTest
        static void test_updateLatestClosedWonAmountForDelete(){
            Account acc = new Account(Name = 'Test Account');
            insert acc;
            Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today().addDays(10),Amount = 600000, AccountId = acc.Id);
            insert opp;
            Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{opp.Id => opp};
            Test.startTest();
            OpportunityTriggerHandler.updateLatestClosedWonAmountForDelete(oldMap);
            OpportunityTriggerHandler.updateLatestClosedWonAmount(oldMap.keySet());
            Test.stopTest();
    }
        @isTest
        static void test_updateLatestClosedWonAmountForDelete2(){
        Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON,CloseDate = Date.today().addDays(10),Amount = 600000);
        insert opp;
        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{opp.Id => opp};
        Test.startTest();
        OpportunityTriggerHandler.updateLatestClosedWonAmountForDelete(oldMap);
        OpportunityTriggerHandler.updateLatestClosedWonAmount(oldMap.keySet());
        Test.stopTest();
    }
}