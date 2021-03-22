function update_param ( filename, param_line_nb, edited_param)
% replace line containing param with given edited_param string
%
% Syntax : update_param ( filename, param_line_nb, 
% edited_param)
%
% Param : filename, string, name of text file
%
% Param : param_line_nb, integer, number of the line to 
% replace with edited_param
%
% Param : edited_param, string
%
% Note : if you want to give multiple lines, just make 
% sure they are all in one string object
%
% See also
% RAS writing :  update_table, param_delete,
% prompt_reset_plan, update_param_first
%
% Written by Ronan Deshays for IMTLD, July 2020



%% INIT



    global RASnewline % read only

    file=fopen(filename,'r');

    frewind(file) % go back to beginning of file

    [filepath,name,ext]=fileparts(filename);
    filetempname=[filepath,'\',name,'.temp',ext];
    % issue, loose the last folder
    filetemp=fopen(filetempname,'w');
    % erase filetemp before writing
    % so no need to delete it after save
    current_line_nb=0;



%% WRITING



    while ~feof(file)

        current_line=fgets(file);
        current_line_nb=current_line_nb+1;

        if current_line_nb==param_line_nb

            current_line=[edited_param, RASnewline];

        end

        fprintf(filetemp,'%s',current_line);

    end



%% END



    fclose(file);
    fclose(filetemp);

    copyfile(filetempname,filename)

end