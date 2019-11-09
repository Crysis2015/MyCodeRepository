public class AccountViewerController {
    @AuraEnabled
    public static AccountDataTableWrapper getAccountData(Decimal pageNumber, Decimal pageSize) {
         
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
         
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
         
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account]; 
        Integer recordEnd = pSize * pNumber;
 
        //Instance of Account DataTable Wrapper Class
        AccountDataTableWrapper objDT =  new AccountDataTableWrapper(); 
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.accountList=new List<AccountWrapper>();
        for(Account acc : [SELECT Id, Name,AccountNumber,Owner.Name,AccountSource,Parent.Name,AnnualRevenue,Type,CreatedBy.Name,LastModifiedBy.Name,Industry,Description,Phone,Fax FROM Account ORDER BY CreatedDate LIMIT :pSize OFFSET :offset])
            objDT.accountList.add(new AccountWrapper(false,acc));
        return objDT;
    }
     
    //Wrapper Class For Account DataTable  
    public class AccountDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<AccountWrapper> accountList {get;set;}
    }


    public class AccountWrapper{
        @AuraEnabled
        public Boolean isSelected{get;set;}
        @AuraEnabled
        public Account acc{get;set;}
        public AccountWrapper(Boolean isSelected,Account acc){
            this.isSelected=isSelected;
            this.acc=acc;
        }
    }

    @AuraEnabled
    public static Map<String, String> createAccountRecord(Account newAccount) {
        // Forming a  string map to return response
        Map<String,String> resultMap = new Map<String,String>();
        // Adding try catch for exception handling
        try {
            // Inserting the Account
            insert newAccount;
            // Setting the success status and message in resultMap
            resultMap.put('status', 'success');
            resultMap.put('message', 'Account Inserted Successfully');        
        }
        catch(Exception e) {
            // Setting the error status and message in resultMap
            resultMap.put('status', 'error');
            resultMap.put('message',e.getMessage());
        }
        // Returning the result string map
        return resultMap;        
    }

    @AuraEnabled
    public static Map<String,String> deleteAccounts(List<String> accIds)
    {
        System.debug('xxx');
        System.debug(accIds);
        List<Account> lstDeleteAcc=new List<Account>();
        for(String accId : accIds)
            lstDeleteAcc.add(new Account(Id=accId));
        Map<String,String> resultMap = new Map<String,String>();
          try {
                delete lstDeleteAcc;
                // Setting the success status and message in resultMap
                resultMap.put('status', 'success');
                resultMap.put('message', 'Accounts Deleted Successfully');        
            }
            catch(Exception e) {
                // Setting the error status and message in resultMap
                resultMap.put('status', 'error');
                resultMap.put('message',e.getMessage());
            }
            return resultMap;
    }

     @AuraEnabled
     public static List <String> getselectOptions(sObject objObject, string fld) {
      List < String > allOpts = new list < String > ();
      for (Schema.PicklistEntry a: objObject.getSObjectType().getDescribe().fields.getMap().get(fld).getDescribe().getPickListValues())
        allOpts.add(a.getValue());
      allOpts.sort();
      return allOpts;
     }

     @AuraEnabled
     public static Map<String, String> massUpdateSource(List<String> accIds,String accSource) {
          List<Account> lstUpdate=new List<Account>();
          Map<String,String> resultMap = new Map<String,String>();
          for(String accId : accIds)
            lstUpdate.add(new Account(Id=accId,AccountSource=accSource));
          try {
                update lstUpdate;
                // Setting the success status and message in resultMap
                resultMap.put('status', 'success');
                resultMap.put('message', 'Accounts Updated Successfully');        
            }
            catch(Exception e) {
                // Setting the error status and message in resultMap
                resultMap.put('status', 'error');
                resultMap.put('message',e.getMessage());
            }
            return resultMap;
    }  
}