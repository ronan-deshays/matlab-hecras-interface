% store a date in multiple Ras and Matlab formats
%
% don't forget to update to apply changes to every formats

classdef Date_

    properties

        Mat % MATLAB date
        HRset % HEC-RAS date format for settings ','
        HRfile % HEC-RAS date format for file name ' '

    end

    methods

        function obj = init(obj,InternationalDate)
        % saves and converts in Ras date formats a MATLAB date
        % string
        %
        % Syntax : obj = init(obj,InternationalDate)
        %
        % Param :  a string in the standard MATLAB date format
        %
        % Warning :  it must be a date immediately recognized by 
        % datetime function without additional arguments

            obj.Mat=datetime(InternationalDate);
            % save the date Matlab type
            obj=obj.update(); % apply change to others

        end

        function obj = increment(obj,timeStep)
        % increment every date formats with the given duration
        %
        % Syntax : obj = increment(obj,timeStep)
        %
        % Param : timeStep, a MATLAB duration type variable, e.g. 
        % a Step_ obj.dur

            obj.Mat=obj.Mat+timeStep;
            obj=update(obj);

        end

        function obj = update(obj)
        % updates every date formats according to the MATLAB date 
        % format property
        %
        % Syntax : obj = update(obj)

            % m for month and M for minutes
            % upper converts e.g. Feb becomes FEB
            temp1=upper(datestr(obj.Mat,'ddmmmyyyy,HHMM'));

        % midnight bug workaround

            % HEC-RAS understands 24:00 but MATLAB doesn't
            if strcmp(temp1(11:14),'0000')

                temp1=upper(datestr(obj.Mat-1,'ddmmmyyyy'));
                temp1=[temp1,',2400'];

            end

            obj.HRset=temp1;
            obj.HRfile=replace(temp1, ',', " ");

        end

    end

end