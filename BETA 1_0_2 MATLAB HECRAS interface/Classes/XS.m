% store every informations required to find an XS
%
% XS stands for cross section, RiverStation, Node

classdef XS

    properties

        riverID
        riverName
        reachID
        reachName
        nodeID
        nodeName
        HRset % one string for boundary Location info
        % ready to be written in RAS files

    end

    methods

        function obj = update (obj, rp, riverName,...
            reachName, nodeName)
        % updates XS object with given infos
        %
        % Param :  rp, RAS process
        %
        % Param :  others are obvious, they are all text 
        % strings

            obj.riverName=riverName;
            obj.reachName=reachName;
            obj.nodeName=nodeName;

        % ask RAS for related IDs

            obj.riverID=rp.Output_GetRiver(riverName);
            obj.reachID=rp.Output_GetReach(obj.riverID,...
                reachName);
            obj.nodeID=rp.Output_GetNode(obj.riverID,...
                obj.reachID,nodeName);
            obj.HRset=XS.toLocation(riverName,...
                reachName, nodeName);

        end

    end

    methods (Static)

        function location = toLocation (riverName,...
            reachName, nodeName)

        % merge location infos in a string understandable by RAS
        %
        % Syntax : location = toLocation (riverName,...
        %   reachName, nodeName)
        %
        % Param :  every params are obvious, all text
        % strings

            river = fill_space_after (riverName,16);
            reach = fill_space_after (reachName,16);
            node = fill_space_after (nodeName,8);
            
            empty8 = fill_space_after('',8);
            empty16 = fill_space_after('',16);
            empty32 = fill_space_after('',32);

            location = [ river,',', reach, ',',...
                node, ',', empty8, ',', empty16,...
                ',', empty16, ',', empty16, ',',...
                empty32];

        end
        
    end

end
    