function prompt_reset_plan (files, First, Last)
% ask user for switch off restart and put start and last dates in Ras
%
% Syntax : prompt_reset_plan (files, First, Last)
%
% Param : files, a Files_ obj
%
% Param : First, Date_ obj
%
% Param : Last, Date_ obj
%
% See also
% related : update_param_first ; 
% RAS writing : prompt_reset_plan, update_table
% update_param, param_delete
%
% Written by Ronan Deshays for IMTLD, July 2020

    if prompt('Do you want to reset RAS plan ?','N')


    
    %% don't use restart file



        update_param_first (files.flow, 'Use Restart',...
        'Use Restart=0')
    
        [line_nb, found]=find_str_after(files.flow, 0,...
            'Restart Filename');
    
        if found
    
            param_delete (files.flow, line_nb)
    
        end


    
    %% set simulation date



        temp=['Simulation Date=',First.HRset,',',...
        Last.HRset];% one RASnewline is already
        % in update param function
        update_param_first (files.plan,'Simulation Date', temp)


    
    %% don't write restart file at simulation end



        update_param_first (files.plan,...
            'Write IC File at Sim End',...
            'Write IC File at Sim End=0')
    
    end

end