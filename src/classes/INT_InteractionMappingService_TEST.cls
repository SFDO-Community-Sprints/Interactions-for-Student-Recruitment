/*****************************************
* File: INT_InteractionMappingService_TEST
* Author: Sierra-Cedar
* Description: Unit Tests for INT_InteractionMappingService.cls
******************************************/
@IsTest
private class INT_InteractionMappingService_TEST {
    @TestSetup
    static void setUpTest() {
        // Create and insert Interaction Mapping Test Data
        List<Interaction_Mapping__c> testMappings = INT_TestDataFactory.createTestMappings();
        insert testMappings;
    }

    @IsTest
    static void testCreateContact() {
        // Arrange
        Interaction__c testInteraction = new Interaction__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact',
            Interaction_Status__c = 'New'
        );

        Contact c = new Contact(
            FirstName = 'Something',
            LastName = 'Else'
        );

        // Act
        Test.startTest();
        INT_InteractionMappingService interactionMapping = new INT_InteractionMappingService();
        interactionMapping.applyDataToSObject(testInteraction, c);
        Test.stopTest();

        // Assert
        System.assert(c.FirstName == 'Test');
        System.assert(c.LastName == 'Contact');
    }

    @IsTest
    static void testCreateContactExcludedSources() {
        // Arrange
        Interaction__c testInteraction = new Interaction__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact',
            Interaction_Status__c = 'New',
            Interaction_Source__c = 'Webform'
        );

        Contact c = new Contact(
            FirstName = 'Something',
            LastName = 'Else'
        );

        // Act
        Test.startTest();
        INT_InteractionMappingService interactionMapping = new INT_InteractionMappingService();
        interactionMapping.applyDataToSObject(testInteraction, c);
        Test.stopTest();

        // Assert
        // Interaction data should NOT be copied over since we exclude Webform Sources
       	System.assert(c.FirstName == 'Something');
       	System.assert(c.LastName == 'Else');
    }

    @IsTest
    static void testMapFromLeadSources() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'test@nomail.com',
            Company = 'Lead, Test'
        );

        Interaction__c testInteraction = new Interaction__c(
            First_Name__c = '',
            Last_Name__c = 'Lead',
            Interaction_Status__c = 'New',
            Interaction_Source__c = 'Webform'
        );

        // Act
        Test.startTest();
        INT_InteractionMappingService interactionMapping = new INT_InteractionMappingService();
        interactionMapping.applyDataToInteraction(testLead, testInteraction);
        Test.stopTest();

        // Assert
        System.assertEquals('Test', testInteraction.First_Name__c, 'The first name on Lead should have been copied to the Interaction as per the mappings.');
    }
}