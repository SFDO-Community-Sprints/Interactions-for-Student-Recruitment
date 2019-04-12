/*****************************************
* File: INT_OpportunityContactRoleHandler
* Author: Sierra-Cedar
* Description: Uses the HEDA Table Driven Trigger Management to update Opportunities when Contact Roles Change
******************************************/
global without sharing class INT_OpportunityContactRoleHandler extends hed.TDTM_Runnable {
    global override DmlWrapper run(List<SObject> newList, List<SObject> oldlist,
        hed.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult
    ) {
        List<OpportunityContactRole> rolesToInsert = new List<OpportunityContactRole>();
        DmlWrapper dmlWrapper = new DmlWrapper();

        for (SObject anSObject : newList) {
            Opportunity anOpportunity = (Opportunity) anSObject;

            if (anOpportunity.Contact__c != null) {
                OpportunityContactRole newRole = new OpportunityContactRole(
                    ContactId = anOpportunity.Contact__c,
                    OpportunityId = anOpportunity.Id,
                    IsPrimary = true,
                    Role = 'Opportunity Contact'
                );
                rolesToInsert.add(newRole);
            }
        }

        // Identify roles to delete
        List<OpportunityContactRole> rolesToDelete = [
            SELECT Id, ContactId, IsPrimary, OpportunityId, Role
            FROM OpportunityContactRole
            WHERE OpportunityId IN :newList
        ];

        // Delete the roles
        if (rolesToDelete.size() > 0) {
            dmlWrapper.objectsToDelete.addAll((List<SObject>) rolesToDelete);
        }

        // Insert Opportunity Contact Roles
        insert rolesToInsert;

        // Retrieve Inserted Role Ids to upate primary, doesn't work in same context as Lead Convert
        // Keep an eye on Idea Exchange below, @future context is handling this for now
        // https://success.salesforce.com/ideaview?id=08730000000HKbnAAG
        List<String> roleIds = new List<String>();

        for (OpportunityContactRole aRole : rolesToInsert) {
            roleIds.add(aRole.Id);
        }

        if (roleIds.size() > 0) {
            if (System.isBatch()) {
                updateRoles(roleIds);
            } else {
                updateRolesFuture(roleIds);
            }
        }

        return dmlWrapper;
    }

    // Update opportunity contact roles in another context, Salesforce currently not setting primary
    @Future
    public static void updateRolesFuture(List<String> roleIds) {
        updateRoles(roleIds);
    }

    public static void updateRoles(List<String> roleIds) {
        List<OpportunityContactRole> roles = [SELECT Id, IsPrimary FROM OpportunityContactRole WHERE Id IN :roleIds];

        for (OpportunityContactRole aRole : roles) {
            aRole.IsPrimary = true;
        }

        update roles;
    }
}