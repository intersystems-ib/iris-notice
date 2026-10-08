Include RESTUtils.INC.Utils

Class RESTUtils.Util.Examples
{

/// TODO finish
ClassMethod GraphGenerator(namespace As %String(MAXLEN=""), class As %String(MAXLEN="")) As %Stream.TmpCharacter
{
    Set res= ##Class(%Stream.TmpCharacter).%New()
    Do res.Write("<!DOCTYPE html> "_
    "<html lang=""en""> "_
    "<head> "_
    "<meta charset=""UTF-8"" /> "_
    "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0"" /> "_
    "<title>JSON Graph Builder</title> "_
    "<script src=""https://cdn.jsdelivr.net/npm/chart.js""></script> "_
    "<style> "_
    ":root { "_
    "--bg: #f6f7fb; "_
    "--panel: #ffffff; "_
    "--border: #d9deea; "_
    "--text: #1f2937; "_
    "--muted: #6b7280; "_
    "--accent: #2563eb; "_
    "--danger: #b91c1c; "_
    "} "_
    "* { box-sizing: border-box; } "_
    "body { "_
    "margin: 0; "_
    "font-family: Arial, Helvetica, sans-serif; "_
    "background: var(--bg); "_
    "color: var(--text); "_
    "} "_
    ".wrap { "_
    "max-width: 1100px; "_
    "margin: 32px auto; "_
    "padding: 0 20px; "_
    "} "_
    "h1 { "_
    "margin: 0 0 8px; "_
    "font-size: 28px; "_
    "} "_
    "p { "_
    "margin: 0 0 24px; "_
    "color: var(--muted); "_
    "line-height: 1.5; "_
    "} "_
    ".layout { "_
    "display: grid; "_
    "grid-template-columns: 320px 1fr; "_
    "gap: 20px; "_
    "align-items: start; "_
    "} "_
    ".panel { "_
    "background: var(--panel); "_
    "border: 1px solid var(--border); "_
    "border-radius: 16px; "_
    "padding: 18px; "_
    "box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05); "_
    "} "_
    ".controls { "_
    "display: grid; "_
    "gap: 14px; "_
    "} "_
    "label { "_
    "display: block; "_
    "font-size: 14px; "_
    "font-weight: 600; "_
    "margin-bottom: 6px; "_
    "} "_
    "select, button { "_
    "width: 100%; "_
    "padding: 10px 12px; "_
    "border-radius: 10px; "_
    "border: 1px solid var(--border); "_
    "font-size: 14px; "_
    "background: #fff; "_
    "} "_
    "button { "_
    "background: var(--accent); "_
    "border: none; "_
    "color: white; "_
    "font-weight: 700; "_
    "cursor: pointer; "_
    "} "_
    "button:hover { "_
    "filter: brightness(0.96); "_
    "} "_
    ".note { "_
    "font-size: 13px; "_
    "color: var(--muted); "_
    "line-height: 1.45; "_
    "padding-top: 4px; "_
    "} "_
    ".status { "_
    "min-height: 20px; "_
    "font-size: 13px; "_
    "color: var(--muted); "_
    "} "_
    ".status.error { "_
    "color: var(--danger); "_
    "} "_
    ".chart-box { "_
    "min-height: 520px; "_
    "display: flex; "_
    "flex-direction: column; "_
    "} "_
    ".chart-header { "_
    "display: flex; "_
    "justify-content: space-between; "_
    "align-items: center; "_
    "gap: 12px; "_
    "margin-bottom: 12px; "_
    "flex-wrap: wrap; "_
    "} "_
    ".chart-header h2 { "_
    "margin: 0; "_
    "font-size: 18px; "_
    "} "_
    ".pill { "_
    "padding: 6px 10px; "_
    "border-radius: 999px; "_
    "background: #eef2ff; "_
    "color: #3730a3; "_
    "font-size: 12px; "_
    "font-weight: 700; "_
    "} "_
    ".canvas-wrap { "_
    "position: relative; "_
    "flex: 1; "_
    "min-height: 440px; "_
    "} "_
    ".data-preview { "_
    "margin-top: 18px; "_
    "max-height: 240px; "_
    "overflow: auto; "_
    "background: #0f172a; "_
    "color: #e5e7eb; "_
    "border-radius: 12px; "_
    "padding: 14px; "_
    "font-size: 12px; "_
    "line-height: 1.5; "_
    "} "_
    "@media (max-width: 860px) { "_
    ".layout { "_
    "grid-template-columns: 1fr; "_
    "} "_
    ".chart-box { "_
    "min-height: 420px; "_
    "} "_
    ".canvas-wrap { "_
    "min-height: 340px; "_
    "} "_
    "} "_
    "</style> "_
    "</head> "_
    "<body> "_
    "<div class=""wrap""> "_
    "<h1>JSON Graph Builder</h1> "_
    "<p>Choose a chart type and map keys from JSON data loaded from an endpoint to render either a bar chart or a donut chart.</p> "_
    "<div class=""layout""> "_
    "<div class=""panel controls""> "_
    "<div> "_
    "<label for=""chartType"">Graph type</label> "_
    "<select id=""chartType""> "_
    "<option value=""bar"">Bar</option> "_
    "<option value=""doughnut"">Donut</option> "_
    "</select> "_
    "</div> "_
    "<div> "_
    "<label for=""xKey"">Category key</label> "_
    "<select id=""xKey""></select> "_
    "</div> "_
    "<div> "_
    "<label for=""yKey"">Value key</label> "_
    "<select id=""yKey""></select> "_
    "</div> "_
    "<div> "_
    "<label for=""groupKey"">Optional grouping key</label> "_
    "<select id=""groupKey""></select> "_
    "</div> "_
    "<button id=""renderBtn"" type=""button"">Render graph</button> "_
    "<div class=""status"" id=""statusMessage""></div> "_
    "<div class=""note""> "_
    "The page fetches data from a configured endpoint with a POST request and inspects the keys from the returned JSON array. For bar charts, values are summed by category. For donut charts, the selected category becomes the slice label and the numeric key becomes the slice value. "_
    "</div> "_
    "</div> "_
    "<div class=""panel chart-box""> "_
    "<div class=""chart-header""> "_
    "<h2 id=""chartTitle"">Chart preview</h2> "_
    "<div class=""pill"" id=""recordCount"">0 records</div> "_
    "</div> "_
    "<div class=""canvas-wrap""> "_
    "<canvas id=""chartCanvas""></canvas> "_
    "</div> "_
    "<pre class=""data-preview"" id=""dataPreview""></pre> "_
    "</div> "_
    "</div> "_
    "</div> "_
    "<script> "_
    "const DATA_ENDPOINT = ""../../../search/"_namespace_"/"_class_"""; "_
    "const REQUEST_PAYLOAD = {""select"":""*""}; "_
    "let rawData = []; "_
    "let allKeys = []; "_
    "let numericKeys = []; "_
    "let chartInstance = null; "_
    "const chartTypeEl = document.getElementById(""chartType""); "_
    "const xKeyEl = document.getElementById(""xKey""); "_
    "const yKeyEl = document.getElementById(""yKey""); "_
    "const groupKeyEl = document.getElementById(""groupKey""); "_
    "const renderBtn = document.getElementById(""renderBtn""); "_
    "const dataPreviewEl = document.getElementById(""dataPreview""); "_
    "const chartTitleEl = document.getElementById(""chartTitle""); "_
    "const recordCountEl = document.getElementById(""recordCount""); "_
    "const statusMessageEl = document.getElementById(""statusMessage""); "_
    "function setStatus(message, isError = false) { "_
    "statusMessageEl.textContent = message; "_
    "statusMessageEl.classList.toggle(""error"", isError); "_
    "} "_
    "function fillSelect(select, values, includeBlank = false, blankLabel = ""None"") { "_
    "select.innerHTML = """"; "_
    "if (includeBlank) { "_
    "const blankOption = document.createElement(""option""); "_
    "blankOption.value = """"; "_
    "blankOption.textContent = blankLabel; "_
    "select.appendChild(blankOption); "_
    "} "_
    "values.forEach((value) => { "_
    "const option = document.createElement(""option""); "_
    "option.value = value; "_
    "option.textContent = value; "_
    "select.appendChild(option); "_
    "}); "_
    "} "_
    "function updatePreview() { "_
    "dataPreviewEl.textContent = JSON.stringify(rawData, null, 2); "_
    "recordCountEl.textContent = `${rawData.length} records`; "_
    "} "_
    "function initControls() { "_
    "allKeys = Object.keys(rawData[0] || {}); "_
    "numericKeys = allKeys.filter((key) => rawData.some((row) => typeof row[key] === ""number"" && Number.isFinite(row[key]))); "_
    "fillSelect(xKeyEl, allKeys); "_
    "fillSelect(yKeyEl, numericKeys); "_
    "fillSelect(groupKeyEl, allKeys, true, ""No grouping""); "_
    "xKeyEl.value = allKeys.includes(""region"") ? ""region"" : (allKeys[0] || """"); "_
    "yKeyEl.value = numericKeys.includes(""sales"") ? ""sales"" : (numericKeys[0] || """"); "_
    "groupKeyEl.value = allKeys.includes(""product"") ? ""product"" : """"; "_
    "updatePreview(); "_
    "} "_
    "function aggregateData(data, categoryKey, valueKey, groupKey) { "_
    "if (!categoryKey || !valueKey) { "_
    "return { labels: [], datasets: [] }; "_
    "} "_
    "if (!groupKey) { "_
    "const totals = new Map(); "_
    "data.forEach((row) => { "_
    "const category = String(row[categoryKey]); "_
    "const value = Number(row[valueKey]) || 0; "_
    "totals.set(category, (totals.get(category) || 0) + value); "_
    "}); "_
    "return { "_
    "labels: Array.from(totals.keys()), "_
    "datasets: [ "_
    "{ "_
    "label: `${valueKey} by ${categoryKey}`, "_
    "data: Array.from(totals.values()), "_
    "borderWidth: 1 "_
    "} "_
    "] "_
    "}; "_
    "} "_
    "const categories = [...new Set(data.map((row) => String(row[categoryKey])))]; "_
    "const groups = [...new Set(data.map((row) => String(row[groupKey])))]; "_
    "const datasets = groups.map((group) => ({ "_
    "label: group, "_
    "data: categories.map((category) => { "_
    "return data "_
    ".filter((row) => String(row[groupKey]) === group && String(row[categoryKey]) === category) "_
    ".reduce((sum, row) => sum + (Number(row[valueKey]) || 0), 0); "_
    "}), "_
    "borderWidth: 1 "_
    "})); "_
    "return { labels: categories, datasets }; "_
    "} "_
    "function destroyChart() { "_
    "if (chartInstance) { "_
    "chartInstance.destroy(); "_
    "chartInstance = null; "_
    "} "_
    "} "_
    "function buildChart() { "_
    "if (!rawData.length) { "_
    "chartTitleEl.textContent = ""Chart preview""; "_
    "destroyChart(); "_
    "return; "_
    "} "_
    "const chartType = chartTypeEl.value; "_
    "const categoryKey = xKeyEl.value; "_
    "const valueKey = yKeyEl.value; "_
    "const groupKey = groupKeyEl.value; "_
    "if (!categoryKey || !valueKey) { "_
    "setStatus(""Select both a category key and a numeric value key."", true); "_
    "destroyChart(); "_
    "return; "_
    "} "_
    "const configData = aggregateData( "_
    "rawData, "_
    "categoryKey, "_
    "valueKey, "_
    "chartType === ""doughnut"" ? """" : groupKey "_
    "); "_
    "destroyChart(); "_
    "const ctx = document.getElementById(""chartCanvas""); "_
    "chartInstance = new Chart(ctx, { "_
    "type: chartType, "_
    "data: configData, "_
    "options: { "_
    "responsive: true, "_
    "maintainAspectRatio: false, "_
    "plugins: { "_
    "legend: { "_
    "display: true, "_
    "position: ""top"" "_
    "}, "_
    "title: { "_
    "display: true, "_
    "text: `${chartType === ""doughnut"" ? ""Donut"" : ""Bar""} chart: ${valueKey} by ${categoryKey}` "_
    "} "_
    "}, "_
    "scales: chartType === ""bar"" "_
    "? { "_
    "y: { "_
    "beginAtZero: true, "_
    "title: { "_
    "display: true, "_
    "text: valueKey "_
    "} "_
    "}, "_
    "x: { "_
    "title: { "_
    "display: true, "_
    "text: categoryKey "_
    "} "_
    "} "_
    "} "_
    ": {} "_
    "} "_
    "}); "_
    "chartTitleEl.textContent = `${chartType === ""doughnut"" ? ""Donut"" : ""Bar""} chart using “${categoryKey}” and “${valueKey}”`; "_
    "setStatus(""Chart rendered successfully.""); "_
    "} "_
    "async function loadData() { "_
    "setStatus(""Loading data...""); "_
    "try { "_
    "const response = await fetch(DATA_ENDPOINT, { "_
    "method: ""POST"", "_
    "headers: { "_
    """Content-Type"": ""application/json"" "_
    "}, "_
    "body: JSON.stringify(REQUEST_PAYLOAD) "_
    "}); "_
    "if (!response.ok) { "_
    "throw new Error(`Request failed with status ${response.status}`); "_
    "} "_
    "let data = await response.json(); data = data.result; console.log(data); "_
    "if (!Array.isArray(data)) { "_
    "throw new Error(""Endpoint must return a JSON array of objects.""); "_
    "} "_
    "rawData = data; "_
    "initControls(); "_
    "groupKeyEl.disabled = chartTypeEl.value === ""doughnut""; "_
    "if (!rawData.length) { "_
    "setStatus(""The endpoint returned an empty array."", true); "_
    "chartTitleEl.textContent = ""No data available""; "_
    "destroyChart(); "_
    "return; "_
    "} "_
    "if (!numericKeys.length) { "_
    "setStatus(""Loaded data does not include any numeric keys to chart."", true); "_
    "chartTitleEl.textContent = ""No numeric fields found""; "_
    "destroyChart(); "_
    "return; "_
    "} "_
    "buildChart(); "_
    "} catch (error) { "_
    "rawData = []; "_
    "updatePreview(); "_
    "destroyChart(); "_
    "chartTitleEl.textContent = ""Unable to load chart data""; "_
    "dataPreviewEl.textContent = error.message; "_
    "recordCountEl.textContent = ""0 records""; "_
    "setStatus(error.message, true); "_
    "console.error(error); "_
    "} "_
    "} "_
    "function runSelfTests() { "_
    "const sample = [ "_
    "{ region: ""North"", product: ""Alpha"", sales: 10, units: 2 }, "_
    "{ region: ""North"", product: ""Beta"", sales: 15, units: 3 }, "_
    "{ region: ""South"", product: ""Alpha"", sales: 7, units: 1 } "_
    "]; "_
    "const ungrouped = aggregateData(sample, ""region"", ""sales"", """"); "_
    "console.assert(JSON.stringify(ungrouped.labels) === JSON.stringify([""North"", ""South""]), ""Ungrouped labels should match distinct categories.""); "_
    "console.assert(JSON.stringify(ungrouped.datasets[0].data) === JSON.stringify([25, 7]), ""Ungrouped totals should sum sales by region.""); "_
    "const grouped = aggregateData(sample, ""region"", ""sales"", ""product""); "_
    "console.assert(grouped.datasets.length === 2, ""Grouped chart should create one dataset per group.""); "_
    "console.assert(JSON.stringify(grouped.datasets[0].data) === JSON.stringify([10, 7]), ""Alpha group should sum correctly across categories.""); "_
    "const missingKeys = aggregateData(sample, """", ""sales"", """"); "_
    "console.assert(missingKeys.labels.length === 0 && missingKeys.datasets.length === 0, ""Missing keys should return empty chart data.""); "_
    "} "_
    "chartTypeEl.addEventListener(""change"", () => { "_
    "const isDonut = chartTypeEl.value === ""doughnut""; "_
    "groupKeyEl.disabled = isDonut; "_
    "buildChart(); "_
    "}); "_
    "renderBtn.addEventListener(""click"", buildChart); "_
    "xKeyEl.addEventListener(""change"", buildChart); "_
    "yKeyEl.addEventListener(""change"", buildChart); "_
    "groupKeyEl.addEventListener(""change"", buildChart); "_
    "runSelfTests(); "_
    "groupKeyEl.disabled = false; "_
    "loadData(); "_
    "</script> "_
    "</body> "_
    "</html>"
    
    )
    Return res
}

}
