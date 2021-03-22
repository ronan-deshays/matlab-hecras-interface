function ndbc ()

    % clear console only if not db mode enabled

    global db_enabled

    if db_enabled==0

        clc

    end

end