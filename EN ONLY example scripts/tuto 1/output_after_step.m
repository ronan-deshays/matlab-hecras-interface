function output_after_step (results, xs, rp)
% function customized by user
% called after each simulation step
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


    db('output_after_step launched')

    % your code

    global ws_elev

    % get value in station 5.99
    ws_elev=results{1}.GetValue (xs{1},rp, 'W.S. Elev','last');

    db(ws_elev)

end

