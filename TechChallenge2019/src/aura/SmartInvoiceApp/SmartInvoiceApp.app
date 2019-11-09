<aura:application extends="ltng:outApp" implements="force:appHostable">
    <aura:dependency resource="c:SmartInvoiceCmp"/>
    <aura:attribute name="Id" type="String" default=""/>
    <c:SmartInvoiceCmp recordId="{!v.Id}"/>
<!-- here c: is org. default namespace prefix-->
</aura:application>