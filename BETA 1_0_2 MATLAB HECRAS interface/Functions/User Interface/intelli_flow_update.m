function intelli_flow_update (filename, flow_type,...
    array, xs)
% update hydrograph formatted data in a RAS file
%
% Syntax : intelli_flow_update (filename, flow_type,...
%
% array, xs)
%
% Param : filename, string, name of Ras text file
%
% Param : flow_type, string, exact RAS name of a 
% hydrograph, currently supported : every names containing 
% 'Hydrograph' or beginning with 'Gate #<n° of gate>'
%
% Param : array, cell array with one column or row 
% containing only MATLAB date or date string which can be 
% immediately recognized by MATLAB and another one containing 
% only double
%
% Param : xs, XS object
%
% Note : for rating curve, cf. see also section
%
% See also
% For other conditions : rating_curve_update ; 
% User Interface : input_update_standalone,
% intelli_flow_update, prompt_export_results, 
%
% Written by Ronan Deshays for IMTLD, July 2020

    supported_names=["Gate","Hydrograph"];
    supp_array=contains(flow_type, supported_names);

    if any(~supp_array(:))
    % from MATLAB doc > Reduce Logical Arrays to Single Value

        error('%s %s \n %s %s',...
            flow_type,...
             'not recognized, not yet supported',...
             'or you choosed the wrong fonction to write',...
             'this kind of data')
            
    end

    [flow_line_nb, bound_line_nb, found]=...
        find_param_ref(filename, xs, flow_type);

    if contains(flow_type,'Gate')

        % then there is a extra step to perform,
        % because in this case, the hydrograph is not below
        % the ref_param, it is below the Gate Openings
        % sub_param, so we have to give the line nb
        % of Gate Openings for the writing of hydrograph

        % Gate Opening is a sub_param, but we already know
        % the line nb of the ref param, so we can just
        % search the first matching line after it
        opening_line_nb=find_str_after (filename,...
            bound_line_nb, 'Gate Openings');

        flow_line_nb=opening_line_nb;

    end

    if found

        if iscell(array)

        % then one column or row 
        % contains only MATLAB date or date string which
        % and another one contains only double

        % try to detect colum

            % get_column_type is one of the local functions
            % their code is below in this file
            column_type_array = get_column_type(array);
            [found, ~, num_column]=search_in_array (...
                "numeric",column_type_array);

            if ~found 
                
            % then try with transposed array
            % so try to detect row

                array=array'; % transpose array
                column_type_array = get_column_type(array);
                [found, ~, num_column]=search_in_array (...
                "numeric",column_type_array);

            end

            if found

            % then array contains dates and numbers

            % first write numbers

                update_table( filename, flow_line_nb,...
                    cell2mat( array(:, num_column) ) )

            % then read dates and prepare editing of
            % date settings in RAS file

                [found, ~, date_column]...
                    =search_in_array("datetime", column_type_array);

                if ~found % if dates are not date object
                    % they can be char strings

                    [found, ~, date_column]...
                        =search_in_array("datestring",...
                        column_type_array);

                    % WARNING, datestrings must be all in the same
                    % format, else they will not be recognized

                % convert datestrings to MATLAB date objects

                    for k=1:size(array,1)

                        array{k,date_column} = datetime(...
                            array(k, date_column));

                    end

                end

                if found % date were char string or date objects
                    % but now they are in each case date objects

                % update params to help RAS understand these data

                    Start1=Date_; % to avoid confusion with main Start
                    Start1=Start1.init(array{1,date_column});
                    interval=array{2,date_column}-Start1.Mat;
                    param_array=cell(3,2);
                    % param_array columns :
                    % target_param ; edited_param
                    if contains(flow_type,'Hydrograph')

                        param_array{1,1}='Interval';
                        param_array{2,1}='Use Fixed Start Time';
                        param_array{3,1}='Fixed Start Date/Time';

                    elseif contains(flow_type,'Gate')

                        db('In else if Gate')

                        param_array{1,1}='Gate Time Interval';
                        param_array{2,1}='Gate Use Fixed Start Time';
                        param_array{3,1}='Gate Fixed Start Date/Time';

                    else

                        error('%s %s %s %s',...
                            'unrecognized flow type ', flow_type, newline,...
                            ' but some data were found and written.')

                    end

                % param name change, but values are the same
                % for Hydrograph and Gate

                    param_array{1,2}=[param_array{1,1},'=',...
                        dur2HRdur(interval)];

                    param_array{2,2}=[param_array{2,1},'=True'];

                    param_array{3,2}=[param_array{3,1},'=',...
                        Start1.HRset];
                    
                    for k=1:size(param_array,1)

                        param_line=find_str_after (filename,...
                            bound_line_nb, param_array{k,1});
                        update_param(filename, param_line,...
                            param_array{k,2})

                    end

                end

            end

        elseif isnumeric(array)

            % then simply write datas in the RAS format "as is"

            update_table (filename, flow_line_nb, array)

        else

            error('%s \n %s \n %s \n %s',...
                'wrong input array format',...
                'it must be a cell array with only ',...
                'datetime, numbers, and headers',...
                'or a numeric array')

        end

    else

        error('%s %s %s',...
            'ref param ',flow_type, ' not found')

    end

