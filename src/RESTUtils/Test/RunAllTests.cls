Class RESTUtils.Test.RunAllTests
{

/// tmp/test/
ClassMethod RunAllTests()
{
    set ^UnitTestRoot = "/tmp/test"
    D ##Class(%UnitTest.Manager).DebugRunTestCase()
}

ClassMethod Run()
{
    D ##class(RESTUtils.Test.GlobalAccesses.GeneralUtils).GlobalAccessGeneralUtilsTest()
    W !
    D ##class(RESTUtils.Test.Query.Clean).CheckTests()
}

}
