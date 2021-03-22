function master ()
% master script - MATLAB HECRAS interface
% see Dev Doc to learn how to edit this script
%
% VERSION : BETA 1.0.1
%
% Written by Ronan Deshays for IMTLD, July 2020



%% MATLAB INIT



%To kill hec-ras from the background
    !taskkill /im ras.exe

% get some settings
    sett=Settings_;
    sett=sett.init();

    project_path=sett.GetValue('ProjectPath');
    project_name=sett.GetValue('ProjectName');
    % can be get from actx so think about asking directly
    % project_file_path
    project_file_path=strcat(project_path,project_name);
    project_file_path=strcat(project_file_path,".prj");

    RASversion=sett.GetValue('RASversion');
    RAShide=sett.GetValue('RAShide'); % not available yet

    global db_enabled wait_duration
    db_enabled=str2double(sett.GetValue('debug'));
    wait_duration=str2double(sett.GetValue('Wait'));

% open run HEC RAS % parallel computing not available
    rp=actxserver(['RAS',num2str(RASversion),...
    '.HECRASCONTROLLER']);   
    rp.Project_Open(project_file_path);

% get Output RAS Variables
    sett=sett.initVar(rp);

    db(sett.RASVar)
    db(sett)
    db(sett.List)

% get dates
    Start=Date_;
    First=Date_;

    Start=Start.init(sett.GetValue('StartTime'));
    First=First.init(sett.GetValue('StartTime'));

    Last=Date_;
    Last=Last.init(sett.GetValue('EndTime'));

    time_step=sett.GetValue('TimeStep');

    End=Date_;
    End=End.init(sett.GetValue('StartTime'));
    End=increment(End,time_step);

% get RAS files
    files=Files_;
    files=files.init(rp,Start.HRfile);

    db(files)

% count number of iterations
    % WARNING : totally different from iteration_nb
    EndCopy=End;
    nb_of_iterations=get_nb_iterations(EndCopy,Last,time_step);
    
%get newline char for HEC-RAS
    global RASnewline
    planID=fopen(files.plan,'r');
    frewind(planID)
    RASnewline=fgets(planID);
    RASnewline=RASnewline(end-1:end);
    fclose(planID);

% RAS project utilities

    if sett.GetValue('HeavyProject')=='1' 
    % check if it is 1 or '1'

        % then, ask which utility to run

        say('Heavy HEC-RAS project utilities')

        disp('If you want to rerun utilities below, Stop master script with Ctrl + C and restart it.')

        if input('Launch add__mannings_everywhere ? Y/N [N] : ','s')=='Y'

            add_mannings_everywhere(rp,sett)

        end

        if input('Launch copy_flow ? Y/N [N] : ','s')=='Y'

            copy_flow (sett, files)

        end

        if input('Launch import_XS_from_u ? Y/N [N] : ','s')=='Y'

            import_XS_from_u (sett, files)

        end

        % ask user if he wants to restore project from the source
        % setting
        restore_prompt(files,sett)

        % backup after init
        disp("MATLAB side init done, nothing edited into RAS")
        backup_prompt(files,'AfterInit',0)

    end

% get location settings
    sett=sett.initXS(rp);

    db(sett.XSlist)



%% LOOP



    for iteration_nb=1:nb_of_iterations
    % while Last.Mat >= End.Mat % old code version but same result

        db(['Iteration n° ',num2str(round(iteration_nb)),' begin.'])

    % stopwatch starts estimating computation duration

        esti_start=tic;

        if iteration_nb==1 
            
            % then it is the init of RAS, without restart

            % launch your custom input scripts before RAS init
                input_init(files, sett.XSlist) 

            % don't use restart file for the first step
                update_param_first (files.flow, 'Use Restart',...
                    'Use Restart=0')

                [line_nb,found] = find_str_after(...
                    files.flow, 0, 'Restart Filename');

                if found

                    param_delete (files.flow, line_nb)

                end

            % set simulation date for a first step
                Temp2=First.increment(time_step);
                temp=['Simulation Date=',First.HRset,',',...
                Temp2.HRset];% one RASnewline is already
                % in update param function
                update_param_first (files.plan,'Simulation Date', temp)

            % write restart file at simulation end
                update_param_first (files.plan,...
                    'Write IC File at Sim End',...
                    'Write IC File at Sim End=-1')

            db('Init RAS side done')

        else
            
            if iteration_nb==2 % this is the first step with restart

            % toogle on Use Restart and add Restart Filename line
                temp=['Use Restart=-1',RASnewline,...
                    'Restart Filename='];
                update_param_first (files.flow, 'Use Restart', temp)

                db('First Restart')

            end

        % update Simulation Date
            temp=['Simulation Date=',Start.HRset,',',...
                End.HRset];
            update_param_first (files.plan,'Simulation Date', temp)

        % update Restart Filename
            temp=['Restart Filename=',files.restart];
            update_param_first (files.flow, 'Restart Filename', temp)

        end

    % launch your custom scripts before next computation step of RAS
        input_before_step (iteration_nb, sett.XSlist, files) 
        % use it to edit some data in RAS
        % e.g hydrographs

        disp('RAS parameters edited')
        backup_prompt(files,'BeforeRun',iteration_nb)

    % close open run RAS

        try

            rp = close_open_run_RAS(...
                RASversion, files, RAShide, sett);

        catch

        % then, useless to continue the loop
            warning('ERROR occured in Ras process')
            break

        end

        % WARNING : use open run close RAS instead of
        % close open run RAS in this script will causes some
        % issues

        db('after RAS run')
        backup_prompt(files,'AfterRun',iteration_nb)

        if iteration_nb == 1

        % save results of init
            results=cell(1,1);

            for k=1:size(sett.XSlist,1)
                % for each XS, create a cell in results array

                xs=sett.XSlist{k,1};
                results{k,1}=Results_;
                results{k,1}=results{k,1}.init(rp,xs,sett,...
                    nb_of_iterations);
                db(results{k,1}.Array)

            end

        else

        % save Results of this step
            for k=1:size(sett.XSlist,1)

                xs=sett.XSlist{k,1};
                results{k,1}=results{k,1}.update(rp,xs,sett);
                db(results{k,1}.Array)

            end

        end

    % launch your custom scripts after results update
        output_after_step (results, sett.XSlist, rp)

    % increment
        Start=Start.increment(time_step);
        End=End.increment(time_step);
        files=files.update(Start.HRfile);
        % iteration_nb=iteration_nb+1; % for iteration management

    % stop stopwatch and estimate duration of total simulation
        fprintf('Estimated time remaining %s = %s | ',...
        '(hh:mm:ss)',...
        duration(seconds(toc(esti_start)*(...
            nb_of_iterations-iteration_nb)),...
            'Format','hh:mm:ss'))

        fprintf('Loop %d on %d | Progress = %2.2f %% \n',...
            iteration_nb, nb_of_iterations,...
            (iteration_nb/nb_of_iterations)*100)

    end



%% END



    db('End of simulation')
    ndbc

% display Results for every XS
    for k=1:size(results,1)
        disp(results{k}.Array)
    end

% launch your results analysis code
    output_after_all (results) 

% restore Initial RRR Elev
    

% reset RAS plan
    if db_enabled
        
        prompt_reset_plan (files, First, Last)
        
    end

%To kill hec-ras from the background
    !taskkill /im ras.exe

end
    