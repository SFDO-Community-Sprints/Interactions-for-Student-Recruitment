# Interactions-for-Student-Recruitment
This repo was set up for University of Miami's *Interactions for Student Recruitment*.

## Synopsis
*Interactions for Student Recruitment* provides higher education institutions the tools they need to manage student recruitment in Salesforce. As an unmanaged package/open-source code, it builds on the Higher Education Data Architecture (HEDA) data model and uses Affiliations, Administrative Accounts, and other HEDA features. *Interactions for Student Recruitment* uses Salesforce-standard Duplicate Management with new functionality called Interactions, which save time and reduce duplicate records by streamlining the data entry process. It provides a highly customizable structure to standard functionality such as Opportunities and Campaigns to meet the many different needs of a higher education institution. This project was created through Salesforce.org's Force for Change Grant program and includes technical documentation, user guides, learning guides, and other documents to help universities get started with recruiting in Salesforce. 

We welcome contributions and feedback. Read below for more information about how to get involved!

## Motivation
Our project team has implemented out-of-the-box, managed package, and hybrid approaches for automating student recruitment. We would like to share our lessons learned and best practices with new and existing Salesforce schools. Our goal is to extend HEDA to provide structure and functionality around student recruitment. We will complete this goal by simplifying the entry of one-on-one interactions in Salesforce while also automating stages of the recruitment process, simplifying pipeline management, and bringing together marketing and recruiting efforts to focus on the most promising prospects. It is our sincere hope that other universities, as well as consultants, look to build upon as well as improve *Interactions for Student Recruitment*. To get involved, please see the Maintenance and Collaboration section below.

## Installation
You can install *Interactions for Student Recruitment* as-is into any Developer Edition, Sandbox, Enterprise, or higher edition org in which HEDA has been installed. The HEDA installer for existing orgs can be found <a href="https://mrbelvedere.salesforcefoundation.org/mpinstaller/hed" target="_blank">here</a>. If you are unfamiliar with HEDA, we recommend learning more about it and its installation and trial org options by reviewing the documentation available <a href="https://powerofus.force.com/articles/Resource/Install-and-Configure-the-Higher-Education-Data-Architecture-HEDA" target="_blank">here</a>. Once HEDA has been installed into an org, you can easily install *Interactions for Student Recruitment* using this unmanaged package link and the Interactions Installation and Configuration Guide (Coming Soon!).

Alternatively, please reference the Interactions Technical Implementation Guide (Coming Soon!) in this repository for non-HEDA orgs.

## Maintenance and Collaboration
Thank you for your interest in *Interactions for Student Recruitment*. This project's code is provided as-is, and is not actively maintained. The developers invite you to peruse their code and even use it in your next project, provided you follow the included license. There is no guarantee of support for the code (including submitted Issues). There is no guarantee that pull requests will be reviewed or merged. It's open-source, so forking is permitted; just be sure to give credit where it's due.

If you are interested in learning about the project roles, roadmap, how to become a collaborator, and/or where to find the community surrounding this project, then please review our <a href="https://github.com/SalesforceFoundation/Interactions-for-Student-Recruitment/blob/master/Maintenance-Policy.md" target="_blank">Maintenance Policy</a>. Additionally, please see the <a href="https://github.com/SalesforceFoundation/Interactions-for-Student-Recruitment/issues" target="_blank">Issues section</a> where we’ve added some suggestions for further development opportunities for those interested (Coming Soon!).

## Documentation and Other Resources
*Interactions for Student Recruitment* comes with a wealth of documentation and other resources to help admins, developers, and users implement, use, and customize Interactions. It is important to read through these materials before downloading the Interactions package, as they contain important information necessary for a successful implementation.

### Documentation Guides (Coming Soon!)
* Overview of Interactions – This overview document is a high-level look at all the features *Interactions for Student Recruitment* has to offer.
* Interactions Learning Guide – The Learning Guide follows the experience of Stella, the admin, learning about Interactions and how best to implement the package at Connected University (CU). It also follows one of her end users, a recruiter at CU’s School of Business, and their journey to discover how Interactions can help them connect meaningfully with potential students.
* User Guide – This guide is both for admins and end users (e.g. recruiters) to learn about best practices for using *Interactions for Student Recruitment* and all its features.
* Installation and Configuration Guide – The Installation and Configuration Guide is an important resource for administrators looking to implement *Interactions for Student Recruitment* with step-by-step instructions for pre-install, install, and post-install requirements and recommendations.
* Technical Implementation Guide – This guide is geared toward developers and admins experienced with Apex to learn more about how the *Interactions for Student Recruitment* classes function and some customization tips.
* Data Dictionary – The Data Dictionary file is a comprehensive list of every metadata element included in the package (e.g. fields, picklist values, workflow rules, page layouts, etc.).

