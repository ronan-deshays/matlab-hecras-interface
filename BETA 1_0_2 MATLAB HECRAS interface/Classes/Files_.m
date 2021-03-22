% store every useful Ras filename 
% e.g. unsteady flow file
%
% Files is already a MATLAB class
%
% object is used there as a enhanced struct type

classdef Files_

    properties

        plan % plan
        flow % unsteady flow filename
        project % project filename
        folder % RAS project folder
        restart % restart filename
        compute_msg % error msg filename

    end

    methods

        function obj = init (obj, rp, start_date)
        % Gets useful RAS filenames
        %
        % Syntax : obj = init (obj, rp, start_date)
        %
        % Param : rp, a RAS process
        %
        % Param : start_date, a date in RAS file format, e.g. a Dat
        % e_ object.HRfile

            obj.plan=rp.CurrentPlanFile;

            % NOTE : error in Breaking
            % this is a uppercase 'S' UnSteady
            % instead of Unsteady
            obj.flow=rp.CurrentUnSteadyFile;

            obj.project=rp.CurrentProjectFile;

            [obj.folder,~,~]=fileparts(obj.project);

            obj.restart=[obj.plan,'.',start_date,'.rst'];

            obj.compute_msg=[obj.plan,'.computeMsgs.txt'];

        end

        function obj= update (obj, new_start)
        % Updates restart filename date
        %
        % Syntax : obj= update (obj, new_start)
        %
        % Param : new_start, a date in RAS file format, e.g. a Date
        % _ obj.HRfile

            obj.restart=[obj.plan,'.',new_start,'.rst'];
            
        end

    end

end