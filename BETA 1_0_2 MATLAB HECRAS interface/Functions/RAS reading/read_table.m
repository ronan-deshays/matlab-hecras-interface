function table = read_table ( filename, ref_param_line_nb )
% Reads table in HEC-RAS files and returns a numeric array 
%
% Param : filename, string, name of RAS file to read, e.g. 
% MyProject.u01 for unsteady flow file
%
% Param : ref_param_line_nb, integer, line number of the 
% ref param
%
% Return : table, numeric array, same dimensions as
% in HEC-RAS. But contains MATLAB double, instead 
% of strings with a length of 8 char
%
% Syntax : table = read_table ( filename, 
% ref_param_line_nb )
%
% Written by Ronan Deshays for IMTLD, July 2020
%
% Updated by Ronan Deshays for IMTLD, August 2020

    fID=fopen(filename,'r');
    frewind(fID)

    line_nb=0;
    conti=true;
    l=0;

    while ~feof(fID)

        line_nb=line_nb+1;
        current_line=fgets(fID);

        if line_nb == ref_param_line_nb

            temp=str2double(split(current_line,'='));
            nb_of_values=temp(2);
            table=zeros(ceil(nb_of_values/10),10);

        elseif line_nb > ref_param_line_nb ...
            && conti

            if begin_with(current_line,'DSS') ...
                || begin_with(current_line,'Boundary')

                conti=false;

            else

                l=l+1;

                values=str2double(split(current_line));

                table(l,:)=values(2:end-1);

            end

        end

    end

    fclose(fID);

end