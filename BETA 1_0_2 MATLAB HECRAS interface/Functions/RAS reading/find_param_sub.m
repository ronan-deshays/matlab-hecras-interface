function [sub_line_nb, found] = find_param_sub (...
    filename, xs, ref_param_name, sub_param_name)
% find a subordinate param thanks to xs and ref_param informations
%
% Syntax : [sub_line_nb, found] = find_param_sub (...
%
% filename, xs, ref_param_name, sub_param_name)
%
% Param : filename, string, the name of a Ras text file 
% containing the sub_param
%
% Param : xs, XS obj
%
% Param : ref_param_name, string, see find_ref_param 
% function documentation, cf. See also section below
%
% Param : sub_param_name, string, name of the sub_param to 
% search, e.g. 'Interval'
%
% Return : sub_line_nb, integer, line number where the 
% sub_param was found
%
% Return : found, boolean, true if sub_param was found
%
% Note : for complexity purposes, use find_str_after 
% instead of this function if you know the line number of XS 
% location info related to the ref_param, known as 
% bound_line_nb
%
% Note : this function is just a shortcut to call faster
% functions of the See also section
%
% See also
% related : find_param_sub , find_str_after ; 
% RAS reading : find_closest, find_str_every
%
% Written by Ronan Deshays for IMTLD, July 2020

    [~, bound_line_nb, found] = find_param_ref (...
        filename, xs, ref_param_name);

    if found

        [sub_line_nb, found] = find_str_after (...
            filename, bound_line_nb, sub_param_name);

    end

end