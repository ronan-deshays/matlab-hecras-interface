function input_update_standalone (input_list, k, filename)
% update a standalone param saved into a input_list
%
% Syntax : input_update_standalone (input_list, k, 
% filename)
%
% Param : input_list, cell array, following format 
% recommanded in input and output scripts documentation
%
% Param : k, integer, number of the row which contains
% the standalone param infos in input_list
%
% Param : filename, string, a Ras text file
%
% Note : a standalone param is a param which appears only 
% one time in a given text file
%
% See also
% User Interface : input_writing, intelli_flow_update,
% prompt_export_results, rating_curve_update
%
% Written by Ronan Deshays for IMTLD, July 2020

    if iscellstr (input_list(k,1)) ...
        || isstring (input_list(k,1))
        % || according to a MATLAB warning

        [line_nb, found] = find_str_after(...
            filename, 0, input_list{k,4});

        if found

            update_param(filename, line_nb,...
            input_list{k,1})

        else

            error('%s %s %s %s',...
                'for k = ',num2str(k),newline,...
                'param not found, and also not updated')

        end

    else

        error('%s %s %s %s %s',...
            'for k = ',num2str(k),newline,...
            'data : ',input_list{k,1}, 'is not a string')

    end

end