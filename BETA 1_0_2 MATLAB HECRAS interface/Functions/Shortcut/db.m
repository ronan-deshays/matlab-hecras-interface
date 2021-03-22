function db (thing)

    % displays str only if db_enabled is true

    global db_enabled

    if db_enabled==1

        if isstring(thing)

            say(thing)
        
        elseif iscellstr({thing})

            say(thing)

        else
            
            disp(thing) % disp values and name of the variable

        end

    end

end