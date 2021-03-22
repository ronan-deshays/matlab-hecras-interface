function bool_num = prompt(msg_str,default_choice)
% shortcut of the request unprocessed text input example 
% in input page of MATLAB doc

    bool_num=false;

    str = input([msg_str, ' Y/N [',default_choice,'] : '],'s');

    if isempty(str)

        str = default_choice;
    
    end

    if str(1)=='Y'

        bool_num=true;

    end

end
