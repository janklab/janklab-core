function out = connectViaDbtb(url, user, password)
% Connect using the database toolbox
%
% This is currently unimplemented.

flavor = regexprep(url, ':.*', '');
switch flavor
    case 'mysql'
    case 'postgresql'
    case 'sqlserver'
    otherwise
        error('Unsupported flavor: %s', flavor);
end

jdbcUrl = ['jdbc:' url];

end