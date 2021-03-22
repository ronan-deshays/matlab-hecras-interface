function input_writing (input_list, files)
% applies modifications asked in input_list according to there type
%
% Syntax : input_writing (input_list, files)
%
% Param : input_list, cell array, following format 
% recommanded in input and output scripts documentation
%
% Param : files, Files_ object
%
% See also
% User Interface : input_update_standalone,
% intelli_flow_update, prompt_export_results, 
% rating_curve_update
%
% Written by Ronan Deshays for IMTLD, July 2020

    nb_of_input=size(input_list,1);

    for k=1:nb_of_input

        if begin_with (input_list{k,3},'.u')

            % then, this is the current unsteady flow file

            if begin_with (input_list{k,2}, 'hydrograph')

                intelli_flow_update (files.flow, input_list{k,4},...
                    input_list{k,1}, input_list{k,5})

            elseif begin_with (input_list{k,2}, 'param')

                input_update_standalone(input_list, k, files.flow)

            elseif begin_with (input_list{k,2}, 'rating curve')

                rating_curve_update(files.flow, input_list{k,1},...
                    input_list{k,5})

            else

                say('ERROR in input_list for k = ',...
                    num2str(k),newline,...
                    'type', input_list{k,2},...
                    ' not supported or not recognized')

                disp(input_list(k,:))

                error('. ')

            end

        elseif strcmp(input_list{k,3},'.p')

            % then, this is the current plan file
            % there is only "common", i.e. one string long
            % standalone params in this file, so
            % data must be only a string

            if begin_with (input_list{k,2}, 'param')
                
                input_update_standalone(input_list, k, files.plan)

            else

                say('ERROR in input_list for k = ',...
                    num2str(k),newline,...
                    'type', input_list{k,2},...
                    ' not supported or not recognized')

                disp(input_list(k,:))

                error('. ')

            end

        else

            say('ERROR in input_list for k = ',...
                num2str(k),newline,...
                'fileext ', input_list{k,3},...
                ' not supported or not recognized')

            disp(input_list(k,:))

            error('. ')

        end

    end

end