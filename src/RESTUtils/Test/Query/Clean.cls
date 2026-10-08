Class RESTUtils.Test.Query.Clean Extends RESTUtils.Test.AbstractTest
{

ClassMethod CheckTests()
{
    Do ..TestCleanColumn() W !
    Do ..TestCleanTable() W !
    Do ..TestCleanOrderBy() W !
}

ClassMethod TestCleanColumn()
{
    W !,"Clean column",!
    Set anyFailed = 0
    D ..CleanColumn("simpleSelectColumn","col", 1, 0, """col""", .anyFailed)
    D ..CleanColumn("simpleColumn","col", 1, 1, "%Exact(""col"")", .anyFailed)
    D ..CleanColumn("scopedSelectColumn","t.col", 0, 0, """t"".""col""", .anyFailed)
    D ..CleanColumn("scopedColumn","t.col", 1, 0, """t"".""col""", .anyFailed)
    D ..CleanColumn("exactSelectColumn","col", 1, 1, "%Exact(""col"")", .anyFailed)
    D ..CleanColumn("exactScopedSelectColumn","t.col", 1, 1, "%Exact(""t"".""col"")", .anyFailed)
    D ..CleanColumn("arrowColumn","col->col", 0, 0, """col""->""col""", .anyFailed)
    D ..CleanColumn("scopedArrowColumn","t.col->col", 0, 0, """t"".""col""->""col""", .anyFailed)
    D ..CleanColumn("scopedArrowSelectColumn","t.col->col", 1, 0, """t"".""col""->""col""", .anyFailed)
    D ..CleanColumn("scopedArrowExactSelectColumn","t.col->col", 1, 1, "%Exact(""t"".""col""->""col"")", .anyFailed)
    D ..CleanColumn("selectAll","*", 1, 0, "*", .anyFailed)
    D ..CleanColumn("addSelectAll","SUM(*)", 1, 0, "SUM(*)", .anyFailed)
    D ..CleanColumn("addSelectColumn","SUM(col)", 1, 0, "SUM(""col"")", .anyFailed)
    D ..CleanColumn("addArrowSelectColumn","SUM(col->col)", 1, 0, "SUM(""col""->""col"")", .anyFailed)
    D ..CleanColumn("addScopedArrowSelectColumn","SUM(t.col->col)", 1, 0, "SUM(""t"".""col""->""col"")", .anyFailed)
    D ..CleanColumn("aliasSelectColumn","col As col", 1, 0, """col"" As ""col""", .anyFailed)
    D ..CleanColumn("aliasExactSelectColumn","col As col", 1, 1, "%Exact(""col"") As ""col""", .anyFailed)
    D ..CleanColumn("aliasArrowSelectColumn","col->col As col", 1, 0, """col""->""col"" As ""col""", .anyFailed)
    D ..CleanColumn("aliasArrowExactSelectColumn","col->col As col", 1, 1, "%Exact(""col""->""col"") As ""col""", .anyFailed)
    D ..CleanColumn("aliasScopedSelectColumn","t.col As col", 1, 0, """t"".""col"" As ""col""", .anyFailed)
    D ..CleanColumn("aliasScopedExactSelectColumn","t.col As col", 1, 1, "%Exact(""t"".""col"") As ""col""", .anyFailed)
    D ..CleanColumn("aliasScopedArrowSelectColumn","t.col->col As col", 1, 0, """t"".""col""->""col"" As ""col""", .anyFailed)
    D ..CleanColumn("aliasScopedArrowExactSelectColumn","t.col->col As col", 1, 1, "%Exact(""t"".""col""->""col"") As ""col""", .anyFailed)
    D ..CleanColumn("endLiteral","t.col->col||'gkh ,.' As algo", 1, 0, """t"".""col""->""col""||'gkh ,.' As ""algo""", .anyFailed)
    D ..CleanColumn("startLiteral","'dsa .,'||t.col->col As algo", 1, 0, "'dsa .,'||""t"".""col""->""col"" As ""algo""", .anyFailed)
    D ..CleanColumn("twoLiteral","'dsa .,'||t.col->col||'gkh ,.' As algo", 1, 0, "'dsa .,'||""t"".""col""->""col""||'gkh ,.' As ""algo""", .anyFailed)
    D ..CleanColumn("mixedLiteral","'pr'||SUM(t.num)||'dsa .,'||t.col->col||'gkh ,.' As algo", 1, 0, "'pr'||SUM(""t"".""num"")||'dsa .,'||""t"".""col""->""col""||'gkh ,.' As ""algo""", .anyFailed)
    D ..CleanColumn("exactEndLiteral","t.col->col||'gkh ,.' As algo", 1, 1, "%Exact(""t"".""col""->""col"")||'gkh ,.' As ""algo""", .anyFailed)
    D ..CleanColumn("exactStartLiteral","'dsa .,'||t.col->col As algo", 1, 1, "'dsa .,'||%Exact(""t"".""col""->""col"") As ""algo""", .anyFailed)
    D ..CleanColumn("exactTwoLiterals","'dsa .,'||t.col->col||'gk ,.' As algo", 1, 1, "'dsa .,'||%Exact(""t"".""col""->""col"")||'gk ,.' As ""algo""", .anyFailed)

    ///Distinct columns
    D ..CleanColumn("distinctSimple","DISTINCT col", 1, 0, "DISTINCT ""col""", .anyFailed)
    D ..CleanColumn("distinctArrow","DISTINCT col->col", 1, 0, "DISTINCT ""col""->""col""", .anyFailed)
    D ..CleanColumn("distinctScopedArrowAlias","DISTINCT t.col->col", 1, 0, "DISTINCT ""t"".""col""->""col""", .anyFailed)
    D ..CleanColumn("distinctScopedArrowAlias","DISTINCT t.col->col As algo", 1, 0, "DISTINCT ""t"".""col""->""col"" As ""algo""", .anyFailed)
    D ..CleanColumn("distinctExactTwoLiterals","DISTINCT t.col->col As algo", 1, 1, "%Exact(DISTINCT ""t"".""col""->""col"") As ""algo""", .anyFailed)
    D ..CleanColumn("distinctExactTwoLiterals","'dsa .,'||DISTINCT t.col->col||'gk ,.' As algo", 1, 1, "'dsa .,'||%Exact(DISTINCT ""t"".""col""->""col"")||'gk ,.' As ""algo""", .anyFailed)
    W:('anyFailed) ..WriteColor(2, "All OK")
}

ClassMethod CleanColumn(name As %String(MAXLEN=""), column As %String(MAXLEN=""), isSelectColumn As %Boolean = 0, addExact As %Boolean = 0, expectedResult As %String(MAXLEN=""), ByRef anyFailed As %Boolean)
{
    Set exception = ""
    Try{
        Set result = ##Class(RESTUtils.Resolver.Query.QueryResolver).CleanCompColumn(column, "ColumnIsInvalid", isSelectColumn, addExact, 1)
    }Catch e {
        Set result = "FAILED"
        Set exception = e.DisplayString()
    }
    Do ..CheckTest(name, expectedResult, result, .anyFailed, "RESTUtils.Resolver.Query.QueryResolver", "CleanColumn", column, isSelectColumn, addExact, 1)
    w:(exception '= "") "Exec threw: "_exception,!,!
}

ClassMethod TestCleanTable()
{
    Set anyFailed = 0
    W !, "Clean table",!,!
    Do ..CleanTable("Long table", "BOS_Data.Billing", """BOS_Data"".""Billing"" ", .anyFailed)
    Do ..CleanTable("More long table", "BOS_Data_Data.Billing", """BOS_Data_Data"".""Billing"" ", .anyFailed)
    Do ..CleanTable("Short table", "Data.Billing", """Data"".""Billing"" ", .anyFailed)
    W:('anyFailed) ..WriteColor(2, "All OK")
}

ClassMethod CleanTable(name As %String(MAXLEN=""), table As %String(MAXLEN=""), expectedResult As %String(MAXLEN=""), ByRef anyFailed As %Boolean)
{
    Set result = ##class(RESTUtils.Resolver.Query.QueryResolver).CleanTable(table)
    Do ..CheckTest(name, expectedResult, result, .anyFailed, "RESTUtils.Resolver.Query.QueryResolver", "CleanTable", table)
}

ClassMethod TestCleanOrderBy()
{
    Set anyFailed = 0
    W !, "Clean order by",!,!
    Do ..CleanOrderBy("singleColumn", "col asc", """col"" asc", .anyFailed)
    Do ..CleanOrderBy("multipleColumn", "col desc,col asc", """col"" desc,""col"" asc", .anyFailed)
    Do ..CleanOrderBy("singleColumnArrow", "col->col asc", """col""->""col"" asc", .anyFailed)
    Do ..CleanOrderBy("multipleColumnArrow", "col->col asc,col2->col2 desc", """col""->""col"" asc,""col2""->""col2"" desc", .anyFailed)
    Do ..CleanOrderBy("multipleColumnBoth", "col->col asc,col2 desc", """col""->""col"" asc,""col2"" desc", .anyFailed)
    W:('anyFailed) ..WriteColor(2, "All OK")
}

ClassMethod CleanOrderBy(name As %String(MAXLEN=""), orderby As %String(MAXLEN=""), expectedResult As %String(MAXLEN=""), ByRef anyFailed As %Boolean)
{
    Set result = ##class(RESTUtils.Resolver.Query.QueryResolver).CleanOrderBy(orderby)
    Do ..CheckTest(name, expectedResult, result, .anyFailed, "RESTUtils.Resolver.Query.QueryResolver", "CleanOrderBy", orderby)
}

}
