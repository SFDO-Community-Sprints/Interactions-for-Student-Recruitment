<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Member_Key_Update_to_Lead_Camp</fullName>
        <description>INTERACTIONS: Sets the Campaign Member Key field on Campaign Member to the 18-Digit Lead/Contact ID + the 18-Digit Campaign Id.</description>
        <field>Campaign_Member_Key__c</field>
        <formula>Lead_Contact_ID__c + &quot;.&quot; + CASESAFEID(CampaignId)</formula>
        <name>Campaign Member Key: Update to Lead.Camp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Member%3A Update Campaign Member Key for Lead</fullName>
        <actions>
            <name>Campaign_Member_Key_Update_to_Lead_Camp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>INTERACTIONS: Update Campaign Member Key if it does not equal 18-Digit Lead/Contact ID + &apos;.&apos; + 18-Digit Campaign Member ID.</description>
        <formula>Campaign_Member_Key__c &lt;&gt; Lead_Contact_ID__c + &quot;.&quot; + CASESAFEID(CampaignId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
