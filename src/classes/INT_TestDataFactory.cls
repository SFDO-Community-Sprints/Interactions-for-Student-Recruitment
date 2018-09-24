/*****************************************
* File: INT_TestDataFactory
* Author: Sierra-Cedar
* Description: Test data factory for Interactions
******************************************/
@IsTest
public class INT_TestDataFactory {
    /**
     * @description Creates and returns a List of Interaction_Mapping__c test data
     * @return testMappingsToInsert, the List of test data to insert in your unit test
     */
    public static List<Interaction_Mapping__c> createTestMappings() {
        List<Interaction_Mapping__c> testMappingsToInsert = new List<Interaction_Mapping__c>();

        /* CampaignMember Mappings */
        Interaction_Mapping__c campaignMemberStatusMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'CampaignMember',
            Source_Field_API_Name__c = 'Campaign_Member_Status__c',
            Target_Field_API_Name__c = 'Status',
            Active__c = true
        );
        testMappingsToInsert.add(campaignMemberStatusMapping);

        /* Contact Mappings */
        Interaction_Mapping__c contactBirthdateMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Birthdate__c',
            Target_Field_API_Name__c = 'Birthdate',
            Active__c = true
        );
        testMappingsToInsert.add(contactBirthdateMapping);

        Interaction_Mapping__c contactConstituentMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Constituent_ID__c',
            Target_Field_API_Name__c = 'Constituent_ID__c',
            Active__c = true
        );
        testMappingsToInsert.add(contactConstituentMapping);


        Interaction_Mapping__c contactEmailMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Email__c',
            Target_Field_API_Name__c = 'Email',
            Active__c = true
        );
        testMappingsToInsert.add(contactEmailMapping);

        Interaction_Mapping__c contactFirstNameMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'First_Name__c',
            Target_Field_API_Name__c = 'FirstName',
			Skip_Mapping__c = 'Webform',
            Active__c = true
        );
        testMappingsToInsert.add(contactFirstNameMapping);

        Interaction_Mapping__c contactGenderMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Gender__c',
            Target_Field_API_Name__c = 'hed__Gender__c',
            Skip_Mapping__c = 'Webform;Manual Entry',
            Active__c = true
        );
        testMappingsToInsert.add(contactGenderMapping);

        Interaction_Mapping__c contactHomePhoneMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Home_Phone__c',
            Target_Field_API_Name__c = 'HomePhone',
            Active__c = true
        );
        testMappingsToInsert.add(contactHomePhoneMapping);

        Interaction_Mapping__c contactLastNameMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Last_Name__c',
            Target_Field_API_Name__c = 'LastName',
			Skip_Mapping__c = 'Webform',
            Active__c = true
        );
        testMappingsToInsert.add(contactLastNameMapping);

        Interaction_Mapping__c contactLeadSourceMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Lead_Source__c',
            Target_Field_API_Name__c = 'LeadSource',
            Active__c = true
        );
        testMappingsToInsert.add(contactLeadSourceMapping);

        Interaction_Mapping__c contactMailingCityMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mailing_City__c',
            Target_Field_API_Name__c = 'MailingCity',
            Active__c = true
        );
        testMappingsToInsert.add(contactMailingCityMapping);

        Interaction_Mapping__c contactMailingCountryMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mailing_Country__c',
            Target_Field_API_Name__c = 'MailingCountry',
            Active__c = true
        );
        testMappingsToInsert.add(contactMailingCountryMapping);

        Interaction_Mapping__c contactMailingPostalCodeMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mailing_Postal_Code__c',
            Target_Field_API_Name__c = 'MailingPostalCode',
            Active__c = true
        );
        testMappingsToInsert.add(contactMailingPostalCodeMapping);

        Interaction_Mapping__c contactMailingStateMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mailing_State__c',
            Target_Field_API_Name__c = 'MailingState',
            Active__c = true
        );
        testMappingsToInsert.add(contactMailingStateMapping);

        Interaction_Mapping__c contactMailingStreetMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mailing_Street__c',
            Target_Field_API_Name__c = 'MailingStreet',
            Active__c = true
        );
        testMappingsToInsert.add(contactMailingStreetMapping);

        Interaction_Mapping__c contactMobilePhoneMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Mobile_Phone__c',
            Target_Field_API_Name__c = 'MobilePhone',
            Active__c = true
        );
        testMappingsToInsert.add(contactMobilePhoneMapping);

        Interaction_Mapping__c contactSalutationMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Contact',
            Source_Field_API_Name__c = 'Salutation__c',
            Target_Field_API_Name__c = 'Salutation',
            Active__c = true
        );
        testMappingsToInsert.add(contactSalutationMapping);

        /* hed__Affiliation__c Mappings */
        Interaction_Mapping__c affiliationAccountMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'hed__Affiliation__c',
            Source_Field_API_Name__c = 'Affiliated_Account__c',
            Target_Field_API_Name__c = 'hed__Account__c',
            Active__c = true
        );
        testMappingsToInsert.add(affiliationAccountMapping);

        Interaction_Mapping__c affiliationKeyMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'hed__Affiliation__c',
            Source_Field_API_Name__c = 'Affiliation_Key__c',
            Target_Field_API_Name__c = 'Upsert_Key__c',
            Active__c = true
        );
        testMappingsToInsert.add(affiliationKeyMapping);

        Interaction_Mapping__c affiliationRoleMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'hed__Affiliation__c',
            Source_Field_API_Name__c = 'Affiliation_Role__c',
            Target_Field_API_Name__c = 'hed__Role__c',
            Active__c = true
        );
        testMappingsToInsert.add(affiliationRoleMapping);

        Interaction_Mapping__c affiliationContactMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'hed__Affiliation__c',
            Source_Field_API_Name__c = 'Contact__c',
            Target_Field_API_Name__c = 'hed__Contact__c',
            Active__c = true
        );
        testMappingsToInsert.add(affiliationContactMapping);

        Interaction_Mapping__c affiliationPrimaryMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'hed__Affiliation__c',
            Source_Field_API_Name__c = 'Primary_Affiliation__c',
            Target_Field_API_Name__c = 'hed__Primary__c',
            Active__c = true
        );
        testMappingsToInsert.add(affiliationPrimaryMapping);

        /* Lead Mappings */
        Interaction_Mapping__c leadEmailMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Email__c',
            Target_Field_API_Name__c = 'Email',
            Active__c = true
        );
        testMappingsToInsert.add(leadEmailMapping);

        Interaction_Mapping__c leadFirstNameMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'First_Name__c',
            Target_Field_API_Name__c = 'FirstName',
            Active__c = true
        );
        testMappingsToInsert.add(leadFirstNameMapping);

        Interaction_Mapping__c leadPhoneMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Home_Phone__c',
            Target_Field_API_Name__c = 'Phone',
            Active__c = true
        );
        testMappingsToInsert.add(leadPhoneMapping);

        Interaction_Mapping__c leadLastNameMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Last_Name__c',
            Target_Field_API_Name__c = 'LastName',
            Active__c = true
        );
        testMappingsToInsert.add(leadLastNameMapping);

        Interaction_Mapping__c leadLeadSourceMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Lead_Source__c',
            Target_Field_API_Name__c = 'LeadSource',
            Active__c = true
        );
        testMappingsToInsert.add(leadLeadSourceMapping);

        Interaction_Mapping__c leadCityMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mailing_City__c',
            Target_Field_API_Name__c = 'City',
            Active__c = true
        );
        testMappingsToInsert.add(leadCityMapping);

        Interaction_Mapping__c leadCountryMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mailing_Country__c',
            Target_Field_API_Name__c = 'Country',
            Active__c = true
        );
        testMappingsToInsert.add(leadCountryMapping);

        Interaction_Mapping__c leadPostalCodeMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mailing_Postal_Code__c',
            Target_Field_API_Name__c = 'PostalCode',
            Active__c = true
        );
        testMappingsToInsert.add(leadPostalCodeMapping);

        Interaction_Mapping__c leadStateMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mailing_State__c',
            Target_Field_API_Name__c = 'State',
            Active__c = true
        );
        testMappingsToInsert.add(leadStateMapping);

        Interaction_Mapping__c leadStreetMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mailing_Street__c',
            Target_Field_API_Name__c = 'Street',
            Active__c = true
        );
        testMappingsToInsert.add(leadStreetMapping);

        Interaction_Mapping__c leadMobilePhoneMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Mobile_Phone__c',
            Target_Field_API_Name__c = 'MobilePhone',
            Active__c = true
        );
        testMappingsToInsert.add(leadMobilePhoneMapping);

        Interaction_Mapping__c leadSalutationMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'Salutation__c',
            Target_Field_API_Name__c = 'Salutation',
            Active__c = true
        );
        testMappingsToInsert.add(leadSalutationMapping);

        /* Opportunity Mappings */
        Interaction_Mapping__c opportunityAdmitTypeMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Admit_Type__c',
            Target_Field_API_Name__c = 'Admit_Type__c',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityAdmitTypeMapping);

        Interaction_Mapping__c opportunityContactMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Contact__c',
            Target_Field_API_Name__c = 'Contact__c',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityContactMapping);

        Interaction_Mapping__c opportunityLeadSourceMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Lead_Source__c',
            Target_Field_API_Name__c = 'LeadSource',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityLeadSourceMapping);

        Interaction_Mapping__c opportunityNameMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Opportunity_Name__c',
            Target_Field_API_Name__c = 'Name',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityNameMapping);

        Interaction_Mapping__c opportunityStageMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Opportunity_Stage__c',
            Target_Field_API_Name__c = 'StageName',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityStageMapping);

        Interaction_Mapping__c opportunityTermMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Term__c',
            Target_Field_API_Name__c = 'Term__c',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityTermMapping);

        Interaction_Mapping__c opportunityAcadPlanMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Academic_Interest__c',
            Target_Field_API_Name__c = 'Academic_Interest__c',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityAcadPlanMapping);

        Interaction_Mapping__c opportunityRecruitPlanMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Opportunity',
            Source_Field_API_Name__c = 'Recruitment_Interest__c',
            Target_Field_API_Name__c = 'Recruitment_Interest__c',
            Active__c = true
        );
        testMappingsToInsert.add(opportunityRecruitPlanMapping);

        Interaction_Mapping__c interactionFirstNameFromLeadMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Interaction__c',
            Source_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'FirstName',
            Target_Field_API_Name__c = 'First_Name__c',
            Active__c = true
        );
        testMappingsToInsert.add(interactionFirstNameFromLeadMapping);

        Interaction_Mapping__c interactionLastNameFromLeadMapping = new Interaction_Mapping__c(
            Target_Object_API_Name__c = 'Interaction__c',
            Source_Object_API_Name__c = 'Lead',
            Source_Field_API_Name__c = 'LastName',
            Target_Field_API_Name__c = 'Last_Name__c',
            Active__c = true
        );
        testMappingsToInsert.add(interactionLastNameFromLeadMapping);

        return testMappingsToInsert;
    }

    /**
     * @description Creates and returns a List of Interaction__c test data
     * @return testInteractionsToInsert, the List of test data to insert in your unit test
     */
    public static List<Interaction__c> createBulkTestInteractions() {
        List<Interaction__c> testInteractionsToInsert = new List<Interaction__c>();

        for (Integer i = 0; i < 500; i++) {
            Interaction__c testInt = new Interaction__c(
                First_Name__c = 'Test' + i,
                Last_Name__c = 'Person' + i,
                Email__c = 'test.person' + i + '@nomail.com'
            );
            testInteractionsToInsert.add(testInt);
        }

        return testInteractionsToInsert;
    }
}