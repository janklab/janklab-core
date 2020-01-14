function benchmarkConnectionChurn(connInfo, nRuns)
% Benchmark connection churn performance on a database

if nargin < 2; nRuns = []; end
if isempty(nRuns); nRuns = 500; end

% Bench the connections
% MDBC version
mdbc_times = benchmarkRun(nRuns, @connectDb, connInfo);
% Database Toolbox version
dbtb_times = benchmarkRun(nRuns, @connectWithDbToolboxJdbcUrl, connInfo);

% Plot results

fig = figure; %#ok<NASGU>
subplot(2, 1, 1);
ax(1) = plotResults(mdbc_times, 'Janklab/MDBC', connInfo.vendor);
subplot(2, 1, 2);
ax(2) = plotResults(dbtb_times, 'Database Toolbox', connInfo.vendor);
linkaxes(ax);

end

function out = benchmarkRun(nRuns, connectFcn, connInfo)
times = NaN(1,nRuns);
for i = 1:nRuns
    t0 = tic;
    db = feval(connectFcn, connInfo);
    db.close();
    te = toc(t0);
    times(i) = te;
end
out = times;
end

function out = plotResults(times, myTitle, vendor)
millis = round(times * 1000);
out = gca;
histogram(millis);
title([myTitle ' Connection Times to ' vendor]);
ylabel('Occurrences');
xlabel('Connect/Close Time in milliseconds');
end

function out = connectDb(connInfo)
out = jl.sql.Mdbc.connectFromJdbcUrl(connInfo.url, connInfo.user, ...
    connInfo.password);
end

function out = connectWithDbToolbox(connInfo)
out = database(connInfo.instance, connInfo.user, connInfo.password, ...
    'Vendor',connInfo.vendor, 'Server',connInfo.server);
end

function out = connectWithDbToolboxJdbcUrl(connInfo)
out = database(connInfo.instance, connInfo.user, connInfo.password, ...
	connInfo.driver, connInfo.jdbcUrl);
end
