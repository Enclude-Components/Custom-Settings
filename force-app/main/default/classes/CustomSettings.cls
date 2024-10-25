/**
 * @description   Virtual base class for Custom Settings wrappers
 * @since         25/10/2024
 * @author        Brandon DeMatteis, Enclude
 * @example
 * ```apex
 * // Extend this class, overriding the getInstance(Id userId) method to return your Custom Setting instance
 * public inherited sharing class MyDemoSettings extends CustomSettings {
 *    public override SObject getInstance(Id userId) {
 *       return My_Demo_Settings__c.getInstance(userId);
 *    }
 * }
 */
public inherited sharing virtual class CustomSettings {
  @TestVisible
  private static final Map<String, Object> TEST_VALUES = new Map<String, Object>();
  /**
   * @description   Virtual method that concrete implementations must override to return
   *                their specific Custom Setting instance for given User
   * @param         userId The ID of the user to get settings for
   * @return        SObject The Custom Setting instance
   */
  public virtual SObject getInstance(Id userId) {
    return null;
  }
  /**
   * @description     Returns instance of Custom Setting for current running user
   * @return          SObject The Custom Setting instance
   */
  public SObject getInstance() {
    return getInstance(UserInfo.getUserId());
  }
  /**
   * @description       Get Custom Setting field value for running user
   * @param             fieldName API name of field to retrieve
   * @return            Object value returned, must be cast to expected type
   */
  public Object get(String fieldName) {
    return get(fieldName, UserInfo.getUserId());
  }
  /**
   * @description       Get Custom Setting field value for provided user
   * @param             fieldName API name of field to retrieve
   * @param             userId ID of user to retrieve values for
   * @return            Object value returned, must be cast to expected type
   */
  public Object get(String fieldName, Id userId) {
    // If a TEST_VALUE exists, we must be in a unit test, so return the mock value
    if (TEST_VALUES.containsKey(fieldName)) {
      return TEST_VALUES.get(fieldName);
    }
    // Get the instance
    SObject instance = getInstance(userId);
    if (instance != null && instance.get('Name') == null) {
      // Custom Setting has not been instantiated in Setup, so return field's default value (might still be null)
      return getDefaultValue(instance, fieldName);
    }
    return instance?.get(fieldName);
  }
  /**
   * @description       Get Custom Setting default field value
   * @param             instance SObject instance of the Custom Setting
   * @param             fieldName API name of the field
   * @return            Default field value or null if none
   */
  private Object getDefaultValue(SObject instance, String fieldName) {
    return instance?.getSObjectType()?.newSObject(null, true)?.get(fieldName);
  }
}
