public without sharing class ObjectServiceFactory{ 
  public static ObjectService getInstance( SObjectType sobjType ) {
        ObjectService service = NULL;
        if(sobjType != NULL) {
            //should be the object API name with all whitespaces,special characters and __c removed
            String objectNameNormalized = sobjType.getDescribe().getName().deleteWhitespace().removeEnd('__c').replaceAll('[^a-zA-Z0-9\\s+]', '');
            if(String.isNotBlank(objectNameNormalized)){
               service = (ObjectService)Type.forName(objectNameNormalized+'ObjectService').newInstance();   
            }
        }
        //No object service found. throw Exception
        if (service == NULL) {
            throw new ObjectServiceFactoryException('No implementation found for this SObject' + sobjType.getDescribe().getName());
        }   
        return service;
   }
   public class ObjectServiceFactoryException extends Exception {}  
}