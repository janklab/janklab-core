function dumbView(x)
%DUMBVIEW Show a simple viewer UI for the input data
%
% jl.ui.dumbView(x)
%
% Display a simple view of the given object in a new GUI window.
%
% This is just a placeholder for future functions. It is likey to be replaced
% and removed.

% Input conversions
if isa(x, 'table')
    x = relation(x);
end
if isnumeric(x)
    if ~ismatrix(x)
        error('jl:InvaldInput', 'Can''t display numerics with ndims > 2');
    end
    c = num2cell(x, 1);
    colNames = sprintfv('Col %d', 1:numel(c));
    x = relation(colNames, c);
end
tabNames = [];
if isscalar(x)
    if ~isempty(inputname(1))
        tabNames = {inputname(1)};
    end
end


% View logic
if isa(x, 'relation')
    dumbViewRelation(x, tabNames);
else
    error('I don''t know how to display a %s. Sorry', class(x));
end
end

function dumbViewRelation(r, tabNames)
tabbedPane = javax.swing.JTabbedPane();

if isempty(tabNames)
    tabNames = sprintfv('%d', 1:numel(r));
end
for i = 1:numel(r)
    view = dumbViewRelation1(r(i));
    tabbedPane.addTab(tabNames{i}, view);
end

% Show it in a new window
frame = javax.swing.JFrame;
frame.getContentPane().add(tabbedPane);

frame.pack();
frame.validate();

frame.setVisible(true);

end

function component = dumbViewRelation1(r)
%DUMBVIEWRELATION1 Implementation that uses addColumn()
mustBeScalar(r);

% Convert it to a DefaultTableModel
nRows = nrows(r);
colNames = colnames(r);
colData = coldata(r);

tm = javax.swing.table.DefaultTableModel;

for iCol = 1:ncols(r)
    colName = colNames{iCol};
    x = colData{iCol};
    if isa(x, 'double')
        if all(rem(x,1) == 0)
            x = int64(x);
        end
    end
    jColData = javaArray('java.lang.Object', numel(x));
    for iRow = 1:nRows
        if isa(x, 'double')
            jColData(iRow) = java.lang.Double(x(iRow));
        elseif iscellstr(x) || isstring(x)
            jColData(iRow) = java.lang.String(x{iRow});
        else
            str = dispstr(x(iRow));
            jColData(iRow) = java.lang.String(str);
        end
    end
    tm.addColumn(java.lang.String(colName), jColData);    
end

jTable = javax.swing.JTable(tm);
jTable.setAutoCreateRowSorter(true);
jTable.setGridColor(java.awt.Color.BLACK);
jTable.setRowHeight(round(jTable.getRowHeight * 1.2));
scrollPane = javax.swing.JScrollPane(jTable);

component = scrollPane;


end
