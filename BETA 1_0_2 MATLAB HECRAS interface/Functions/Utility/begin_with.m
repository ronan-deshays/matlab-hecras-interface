function found = begin_with (line1,str)
% test if a given string begin with another shorter string
%
% Syntax : found = begin_with (line1,str)
%
% Param : line1, string, must be longer than or as long as str
%
% Param : str, string, must be shorter than or as long as line1
%
% Return : found, boolean, obvious
%
% Note : lower complexity than MATLAB contains function
%
% Written by Ronan Deshays for IMTLD, July 2020

    found=false;

    if size(line1,2) >= size(str,2)

        if strcmp(line1(1:size(str,2)), str)

            found = true;

        end

    end

end
