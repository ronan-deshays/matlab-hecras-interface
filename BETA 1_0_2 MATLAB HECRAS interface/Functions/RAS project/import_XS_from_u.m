function import_XS_from_u (sett, files)
% import XS infos to settings.ini from given unsteady
% flow file
%
% Param : sett, Settings_ object
%
% Param : files, Files_ object
%
% Note : if there is already XS, copy paste newly imported XS
% and change the nb_of_XS_already_there param
%
% Written by Ronan DESHAYS for IMTLD, August 2020



%% USER SETTINGS



    unsteady_flow_filename=sett.GetValue('HP_geo_name');

    if strcmp(unsteady_flow_filename,'default')

        unsteady_flow_filename=files.flow;

    end

    nb_of_XS_already_there=str2double(...
        sett.GetValue('HP_nb_of_XS_already_there'));



%% INIT



    ini_name=[pwd,'\settings.ini'];
    temp_ini_name=[pwd,'\settings.temp.ini'];

    u_ID=fopen(unsteady_flow_filename,'r');
    frewind(u_ID)

    ini_ID=fopen(ini_name,'r');
    frewind(ini_ID)

    temp_ini_ID=fopen(temp_ini_name,'w');

    m=nb_of_XS_already_there;
    countdown=-1;



%% READING AND WRITING



    while ~feof(ini_ID)

        current_line_ini=fgetl(ini_ID);

        if contains(current_line_ini,'LOCATION')

            % then, XS information must be written 5 lines
            % below + the number of XS already there

            countdown=5+m;

        end

        if countdown > 0

            % then, coutndown has been instantiated,
            % so decrement it

            countdown=countdown-1;

        elseif countdown == 0

            % then, write imported XS

            k=0;

            while ~feof(u_ID)
                
                k=k+1;
                
                current_line=fgetl(u_ID);
                
                if contains(current_line,'Boundary Location')

                    m=m+1;

                    temp_str='';

                    % remove extra whitespace by spliting
                    temp_array=split(current_line(19:60),',');

                    for n=1:size(temp_array,1)

                        temp_str=[temp_str,',',strtrim(temp_array{n})];

                    end
                    
                    % 2:end to remove extra comma at beginning of temp_str
                    fprintf(temp_ini_ID,'XS%d=%s \n',m,temp_str(2:end));
                    
                end
                
            end

        end

        fprintf(temp_ini_ID,'%s\n',current_line_ini);

    end



%% END



    fclose('all');

    copyfile(temp_ini_name,ini_name)

    delete(temp_ini_name)

end
        
        