# Janklab Office IO User Guide

Janklab provides an API for reading and writing Office files, especially Excel.
This allows you to work with Excel

## Why this is good

Matlab has support for Excel reading and writing, using `xlswrite`, `writetable`, and similar functions. But it only supports reading and writing of basic arrays and tables, and requires Microsoft Excel to be installed on your machine.

Janklab’s Office IO API doesn’t use the Office applications. Instead, it’s built on the Apache POI Java library, and reads & writes the files directly. This is good because:

* Works on Linux
* Is suitable for [server-side automation](https://support.microsoft.com/en-us/help/257757/considerations-for-server-side-automation-of-office), unlike Office-based implementations like Matlab’s
* Supports advanced Excel features, like cell formatting, merged cells, freeze panes & split panes, data validation, hyperlinks, charting (coming soon), and so on
* Doesn’t require Office to be installed
* Doesn’t require an Office license
* Will work when multiple Matlab processes are running in the same desktop session
* Won’t interfere with running interactive Excel instances on your desktop
* Is potentially faster, once I write some accelerated code ;)

## Quick start

```matlab
wkbk = jl.office.excel.createNew();
sheet = wkbk.createSheet("Hello");
sheet.cells{1,1} = "Hello, world!";
sheet.cells{2,1} = 42;
wkbk.save("Hello World.xlsx");
```

## Limitations

Actually, Excel is the only format currently implemented.
I’ll add Word or other applications if there’s actual user interest in them.

### Not implemented yet

* Excel
  * Charting
  * OLE embedding
