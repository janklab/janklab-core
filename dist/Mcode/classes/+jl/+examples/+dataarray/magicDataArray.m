function out = magicDataArray
%MAGICDATAARRAY A mapmatrix containing a magic square

out = dataarray(magic(3), { {'foo','bar','baz'}, [7 8 9] },...
	{'words','numbers'});

end