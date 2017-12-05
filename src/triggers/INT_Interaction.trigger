/*****************************************
* File: INT_Interaction
* Author: Sierra-Cedar
* Description: Interaction__c Trigger
******************************************/
trigger INT_Interaction on Interaction__c (after insert, after update) {
    List<Interaction__c> interactionsToProcess = new List<Interaction__c>();
    List<Interaction__c> interactionsToLeadsOnly = new List<Interaction__c>();

    // Filter the new Interactions by Lead Only vs. those to process normally
    for (Interaction__c interaction : Trigger.new) {
        Interaction__c clonedInteraction = interaction.clone(true, true, true, true); // Clone because After Trigger context, we need the Id for processing.
        if (clonedInteraction.Interaction_Status__c == 'New') { // Only process New Interactions
            clonedInteraction.Audit_Reason__c = ''; // Clear audit reason in case any failed previously and are being re-processed.

            if (clonedInteraction.Lead_Only__c) {
                interactionsToLeadsOnly.add(clonedInteraction);
            } else {
                interactionsToProcess.add(clonedInteraction);
            }
        }
    }

    // Call the InteractionProcessor for the collections of new Interactions
    INT_InteractionProcessor processor = new INT_InteractionProcessor();
    if (interactionsToLeadsOnly.size() > 0) processor.processLeads(interactionsToLeadsOnly);
    if (interactionsToProcess.size() > 0) processor.processInteractions(interactionsToProcess);
}