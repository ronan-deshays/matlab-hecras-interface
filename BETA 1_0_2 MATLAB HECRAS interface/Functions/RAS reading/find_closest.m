function [closest_line_nb, gap, found] = find_closest (...
    filename, ref_line_nb, str)
% find closest line containing a string from a line in a text file
%
% Syntax : [closest_line_nb, gap, found] = find_closest (...
%    filename, ref_line_nb, str)
%
% Param : filename, string, name of the text file, where 
% the line will be searched
%
% Param : ref_line_nb, integer, the line number from which 
% the closest line containing str will be searched
%
% Param : str, string, the sentence to search
%
% Return : closest_line_nb, integer, closest line number 
% from ref_line_nb where the string was found
%
% Return : gap, integer, the distance (number of lines) 
% between closest_line_nb and ref_line_nb
%
% Return : found, boolean, true if str was found
%
% See also 
% same level : find_str_after, find_str_every ; 
% RAS reading : find_param_sub, find_param_ref
%
% Written by Ronan Deshays for IMTLD, July 2020



%% INIT



    file=fopen(filename,'r');
    frewind(file) % go back to beginning of file
    current_line_nb=0;
    found=false;
    gap=Inf;
    closest_line_nb=0;



%% RESEARCH



    while ~feof(file)

        current_line=fgets(file);
        current_line_nb=current_line_nb+1;

        if current_line_nb < ref_line_nb

        % then a potential closer line is after current_line

            if begin_with (current_line,str)

                found=true;
                closest_line_nb=current_line_nb;
                gap=ref_line_nb-closest_line_nb;

            end

        elseif current_line_nb > ref_line_nb

        % then the closest line after ref_line is the first
        % found after ref_line
            
            if begin_with (current_line,str)
                    
                if current_line_nb-ref_line_nb...
                    < gap

                    found=true;
                    closest_line_nb=current_line_nb;
                    gap=current_line_nb-ref_line_nb;

                end

                % if current_line was closer to ref_line
                % than lines previously found before ref_line
                %
                % then it is the closest
                %
                % and if not
                %
                % then the closest line was before ref_line
                %
                % so in every cases, no need to continue
                % the read of the file

                break

            end

        end

    end



%% END



    fclose(file);

end