### Data Model Sheets (Coming Soon!)
* Interactions ERD – Take a look at the Interactions data model and how it utilizes standard Salesforce and HEDA objects and processes.
* Processes Flow Chart and Swim-Lane Diagram – This flow chart and diagram presents the same information (the order of operations for the Interaction Processor) in different formats for your convenience.
* Student Recruitment Model – This model shows a common path for a prospective student from being a purchased list name, to the point of inquiry and application, and then to a current student.

### Additional Implementation Resources (Coming Soon!)
* Discovery Document – After all that documentation, it may seem daunting to figure out where to start, but never fear! The Discovery Document is here to streamline your discovery process. Use it to identify current business practices, data models, and integrations that can be managed by *Interactions for Student Recruitment*.
* Project Plan Template – This template provides a basis for creating your own Project Plan to implement *Interactions for Student Recruitment*.
* Communication and Training Plan Template – As with any major implementation, it is important to have a plan to keep users and stakeholders in the loop and ready for training when the time comes. This template gives you a starting point for building this plan.
* Sample Data File – This file contains useful sample data that can be loaded into a configured org (with HEDA and *Interactions for Student Recruitment*) to test Interactions and see how the package works with real records.

## Code Example
Below are some samples of the Interaction Processor Class and Interaction Mapping Service Class. See the Interactions Technical Implementation Guide (Coming Soon!) for more information about these and the other classes and triggers included in *Interactions for Student Recruitment*.

    /*****************************************
    *File: INT_InteractionProcessor
    *Author: Sierra-Cedar
    *Description: Processes new Interaction__c records by inserting/converting Leads, upserting pportunities, 
    *updating Contacts, upserting Affiliations, and upserting CampaignMembers
    ******************************************/

    public class INT_InteractionProcessor {
        private List<Interaction__c> dupeInteractions = new List<Interaction__c>();
        private List<Lead> leadsToDelete = new List<Lead>();
        private List<Opportunity> opportunitiesToUpsert = new List<Opportunity>();
        private Map<Id, Lead> interactionIdToLead = new Map<Id, Lead>();
        private Map<Id, Interaction__c> interactionMap = new Map<Id, Interaction__c>();
        private Map<Id, Interaction__c> leadIdToInteractionMap = new Map<Id, Interaction__c>();
        private Set<Id> leadIds = new Set<Id>();

        /**
         * @description Main method for processing new Interaction__c records.
         * @param interactionsToProcess, the List of new Interaction__c objects to process.
         */
        public void processInteractions(List<Interaction__c> newInteractions) {
        List<Contact> contactsToUpdate = new List<Contact>();
        List<hed__Affiliation__c> affiliationsToUpsert = new List<hed__Affiliation__c>();

            // Run duplicate pre-processing
        List<Interaction__c> interactionsToProcess = duplicatePreProcessing(newInteractions);
        
            // Set up Interaction Map for reference during processing.
        interactionMap = new Map<Id, Interaction__c>(interactionsToProcess);

            // Create Leads from new Interactions records.
        List<Database.LeadConvert> newLeads = insertLeadsFromInteractions(interactionsToProcess);

            // Create CampaignMembers to upsert from the Leads inserted if they have the proper Campaign Keys
        List<CampaignMember> campaignMembersToUpsert = createCampaignMembersFromLeads();

            // Upsert Campaign Members from Leads
                if (campaignMembersToUpsert.size() > 0) {
                    logPossibleErrors(Database.upsert(campaignMembersToUpsert, CampaignMember.Campaign_Member_Key__c, false));
                    }

            // Attempt initial conversion of leads.
                List<Database.LeadConvert> possibleLeadsToReconvert = convertLeads(newLeads);

            // Reconvert Leads with matched Contacts if duplicate errors.
                if (possibleLeadsToReconvert.size() > 0) {
                    convertLeads(possibleLeadsToReconvert);
                }

            // Upsert associated Opportunities using Opportunity_Key__c as the lookup Id.
                if (opportunitiesToUpsert.size() > 0) {
                    logPossibleErrors(Database.upsert(opportunitiesToUpsert, Opportunity.Opportunity_Key__c, false));
                }
            }
        }


    /*****************************************
    * File: INT_InteractionMappingService
    * Author: Sierra-Cedar
    * Description: Caches Interaction_Mapping__c records for reference during Interactions processing
    ******************************************/
    public class INT_InteractionMappingService {
        private Map<String, Set<String>> skipMappingMap = new Map<String, Set<String>>();
        private Map<String, List<Interaction_Mapping__c>> intMappingMap = new Map<String, List<Interaction_Mapping__c>>();

        public INT_InteractionMappingService() {
            for (Interaction_Mapping__c mapping : [
                SELECT Skip_Mapping__c, Insert_Null__c, Target_Object_API_Name__c, Interaction_Source_Field_API_Name__c, Target_Field_API_Name__c
                FROM Interaction_Mapping__c
                WHERE Active__c = true
            ]) {
                if (!intMappingMap.containsKey(mapping.Target_Object_API_Name__c)) {
                    intMappingMap.put(mapping.Target_Object_API_Name__c, new List<Interaction_Mapping__c>{mapping});
                } else {
                    intMappingMap.get(mapping.Target_Object_API_Name__c).add(mapping);
                }

                // Populate excluded sources map
                if (!String.isEmpty(mapping.Skip_Mapping__c)) {
                    skipMappingMap.put(mapping.Id, new Set<String>(mapping.Skip_Mapping__c.split(';')));
                }
            }
        }
    }


