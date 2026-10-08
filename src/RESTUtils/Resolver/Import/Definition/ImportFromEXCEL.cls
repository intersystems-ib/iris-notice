Class RESTUtils.Resolver.Import.Definition.ImportFromEXCEL
{

ClassMethod Import(content As %Stream.Object) As %DynamicObject
{
    set builtins = ##class(%SYS.Python).Import("builtins")
    Set binaries = builtins.bytearray()
    Do content.Rewind()
    while('content.AtEnd){
        Do binaries.extend(##class(%SYS.Python).Bytes(content.Read()))
    }
    Return {}.%FromJSON(..IntImport(binaries))
}

/// Content should be a binary array
/// 
/// set builtins = ##class(%SYS.Python).Import("builtins")
/// Set binaries = builtins.bytearray()
/// D %request.Content.Rewind()
/// while(%request.Content.AtEnd = 0){
///      D binaries.extend(##class(%SYS.Python).Bytes(%request.Content.Read()))
/// }
ClassMethod IntImport(content) [ Internal, Language = python ]
{
    from openpyxl import Workbook
    from openpyxl import load_workbook
    from io import BytesIO
    import json
    import iris
    # Load workbook from bytes
    by = BytesIO(content)
    wb = load_workbook(by)
    ws = wb.active  # "single book/sheet" assumption

    # Read header (first row)
    header_row = next(ws.iter_rows(min_row=1, max_row=1, values_only=True))
    headers = ["" if h is None else str(h).strip() for h in header_row]
    # Read data rows (row 2 onwards) and map to dicts by header
    result = iris._Stream.TmpCharacter._New()
    result.Write("[")
    isFirst = True
    for values in ws.iter_rows(min_row=2, values_only=True):
        row_dict = {headers[i]: values[i] for i in range(len(headers))}
        if isFirst:
            isFirst = False
        else:
            result.Write(",")
        json.dump(row_dict, result, default=str)
    result.Write("]")
    result.Rewind()
    return result
}

}
