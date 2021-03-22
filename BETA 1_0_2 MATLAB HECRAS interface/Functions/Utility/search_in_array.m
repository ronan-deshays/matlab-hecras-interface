function [found,row,column]=search_in_array(string,array2D)
% search a string in a 2D or 1D array and return 
% position
%
% Syntax : 
% [found,row,column]=search_in_array(string,array2D)
%
% Param : string, string, sentence to search in array
%
% Param : array2D, 1D or 2D array of every MATLAB type
%
% Return : found, boolean, obvious
%
% Return : row, integer, the row number where the string 
% was found
%
% Return : column, integer, the column number where the 
% string was found
%
% Written by Ronan Deshays for IMTLD, July 2020

    size_array=size(array2D);

    sz_sz_array=size(size_array); % return dimension of array2D
    % e.g. 2 if cell array is 2D

    if sz_sz_array > 2

        error('%d%s',...
            sz_sz_array, 'D array not yet supported')

    end

    found=false;
    row=0;
    column=0;
    
    if iscell (array2D)

        for k=1:size(array2D,1)

            for l=1:size(array2D,2)
    
                if strcmp(num2str(array2D{k,l}),string)
    
                    % management of number arrays
                    found=true;
                    row=k;
                    column=l;
    
                    break
    
                end
    
            end
    
        end

    else % the redundancy of code is faster in terms
        % of complexity than testing at each iteration
        % if array is cell array

        for k=1:size(array2D,1)

            for l=1:size(array2D,2)

                if strcmp(array2D(k,l),string)

                    found=true;
                    row=k;
                    column=l;

                    break

                end

            end

        end

    end

end
