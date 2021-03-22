function error_occured = detect_RAS_error(files)



%% INIT



    error_occured=false;
    progress=false;

% count number of lines in compute_msg

    compute_msg_ID=fopen(files.compute_msg,'r');
    frewind(compute_msg_ID);
    nb_of_lines=0;



%% READING



    while~feof(compute_msg_ID)

        current_line=fgets(compute_msg_ID);

        if ~progress && ...
            contains(current_line,'Progress')

            progress=true;

        end

        if contains(current_line,'Error')

            error_occured=true;
            break

        end

        nb_of_lines=nb_of_lines+1;

    end



%% END



    fclose(compute_msg_ID);

% blocking error detection

    if ~progress

    % then it should be a blocking error
    % because normal computation is at least 100 lines
    % long

        error_occured=true;

    end

end