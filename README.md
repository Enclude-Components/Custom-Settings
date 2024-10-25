# CustomSettings
Extendable class to make accessing Custom Settings easier and allow for easier mocking in unit tests

## Deploy

<a href="https://githubsfdeploy.herokuapp.com?owner=Enclude-Components&repo=Custom-Settings&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Usage Guide
First, create a class extending the CustomSettings base class. You'll need one for each Custom Setting you want to access in Apex.

### Override the Base Class
```java
// Extend the CustomSettings class
public inherited sharing class MyExampleSettings extends CustomSettings {
    // Override the getInstance method to return your own setting's instance
    public override SObject getInstance(Id userId) {
        return My_Example_Settings__c.getInstance(userId);
    }
}
```

### Get a Value
```java
MyExampleSettings settings = new MyExampleSettings();
// Method .get returns an Object, so cast it to expected data type
String myTextValue = (String)settings.get('My_Custom_Text_Field__c');
```
If a Custom Setting has not be instantiated for the running user, the default value of that field will be returned instead.

### Mock a Value
Writing unit tests that depend on Custom Settings is bad practice, so it's often useful to mock these values. This is made easier using the CustomSettings class.
```java
@IsTest
static void myUnitTest() {
    CustomSettings.setMockValue(
        'My_Example_Settings__c', // API name (including namespace) of Custom Setting object to mock
        'My_Custom_Text_Field__c', // API name (including namespace) of Custom Setting field to mock
        'My mocked text value' // Mock value to return
    );
    // For the remainder of the test, anytime this value is requested anywhere, the mock value will be returned
    ...
}
```