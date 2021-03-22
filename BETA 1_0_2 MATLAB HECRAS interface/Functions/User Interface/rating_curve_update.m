function rating_curve_update (filename, array, xs)
% update rating curve data in a RAS file
%
% Syntax : rating_curve_update (filename, array, xs)
%
% Param : filename, string, a Ras text file
%
% Param : array, array of double, data that will be written
%
% Param : xs, XS object
% See also
% For other conditions : intelli_flow_update ; 
% User Interface : input_update_standalone,
% intelli_flow_update, prompt_export_results, 
%
% Written by Ronan Deshays for IMTLD, July 2020

    [flow_line_nb, ~, found]=...
        find_param_ref(filename, xs, 'Rating Curve');

    nb_of_row=size(array,1);
    nb_of_columns=size(array,2);
    temp=zeros(1,nb_of_row*nb_of_columns);

    m=0;

    if found ...
        && nb_of_columns==2 ...
        && ~mod(nb_of_columns,2)

        for k=1:nb_of_row

            for l=1:nb_of_columns

                m=m+1;

                temp(m)=array(k,l);

            end

        end

        say('Rating Curve OK')

        update_curve (filename, flow_line_nb, temp)

    else

        error('%s %s',...
            'Wrong array format or Rating Curve not found',...
            'in RAS param')

    end

end

function update_curve (filename, ref_param_line_nb, num_array)
% modified version of update_table
%
%% MODIFICATIONS LIST :
% -> update param -> /2
% and modified temp_struct.value -> * 2

% NOTE : if num_array completely empty, script will deal with that
%
% WARNING : don't use array with some empty cells, if you don't know,
% use 1D arrays e.g. 249 * 1 array instead of 50*5 array with
% one cell empty



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

            regexstr='(?<name>.*)= *(?<value>[0-9]*)';
            temp_struct=regexp(current_line,...
                regexstr, 'names');

            % ceil - Round toward positive infinity
            % because the last line can be not completely
            % filled

            value=str2double(temp_struct.value)*2;

            nb_of_line_old=ceil(value/10);

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
                sz=size(nb,2);

                if sz > 8

                    disp(['ERROR in update_table ',...
                        'too much digits in a number. ',...
                        'Please check below the wrong ',...
                        'number.',newline])
                    disp(nb)

                    error('. ')

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
        num2str(round(nb_of_values/2))];

    update_param(filename,ref_param_line_nb,new_table_param) 

end