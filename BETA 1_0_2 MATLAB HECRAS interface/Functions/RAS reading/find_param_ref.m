function [ref_param_line_nb, bound_line_nb, found] = find_param_ref (...
    filename, xs, ref_param_name)
% find a param for a given XS, which can exists for multiple XS
%
% Syntax : [ref_param_line_nb, bound_line_nb, found] = 
% find_param_ref (filename, xs, ref_param_name)
%
% Warning : doesn't support XS which contains two or more 
% times the same ref_param, e.g. if you have two Flow 
% Hydrograph in a XS, only the first one in the RAS file will 
% be found
%
% Param : filename, string, text file, which contains 
% ref_param
%
% Param : xs, XS obj
%
% Param : ref_param_name, string, e.g. 'Flow Hydrograph'
%
% Return : ref_param_line_nb, integer, line_nb where 
% ref_param was found
%
% Return : bound_line_nb, integer, line_nb which contains 
% the XS location infos
%
% Return : found, boolean, true if ref_param was found
%
% e.g. of param of reference : 'Flow Hydrograph' ; it can 
% exist at multiple XS, this function will be able to find 
% the right one, despite they are all called Flow Hydrograph
%
% See also
% related shortcut : find_param_sub ; 
% RAS reading : find_closest, find_str_after, 
% find_str_every
%
% Written by Ronan Deshays for IMTLD, July 2020


    
%% INIT



    bound_line=['Boundary Location=',xs.HRset];

    % find every lines containing the target boundary location

    [bound_line_nb_array,found]=find_str_every ...
        (filename, bound_line);

    min_gap=Inf;
    ref_param_line_nb=0;
    bound_line_nb=0;



%% RESEARCH



    % test how far is the target ref_param from every
    % line containing the target location
    % and asume that the closest boundary location line
    % from the target ref_param is the boundary location linked
    % to this ref param

    if found

        for k=1:size(bound_line_nb_array,2)

            % find closest line containing ref_param_name
            % to every bound_line of the file
            % and save the gap for comparison

            [ref_line_nb, gap, found]=find_closest (filename,...
                bound_line_nb_array(k), ref_param_name);

            if min_gap > gap

            % then this bound_line is closer to its associated
            % ref param, than the previous couple of bound_line
            % and ref param, so save it

                min_gap=gap;
                ref_param_line_nb=ref_line_nb;

                bound_line_nb=bound_line_nb_array(k);

            elseif min_gap == gap

                warning('%s','2 ref param found')
                found=false;

            end

        end

        if min_gap > 10 && found

            warning('%s %s %s %s','Ref param is far away from ',...
            'bound line, check RAS files, an error', newline,...
            'in the ref_param_name is very likely')

        end

    end

end

        