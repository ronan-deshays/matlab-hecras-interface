% store every settings given in settings.ini

classdef Settings_

    properties

        List % list of detected settings
        RASVar % Cell Array of RAS variables choosed by user
        XSlist % Cell Array of XS choosed by user

    end

    methods

        function obj = initVar(obj,rp)
        % recognize Ras variables and save them
        %
        % Syntax : function obj = initVar(obj,rp)
        %
        % Param : rp, Ras process
        %
        % Warning : Call it after init method

            var_name='Name';
            var_ID='ID';
            m=1;
            var_found=true;
            var_info='hey';
            obj.RASVar=cell(1,2);
            % cell array size will grow by itself
            while ~strcmp(var_info,'empty')
                % if empty, don't save it into array

                if var_found
                    obj.RASVar{m,1}=var_name;
                    obj.RASVar{m,2}=var_ID;

                    sett_name=['Variable',num2str(m)];
                    
                    var_info=obj.GetValue(sett_name);

                    [var_name,var_ID,var_found]=...
                        Settings_.SetVarInfos(rp,var_info);
                    
                    m=m+1;

                end

            end

        end

        function obj = initXS (obj, rp)
        % recognize Ras XS and save them
        %
        % Syntax : obj = initXS (obj, rp)
        %
        % Param : rp, Ras process
        %
        % Warning : call it after init Method
 
            temp_xs=XS;
            m=1;
            var_info=cell(3,1);
            obj.XSlist=cell(1);
            % cell array size will grow by itself
            while ~strcmp(var_info,'empty')
                % if empty, don't save it into array               

                % likely name of the variable
                % in settings.ini
                sett_name=['XS',num2str(m)];
                var_info=obj.GetValue(sett_name);

                % split to get every infos
                var_info=split(var_info,',');

                % avoid save if var_info empty (2d check)
                if ~strcmp(var_info,'empty')

                % save these infos
                    river=var_info{1};
                    reach=var_info{2};
                    station=var_info{3};

                % put them in an XS variable
                    % update is too an init function
                    temp_xs=temp_xs.update(rp, river,...
                    reach, station);

                    obj.XSlist{m,1}=temp_xs;

                end
                    
                m=m+1;

            end

        end

        function obj = init (obj)
        % read settings.ini and save recognized settings
        %
        % Syntax : obj = init (obj)
        %
        % Note : every line which contains = will be recognized as 
        % a setting
        %
        % Warning : don't let a parameter empty, e.g. nothing 
        % after a = char, it will cause an error


            say('NOTE : warnings below can be ignored',...
                newline,' if they are related to variables',...
                ' that does not exist in settings.ini',...
                newline,' e.g. Variable3 if there is only',...
                ' Variable1 and Variable2 written in settings.ini')
        


        %% init


            
            number_of_settings=size(obj.List,1);

            settingsID=fopen('settings.ini','r');

            frewind(settingsID);
        
            regexstr='(?<name>.*)=(?<value>.*[^\r\n])';
            k=1;
        
            obj.List=cell(number_of_settings,2);


        
        %% read



            while ~feof(settingsID)

                current_line=fgets(settingsID);

                if contains(current_line,'=')

                    temp_struct=regexp(current_line, regexstr, 'names');
                    sz=size(temp_struct);

                    if sz(1) > 0
                        obj.List(k,1)={temp_struct(1).name};
                        obj.List(k,2)={temp_struct(1).value};
                        k=k+1;
                    end

                end

            end

            
        
        %% end



            fclose(settingsID);

        end

        function out = GetValue(obj,name)
        % get value related to a setting name
        %
        % Syntax : out = GetValue(obj,name)
        %
        % Param : name, string, name of the variable (the one 
        % written in settings.ini)
        %
        % Warning : for Ras var, use GetVarinfos instead

            out='empty';
            number_of_settings=size(obj.List,1);

            for k=1:number_of_settings

                if strcmp(obj.List(k,1),name)

                    temp=obj.List(k,2);
                    out=char(temp);

                    break

                end

            end

            if strcmp(out,'empty')

                warning('%s %s %s', 'Setting name ',...
                    name,' not found')

            end

        end

        function [name,ID] = GetVarInfos(obj,str)
        % get name and ID of a RAS output variable
        %
        % Syntax : [name,ID] = GetVarInfos(obj,str)
        %
        % Param : str, string, can be the ID or the name of the 
        % RAS var or the name of the parameter as written in
        % settings.ini
        %
        % Return : name and ID
        %
        % Example : if you give Variable 1 or Flow Area or 10, it 
        % will return Flow Area and 10

            ID=0;
            name='not found';
            value=obj.GetValue(str);

            if ~strcmp(value,'empty')

                [found,row,~]=search_in_array(...
                    value, obj.RASVar);

            else

                [found,row,~]=search_in_array(str,...
                    obj.RASVar);

            end

            if found==true

                ID=obj.RASVar{row,2};
                name=obj.RASVar{row,1};

            end

        end

    end

    methods (Static)

        function [name,ID,found1]=SetVarInfos(rp,var1)
        % search by name and ID, and save, a RAS output variable
        %
        % Syntax : [name,ID,found1]=SetVarInfos(rp,var1)
        %
        % Param : rp, Ras process
        %
        % Param : var1, string, name or ID of a RAS output 
        % variable
        %
        % Return : name, string, name of the RAS output variable 
        % or 'not found'
        %
        % Return : ID, double, conversion to double of the var1 
        % input
        %
        % Return : found1, boolean, true = var1 is a recognized 
        % RAS output variable
        %
        % Warning : a wrong ID can causes HEC-RAS error


        
        % ask RAS for list of RAS output variables
            [~,nameVarArraySettings]=...
                rp.Output_Variables(0,0,0);
        
            ID=str2double(var1); % can causes HEC-RAS error
            name='not found';
        
            if ID >= 1 ...
                && ID <= size(nameVarArraySettings,1)

                % then ID is in the RAS var array

                name=nameVarArraySettings{ID,1};
                found1=true;
        
            else

                % then this is a big string, probably a name

                [found1,ID,~]=...
                    search_in_array(var1,nameVarArraySettings);
        
                if found1

                    name=nameVarArraySettings{ID,1};

                end

            end

        end

    end

end


