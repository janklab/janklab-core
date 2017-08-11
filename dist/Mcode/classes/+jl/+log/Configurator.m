classdef Configurator
    % A configurator for log4j
    %
    % This class configures the logging setup for Janklab/Matlab logging. It
    % configures the log4j library that Janklab logging sits on top of. (We use log4j
    % because it ships with Matlab.)
    %
    % This class is provided as a convenience. You can also configure Janklab logging
    % by directly configuring log4j using its normal Java interface.
    %
    % Janklab does not automatically configure log4j. You must either call a
    % configureXxx method on this class or configure log4j directly yourself to get
    % logging to work.
    
    methods (Static)
        function configureBasicConsoleLogging
        % Configures log4j to do basic logging to the console
        %
        % This sets up a basic log4j configuration, with log output going to the
        % console, and the root logger set to the INFO level.
        %
        % Don't call this or other configureXxx methods more than once per session;
        % that could cause wonky logging output. This method is not idempotent.
        org.apache.log4j.BasicConfigurator.configure();
        rootLogger = org.apache.log4j.Logger.getRootLogger();
        rootLogger.setLevel(org.apache.log4j.Level.INFO);
        rootAppender = rootLogger.getAllAppenders().nextElement();
        % Use \n instead of %n because the Matlab console wants Unix-style line
        % endings, even on Windows.
        pattern = ['%d{HH:mm:ss.SSS} %-5p %c %x - %m' sprintf('\n')];
        myLayout = org.apache.log4j.PatternLayout(pattern);
        rootAppender.setLayout(myLayout);
        end
        
        function out = getLog4jLevel(levelName)
        % Gets the log4j Level enum for a named level
        validLevels = {'OFF' 'FATAL' 'ERROR' 'WARN' 'INFO' 'DEBUG' 'TRACE' 'ALL'};
        levelName = upper(levelName);
        if ~ismember(levelName, validLevels)
            error('Invalid levelName: ''%s''', levelName);
        end
        out = eval(['org.apache.log4j.Level.' levelName]);
        end
        
        function setLevels(levels)
        % Set the logging levels for multiple loggers
        %
        % jl.log.Configurator.setLevels(levels)
        %
        % This is a convenience method for setting the logging levels for multiple
        % loggers.
        %
        % The levels input is an n-by-2 cellstr with logger names in column 1 and
        % level names in column 2.
        for i = 1:size(levels, 1)
            [logName,levelName] = levels{i,:};
            logger = org.apache.log4j.LogManager.getLogger(logName);
            level = jl.log.Configurator.getLog4jLevel(levelName);
            logger.setLevel(level);
        end
        end
        
        function prettyPrintLogConfiguration(verbose)
        % Displays the current log configuration to the console
        
        if nargin < 1 || isempty(verbose);  verbose = false;  end
        
            function out = getLevelName(lgr)        
                level = lgr.getLevel();
                if isempty(level)
                    out = '';
                else
                    out = char(level.toString());
                end
            end
        
        % Get all names first so we can display in sorted order
        loggers = org.apache.log4j.LogManager.getCurrentLoggers();
        loggerNames = {};
        while loggers.hasMoreElements()
            logger = loggers.nextElement();
            loggerNames{end+1} = char(logger.getName()); %#ok<AGROW>
        end
        loggerNames = sort(loggerNames);
        
        % Display the hierarchy
        rootLogger = org.apache.log4j.LogManager.getRootLogger();
        fprintf('Root (%s): %s\n', char(rootLogger.getName()), getLevelName(rootLogger));
        for i = 1:numel(loggerNames)
            logger = org.apache.log4j.LogManager.getLogger(loggerNames{i});
            appenders = logger.getAllAppenders();
            appenderStrs = {};
            while appenders.hasMoreElements
                appender = appenders.nextElement();
                if isa(appender, 'org.apache.log4j.varia.NullAppender')
                    appenderStr = 'NullAppender';
                else
                    appenderStr = sprintf('%s (%s)', char(appender.toString()), ...
                        char(appender.getName()));
                end
                appenderStrs{end+1} = ['appender: ' appenderStr]; %#ok<AGROW>
            end
            appenderList = strjoin(appenderStrs, ' ');
            if ~verbose
                if isempty(logger.getLevel()) && isempty(appenderList) ...
                        && logger.getAdditivity()
                    continue
                end
            end
            items = {};
            if ~isempty(getLevelName(logger))
                items{end+1} = getLevelName(logger); %#ok<AGROW>
            end
            if ~isempty(appenderStr)
                items{end+1} = appenderList; %#ok<AGROW>
            end
            if ~logger.getAdditivity()
                items{end+1} = sprintf('additivity=%d', logger.getAdditivity()); %#ok<AGROW>
            end
            str = strjoin(items, ' ');
            fprintf('%s: %s\n',...
                loggerNames{i}, str);
        end
        end
    end
    
end