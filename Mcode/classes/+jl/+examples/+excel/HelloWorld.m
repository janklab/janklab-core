function HelloWorld

tmpDir = tempname;
mkdir(tmpDir);
tmpFile = fullfile(tmpDir, 'HelloWorld.xlsx');

wkbk = jl.office.excel.Workbook;
sheet = wkbk.createSheet('Hello');
sheet.cells{1, 1} = 'Hello, World!';

wkbk.write(tmpFile);
fprintf('Wrote Hello World Excel workbook to: %s\n', tmpFile);

end