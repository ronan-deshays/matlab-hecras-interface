% gather results for a given XS
%
% WARNING : for the time being, only XS are supported
% not buildings
%
% Written by : Ronan DESHAYS for IMTLD, July 2020

classdef Results_

    properties

        Array % Cell Array of datas for every profiles
        Row % the first free row, available for writing
        Column % number of column
        
    end

    methods

        function obj = init (obj, rp, xs, sett,...
            nb_of_iterations)
        % saves in array the values of the two first profiles
        %
        % Syntax : obj = init (obj, rp, xs, sett, nb_of_iterations)
        %
        % Param : rp, ras process
        %
        % Param : xs, XS obj
        %
        % Param : sett, Sett obj
        %
        % Param : nb_of_iterations, it is obvious
        %
        % Warning : call this AFTER manual or auto init of HEC-RAS
        %
        % Warning : only XS supported, no building
            
            obj.Row=1;
            obj.Column=size(sett.RASVar,1); 
            % +1 because profile column,
            % - 1 because headers in RAS array, 
            % so only size(sett.RASVar)

            obj.Array=cell(nb_of_iterations+2,obj.Column);
            obj.Array{1,1}='profiles';
            [~,profile_list]=...
                rp.Output_GetProfiles(xs.riverID,0);

            if size(profile_list,1) < 3

                disp('ERROR : not enough profiles')
                disp('please check the list below :')
                disp(profile_list)
                error('%s','. ')

            end


        %% write headers

            for column = 2:obj.Column

                obj.Array{obj.Row,column}=...
                    sett.RASVar{column,1};

                % NOTE : obj.Array size is e.g. 4 column, n rows
                % but sett.RASVar size is n rows, 2 column, so we
                % use the column variable to go to the next row

            end

            obj.Row=obj.Row+1;

        %% write 2 first profiles (from Init)

            for profiles=2:3 % because Max W.S is n°1 but useless
            % because calculated only during this timestep
            % read documentation for further explanations

                obj.Array{obj.Row,1}=profile_list{profiles,1};

                for column = 2:obj.Column

                    obj.Array{obj.Row,column}=...
                        rp.Output_NodeOutput(xs.riverID,...
                        xs.reachID,xs.nodeID,0,profiles,...
                        sett.RASVar{column,2});

                    % NOTE : 0 for XS, for buildings, you have to
                    % change this value

                end

                obj.Row=obj.Row+1;

            end

        %% write xs infos

            nb_row=obj.Row-1;
            obj.Column=obj.Column+3; % room for XS infos

            temp=cell(nb_row,obj.Column);

            for k=1:nb_row

                
                temp(k,1:3)={xs.riverName,xs.reachName,...
                    xs.nodeName};
                temp(k,4:obj.Column)=obj.Array(k,:);

            end

            obj.Array=temp;

        end

        function obj = update (obj, rp, xs, sett)
        % ask Ras for new results and save them
        %
        % Syntax : obj = update (obj, rp, xs, sett)
        %
        % Param : rp, Ras process
        %
        % Param : xs, XS obj
        %
        % Param : sett, Settings_ obj
        %
        % Warning : only XS supported, no building

            [~,profile_list]=...
                rp.Output_GetProfiles(xs.riverID,0);
            obj.Array{obj.Row,4}=profile_list{3,1};

        %% write profiles and results

            for column = 2+3:obj.Column

                rasVarRow=column-3; % because there is 3 useless
                % columns

                obj.Array{obj.Row,column}=...
                    rp.Output_NodeOutput(xs.riverID,...
                    xs.reachID,xs.nodeID,0,3,...
                    sett.RASVar{rasVarRow,2});

                % NOTE : 0 for XS, for buildings, you have to
                % change this value

            end

        %% write xs infos

            obj.Array(obj.Row,1:3)={xs.riverName,xs.reachName,...
            xs.nodeName};

            obj.Row=obj.Row+1;

        end

        function value = GetValue (obj, xs, rp, var_name,...
            profile_name)
        % search a value by name in the results array, and return it
        %
        % Syntax : value = GetValue (obj, xs, rp, var_name, profile_name)
        %
        % Param : xs, XS obj
        %
        % Param : rp, Ras process
        %
        % Param : var_name, string, the name of the variable to 
        % find
        %
        % Param : profile_name, the name of the Ras profile, e.g. 
        % 12JAN2014 0000
        %
        % Return : the value if it was found, or 'not found' 
        % string
        %
        % Warning : don't call this method before init method

            [found1,~, column]=search_in_array(...
                var_name,obj.Array);

            if strcmp(profile_name,'last')

                [~,profile_list]=...
                rp.Output_GetProfiles(xs.riverID,0);

                profile_name=profile_list{3,1};

            end
            
                [found2, row, ~]=search_in_array(...
                    profile_name,obj.Array);

            if found1 && found2

                value=obj.Array{row,column};

            else
                
                value='not found';

            end

        end

    end
    
end