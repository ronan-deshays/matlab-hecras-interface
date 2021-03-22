function update_param_first (filename, target_param, edited_param)
% replace line containing target_param with given edited_param string
%
% this is a shortcut calling find_str_after(line 0) and
% update param
%
% Syntax : update_param_first (filename, target_param, 
%    edited_param)
%
% Param : filename, string, name of text file
%
% Param : target_param, string, beginning of the line, that you
% want to replace with edited_param string
%
% Param : edited_param, string
%
% Note : if you want to give multiple lines, just make 
% sure they are all in one string object
%
% See also
% related : update_param ; 
% RAS writing :  update_table, param_delete
% prompt_reset_plan
%
% Written by Ronan Deshays for IMTLD, July 2020

    [line_nb, found]=find_str_after(filename, 0, target_param);

    if found

        update_param (filename, line_nb, edited_param)

    else
        
        error('%s %s',target_param,'not found')

    end

end