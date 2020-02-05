package net.janklab.office.excel;

import net.janklab.time.TimeUtil;
import net.janklab.util.CategoricalArrayList;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;

import java.util.Calendar;
import java.util.Date;

// TODO: Write range from categoricals

public class SheetIOHelper {

    Sheet sheet;

    public SheetIOHelper(Sheet sheet) {
        this.sheet = sheet;
    }

    private void checkRangeSizeAgainstInputData(CellRangeAddress rangeAddr, int dataLength) {
        if (rangeAddr.getNumberOfCells() != dataLength) {
            throw new IllegalArgumentException("Size mismatch: range is " + rangeAddr.getNumberOfCells()
                    + " cells, but data is " + dataLength + " elements.");
        }
    }

    public void writeRangeFormulas(CellRangeAddress rangeAddr, String[] data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.length);
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                cell.setCellFormula(data[i]);
                ++i;
            }
        }
    }

    public void writeRange(CellRangeAddress rangeAddr, String[] data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.length);
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                cell.setCellValue(data[i]);
                ++i;
            }
        }
    }

    public void writeRange(CellRangeAddress rangeAddr, double[] data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.length);
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                cell.setCellValue(data[i]);
                ++i;
            }
        }
    }

    public void writeRange(CellRangeAddress rangeAddr, boolean[] data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.length);
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                cell.setCellValue(data[i]);
                ++i;
            }
        }
    }

    public void writeRange(CellRangeAddress rangeAddr, CategoricalArrayList data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.size());
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                cell.setCellValue(data.get(i));
                ++i;
            }
        }
    }

    // TODO: writeRangeDatenum()

    /**
     * Takes an array in ROW-MAJOR order and writes it into a range.
     * @param rangeAddr Range address to write to
     * @param data Data for range in ROW MAJOR order
     */
    public void writeRange(CellRangeAddress rangeAddr, Object[] data) {
        checkRangeSizeAgainstInputData(rangeAddr, data.length);
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                Object val = data[i];
                if (val != null) {
                    if (val instanceof String) {
                        cell.setCellValue((String) val);
                    } else if (val instanceof Date) {
                        cell.setCellValue((Date) val);
                    } else if (val instanceof Calendar) {
                        cell.setCellValue((Calendar) val);
                    } else if (val instanceof Double) {
                        cell.setCellValue((Double) val);
                    } else if (val instanceof RichTextString) {
                        cell.setCellValue((RichTextString) val);
                    } else {
                        cell.setCellValue(val.toString());
                    }
                }
                ++i;
            }
        }
    }

    public double[] readRangeNumeric(CellRangeAddress rangeAddr) {
        double[] out = new double[rangeAddr.getNumberOfCells()];
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                out[i++] = cell.getNumericCellValue();
            }
        }
        return out;
    }

    public String[] readRangeString(CellRangeAddress rangeAddr) {
        String[] out = new String[rangeAddr.getNumberOfCells()];
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                out[i++] = cell.getStringCellValue();
            }
        }
        return out;
    }

    public Date[] readRangeDate(CellRangeAddress rangeAddr) {
        Date[] out = new Date[rangeAddr.getNumberOfCells()];
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                out[i++] = cell.getDateCellValue();
            }
        }
        return out;
    }

    public double[] readRangeDatenum(CellRangeAddress rangeAddr) {
        double[] out = new double[rangeAddr.getNumberOfCells()];
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                out[i++] = TimeUtil.javaDateToDatenum(cell.getDateCellValue());
            }
        }
        return out;
    }

    public CategoricalArrayList readRangeCategoricalish(CellRangeAddress rangeAddr) {
        CategoricalArrayList out = new CategoricalArrayList();
        int i = 0;
        for (int ixRow = rangeAddr.getFirstRow(); ixRow <= rangeAddr.getLastRow(); ixRow++) {
            Row row = sheet.getRow(ixRow);
            if (row == null) {
                throw new RuntimeException("Row index out of range: " + ixRow);
            }
            for (int ixCol = rangeAddr.getFirstColumn(); ixCol <= rangeAddr.getLastColumn(); ixCol++) {
                Cell cell = row.getCell(ixCol);
                if (cell == null) {
                    throw new RuntimeException("Column index out of range: " + ixCol);
                }
                out.add(cell.getStringCellValue());
            }
        }
        return out;
    }


}
