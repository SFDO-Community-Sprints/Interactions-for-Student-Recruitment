<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Member_Key_Update_to_Lead_Camp</fullName>
        <description>Sets the Campaign Member Key field to LeadId.CampaignId</description>
        <field>Campaign_Member_Key__c</field>
        <formula>LeadId&amp;&quot;.&quot;&amp;CampaignId</formula>
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
        <description>Runs on any update of Campaign Member associated to a Lead if the key is not Lead.Campaign</description>
        <formula>NOT(ISBLANK(LeadId)) &amp;&amp; Campaign_Member_Key__c &lt;&gt; LeadId&amp;&quot;.&quot;&amp;CampaignId</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
