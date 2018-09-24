/*****************************************
* File: INT_OpportunityContactRoleHandler_TEST
* Author: Sierra-Cedar
* Description: Unit tests for INT_OpportunityContactRoleHandler.cls
******************************************/
@IsTest
private class INT_OpportunityContactRoleHandler_TEST {
    @TestSetup static void setUp() {
        hed__Trigger_Handler__c oppHandler = new hed__Trigger_Handler__c(
            Name = 'Update Opportunity Contact Role',
            hed__Object__c = 'Opportunity',
            hed__Class__c = 'INT_OpportunityContactRoleHandler',
            hed__Active__c = true,
            hed__Trigger_Action__c = 'BeforeUpdate;AfterInsert',
            hed__Load_Order__c = 1
        );
        insert oppHandler;
    }

    @IsTest
    static void testOpportunityContactRoleHandler() {
        // Arrange
        Contact aContact = new Contact(
            LastName = 'Johnson',
            Email = 'test@test.com'
        );
        insert aContact;

        Opportunity anOpportunity = new Opportunity(
            Name = 'test',
            AccountId = aContact.AccountId,
            CloseDate = Date.today(),
            StageName = 'Prospect',
            Contact__c = aContact.Id
        );

        // Act
        Test.startTest();
        insert anOpportunity;
        Test.stopTest();

        // Assert
        List<OpportunityContactRole> assertRoles = [
            SELECT ContactId, OpportunityId, IsPrimary, Role
            FROM OpportunityContactRole
            WHERE ContactId = :aContact.Id
        ];

        System.assertEquals(1, assertRoles.size(), 'Once Opportunity Contact Role should have been created.');
        System.assertEquals(true, assertRoles[0].IsPrimary, 'Role should be primary.');
        System.assertEquals('Opportunity Contact', assertRoles[0].Role, 'Role should be \'Opportunity Contact\'.');
        System.assertEquals(anOpportunity.Id, assertRoles[0].OpportunityId, 'Role should be tied to the test Opportunity.');
    }
}