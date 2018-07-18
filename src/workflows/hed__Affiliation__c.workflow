<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Upsert_Key_Set_to_Contact_Account</fullName>
        <description>INTERACTIONS: Sets the Upsert Key to Contact ID + &quot;.&quot; + Account ID</description>
        <field>Upsert_Key__c</field>
        <formula>CASESAFEID(hed__Contact__r.Id)+&quot;.&quot;+CASESAFEID(hed__Account__r.Id)</formula>
        <name>Upsert Key: Set to Contact.Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Affiliation%3A Update Upsert Key</fullName>
        <actions>
            <name>Upsert_Key_Set_to_Contact_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>INTERACTIONS: Sets the Affiliation Upsert Key field to the Contact ID +  &quot;.&quot; + Account ID for matching records through Interactions.</description>
        <formula>Upsert_Key__c &lt;&gt;
CASESAFEID(hed__Contact__r.Id)+&quot;.&quot;+CASESAFEID(hed__Account__r.Id)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
