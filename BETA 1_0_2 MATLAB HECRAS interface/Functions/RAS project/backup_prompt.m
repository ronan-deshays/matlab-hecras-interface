function backup_prompt(files,backup_name,iteration_nb)
% ask user to backup Ras project in a newly created folder
%
% Syntax : backup_prompt(files,backup_name,iteration_nb)
%
% Param : files, a Files_ obj
%
% Param : backup_name, string, name part of the new folder
%
% Param : iteration_nb, integer, obvious
%
% Param : db_enabled, backup porposed only if debug mode 
% enabled
%
% Return : a directory tree of Ras project backups
%
% Note : call it multiple times during a simulation, just 
% ensure that backup_name or iteration_nb differ between each 
% call, to avoid erase of a previously created folder
%
% Warning : if you save different backup_name, 
% if one already exist and not the other, 
% the last will be saved in a older folder
% always check the 'Backup done there : ' message
%
% Written by Ronan Deshays for IMTLD, July 2020

    global db_enabled

    if db_enabled==1

        [project_folder,~,~]=fileparts(files.project);
        % ~ are ignored outputs

        m=1; % init to check if a backup folder already exists
        
        if prompt('Do you want to Backup ?','Y')

        %% avoid overwriting on existing Backup

            backup_parent=[project_folder,'_Backup_',num2str(m)];
            backup_folder=[backup_parent,'\',...
            backup_name,num2str(iteration_nb)];
            
            while exist(backup_folder,'dir')
                m=m+1;
                backup_parent=[project_folder,'_Backup_',num2str(m)];
                backup_folder=[backup_parent,'\',...
                backup_name,num2str(iteration_nb)];

            end

        %% writing

            mkdir(backup_folder)
            copyfile(project_folder,backup_folder)
            
            disp('Backup done there : ')
            disp(backup_folder)
            disp(newline)

        end

    end
    
end

