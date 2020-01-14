function out = connectViaDbtb(url, user, password)

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