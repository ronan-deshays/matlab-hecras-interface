function [line_nb_array, found] = find_str_every (...
    filename, str)
% find line number of every line which begin with str
%
% Param : filename, string, name of a text file
%
% Param : str, string, sentence to search
%
% Syntax : [line_nb_array, found] = find_str_every (...
%
% filename, str)
%
% Return : line_nb_array, integer array, list of every 
% line numbers which begin with str
%
% Return : found, boolean, obvious
%
% See also 
% same level : find_closest, find_str_after ; 
% RAS reading : find_param_sub, find_param_ref
%
% Written by Ronan Deshays for IMTLD, July 2020



%% INIT



    file=fopen(filename,'r');

    frewind(file) % go back to beginning of file
    current_line_nb=0;
    line_nb_array=zeros(1,1); % supress prealloc warning
    k=0;
    found=false;



%% RESEARCH



    while ~feof(file)

        current_line=fgets(file);
        current_line_nb=current_line_nb+1;

        if begin_with (current_line,str)

            k=k+1;
            line_nb_array(k)=current_line_nb;
            found=true;

        end

    end



%% END



    fclose(file);

end