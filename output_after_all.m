function output_after_all (results)
% function customized by user
% called when the entire simulation (and also last step)
% is done
%
% Param : depends on what you choosed, potentially, every 
% variables defined in master script, see input and output 
% scripts doc for further informations.
%
% Note : this script was designed for read-only. 
% If you want to write in RAS files, please use the
% input scripts
%
% Written by Ronan Deshays for IMTLD, july 2020
    
    db('output_after_all launched')

    % your code

    prompt_export_results (results)
    
end