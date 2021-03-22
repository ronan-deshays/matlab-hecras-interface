function [row, col] = ind_lat2sub (sz, ind)
% converts horizontal (or lateral) linear indexing to 
% subscripts indexing
%
% Syntax : [row, col] = ind_lat2sub (sz, ind)
%
% Param : sz
%
% Param : sz, double array, e.g. value returned by the 
% size function
%
% Param : ind, 1D horizontal integer array, index in horizontal 
% index
%
% Return : row, 1D horizontal integer array, index of row of 
% the cell designated by ind index
%
% Return : col, 1D horizontal integer array, index of col of 
% the cell designated by ind index
%
% Written by Ronan Deshays for IMTLD, July 2020

    % converts horizontal (or lateral) linear indexing to subscritps indexing

    % variation of ind2sub function which works with vertical linear indexing

    sz_sz_col=size(sz,2);

    if sz_sz_col == 1

        % then it is a 1D array
        % then ind_lat is equal to ind_vert

        warning('%s \n %s %s',...
            'It is useless to call this function for 1D array',...
            'Please refer to MATLAB Documentation > Array Indexing page >', ...
            'Indexing with a Single Index section')

        if sz(1) == 1

            % then it is a horizontal array

            row = 1;

            col = ind;

        else

            % then it is a vertical array

            col = 1;

            row = ind;

        end

    elseif sz_sz_col == 2

        % then it is a 2D array

        col = mod(ind, sz(2)); % if there is 10 col,
        % values of different rows are at least spaced of 10 indices
        row = ceil(ind / sz(2)); % because if it is between 1st and 2d col
        % it is on 2d col

        for k=1:size(col,2)

            if col(k) == 0

                % then it is the last value of the row

                col(k) = sz(2);

            end

        end

    else

        error('%s %s','array with dimension number higher',...
            'than 2 is not supported')

    end

end