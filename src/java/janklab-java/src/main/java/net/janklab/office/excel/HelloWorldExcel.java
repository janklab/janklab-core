package net.janklab.office.excel;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class HelloWorldExcel {

    public static void createHelloWorldExcelFile() throws IOException {
        Workbook wkbk = new XSSFWorkbook();
        Sheet sheet = wkbk.createSheet("Hello");
        Row row = sheet.createRow(0);
        Cell cell = row.createCell(0);
        cell.setCellValue("Hello, World!");
        OutputStream out = new FileOutputStream("Hello.xlsx");
        wkbk.write(out);
        out.close();
    }

    public static void main(String[] argv) {
        try {
            createHelloWorldExcelFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
