function new_poi_wrapper(javaClass, matlabClass)

if nargin < 2 || isempty(matlabClass)
  matlabClass = regexprep(javaClass, '.*\.', '');
  matlabClass = regexprep(matlabClass, '(H|X)SSF', '');
end


boilerplate = sprintf(strjoin({
  'classdef %s < handle'
  '%% %s'
  ''
  '  properties'
  '    %% The underlying POI %s Java object'
  '    j'
  '  end'
  ''
  '  methods'
  ''
  '    function this = %s(jObj)'
  '      if nargin == 0'
  '        return'
  '      end'
  '      mustBeA(jObj, ''%s'');'
  '      this.j = jObj;'
  '    end'
  ''
  '  end'
  ''
  'end'
  ''
  }, '\n'), ...
  matlabClass, matlabClass, javaClass, matlabClass, javaClass);

matlab.desktop.editor.newDocument(boilerplate);
