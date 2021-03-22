function copy_flow (sett, files)
% copy a hydrograph to every XS below in unsteady 
% flow HEC-RAS file
%
% Syntax : copy_flow (sett, files)
%
% Param : sett, Settings_ object
%
% Param : files, Files_ object
%
% Written by Ronan Deshays for IMTLD, August 2020



%% USER SETTINGS



    warning('%s \n%s',...
        'This function can overwrite and corrupt the target',...
        'unsteady flow file')

    say('How to use : enclose the pattern boundary condition between',...
        newline, 'HP_start_line and HP_after_last_line line numbers',...
        newline,'It will be copied under every XS written after it',...
        newline, 'in unsteady flow RAS file.')

    say('Be careful, XS order displayed in HEC-RAS GUI is different from',...
        newline, 'XS order in unsteady flow RAS file')

    start_line=str2double(sett.GetValue('HP_start_line'));
    after_last_line=str2double(sett.GetValue('HP_after_last_line'));

    u_name=sett.GetValue('HP_geo_name');

    if strcmp(u_name,'default')

        u_name=files.flow;

    end

    % Newly not instantiated RS are grouped at the end of the file.
    % so you can init together every XS with the same type of
    % boundary condition



%% INIT



    [filepath,name,ext]=fileparts(u_name);
    temp_u_name=[filepath,name,'.temp',ext];

    u_ID=fopen(u_name,'r');
    frewind(u_ID)

    temp_u_ID=fopen(temp_u_name ,'w');

    k=0; % line number
    m=0; % number of lines to copy
    str='';



%% READING AND WRITING



    while ~feof(u_ID)
                
        k=k+1;

        current_line=fgets(u_ID);
        fprintf(temp_u_ID,'%s',current_line);

        if k > start_line && k < after_last_line

            % then, save what lines contain

            m=m+1;

            str=[str,current_line];
            
        end

        if k > after_last_line - 1 && ...
            begin_with(current_line,'Boundary')

            % then "paste" lines copied previously

            fprintf(temp_u_ID,'%s',str);

        end
        
    end



%% END



    fclose('all');

    copyfile(temp_u_name, u_name)

    delete(temp_u_name)

end