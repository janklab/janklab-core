function out = datenumToModaFixedDate(dnum)
out = int32(dnum - moda.Date.matlabToModaEpochOffset);
end
