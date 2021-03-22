function filled_str = fill_space_after (str, nb_of_char)
% fill a string with spaces to reach a target length
%
% Syntax : filled_str = fill_space_after (str, nb_of_char)
%
% Param : str, string
%
% Param : nb_of_char, integer, this is the target_length 
% of filled_str
%
% Return : filled_str, string, this is str with some 
% spaces after it to reach a target length
%
% See also
% fill_space_before
%
% Written by Ronan Deshays for IMTLD, July 2020

    sz = size(str,2);

    % fill in with spaces
    filled_str=zeros(1,nb_of_char-sz);
    
    for k=1:nb_of_char-sz

        filled_str(k)=' ';

    end

    if  sz > nb_of_char

        error ('%s \n %s %s %s %d',...
        ' str is larger than nb_of_char. Please check below :',...
        ' str = ',str,' ; nb_of_char = ', nb_of_char)

    else 

        filled_str=[str,filled_str];

    end

end
