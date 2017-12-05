/*****************************************
* File: INT_InteractionMappingService_TEST
* Author: Sierra-Cedar
* Description: Unit Tests for
******************************************/
@IsTest
private class INT_InteractionMappingService_TEST {
    @testSetup static void setUpTest() {
        // Create and insert Interaction Mapping Test Data
        List<Interaction_Mapping__c> testMappings = INT_TestDataFactory.createTestMappings();
        insert testMappings;
    }

    static testMethod void testCreateContact() {
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

    static testMethod void testCreateContactExcludedSources() {
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
}