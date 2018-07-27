function view(x, varargin)
%VIEW View a data structure in a desktop GUI view window
%
% jl.view(x)
%
% Views the data structure X in a new window (possibly a figure window, possibly
% not). The type of display is dependent on the type of input.
%
% This function is intended for interactive use.

if isa(x, 'tabular')
    view_tabular(x, varargin{:});
else
    error('jl:InvalidInput', 'Unsupported input type: %s', class(x));
end

end

function view_tabular(t, varargin)
%VIEW_TABULAR View a @tabular object

if ~isempty(varargin)
    error('jl:IllegalArgument', 'Arguments are not accepted for tabular inputs');
end

nCols = size(t, 2);
colNames = t.Properties.VariableNames;
jCols = javaArray('net.janklab.util.dumbtable.DumbTableColumn', [nCols]);
for iCol = 1:nCols
    x = t{:,iCol};
    if isa(x, 'double') || isa(x, 'single')
        x = double(x);
        jCol = net.janklab.util.dumbtable.DoubleDumbTableColumn(x);
    elseif isinteger(x)
        if isa(x, 'uint64')
            tfBad = x > intmax('int64');
            if any(tfBad)
                %TODO: Widen to Java BigIntegers
                error('uint64 values outside supported range');
            end
        end
        x = int64(x);
        jCol = net.janklab.util.dumbtable.LongDumbTableColumn(x);
    else
        strs = dispstrs(x);
        stringKlass = java.lang.Class.forName('java.lang.String');
        jCol = net.janklab.util.dumbtable.ObjectDumbTableColumn(stringKlass, strs);
    end
    jCols(iCol) = jCol;
end

jDumbTable = net.janklab.util.dumbtable.DumbTable(colNames, jCols);
jStyledTable = net.janklab.colstyledtable.ColumnarStyledTable;
jStyledTable.setModel(jDumbTable);

display_in_jframe(jStyledTable);

end

function display_in_jframe(component)
import javax.swing.JFrame;

frame = JFrame;
frame.getContentPane.add(component, java.awt.BorderLayout.CENTER);
frame.pack;
frame.setVisible(true);

end