<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity_Application_Submitted_Date</fullName>
        <description>Sets the Application Submitted Date to Today</description>
        <field>Application_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity: Application Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_First_Recruitment_Interest</fullName>
        <description>Sets the First Recruitment Interest to the Recruitment Interest Name.</description>
        <field>First_Recruitment_Interest__c</field>
        <formula>Recruitment_Interest__r.Name</formula>
        <name>Opportunity: First Recruitment Interest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Key_Set_Based_on_Career</fullName>
        <description>For UG, sets key to Contact ID + Opportunity Career + Term ID, for GR, Contact ID + Opportunity Career + ((Academic Interest ID.Recruitment Interest ID or Academic Interest ID) or Recruitment Interest ID) + Term ID.</description>
        <field>Opportunity_Key__c</field>
        <formula>CASESAFEID(Contact__r.Id)+ 

/*The below formula allows for a centralized and decentralized recruitment model.*/ 

/*If both Academic Interest and Recruitment Interest are blank, the formula is blank, which means the Opportunity is missing important information and no Opportunity will be created.*/ IF(Academic_Interest__c + Recruitment_Interest__c = &quot;&quot;,&quot;&quot;, 

/*If the Academic Interest Career = Undergraduate, or Academic Interest is blank and the Recruitment Interest Career = Undergraduate, this formula uses the centralized model (one Opportunity per Term)*/ 
IF(OR(ISPICKVAL(Academic_Interest__r.Career__c, &quot;Undergraduate&quot;), AND(ISBLANK(Academic_Interest__c), ISPICKVAL(Recruitment_Interest__r.Career__c, &quot;Undergraduate&quot;))), &quot;.Undergraduate.&quot;+Term__r.Id, 

/*Otherwise, this formula uses the decentralized model (one Opportunity per Academic Interest or Recruitment Interest and Term)*/ 
&quot;.Graduate.&quot; + 

/*If there is no Academic Interest, the decentralized model adds the Recruitment Interest Id. Otherwise, the model uses the Recruitment Interest ID from the Academic Interest, or if there is none, the Academic Interest ID is used as a last resort. Most Academic Interests should have a Recruitment Interest ID to ensure a smooth transition from inquiry to application.*/ 
IF(ISBLANK(Academic_Interest__r.Id), Recruitment_Interest__r.Id, IF(ISBLANK(Academic_Interest__r.Recruitment_Interest__c), Academic_Interest__r.Id, Academic_Interest__r.Recruitment_Interest__r.Id))+&quot;.&quot;+Term__r.Id))</formula>
        <name>Opportunity Key: Set Based on Career</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Name_Set_to_Last_Term</fullName>
        <description>Sets the Opportunity Name to Contact Last Name - Term Name</description>
        <field>Name</field>
        <formula>Contact__r.LastName + &quot; - &quot; +  Term__r.Name</formula>
        <name>Opportunity Name - Set to Last - Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_First_Inquiry_Source</fullName>
        <description>Sets the First Inquiry Source field to the LeadSource.</description>
        <field>First_Inquiry_Source__c</field>
        <formula>TEXT(LeadSource)</formula>
        <name>Opportunity: Set First Inquiry Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_Inquiry_Date</fullName>
        <description>Sets the Inquiry Date field to CreatedDate.</description>
        <field>Inquiry_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Opportunity: Set Inquiry Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity%3A Set Application Submitted Date</fullName>
        <actions>
            <name>Opportunity_Application_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Application Submitted Date to Today when the Stage is changed to Applied.</description>
        <formula>ISCHANGED(StageName) &amp;&amp; ISPICKVAL(StageName, &quot;Applied&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set First Recruitment Interest</fullName>
        <actions>
            <name>Opportunity_First_Recruitment_Interest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the First Recruitment Interest field when it is blank.</description>
        <formula>ISBLANK( First_Recruitment_Interest__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Inquiry Date</fullName>
        <actions>
            <name>Opportunity_Set_Inquiry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Inquiry_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Inquiry Date if the Opportunity is created or edited and the Inquiry Date is blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Update Name</fullName>
        <actions>
            <name>Opportunity_Name_Set_to_Last_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Opportunity Name to Contact Last - Term Name</description>
        <formula>Name &lt;&gt; Contact__r.LastName + &quot; - &quot; +  Term__r.Name</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Update Opportunity Key</fullName>
        <actions>
            <name>Opportunity_Key_Set_Based_on_Career</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Opportunity Key based on the Career, Recruitment Interest or Academic Interest, and Term, according to the formula used in the Opportunity Key field on the Interactions object.</description>
        <formula>/*The below formula allows for a centralized and decentralized recruitment model.*/

/*If the Academic Career from the Academic Interest = Undergraduate or the Academic Interest is blank and the Recruitment Interest Career = Undergraduate, this formula uses the centralized model (one Opportunity per Term). If the same is true for the Graduate Career, this formula uses the decentralized model (one Opportunity per Opportunity Plan and Term). Otherwise, the formula is blank, which means the Opportunity is missing important information.*/ Opportunity_Key__c &lt;&gt; CASESAFEID(Contact__r.Id)+ IF(Academic_Interest__c + Recruitment_Interest__c = &quot;&quot;,&quot;&quot;, 

/*If the Academic Interest Career = Undergraduate, or Academic Interest is blank and the Recruitment Interest Career = Undergraduate, this formula uses the centralized model (one Opportunity per Term)*/ 
IF(OR(ISPICKVAL(Academic_Interest__r.Career__c, &quot;Undergraduate&quot;), AND(ISBLANK(Academic_Interest__c), ISPICKVAL(Recruitment_Interest__r.Career__c, &quot;Undergraduate&quot;))), &quot;.Undergraduate.&quot;+Term__r.Id, 

/*Otherwise, this formula uses the decentralized model (one Opportunity per Academic Interest or Recruitment Interest and Term)*/ 
&quot;.Graduate.&quot; + 

/*If there is no Academic Interest, the decentralized model adds the Recruitment Interest Id. Otherwise, the model uses the Recruitment Interest ID from the Academic Interest, or if there is none, the Academic Interest ID is used as a last resort. Most Academic Interests should have a Recruitment Interest ID to ensure a smooth transition from inquiry to application.*/ 
IF(ISBLANK(Academic_Interest__r.Id), Recruitment_Interest__r.Id, IF(ISBLANK(Academic_Interest__r.Recruitment_Interest__c), Academic_Interest__r.Id, Academic_Interest__r.Recruitment_Interest__r.Id))+&quot;.&quot;+Term__r.Id))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