## License

These terms and conditions are provided specifically for your participation in the *Interactions for Student Recruitment* project and exist independently of any Master Subscription Agreement (MSA) terms you or your organization may have or may in the future agree with either Salesforce.org or Salesforce.com.

The *Interactions for Student Recruitment* project code repository is provided on “as-is” and “as-available” bases for exclusive use by *Interactions for Student Recruitment* grantees and their co-contributors, Salesforce.org and Salesforce.com contributors, and others associated with the *Interactions for Student Recruitment* initiative. Although maintained within the Salesforce.org repository at GitHub, Salesforce.org makes no express, implied, or other warranty of any kind regarding the *Interactions for Student Recruitment* repository. To the fullest extent permitted by applicable laws, Salesforce.org disclaims, without limitation, warranties of merchantability, fitness for a particular purpose, freedom from defects, and non-infringement. Salesforce.org has no liability to you or any other party arising from your use of this project repository, including without limitation any liability for direct, indirect, consequential, punitive, special, exemplary, or cover damages, regardless the nature of a claim or theory of liability. The foregoing disclaimer applies even if you advise Salesforce.org of the possibility of such damages.

The nature of this project is such that active maintenance of this repository is not guaranteed by Salesforce.org or any other party or entity. Salesforce.org has relinquished control of the information comprising this code repository and has no obligation to protect the integrity, confidentiality, or availability of said information. Any reference to specific commercial products, or services, other than those services provided by Salesforce.org or Salesforce.com, by reference to trademarks or service marks does not imply any endorsement or recommendation by either Salesforce.org or Salesforce.com. No license to use trademarks or service marks belonging to either Salesforce.org or Salesforce.com is conveyed to you in these terms and conditions.

Some jurisdictions may not allow the exclusion of certain warranties or the limitation of liability for certain types of damages, and thus some of the above exclusions and limitations may not apply to particular users of this repository. If these disclaimers, exclusions, and limitations cannot be given local legal effect according to the terms and conditions described herein, you agree that reviewing courts will apply local laws which most closely approximate an absolute waiver of all civil liability in connection with the *Interactions for Student Recruitment* project and code repository.

## Acknowledgements

Thanks to the following individuals in the Github community who helped shape the README.md:

* <a href="https://gist.github.com/jxson" target="_blank">@jxson</a> for the <a href="https://gist.github.com/jxson/1784669" target="_blank"> readme </a> example
* <a href="https://github.com/potch" target="_blank">@potch</a> for the <a href="https://github.com/potch/unmaintained.tech"> No Maintenance Intended </a> example
* <a href="https://guides.github.com/" target="_blank">Github Guides</a>
    * <a href="https://guides.github.com/introduction/getting-your-project-on-github/" target="_blank">Getting your project on Github</a>
    * <a href="https://guides.github.com/features/wikis/#creating-a-readme" target="_blank">Documenting your projects on Github</a>
    * <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">Mastering Markdown</a>
    * <a href="https://guides.github.com/introduction/flow/" target="_blank">Understanding the GitHub Flow</a>
* <a href="https://help.github.com/articles/github-glossary/" target="_blank">Github Glossary</a>
