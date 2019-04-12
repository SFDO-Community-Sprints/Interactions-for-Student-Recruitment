/*****************************************
* File: INT_InteractionMappingService
* Author: Sierra-Cedar
* Description: Caches Interaction_Mapping__c records for reference during Interactions processing
******************************************/
public class INT_InteractionMappingService {
    private Map<String, Set<String>> skipMappingMap = new Map<String, Set<String>>();
    private Set<String> objectNames = new Set<String>();
    public Map<String, List<Interaction_Mapping__c>> intMappingMap = new Map<String, List<Interaction_Mapping__c>>();

    private Map<String, Set<String>> objectCheckboxesMap {
        get {
            if (objectCheckboxesMap == null) {
                objectCheckboxesMap = new Map<String, Set<String>>();

                for (String objectName : objectNames) {
                    Map<String, SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

                    for (String s : fields.keySet()) {
                        if (fields.get(s).getDescribe().getType().equals(Schema.DisplayType.BOOLEAN)) {
                            if (!objectCheckboxesMap.containsKey(objectName)) {
                                objectCheckboxesMap.put(objectName, new Set<String>{s.toLowerCase()});
                            } else {
                                objectCheckboxesMap.get(objectName).add(s.toLowerCase());
                            }
                        }
                    }
                }
            }

            return objectCheckboxesMap;
        }

        set;
    }

    public INT_InteractionMappingService() {
        for (Interaction_Mapping__c mapping : [
            SELECT Skip_Mapping__c, Insert_Null__c, Target_Object_API_Name__c, Source_Field_API_Name__c,
                Target_Field_API_Name__c, Source_Object_API_Name__c
            FROM Interaction_Mapping__c
            WHERE Active__c = TRUE
        ]) {
            objectNames.add(mapping.Target_Object_API_Name__c);

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

    /**
     * @description Checks to see if field has an excluded source
     * @param mappingId, the Interaction_Mapping__c record Id to pull the record from the Map.
     * @param interactionSource, the value of the Interaction.Interaction_Source__c field.
     * @param skipOrPreserveSourcesMap, the Map containing the Skip Mapping
     * @return a Boolean determining whether or not the field is excluded or overwrite if blank.
     */
    private Boolean isSkipOrPreserveSourceField(
        String mappingId, String interactionSource, Map<String, Set<String>> skipOrPreserveSourcesMap
    ) {
        Set<String> sourcesToCheck = (skipOrPreserveSourcesMap.containsKey(mappingId)
            ? skipOrPreserveSourcesMap.get(mappingId) : new Set<String>());

        return sourcesToCheck.contains(interactionSource);
    }

    /**
     * @description Populates an SObject with Interaction data based on the mapping.
     * @param interaction, the Interaction Record to copy from.
     * @param theObject, the SObject to populate.
     * @return theObject, the SObject that data was applied to.
     */
    public SObject applyDataToSObject(Interaction__c interaction, SObject theObject) {
        String objectName = theObject.getSObjectType().getDescribe().getName();

        if (intMappingMap.containsKey(objectName)) {
            for (Interaction_Mapping__c mapping : intMappingMap.get(objectName)) {
                // Only copy the field value if the Interaction__c field value is different than the Object field value.
                if (isSkipOrPreserveSourceField(mapping.Id, interaction.Interaction_Source__c, skipMappingMap)) {
                    continue; // Prevent mapping of field if it's a skip field or a preserve target source
                } else if (mapping.Insert_Null__c
                    || (interaction.get(mapping.Source_Field_API_Name__c) != null
                        && interaction.get(mapping.Source_Field_API_Name__c) != ''
                        && ((objectCheckboxesMap.containsKey(mapping.Target_Object_API_Name__c)
                                && !objectCheckboxesMap.get(mapping.Target_Object_API_Name__c).contains(mapping.Target_Field_API_Name__c.toLowerCase()))
                            || String.valueOf(interaction.get(mapping.Source_Field_API_Name__c)) != 'false'))
                ) {
                    theObject.put(mapping.Target_Field_API_Name__c, interaction.get(mapping.Source_Field_API_Name__c));
                }

            }
        }

        return theObject;
    }

    /**
     * @description Applies data from a source Object to the Interaction__c based upon Interaction_Mapping__c records.
     * @param theObject, the SObject to pull data from.
     * @param interaction, the Interaction__c record to populate.
     * @return interaction, the populated Interaction__c record.
     */
    public Interaction__c applyDataToInteraction(SObject theObject, Interaction__c interaction) {
        if (intMappingMap.containsKey('Interaction__c')) {
            for (Interaction_Mapping__c mapping : intMappingMap.get('Interaction__c')) {
                if (mapping.Source_Object_API_Name__c == theObject.getSObjectType().getDescribe().getName()
                    && ((objectCheckboxesMap.containsKey(mapping.Source_Object_API_Name__c)
                            && objectCheckboxesMap.get(mapping.Source_Object_API_Name__c).contains(mapping.Source_Field_API_Name__c.toLowerCase())
                            && theObject.get(mapping.Source_Field_API_Name__c) == true)
                        || String.valueOf(theObject.get(mapping.Source_Field_API_Name__c)) != 'false')
                ) {
                    interaction.put(mapping.Target_Field_API_Name__c, theObject.get(mapping.Source_Field_API_Name__c));
                }
            }
        }

        return interaction;
    }
}