/*****************************************
* File: INT_InteractionMapping
* Author: Sierra-Cedar
* Description: Interaction_Mapping__c Trigger
******************************************/
trigger INT_InteractionMapping on Interaction_Mapping__c (after insert, after update) {
    Set<String> sObjectNames = new Set<String>{'Interaction__c'};
    Map<String, Set<String>> sObjectFieldStringsMap = new Map<String, Set<String>>();

    // Collect Target Object names to validate field API names
    for (Interaction_Mapping__c mapping : Trigger.new) {
        sObjectNames.add(mapping.Target_Object_API_Name__c);
    }

    // Loop through Object names and collect all possible field API names into the sObjectFieldStringsMap
    for (String objectName : sObjectNames) {
        Set<String> fieldNames = new Set<String>();
        Map<String, Schema.SObjectField> fieldMap =
            Schema.getGlobalDescribe().get(objectName).newSObject().getSObjectType().getDescribe().fields.getMap();

        for (Schema.SObjectField fieldName : fieldMap.values()) {
            fieldNames.add(String.valueOf(fieldName));
        }

        if (!sObjectFieldStringsMap.containsKey(objectName)) {
            sObjectFieldStringsMap.put(objectName, fieldNames);
        }
    }

    /**
     * Finally, loop through the new Interaction Mappings and check if the value provided in the
     * Target API field matches a possible valid API name on the Target Object.
     */
    for (Interaction_Mapping__c mapping : Trigger.new) {
        String errorString = '';

        // Validate Target Field API Name on the Target Object
        if (sObjectFieldStringsMap.containsKey(mapping.Target_Object_API_Name__c)) {
            if (!sObjectFieldStringsMap.get(mapping.Target_Object_API_Name__c).contains(mapping.Target_Field_API_Name__c)) {
                errorString += 'Target Field API Name \'' + mapping.Target_Field_API_Name__c + '\' does not exist on ' +
                    mapping.Target_Object_API_Name__c + '. Please choose a valid field to map to and ensure it is in API name format.';
            }
        }

        // Validate source field API name from the Interaction
        if (sObjectFieldStringsMap.containsKey(mapping.Source_Object_API_Name__c)) {
            if (!sObjectFieldStringsMap.get(mapping.Source_Object_API_Name__c).contains(mapping.Source_Field_API_Name__c)) {
                if (!String.isEmpty(errorString)) errorString += ' ';
                errorString += 'Recruitment Import Field \'' + mapping.Source_Field_API_Name__c + '\' does not exist ' +
                    'on Interaction. Please choose a valid field to map from and ensure it is in API name format.';
            }
        }

        if (!String.isEmpty(errorString)) mapping.addError(errorString);
    }
}