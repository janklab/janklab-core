function out = magicMapMatrix
%MAGICMAPMATRIX A mapmatrix containing a magic square

out = mapmatrix(magic(3), { {'foo','bar','baz'}, [7 8 9] },...
	{'words','numbers'});

end