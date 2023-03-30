public with sharing class ObjectFactory {
    @TestVisible private static Map<String, CustomObject> mocks = new Map<String, CustomObject>();

    public CustomObject createObject(System.Type classType) {
        String className = classType.getName();
        if (Test.isRunningTest() && this.objectHasMock(className)) {
            return getObjectMock(className);
        } else {
            return (CustomObject) Type.forName(className).newInstance();
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