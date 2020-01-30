function createHelloWorldXls2

wkbk = jl.office.excel.xlsx.Workbook.createNew;
sheet = wkbk.createSheet;
row = sheet.createRow(1);
cell = row.createCell(1);

cell.value = "Hello, world!";
style = cell.cellStyle;

keyboard