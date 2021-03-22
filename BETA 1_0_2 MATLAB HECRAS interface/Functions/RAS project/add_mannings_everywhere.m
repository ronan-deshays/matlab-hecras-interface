function add_mannings_everywhere (rp, sett)
% add manning s n value on every XS
%
% Param : rp, ras process
%
% Param : sett, Settings_ object
%
% Syntax : add_mannings_everywhere (rp, sett)
%
% Written by Ronan Deshays for IMTLD, August 2020



%% INIT



    % user interface

    warning('%s \n %s%s',...
    'Default geometry file is the current geopmetry file used by project',...
    'If you want to edit another file, edit the geo_name variable',...
    ' in the function code')

    % get user settings
    geo_name=sett.GetValue('HP_geo_name');
    LOB_ROB=str2double(sett.GetValue('HP_LOB_ROB'));
    channel=str2double(sett.GetValue('HP_channel'));

    if strcmp(geo_name,'default')

        geo_name=rp.CurrentGeomFile;

    end

    warning('%s', 'this script will overwrite every manning s value')

    if ~(input('Would you like to quit this function ? Y/N [Y]','s') == 'N')

        return

    end

    % compute settings

    LOB_ROB = sprintf('%0.3f',LOB_ROB);
    channel = sprintf('%0.3f',channel);
    LOB_ROB=LOB_ROB(2:end); % transform 0.035 in .035
    channel=channel(2:end);

    [filepath,name,ext]=fileparts(geo_name);
    temp_geo_name=[filepath,name,'.temp',ext];

    geo_ID=fopen(geo_name,'r');
    frewind(geo_ID)

    global RASnewline % get RASnewline char

    temp_geo_ID=fopen(temp_geo_name ,'w');

    % save regular expression to extract data in HEC-RAS geo file
    regexstr='Bank Sta=(?<channel>[0-9.]*),(?<ROB>[0-9.]*)';

    % save some strings which will be used multiple times
    zero_filled=fill_space_before('0',8);
    zero_five=fill_space_before(LOB_ROB,8);
    zero_three=fill_space_before(channel,8);



%% READING AND WRITING



    while ~feof(geo_ID)

        current_line=fgets(geo_ID);

        if begin_with(current_line,'#Mann= 0 , 0 , 0')

            % then, this XS has no Mannings value

            next_line=fgets(geo_ID);

            if ~begin_with(next_line,'Bank Sta')

                error(['Bank Sta not found,', ...
                    ' Bank station needed to set mannings values'])

            end

            % add 3 mannings value (LOB, channel, ROB)

            fprintf(temp_geo_ID,'%s%s','#Mann= 3 , 0 , 0 ',...
                RASnewline);

            % extract useful data from Bank Sta line
            bank_sta=regexp(next_line,regexstr,'names');

            fprintf(temp_geo_ID,'%s%s%s%s%s%s%s%s%s%s', ...
                zero_filled,zero_five,zero_filled, ...
                fill_space_before(bank_sta.channel,8),...
                zero_three,zero_filled, ...
                fill_space_before(bank_sta.ROB,8),...
                zero_five,zero_filled, RASnewline);

            current_line=next_line;
            
        end

        fprintf(temp_geo_ID,'%s',current_line);
        
    end



%% END



    fclose('all');

    copyfile(temp_geo_name, geo_name)

    delete(temp_geo_name)

end