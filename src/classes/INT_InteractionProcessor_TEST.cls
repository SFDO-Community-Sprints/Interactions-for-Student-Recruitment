/*****************************************
* File: INT_InteractionProcessor_TEST
* Author: Sierra-Cedar
* Description: Unit Tests for INT_InteractionProcessor.cls
******************************************/
@IsTest
private class INT_InteractionProcessor_TEST {
    @TestSetup
    static void setUpTest() {
        // Create and insert Interaction Mapping Test Data
        List<Interaction_Mapping__c> testMappings = INT_TestDataFactory.createTestMappings();
        insert testMappings;
    }

    @IsTest
    static void testInsertDupeLeadsOnlyInImport() {
        // Arrange
        List<Interaction__c> interactionsToInsert = new List<Interaction__c>();

        for (Integer i = 0; i < 200; i++) { // Create 200 duplicate Interactions which should be de-duped once processed
            Interaction__c testInt = new Interaction__c(
                First_Name__c = 'Test',
                Last_Name__c = 'Man',
                Email__c = 'test@nomail.com',
                Lead_Only__c = true
            );
            interactionsToInsert.add(testInt);
        }

        // Act
        Test.startTest();
        insert interactionsToInsert;
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT FirstName, LastName FROM Lead];
        System.assertEquals(1, leads.size(),
            '1 Lead Expected - This test converts Leads only and does not process Interactions. ' +
                'Duplicate pre-processing should have prevented the processing of duplicate records.');

        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Name, Account.Name FROM Contact]);
        System.assertEquals(0, contactMap.size(),
            '0 Contacts Expected - This test converts Leads only and does not process Interactions. ' +
                'Duplicate pre-processing should have prevented the processing of duplicate records.');

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account]);
        System.assertEquals(0, accountMap.size(),
            '0 Accounts Expected - This test converts Leads only and does not process Interactions. ' +
                'Duplicate pre-processing should have prevented the processing of duplicate records.');

        Integer importedFound = 0;
        Integer auditFound = 0;
        for (Interaction__c interaction : [SELECT Interaction_Status__c, Audit_Reason__c FROM Interaction__c]) {
            if (interaction.Interaction_Status__c == 'Imported') importedFound++;
            if (interaction.Interaction_Status__c == 'Audit Required') auditFound++;
        }

        System.assertEquals(1, importedFound,
            '1 Imported Interaction expected - ' +
                'Duplicate pre-processing should have prevented the processing of duplicate records.');
        System.assertEquals(199, auditFound,
            '199 Audit Required Interactions expected - ' +
                'Duplicate pre-processing should have prevented the processing of duplicate records.');
    }

    @IsTest
    static void testBulkInsertLeadsOnly() {
        // Arrange
        List<Interaction__c> interactionsToInsert = INT_TestDataFactory.createBulkTestInteractions();

        for (Interaction__c interaction : interactionsToInsert) {
            interaction.Lead_Only__c = true;
        }

        // Act
        Test.startTest();
        insert interactionsToInsert;
        Test.stopTest();

        // Assert
        List<Contact> contacts = [SELECT Name, AccountId FROM Contact];
        System.assert(contacts.size() == 0);
        List<Account> accounts = [SELECT Name FROM Account];
        System.assert(accounts.size() == 0);
    }

    @IsTest
    static void testBulkInteractionInsert() {
        // Arrange
        List<Interaction__c> interactionsToInsert = INT_TestDataFactory.createBulkTestInteractions();

        Interaction__c testInt = new Interaction__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Man',
            Email__c = 'test@nomail.com'
        );
        interactionsToInsert.add(testInt);

        Interaction__c testInt2 = new Interaction__c(
            First_Name__c = 'Super',
            Last_Name__c = 'Gary',
            Email__c = 'super.gary@nomail.com'
        );
        interactionsToInsert.add(testInt2);

        // Act
        Test.startTest();
        insert interactionsToInsert;
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT FirstName, LastName FROM Lead];
        System.assert(leads.size() == 0,
            'Lead count expected to be at 0. Once converted, the Leads should be deleted');

        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Name, Account.Name FROM Contact]);
        System.assert(contactMap.size() == 502, '502 Contacts Expected - 1 for each of the 502 Interactions');

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account]);
        System.assert(accountMap.size() == 502, '502 Accounts Expected - 1 for each of the 502 Interactions');

        List<Interaction__c> interactions = [
            SELECT First_Name__c, Last_Name__c, Contact__r.Name, Contact__c, Contact_Account_ID__c, Opportunity__c,
                Contact__r.Account.Name, Interaction_Status__c
            FROM Interaction__c
            ORDER BY Interaction_Status__c
        ];

        for (Interaction__c i : interactions) {
            System.assert(i.Contact__c != null);
            System.assertEquals(i.Contact__c, contactMap.get(i.Contact__c).Id,
                'Interaction Contact Id does not match Contact in system');
        }
    }

    @IsTest
    static void testPreProcessing() {
        // Arrange
        List<Interaction__c> interactionsToInsert = new List<Interaction__c>();

        Interaction__c testInt = new Interaction__c(
            First_Name__c = 'Super',
            Last_Name__c = 'Gary',
            Email__c = 'super.gary@nomail.com',
            Interaction_Status__c = 'New'
        );
        interactionsToInsert.add(testInt);

        // Create duplicate Interaction record, this should not be imported.
        Interaction__c testInt2 = new Interaction__c(
            First_Name__c = 'Super',
            Last_Name__c = 'Gary',
            Email__c = 'super.gary@nomail.com',
            Interaction_Status__c = 'New'
        );
        interactionsToInsert.add(testInt2);

        // Act
        Test.startTest();
        insert interactionsToInsert;
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT FirstName, LastName FROM Lead];
        System.assert(leads.size() == 0, 'Lead count expected to be at 0. Once converted, the Leads should be deleted');

        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Name, Account.Name FROM Contact]);
        System.assert(contactMap.size() == 1, '1 Contact Expected - Duplicate pre-processing should have prevented the second Interaction from processing.');

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account]);
        System.assert(accountMap.size() == 1, '1 Accounts Expected - Duplicate pre-processing should have prevented the second Interaction from processing.');

        List<Interaction__c> interactions = [
            SELECT Interaction_Status__c, Audit_Reason__c, Contact__c, First_Name__c
            FROM Interaction__c
            ORDER BY Interaction_Status__c
        ];
        System.assert(interactions[0].Interaction_Status__c == 'Audit Required');
        System.assert(interactions[1].Interaction_Status__c == 'Imported');
    }

    @IsTest
    static void testOpportunityCreation() {
        // Arrange
        Map<String, Schema.RecordTypeInfo> accRTInfo = Account.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> planRTInfo = Plan__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        Account testCollege = new Account(
            Name = 'College of Arts & Sciences',
            RecordTypeId = accRTInfo.get('University Department').getRecordTypeId()
        );
        insert testCollege;

        Account testUniversity = new Account(
            Name = 'Connected University',
            RecordTypeId = accRTInfo.get('Educational Institution').getRecordTypeId()
        );
        insert testUniversity;

        Plan__c acadPlan = new Plan__c(
            Name = 'Business Administration BA',
            Type__c = 'Academic',
            Department__c = testCollege.Id,
            Career__c = 'Undergraduate',
            Active__c = true
        );

        if (planRTInfo != null && planRTInfo.containsKey('Academic Plan')) {
            acadPlan.put('RecordTypeId', planRTInfo.get('Academic Plan').getRecordTypeId());
        }

        insert acadPlan;

        hed__Term__c testFallTerm = new hed__Term__c(
            Name = 'Fall ' + (System.today().year() + 1),
            hed__Start_Date__c = Date.newInstance((System.today().year() + 1), 8, 15),
            hed__End_Date__c = Date.newInstance((System.today().year() + 1), 12, 16),
            hed__Account__c = testCollege.Id
        );
        insert testFallTerm;

        Interaction__c testInt = new Interaction__c(
            First_Name__c = 'Super',
            Last_Name__c = 'Gary',
            Email__c = 'superdgary@nomail.com',
            Contact_Title__c = 'Mr.',
            Constituent_ID__c = '123456',
            Gender__c = 'Male',
            Race__c = 'White',
            Birthdate__c = Date.newInstance(1998, 1, 1),
            Admit_Type__c = 'New Freshman',
            Academic_Interest__c = acadPlan.Id,
            Term__c = testFallTerm.Id,
            Lead_Source__c = 'Office Visit',
            Affiliated_Account__c = testUniversity.Id,
            Affiliation_Role__c = 'Student',
            Primary_Affiliation__c = true
        );

        // Act
        Test.startTest();
        insert testInt;
        Test.stopTest();

        // Assert
        Interaction__c assertInteraction = [
            SELECT First_Name__c, Last_Name__c, Contact__c, Contact_Account_ID__c, Opportunity__c, Term__r.Name,
                Interaction_Status__c, Contact_Title__c, Birthdate__c, Opportunity_Name__c, Career__c
            FROM Interaction__c
            WHERE Id = :testInt.Id
        ];
        System.assert(assertInteraction.Interaction_Status__c == 'Imported', 'Interaction should have been updated to \'Imported\' status.');
        System.assert(!String.isEmpty(assertInteraction.Contact__c), 'Contact should have been populated.');
        System.assert(!String.isEmpty(assertInteraction.Contact_Account_ID__c), 'Account should have been populated.');
        System.assert(!String.isEmpty(assertInteraction.Opportunity__c), 'Opportunity should have been populated.');

        List<Lead> leads = [SELECT FirstName, LastName FROM Lead];
        System.assert(leads.size() == 0, 'Lead count expected to be at 0. Once converted, the Leads should be deleted');

        Contact assertContact = [
            SELECT FirstName, LastName, AccountId, Title, Birthdate,
                (SELECT hed__Account__c FROM hed__Affl_Accounts__r)
            FROM Contact
            WHERE Id = :assertInteraction.Contact__c
        ];
        System.assertEquals(assertInteraction.Birthdate__c, assertContact.Birthdate, 'Birthdate should have been copied over to Contact.');
        System.assert(assertContact.hed__Affl_Accounts__r.size() == 1, 'Affiliation should have been created.');
        System.assertEquals(assertContact.hed__Affl_Accounts__r[0].hed__Account__c, testUniversity.Id, 'Affiliation Account should have been mapped to the testUniversity.');
        System.assertEquals(assertInteraction.Contact__c, assertContact.Id, 'The Contact lookup should have been populated on the Interaction');

        Opportunity assertOppty = [SELECT Name, Career__c, StageName FROM Opportunity WHERE Id = :assertInteraction.Opportunity__c];
        System.assertEquals('Inquired', assertOppty.StageName, 'Stage should be defaulted from processing to \'Inquired\'.');
        System.assertEquals(assertInteraction.Opportunity_Name__c, assertOppty.Name, 'Name should have been copied over to Opportunity.');
        System.assertEquals(assertInteraction.Career__c, assertOppty.Career__c, 'Career__c should have been copied over to Opportunity.');
    }

    @IsTest
    static void testSkipMappingSources() {
        // Arrange
        List<Interaction__c> interactionsToInsert = new List<Interaction__c>();

        Interaction__c testInt = new Interaction__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Man',
            Email__c = 'test@nomail.com',
            Gender__c = 'Male',
            Interaction_Source__c = 'Webform'
        );
        interactionsToInsert.add(testInt);

        // Act
        Test.startTest();
        insert interactionsToInsert;
        Test.stopTest();

        // Assert
        List<Lead> leads = [SELECT FirstName, LastName FROM Lead];
        System.assert(leads.size() == 0, 'Lead count expected to be at 0. Once converted, the Leads should be deleted');

        List<Contact> contactList = new List<Contact>([SELECT FirstName, LastName, hed__Gender__c, Account.Name FROM Contact]);
        System.assert(contactList.size() == 1, '1 Contact Expected');
        System.assert(String.isEmpty(contactList[0].hed__Gender__c), 'Gender should not have been copied over for this skipped Interaction source.');

        List<Account> accountMap = new List<Account>([SELECT Name FROM Account]);
        System.assert(accountMap.size() == 1, '1 Account Expected');
    }

    @IsTest
    static void testCampaignMemberCreation() {
        // Arrange
        List<Campaign> testCampaigns = new List<Campaign>();

        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        Campaign testAddlCampaign = new Campaign(Name = 'Test Additional Campaign');
        testCampaigns.add(testCampaign);
        testCampaigns.add(testAddlCampaign);
        insert testCampaigns;

        Interaction__c testInt = new Interaction__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Man',
            Email__c = 'test@nomail.com',
            Interaction_Source__c = 'Student Information System',
            Campaign__c = testCampaign.Id,
            Campaign_Member_Status__c = 'Sent',
            Additional_Campaign__c = testAddlCampaign.Id,
            Additional_Campaign_Member_Status__c = 'Sent'
        );

        // Act
        Test.startTest();
        insert testInt;
        Test.stopTest();

        // Assert
        List<Lead> assertLeads = [SELECT FirstName, LastName FROM Lead];
        System.assert(assertLeads.size() == 0, 'Lead count expected to be at 0. Once converted, the Leads should be deleted');

        List<Contact> assertContacts = new List<Contact>([SELECT FirstName, LastName, hed__Gender__c, Account.Name FROM Contact]);
        System.assert(assertContacts.size() == 1, '1 Contact expected');

        List<Account> assertAccounts = new List<Account>([SELECT Name FROM Account]);
        System.assert(assertAccounts.size() == 1, '1 Account Expected');

        List<CampaignMember> assertCMs = [SELECT Name, CampaignId, Status, ContactId FROM CampaignMember];
        System.assertEquals(2, assertCMs.size(), '2 CampaignMembers expected, one for each Campaign.');

        // Build out CM map for assertion.
        Map<Id, CampaignMember> campaignMemberMap = new Map<Id, CampaignMember>(); // CampaignId => CampaignMember
        for (CampaignMember cm : assertCMs) campaignMemberMap.put(cm.CampaignId, cm);

        // First Campaign
        System.assert(campaignMemberMap.containsKey(testCampaign.Id), 'CampaignMember should exist for this Campaign.');
        System.assertEquals(testCampaign.Id, campaignMemberMap.get(testCampaign.Id).CampaignId, 'CampaignMember should have been created for test Campaign.');
        System.assertEquals(assertContacts[0].Id, campaignMemberMap.get(testCampaign.Id).ContactId, 'Contact Id should match Contact created.');

        System.assert(campaignMemberMap.containsKey(testAddlCampaign.Id), 'CampaignMember should exist for this Campaign.');
        System.assertEquals(testAddlCampaign.Id, campaignMemberMap.get(testAddlCampaign.Id).CampaignId, 'CampaignMember should have been created for test Campaign.');
        System.assertEquals(assertContacts[0].Id, campaignMemberMap.get(testAddlCampaign.Id).ContactId, 'Contact Id should match Contact created.');
    }

    @IsTest
    static void testCMCreationWithExistingLeadAndCM() {
        // Arrange
        Lead testLead = new Lead(
            FirstName = 'Tony',
            LastName = 'Stark',
            Email = 'test@nomail.com',
            Company = 'Stark, Tony'
        );
        insert testLead;

        Campaign testCampaign = new Campaign(
            Name = 'Test Campaign'
        );
        insert testCampaign;

        Campaign testCampaign2 = new Campaign(
            Name = 'Test Campaign 2'
        );
        insert testCampaign2;

        CampaignMember testCM = new CampaignMember(
            LeadId = testLead.Id,
            CampaignId = testCampaign.Id,
            Status = 'Added to Campaign'
        );
        insert testCM;

        Interaction__c testInteraction = new Interaction__c(
            First_Name__c = 'Tony',
            Last_Name__c = 'Stark',
            Email__c = 'test@nomail.com',
            Campaign__c = testCampaign2.Id,
            Campaign_Member_Status__c = 'Added to Campaign'
        );

        // Act
        Test.startTest();
        insert testInteraction;
        Test.stopTest();

        // Assert
        Interaction__c assertInteraction = [SELECT Interaction_Status__c FROM Interaction__c WHERE Id = :testInteraction.Id];
        System.assertEquals('Imported', assertInteraction.Interaction_Status__c, 'Interaction should have successfully imported.');

        List<CampaignMember> assertCampaignMembers = [SELECT Contact.FirstName, Campaign.Name, Status, LeadId, ContactId FROM CampaignMember];
        System.assertEquals(2, assertCampaignMembers.size(), '2 Campaign Members should have been created for the Lead/Interaction.');
    }
}
