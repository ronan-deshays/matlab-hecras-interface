function restore_prompt(files,sett)
% ask user to replace content of current Ras folder with 
% another Ras project
%
% Param : files, a Files_ obj
%
% Param : sett, a Settings_ obj
%
% Written by Ronan Deshays for IMTLD, July 2020

    global db_enabled

    if db_enabled==1

        [project_folder,~,~]=fileparts(files.project);
        source_folder=sett.GetValue('SourcePath');

        warning('%s %s','restore will erase files currently in ',...
            project_folder)
    
        if prompt('Do you want to restore ?','N')

            restore_folder (source_folder, project_folder)

        end

    end

end