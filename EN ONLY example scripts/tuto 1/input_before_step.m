function input_before_step (iteration_nb, xs, files) 
% function customized by user
% called before each simulation step, except the 
% first one, because it is the input_before_init function
% which is called
%
% Param : depends on what you choosed, potentially, every 
% variables defined in master script, see input and output 
% scripts doc for further informations.
%
% Note : please follow the input_list rules to avoid 
% issues
%
% Written by Ronan Deshays for IMTLD, july 2020

    db('input_before_step launched')


%% YOUR CODE



    % your code



%% EXAMPLE 2 : GATE SIMULATION FOR VIDEO TUTORIAL #1



    global ws_elev
    global data

    if iteration_nb > 1

        if ws_elev > 65

            data(iteration_nb+1)=-100; % m^3 . s^-1
            db(data)

        end

    else

        data=zeros(1,100);

    end



%% SAVE INPUT DATA



    % short reminder : %   data, type, fileext, ref_param, XS, other_info
    input_list={data, 'hydrograph', '.u', 'Lateral Inflow Hydrograph', xs{1}};



%% PREPARE AND WRITE INPUT DATA



    input_writing (input_list, files)

end
    
    
    
    
    
    
