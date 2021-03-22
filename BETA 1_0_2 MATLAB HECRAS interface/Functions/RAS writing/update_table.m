function update_table (filename, ref_param_line_nb, num_array)
% update table of values in a RAS file with given numeric array
%
% Syntax : update_table (filename, ref_param_line_nb, 
% num_array)
%
% Param : filename, string, name of RAS text file
%
% Param : ref_param_line_nb, integer, line number of 
% sentence above the table in the RAS file
%
% Param : num_array, double array, max. 8 digits numbers
%
% Warning : don't use array with some empty cells, if you 
% don't know, use 1D arrays e.g. 249 * 1 array instead of
% 50*5 array with one cell empty
%
% Note : if num_array completely empty, script will deal with that
%
% See also
% related : update_param ; 
% RAS writing :  update_parm_first, param_delete
% prompt_reset_plan
%
% Written by Ronan Deshays for IMTLD, July 2020



%% INIT



    global RASnewline % read only

    file=fopen(filename,'r');

    frewind(file) % go back to beginning of file

    [filepath,name,ext]=fileparts(filename);
    filetempname=[filepath,'\',name,'.temp',ext];
    filetemp=fopen(filetempname,'w');
    % erase filetemp before writing
    % so no need to delete it after save
    current_line_nb=0;
    


%% WRITING



    while ~feof(file)

        current_line_nb=current_line_nb+1;

        current_line=fgets(file);
        fprintf(filetemp,'%s',current_line);

        if current_line_nb == ref_param_line_nb

        %% get number of old data

            regexstr='(?<name>.*)=(?<value>.*[^\r\n])';
            temp_struct=regexp(current_line,...
                regexstr, 'names');

            % ceil - Round toward positive infinity
            % because the last line can be not completely
            % filled

            nb_of_line_old=ceil(...
                str2double(temp_struct.value)/10);

        %% forget old table data

            for n=1:nb_of_line_old

                fgets(file);

            end

        %% replace it with new data

            % get the number of values 
            nb_of_values=size(num_array,1)*size(num_array,2);

            for k=1:nb_of_values
                % manage an empty num_array

                nb=num2str(num_array(k));
                %nb=num2str(num_array(ind_lat2sub(size(num_array),k))); % workaround, check
                sz=size(nb,2);

                if sz > 8

                    disp(['ERROR in update_table ',...
                        'too much digits in a number. ',...
                        'Please check below the wrong ',...
                        'number.',newline])
                    disp(nb)
                    error('.')

                else

                    fprintf(filetemp, '%s', fill_space_before(nb,8));

                    if mod(k,10)==0 || k==nb_of_values

                        fprintf(filetemp, '%s', RASnewline);

                    end

                end
            
            end

        end

    end



%% END



    fclose(file);
    fclose(filetemp);

    copyfile(filetempname,filename)

    % there is a space before the value in the file
    % so I kept it

    new_table_param=[temp_struct.name,'= ',...
        num2str(nb_of_values)];

    update_param(filename,ref_param_line_nb,new_table_param) 

end

