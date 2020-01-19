function HelloWorld

tmpDir = tempname;
mkdir(tmpDir);
tmpFile = fullfile(tmpDir, 'HelloWorld.xlsx');

wkbk = jl.office.excel.Workbook;
sheet = wkbk.createSheet('Hello World');

wkbk.write(tmpFile);
fprintf('Wrote Hello World Excel workbook to: %s\n', tmpFile);


end