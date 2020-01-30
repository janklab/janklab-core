function createHelloWorldXls
% This one does it directly with POI objects
wkbk = org.apache.poi.xssf.usermodel.XSSFWorkbook;
sheet = wkbk.createSheet("Hello");
row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("Hello, World!");
ostr = java.io.FileOutputStream("HelloFromMatlab.xlsx");
wkbk.write(ostr);
ostr.close;