end

function HRdur = dur2HRdur (dur)
% Credits : onverts MATLAB duration object to a duration 
% string understandable for Ras
%
% Syntax : HRdur = dur2HRdur (dur)
%
% Param : dur, MATLAB duration object
%
% Return : HRdur, string, duration string understandable 
% for Ras
%
% Written by Ronan Deshays for IMTLD, July 2020

    % Dev note : please follow syntax patern for interval :
    % 2SEC or 2MIN or 2HOUR or 1DAY (only 1 available ?)
    % or 1WEEK or 1MON or 1YEAR

    warning('dur2HRdur doesn t manage more than days yet')

    [h,m,s] = hms(dur);

    hours=mod(h,24);
    days=floor(h/24);

    if days > 0

        HRdur=[num2str(days),'DAY'];

    elseif hours > 0

        HRdur=[num2str(hours),'HOUR'];

    elseif m > 0

        HRdur=[num2str(m),'MIN'];

    elseif s > 0

        HRdur=[num2str(days),'SEC'];

    else 

        error('empty duration')

    end

end

function column_type_array = get_column_type (array)
% detect if there is a consistent type in an array and if so, return it
%
% Param : array, can be every MATLAB type, depending on 
% what is supported by detect_type function, including
% cell array
%
% Return : column_type_array, it is a 1D array which 
% contains type of each column
%
% Syntax : column_type_array = get_column_type (array)
%
% Written by Ronan Deshays for IMTLD, July 2020

    nb_of_columns=size(array,2);
    nb_of_rows=size(array,1);
    column_type_array=strings(1,nb_of_columns);
    previous_type='';

    if iscell(array)

        for k=1:nb_of_columns

            for l=1:nb_of_rows
    
                detected_type = detect_type (array {l,k});
    
                if ~strcmp(detected_type,previous_type)...
                    && l > 1 % because non sense to compare
                    % first row with something
    
                    detected_type='not consistent';
    
                    break % check if it breaks only one for
                    % or both immediately
    
                end
    
                previous_type=detected_type;
    
            end
    
            column_type_array(1,k)=detected_type;
    
        end

    else

        for k=1:nb_of_columns

            for l=1:nb_of_rows

                detected_type = detect_type (array (l,k));

                if ~strcmp(detected_type,previous_type)...
                    && l > 1 % because non sense to compare
                    % first row with something

                    detected_type='not consistent';

                    break % and test next column

                end

                previous_type=detected_type;

            end

            column_type_array(1,k)=detected_type;

        end

    end

end

function data_type = detect_type (value)
% detect type of a given value
%
% Syntax : data_type = detect_type (value)
%
% Param : value, can be a variable of every MATLAB type
%
% Return : data_type, string
%
% Note : Only numeric, datetime and datestring are 
% detected yet
%
% Written by Ronan Deshays for IMTLD, July 2020

    if isnumeric(value)

        data_type='numeric';

    elseif isdatetime(value)

        data_type='datetime';

    else

        date1=''; % to avoid date1 undefined
        % when try fail

        try

            date1=datetime(value);

        catch

            % nothing, error is not
            % interesting there

        end

        if isdatetime(date1)

            data_type='datestring';

        else

            data_type='unknown';

        end

    end

end
