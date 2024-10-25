@IsTest
@SuppressWarnings('PMD.MethodNamingConventions,PMD.ApexDoc')
private class CustomSettings_TEST {
  @IsTest
  static void getInstance() {
    CustomSettings settings = new CustomSettings();
    System.Assert.isNull(
      settings.getInstance(),
      'CustomSettings.getInstance returned an unexpected value'
    );
    System.Assert.isNull(
      settings.get('My_Test_Field__c'),
      'CustomSettings.getInstance returned an unexpected value'
    );
  }
  @IsTest
  static void get_testValue() {
    TestCustomSettings settings = new TestCustomSettings(new Account());

    CustomSettings.setMockValue('Account', 'My_Test_Field__c', 'My Test Value');
    System.Assert.areEqual(
      'My Test Value',
      settings.get('My_Test_Field__c'),
      'CustomSettings.get returned an unexpected value'
    );
  }
  @IsTest
  static void get_defaultValue() {
    Account mockSetting = new Account();

    TestCustomSettings settings = new TestCustomSettings(mockSetting);
    settings.get('Description');
    System.Assert.isTrue(
      true,
      'CustomSettings.get should return default value without exception'
    );
  }
  @IsTest
  static void get_withInstance() {
    Account mockSetting = new Account(Name = 'Test');
    mockSetting.put('Description', 'Test Value');

    TestCustomSettings settings = new TestCustomSettings(mockSetting);

    System.Assert.areEqual(
      'Test Value',
      settings.get('Description'),
      'CustomSettings.get should return field value when instance has Name'
    );
  }
  private class TestCustomSettings extends CustomSettings {
    private final SObject mockInstance;
    public TestCustomSettings(SObject mock) {
      this.mockInstance = mock;
    }
    public override SObject getInstance(Id userId) {
      return mockInstance;
    }
  }
}
