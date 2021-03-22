function nb_of_iterations = get_nb_iterations (...
    End, Last, time_step)
% count number of iterations between first and last end simulation date
%
% Syntax : nb_of_iterations = get_nb_iterations (...
%    End, Last, time_step)
%
% Param : End, Date_ object, date of the end of the first 
% simulation step
%
% Param : Last, Date_ object, date of the end of the last 
% simulation step
%
% Param : time_step, duration object, duration of a 
% simulation step
%
% Return : nb_of_iterations, integer, number of 
% iterations, i.e. number of simulation steps
%
% Written by Ronan Deshays for IMTLD, July 2020

    nb_of_iterations=0;

    while Last.Mat >= End.Mat

        End=End.increment(time_step);
        nb_of_iterations=nb_of_iterations+1;

    end

end