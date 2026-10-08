/// Global access generates a fair bit of technical debt, therefore we must add a test for each global we access to ensure
/// we can easily detect if it will not work on the version/machine
Class RESTUtils.Test.GlobalAccesses.GeneralUtils Extends (RESTUtils.Test.AbstractTest, RESTUtils.Util.GeneralUtils)
{

/// Must be persistent
Parameter ClassToTest = "RESTUtils.Test.Persistent.pr";

ClassMethod GlobalAccessGeneralUtilsTest()
{
    Set anyFailed = 0
    W !, "GeneralUtils global access test",!,!
    Do ..CheckTest("ClassExists", 1, ..ExistsClassInGlobal(..#ClassToTest), .anyFailed, "RESTUtils.Test.GlobalAccesses.GeneralUtils", "ExistsClassInGlobal", ..#ClassToTest)
    Do ..CheckTest("GetTable", "RESTUtils_Test_Persistent.pr", ..GetClassTableInGlobal(..#ClassToTest), .anyFailed, "RESTUtils.Test.GlobalAccesses.GeneralUtils", "GetClassTableInGlobal", ..#ClassToTest)
    Do ..ClassExtendsAdaptorInGlobal(..#ClassToTest, .extendsAdaptor, .extendsUtilsAdaptor)
    Do ..CheckTest("ExtendsAdaptor", 1, extendsAdaptor, .anyFailed, "RESTUtils.Test.GlobalAccesses.GeneralUtils", "ClassExtendsAdaptorInGlobal", ..#ClassToTest)
    Do ..CheckTest("ExtendsUtilsAdaptor", 1, extendsUtilsAdaptor, .anyFailed, "RESTUtils.Test.GlobalAccesses.GeneralUtils", "ClassExtendsAdaptorInGlobal", ..#ClassToTest)
    W:('anyFailed) ..WriteColor(2, "All OK")
}

}
