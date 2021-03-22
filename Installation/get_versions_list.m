function list_of_versions = get_versions_list ()

    path_list=genpath(pwd);
    path_list=split(path_list,';');
    list_of_versions=cell(1,3);
    l=0;

    for k=1:size(path_list,1)

        [version_type,version_number,version_name,...
            found] = version_detect(path_list{k});

        if found

            l=l+1;
            list_of_versions{l,1}=l; % version ID
            list_of_versions{l,2}=version_type;
            list_of_versions{l,3}=version_number;
            list_of_versions{l,4}=version_name;
            list_of_versions{l,5}=path_list{k};

        end

    end

end