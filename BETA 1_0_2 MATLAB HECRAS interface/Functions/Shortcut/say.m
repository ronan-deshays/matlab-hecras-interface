function say (varargin)

    str='';

    for k=1:nargin

        str=[str,varargin{k}];

    end


    disp(newline)
    disp(str)
    disp(newline)

end