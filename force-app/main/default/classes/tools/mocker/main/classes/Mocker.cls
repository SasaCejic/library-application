/**
 * This is a simple service which utilizes the functionality of @see System.StubProvider. For more info see the links
 * - https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_StubProvider.htm
 * - https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm
 *
 * Simple usage:
 * 		In this example wea are creating a Mock object of the AccountService where we set a certain behavior of the "getAccountType"
 * 		method. This mock instance can later be passed as a dependency to a class which uses the AccountService and we want
 * 		to abstract the behavior of the AccountService by setting a predefined outcome.
 *
 * 		AccountService httpServiceMock = (AccountService) new Mocker(AccountService.class).setBehavior('getAccountType', 'Account').getMock();
 *
 * Exception usage:
 * 		AccountService httpServiceMock = (AccountService) new Mocker(AccountService.class).setBehavior('getAccountType', new MyCustomException('Fail').getMock();
 */
@IsTest
public with sharing class Mocker implements System.StubProvider {

    private Object stub;
    private Map<String, Object> mocks = new Map<String, Object>();
    private Map<String, Integer> mocksExecutions = new Map<String, Integer>();

    public Mocker(Type classType) {
        stub = Test.createStub(classType, this);
    }

    public Mocker(Type classType, Map<String, Object> mocks) {
        stub = Test.createStub(classType, this);
        this.mocks = mocks;
    }

    public Object getMock() {
        if (null == stub) {
            throw new MockerException('Stub was not set');
        }
        return stub;
    }

    public Mocker setBehavior(String stubbedMethodName, Object returnValue) {
        mocks.put(stubbedMethodName, returnValue);
        return this;
    }

    public Mocker removeBehavior(String stubbedMethodName) {
        if (null == mocks || mocks.isEmpty()) {
            mocks.remove(stubbedMethodName);
        }
        return this;
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName,
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames,
        List<Object> listOfArgs) {

        // check if there are any mocked methods
        if (null == mocks || mocks.isEmpty()) {
            throw new MockerException('There are no mocked methods provided for this Mocker instance');
        }

        // return the response of the mocked method
        if (mocks.containsKey(stubbedMethodName)) {
            Object expected = mocks.get(stubbedMethodName);
            incrementMethodExecution(stubbedMethodName);

            // if the exception is set, we throw it
            if (expected instanceof Exception) {
                throw (Exception) expected;
            }

            // else we return the given result
            return expected;
        }

        throw new MockerException('There is no mocked method provided for the given method: ' + stubbedMethodName);
    }

    private void incrementMethodExecution(String stubbedMethodName) {
        if (null == mocksExecutions.get(stubbedMethodName)) {
            mocksExecutions.put(stubbedMethodName, 0);
        }
        Integer timesExecuted = mocksExecutions.get(stubbedMethodName) + 1;
        mocksExecutions.put(stubbedMethodName, timesExecuted);
    }

    public Boolean methodWasExecuted(String stubbedMethodName) {
        return null != mocksExecutions.get(stubbedMethodName) ? true : false;
    }

    public void assertMethodWasExecuted(String stubbedMethodName) {
        System.assert(null != mocksExecutions.get(stubbedMethodName) ? true : false,
            String.format('Method <{0}> was never executed', new List<String>{
                stubbedMethodName
            }));
    }

    public Integer getMethodExecutionCount(String stubbedMethodName) {
        return null != mocksExecutions.get(stubbedMethodName) ? mocksExecutions.get(stubbedMethodName) : 0;
    }

    public void assertMethodExecutionCount(String stubbedMethodName, Integer expectedCount) {
        Integer actualExecutionCount = null != mocksExecutions.get(stubbedMethodName) ? mocksExecutions.get(stubbedMethodName) : 0;
        System.assert(expectedCount == actualExecutionCount,
            String.format('Method <{0}> execution count does not match. Expected: {1} Actual: {2}', new List<String>{
                stubbedMethodName, String.valueOf(expectedCount), String.valueOf(actualExecutionCount)
            }));
    }
}