Class RESTUtils.Resolver.Export.Definitions.ExportToExcel
{

/// TODO, returned should be changed to a type of stream, check out ImportFromExcel for a possible solution
/// 
/// Exports a JSON object to excel, can provide column formatting to customize the columns
/// The dataJson should not have complex object, aka depth, should be an array of objects with flat values
/// [{"org":1, "desc":"MyOrganization", "created":"22/10/2025"},...]
/// The columnFormat is an object that should contain the names of the columns to format with the values being an object with the key
/// type, to indicate the type and any other info if required
/// As of now the types are:
/// currency -> must provide coinFormat key
/// currencyDiff ->  Currency differnce, will apply a red/black color depending on the value, must provide coinFormat key
/// 
/// 
/// If no formatting is provided for a column it is treated as a plain string
/// 
/// 
/// Some coinage formats:
/// [$â¬-2] -> EUR
/// [$$-409] -> USD
/// [$Ch$-24] -> CLP
/// [$R$-416] -> BRL
/// [$Co$-24] -> COP
/// [$âª-43] -> ILS
/// [$SFr-415] -> CHF
/// [$kr-1053] -> SEK
/// [$KÄ-1029] -> CZK
/// [$Ø¯.Ø¥-3801] -> AED
/// [$ï·¼-820] -> QAR
ClassMethod AsExcel(dataJson As %String(MAXLEN=""), columnFormat As %String(MAXLEN="") = "{}") As %String(MAXLEN="") [ Internal, Language = python ]
{
    import json
    import io
    import os
    from openpyxl import Workbook
    from openpyxl.styles import numbers
    from openpyxl.utils import get_column_letter

    # === INPUT DATA ===
    data = json.loads(dataJson)
    format = json.loads(columnFormat)

    # === CREATE EXCEL ===
    wb = Workbook()
    ws = wb.active
    ws.title = "Data Export"

    # Write header
    headers = [key for key in data[0].keys()]
    ws.append(headers)

    # Write data
    for row in data:
        excel_row = []
        for key in headers:
            value = row.get(key, "")
            formatting = format.get(key)
            if formatting is not None and (formatting.get("type") == "currency" or formatting.get("type") == "currencyDiff"):
                if value is not None and value != '':
                    excel_row.append(float(value))
                else:
                    excel_row.append(value)
            else:
                if value is not None:
                    excel_row.append(str(value))
                else:
                    excel_row.append(value)
        ws.append(excel_row)
    #Format
    columnIndex = 0
    for key in headers:
        columnIndex = columnIndex + 1
        formatting = format.get(key)
        if formatting is not None:
            type = formatting.get("type")
            if type == "currency" or type == "currencyDiff":
                coin = formatting.get("coin")
                if coin is None:
                    coin = "[$â¬-2]"
                if type == "currency":
                    style = '[Black]#,##0.00'+coin
                else:
                    style = '[Black]#,##0.00'+formatting+';[Red]-#,##0.00 '+formatting+';[Black]0.00 '+formatting
                rowIndex = 1
                while rowIndex <= len(data) +1:
                    ws.cell(row=rowIndex, column=columnIndex).number_format = style
                    rowIndex = rowIndex +1
    for column_cells in ws.columns:
        max_length = max(len(str(cell.value)) for cell in column_cells if cell.value)
        ws.column_dimensions[get_column_letter(column_cells[0].column)].width = max_length + 2

    # Save the file to a stream
    file_stream = io.BytesIO()
    wb.save(file_stream)
    file_stream.flush()  # Ensure all data is written
    file_stream.seek(0)
    return file_stream.read()
}

}
