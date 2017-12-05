<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Trigger_Handler_Set_Name_to_Class</fullName>
        <description>Sets Name to the Class field.</description>
        <field>Name</field>
        <formula>hed__Class__c</formula>
        <name>Trigger Handler: Set Name to Class</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Trigger Handler%3A Update Name</fullName>
        <actions>
            <name>Trigger_Handler_Set_Name_to_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates name from ID to Class Name.</description>
        <formula>Name &lt;&gt;  hed__Class__c  &amp;&amp; NOT(ISBLANK(hed__Class__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
