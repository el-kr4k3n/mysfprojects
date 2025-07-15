@isTest(SeeAllData=true)
public class RenewalOpportunitySchedulerTest {
    /*  Class Name : RenewalOpportunitySchedulerTest
     *   Author : Kartik
    * Description: This is a test class for Renewal Opportunity Scheduler Apex Class
    * Date: 14/07/2025.
    * 
    */
    static void TestData(Boolean recurringProduct, Boolean subYears, Boolean contactRole){
        //Create Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        //Create Contact
        Contact con = new Contact(FirstName = 'Test', LastName = 'Data', AccountId = acc.id, Email = 'test@example.com');
        insert con;
        //Create Product
        Product2 prod = new Product2(Name = 'Test Prodct', IsActive = true, Is_Recurring__c = true);
        if(!recurringProduct){
            prod.Is_Recurring__c = false;
        }
        insert prod;
        //Add product to pricebook
        Pricebook2 stdPB = [Select id from Pricebook2 where IsStandard  = true Limit 1];
        stdPB.IsActive = true;
        update stdPB;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdPb.Id, Product2Id = prod.Id, UnitPrice = 100, IsActive = true);
        insert pbe;       
        
        // Create Opportunity -7 days ago
        Opportunity opp = new Opportunity(Name = 'Test close Won',StageName = System.label.PICKLISTVAL_CLOSED_WON ,CloseDate = Date.today().addDays(-7),LeadSource = 'Web',
                                          AccountId = acc.Id,Pricebook2Id = stdPB.Id,Subscription_Period_in_Years__c = subYears ? 2 : null);
        insert opp;
        //Opportunity Line Items
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id,Quantity = 150,UnitPrice = 1000,PricebookEntryId = pbe.Id);
        insert oli;
        
        //Create Contact Role
        if(contactRole){
            OpportunityContactRole conrole = new OpportunityContactRole(ContactId = con.Id, OpportunityId = opp.Id, Role = 'Business User',
                                                                        IsPrimary = true);
            insert conrole;
            
        }
    }
    
    @isTest
    static void test_Method1(){
        //all data present
        TestData(true,true,true);
        Test.startTest();
        new RenewalOpportunityScheduler().execute(null);
        Test.stopTest();
        
        //verify the test result
        List<Opportunity> renewed = [Select Id, Name, Type, StageName, Opportunity__c from Opportunity where Name like '%Renewal%'];
        System.assertEquals(1, renewed.size(),'1 renew opp created');
        System.assertEquals('Renewal', renewed[0].Type);
        System.assertEquals(System.label.PICKLISTVAL_PRESENTATION, renewed[0].StageName);
        
        List<OpportunityLineItem> clonedOLI = [Select Id from OpportunityLineItem where OpportunityId = :renewed[0].Id];
        System.assertEquals(1, clonedOLI.size(), '1 oli cloned');
        
        List<OpportunityContactRole>  clonedOCR = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId = :renewed[0].Id];
        System.assertEquals(1, clonedOCR.size(), '1 Contact Role cloned');
    }
    @isTest
    static void test_Method2(){
        //recurring field missing from product
        TestData(false,true,true);
        Test.startTest();
        new RenewalOpportunityScheduler().execute(null);
        Test.stopTest();
        
        //verify the test result
        List<Opportunity> renewed = [Select Id from Opportunity where Name like '%Renewal%' limit 1];
        List<OpportunityLineItem>  cloneoli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :renewed[0].Id];
        System.assertEquals(0, cloneoli.size(),'no data as no line item created');
    }    
    @isTest
    static void test_Method3(){
        //subscription field missing
        TestData(true,false,true);
        Test.startTest();
        new RenewalOpportunityScheduler().execute(null);
        Test.stopTest();
        
        //verify the test result
        List<Opportunity> renewed = [Select Id from Opportunity where Name like '%Renewal%'];
        System.assertEquals(0, renewed.size(),'0 renew opp created');
    }
    @isTest
    static void test_Method4(){
        //no contact roles
        TestData(true,true,false);
        Test.startTest();
        new RenewalOpportunityScheduler().execute(null);
        Test.stopTest();
        
        Opportunity renewed = [Select Id from Opportunity where Name like '%Renewal%' limit 1];
        List<OpportunityContactRole> ocr = [Select Id from OpportunityContactRole where OpportunityId = :renewed.Id];
        System.assertEquals(0, ocr.size(), 'No OCR should be cloned if none existed');
    }
    
}