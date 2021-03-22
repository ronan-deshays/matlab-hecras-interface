function param_delete ( filename, param_line_nb)
% delete an entire line in a text file
%
% Syntax : param_delete ( filename, param_line_nb)
%
% Param : filename, string, name of a text file
%
% Param : param_line_nb, integer, line number of the line 
% to delete, e.g. which contains a param, that you want to 
% delete
%
% See also
% related : update_param, update_param_first ; 
% RAS writing : prompt_reset_plan, update_table
%
% Written by Ronan Deshays for IMTLD, July 2020


%% INIT



    file=fopen(filename,'r');
    frewind(file) % go back to beginning of file

    [filepath,name,ext]=fileparts(filename);
    filetempname=[filepath,'\',name,'.temp',ext];
    filetemp=fopen(filetempname,'w');
    % erase filetemp before writing
    % so no need to delete it after save
    current_line_nb=0;



%% WRITING



    while ~feof(file)

        current_line=fgets(file);
        current_line_nb=current_line_nb+1;

        if current_line_nb==param_line_nb

            current_line='';

        end

        fprintf(filetemp,'%s',current_line);

    end



%% END



    fclose(file);
    fclose(filetemp);

    copyfile(filetempname,filename)

end