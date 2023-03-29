public with sharing class ObjectFactory {
    @TestVisible private static Map<String, CustomObject> mocks = new Map<String, CustomObject>();

    public CustomObject createObject(String objectName) {
        if (Test.isRunningTest() && this.objectHasMock(objectName)) {
            return getObjectMock(objectName);
        } else {
            return (CustomObject) Type.forName(objectName).newInstance();
        }
    }

    private Boolean objectHasMock(String objectName) {
        return null != mocks && mocks.containsKey(objectName);
    }

    private CustomObject getObjectMock(String objectName) {
        if (null != mocks && mocks.containsKey(objectName)) {
            return mocks.get(objectName);
        }
        return null;
    }
}