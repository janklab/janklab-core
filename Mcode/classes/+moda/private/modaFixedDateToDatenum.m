function out = modaFixedDateToDatenum(fixedDate)
out = fixedDate + moda.Date.matlabToModaEpochOffset;
end