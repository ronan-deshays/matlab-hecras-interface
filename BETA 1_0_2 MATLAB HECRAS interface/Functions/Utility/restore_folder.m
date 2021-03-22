function restore_folder (source_folder, target_folder)
% delete target_folder and copy source_folder to target_folder
%
% Syntax : restore_folder (source_folder, target_folder)
%
% Param : source_folder, string, absolute or relative path 
% to the source folder
%
% Param : target_folder, string, absolute or relative path 
% to the target folder
%
% Written by Ronan Deshays for IMTLD, July 2020

    if exist(target_folder,'dir')
        
        % empty the folder
        delete([target_folder,'\*'])

    else 

        % create a new empty folder
        mkdir(target_folder)
        disp('MKDIR done')

    end

    copyfile(source_folder, target_folder)

end