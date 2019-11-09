@isTest
public class TestClassUtil {
    public static void loadEnvironmentVariables(){
        
    } 
    public static sObject getsObj(Map<Schema.sObjectField,Object> dataMap,Schema.SObjectType sObjType,String recordTypeDevName){
        sObject sObj=sObjType.newSObject() ;
        if(dataMap!=NULL){
            for(Schema.SObjectField fld : dataMap.keySet()){
                sObj.put(fld,dataMap.get(fld));
            }
        }
        if(String.isNotBlank(recordTypeDevName)){
            sObj.put('RecordTypeId', sObjType.getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId());
        }
        return sObj;
    }
}