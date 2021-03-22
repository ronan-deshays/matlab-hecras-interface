function cell2csv(cell_array, varargin)
% write cell array in a CSV file
%
% Syntax : cell2csv(cell_array, varargin)
%
% Param : cell_array, Cell Array, containing strings or 
% numbers
%
% Param : varargin, the first cell will be read, a 
% filename string is expected, e.g. example_file.csv
%
% Written by Ronan Deshays for IMTLD, July 2020

    if nargin < 2

        csv_file='out.csv';

    else

        csv_file=varargin{1};
        
    end

    say('CSV file will be available there : ', newline,...
        pwd, '\', csv_file)

    csvID=fopen(csv_file,'w');

    size_array=size(cell_array);

    sz_sz_array=size(size_array); % return dimension of cell_array
    % e.g. 2 if cell array is 2D

    if sz_sz_array > 2

        error('%d%s',...
            sz_sz_array, 'D cell array not yet supported')

    end

    for k=1:size_array(1)

        str='';

        for l=1:size_array(2)

            str=[str,',',num2str(cell_array{k,l})];
            
        end

        line1=[str,',',newline];
        fprintf(csvID,line1);
        
    end

    fclose(csvID);
    disp('array exported to .csv')

end

