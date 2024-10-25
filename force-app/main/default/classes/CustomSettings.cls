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
@SuppressWarnings(
  'PMD.CognitiveComplexity'
) // This code is beautiful just the way it is 😤
public inherited sharing virtual class CustomSettings {
  @TestVisible
  private static final Map<String, Map<String, Object>> MOCK_VALUES = new Map<String, Map<String, Object>>();
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
   * @param             fieldApiName API name of field to retrieve
   * @return            Object value returned, must be cast to expected type
   */
  public Object get(String fieldApiName) {
    return get(fieldApiName, UserInfo.getUserId());
  }
  /**
   * @description       Get Custom Setting field value for provided user
   * @param             fieldApiName API name of field to retrieve
   * @param             userId ID of user to retrieve values for
   * @return            Object value returned, must be cast to expected type
   */
  public Object get(String fieldApiName, Id userId) {
    SObject instance = getInstance(userId);
    if (instance == null) {
      return null;
    }
    // Get mock value if in test
    if (Test.isRunningTest()) {
      String objectApiName = String.valueOf(instance.getSObjectType());
      if (MOCK_VALUES.containsKey(objectApiName)) {
        return MOCK_VALUES.get(objectApiName).get(fieldApiName);
      }
    }
    if (instance.get('Name') == null) {
      // Custom Setting has not been instantiated in Setup, so return field's default value (might still be null)
      return getDefaultValue(instance, fieldApiName);
    }
    return instance.get(fieldApiName);
  }
  /**
   * @description       Get Custom Setting default field value
   * @param             instance SObject instance of the Custom Setting
   * @param             fieldApiName API name of the field
   * @return            Default field value or null if none
   */
  private Object getDefaultValue(SObject instance, String fieldApiName) {
    return instance
      ?.getSObjectType()
      ?.newSObject(null, true)
      ?.get(fieldApiName);
  }
  @TestVisible
  private static void setMockValue(
    String objectApiName,
    String fieldApiName,
    Object value
  ) {
    if (!MOCK_VALUES.containsKey(objectApiName)) {
      MOCK_VALUES.put(objectApiName, new Map<String, Object>());
    }
    MOCK_VALUES.get(objectApiName).put(fieldApiName, value);
  }
}
