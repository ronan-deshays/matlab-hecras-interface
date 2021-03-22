function rp = close_open_run_RAS (...
    RASversion, files, RAShide, sett)
% obvious
%
% Param : RASversion, integer, 3 digits long, e.g. 507 for 
% HEC-RAS 5.0.7
%
% Param : files, Files_ obj
%
% Param : RAShide, boolean, true = hide HEC-RAS computation
% window, not working yet, due to a Ras controller issue
%
% Param : sett, Settings_ obj
%
% Warning : NOT suitable for Ras parallel computing, 
% because it will shutdown EVERY Ras process
%
% Note : see Dev Doc to learn how to edit this function
%
% Written by : Ronan Deshays, July 2020



%% init



    global wait_duration
    RAS_error=sett.GetValue('RAS_error_management');
    RAS_error=(RAS_error(1)=='1');



%% close RAS



    !taskkill /im ras.exe

    

%% create new RAS process



    rp=actxserver(['RAS',num2str(RASversion),...
        '.HECRASCONTROLLER']);   
    rp.Project_Open(files.project)



%% manage RAS hide



    % if RAShide==1 % not working

    %     rp.Compute_HideComputationWindow

    % end



%% launch computation



    [~,~,messages_list,~]=rp.Compute_CurrentPlan(0,0);


%% manage RAS hide (bis)



% if RAShide==1 % not working too

%     rp.Compute_HideComputationWindow

% end



%% wait for HEC-RAS and eventually manage error
    
    while ~rp.Compute_Complete()

        pause(wait_duration)

        if RAS_error && ...
            detect_RAS_error(files) 

            warning('%s %s \n %s',...
                'It seems that an ERROR',...
                'occured in HEC-RAS.',...
                'Please check compute_msg below : ')

            type(files.compute_msg)

            say('messages_list contains : ')

            disp(messages_list)

            if prompt(['Do you want to stop ',...
                'simulation and get results ?'],'N')

                error('%s %s',...
                    'ERROR triggered as asked by user,',...
                    'stopping simulation')

            end

        end

    end

end