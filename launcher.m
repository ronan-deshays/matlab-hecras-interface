% Launcher is a script which helps you choosing which 
% MATLAB HECRAS interface version you want to launch
% and sends to master scripts your customs scripts
%
% LAUNCHER VERSION : 0.3 manage BETA 1_0_2 and higher
%
% last update : August 2020
%
% see Install and Update documentation for further informations
%
% see Dev Doc > launcher script to learn more about launcher



%% CLEANUP



clc

clear global;
close all;
restoredefaultpath % remove already functions to searchpath
% to avoid versions conflicts



%% INIT



addpath('./Installation');

disp('MATLAB HECRAS interface, welcome.')
disp(newline)
disp('Locally installed versions table :')
disp(newline)
disp({'ID','type ','n°','name  ','path'})
list_of_versions=get_versions_list();
disp(list_of_versions)

disp('Quick tip : Y/N [Y] means write Y to say Yes, N to say No,')
disp('[Y] means Y is default value, choosed if you just press ENTER')
disp(newline)
disp('Please choose a version_type in the list above ;')
disp('default = latest installed BETA or RELEASE')

choice1=input('Write the version type there : ');

if ~isstring(choice1)

    % then choose default value
    choice1='BETA';

end

disp('Please choose a version_ID in the list above ; default = last version')
disp(newline)

choice2=input('Write the version ID there : ');

if ~isstring(choice2)

    % then choose default value
    launch_latest (list_of_versions)

else

    launch_version(list_of_versions,str2double(choice2))

end

function launch_latest (list_of_versions)

    last_version_number=0;
    last_version_ID=0;
    size(list_of_versions,1)

    for k=1:size(list_of_versions,1)

        version_number = str2double(replace(...
                list_of_versions{k,3},'_',''));

        % NOTE : BETA and RELEASE versions
        % share the same numbers, so the latest
        % between both is BETA or RELEASE
        % depends on which version installed
        % the last ALPHA version works fine
        % but was not tested a lot

        if version_number > last_version_number
    
            last_version_number=version_number;
            last_version_ID=list_of_versions{k,1};

        end

    end

    if last_version_ID ~= 0

        launch_version(list_of_versions, last_version_ID)

    end

end

function launch_version (list_of_versions,version_ID)

    clc

    disp(['Launching version ',list_of_versions{version_ID,2},...
        ' ',list_of_versions{version_ID,3},newline])

    pause(2)

    clc


    if strcmp(list_of_versions{version_ID,2},'ALPHA')

    % then synchronise global settings with local settings

        scripts={'settings.txt', 'input_before_step.m',...
            'input_init.m', 'output_after_all.m', ...
            'output_after_step.m', 'input_data.xlsx'};

        for k=1:size(scripts,2)

            copyfile([pwd,'\',scripts{k}],...
                [list_of_versions{version_ID,5},...
                '\User Edited Files\', scripts{k}])

        end

    end

    if strcmp(list_of_versions{version_ID,2},'ALPHA')

        % then master is a script

        % change MATLAB current directory to launcher directory
        cd(list_of_versions{version_ID,5})

        master

    else

        % then master is a function

        old_path=[list_of_versions{version_ID,5},'\MATLAB code'];

        if exist(old_path,'dir')

            % then code is in MATLAB code folder

            % add code from subfolders to matlab path
            addpath(list_of_versions{version_ID,5})
            addpath(genpath(old_path))

            master()

        else

            % then, MATLAB code folder doesn't exist
            % so it's a new version of the interface
            % with user files outside of the version folder

            % add code from subfolders to matlab path
            addpath(list_of_versions{version_ID,5})
            addpath(genpath(list_of_versions{version_ID,5}))

            master()

        end

    end
    
    say('master version ',...
        list_of_versions{version_ID,2},...
        ' ',list_of_versions{version_ID,3},' done')

end