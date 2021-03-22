function [current_line_nb, found] = find_str_after (...
    filename, line_nb, str)
% find first line which begin with string after given line number
%
% Syntax : [current_line_nb, found] = find_str_after (...
%   filename, line_nb, str)
%
% Param : filename, string, name of a text file
%
% Param : line_nb, integer, the line number after which 
% begin the search of str
%
% Param : str, string, the sentence to search
%
% Return : current_line_nb, integer, line number where the 
% string was found
%
% Return : found, boolean, obvious
%
% See also 
% same level : find_closest, find_str_every ; 
% RAS reading : find_param_sub, find_param_ref
%
% Written by Ronan Deshays for IMTLD, July 2020



%% INIT



    file=fopen(filename,'r');

    frewind(file) % go back to beginning of file
    current_line_nb=0;
    found=false;



%% RESEARCH



    while ~feof(file)

        current_line=fgets(file);
        current_line_nb=current_line_nb+1;

        if begin_with (current_line,str)...
            && current_line_nb > line_nb

            found=true;

            break

        end

    end



%% END



    fclose(file);

end