public without sharing abstract class ObjectService
{
  
  /**
   * The SObject Type of the objects CRUD is being done on.
   * This couple be used in the logic to get meta data information for 
   * business logic.
   */
  private Schema.SObjectType sobjType; 
  
  
  public ObjectService(Schema.SObjectType objType) { this.sobjType = objType; }
  
  /**
   * Used to instantiate generic ObjectService that is not for a specific 
   * SObjectType. This is the default if no specific ObjectService exists
   * 
   */
  public ObjectService() {
    
  }
  
  /************************************************************************************
   *                       Object Lifecycle Methods                                   *
   ************************************************************************************/
   
  public void processLifecycleEvents()
  {
      if ( Trigger.isBefore )
      {
        if ( Trigger.isInsert )
        {
          doBeforeInsert( Trigger.new );
        }
        else if ( Trigger.isUpdate )
        {
          doBeforeUpdate( Trigger.old, Trigger.new ,Trigger.oldMap,Trigger.newMap);
        }
        else if ( Trigger.isDelete )
        {
          doBeforeDelete( Trigger.old,Trigger.oldMap);
        }
      }
      else if ( Trigger.isAfter )
      {
        if ( Trigger.isInsert )
        {
          doAfterInsert( Trigger.new , Trigger.newMap);
        }
        else if ( Trigger.isUpdate )
        {
          doAfterUpdate( Trigger.old, Trigger.new ,Trigger.oldMap,Trigger.newMap);
        }
        else if ( Trigger.isDelete )
        {
          doAfterDelete( Trigger.old,Trigger.oldMap);
        }
        else if ( Trigger.isUndelete)
        {
          doAfterUndelete( Trigger.new,Trigger.newMap);
        }
      }
  }
  
  /************************************************************************************
   *                       Object CRUD LifeCycle   Methods                            *
   *           Add custom business logic to handle lifecycle events from triggers     *
   ************************************************************************************/

  /**
   * Lifecycle method: before insert. 
   * Override this method to add custom business logic before the validate method is called
   * and insert is performed.
   *
   * @param newRecords: A list of the new records passed in from the processLifecycleEvents method
   */
  public virtual void doBeforeInsert( List<SObject> newRecords )
  {
  }
  
  /**
   * Lifecycle method: after insert
   * Override this method to add custom business logic after insert is performed.
   * 
   * @param newRecords: A list of the new records passed in from the processLifecycleEvents method
   */
  public virtual void doAfterInsert( List<SObject> newRecords , Map<Id,sObject> newMap)
  {
  } 
    
  /**
   * Lifecycle method: before update
   * Override this method to add custom business logic before the validate method is called
   * and update is performed.
   *
   * @param oldRecords: A list of records with the old values passed in from the processLifecycleEvents method
   * @param newRecords: A list of records with the new values passed in from the processLifecycleEvents method
   */
  public virtual void doBeforeUpdate( List<SObject> oldRecords, List<SObject> newRecords , Map<Id,sObject> oldMap, Map<Id,sObject> newMap)
  {
  }
  
  /**
   * Lifecycle method: after update
   * Override this method to add custom business logic after update is performed.
   * 
   * @param oldRecords: A list of records with the old values passed in from the processLifecycleEvents method
   * @param newRecords: A list of records with the new values passed in from the processLifecycleEvents method
   */
  public virtual void doAfterUpdate( List<SObject> oldRecords, List<SObject> newRecords , Map<Id,sObject> oldMap, Map<Id,sObject> newMap)
  {
  } 
  
  /**
   * Lifecycle method: before delete
   * Override this method to add custom business logic before the validate method is called
   * and delete is performed.
   *
   * @param oldRecords: A list of records with the old values passed in from the processLifecycleEvents method
   * @param newRecords: A list of records with the new values passed in from the processLifecycleEvents method
   */
  public virtual void doBeforeDelete( List<SObject> oldRecords, Map<Id,sObject> oldMap)
  {
  }
  
  /**
   * Lifecycle method: after delete
   * Override this method to add custom business logic after delete is performed.
   * 
   * @param oldRecords: A list of records with the old values passed in from the processLifecycleEvents method
   * @param newRecords: A list of records with the new values passed in from the processLifecycleEvents method
   */
  public virtual void doAfterDelete( List<SObject> oldRecords , Map<Id,sObject> oldMap)
  {
  }


  /**
   * Lifecycle method: after undelete
   * Override this method to add custom business logic after undelete is performed.
   * 
   * @param newRecords: A list of records with the new values passed in from the processLifecycleEvents method
   */
  public virtual void doAfterUndelete( List<SObject> newRecords , Map<Id,sObject> newMap)
  {
  }  
   
}