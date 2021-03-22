function [version_type,version_number,version_name,found] = version_detect...
    (folderpath)


    version_name = 0;
    version_number = 0;
    version_type = 0;
    found=false;

    [~,foldername,~]=fileparts(folderpath);
    regexstr=['(?<type>\w*) (?<number>[\d_]*)',...
        '(?<name>\w*) MATLAB HECRAS interface'];

    struct_version=regexp(foldername,regexstr,'names');
    
    if size(struct_version,1) > 0

        version_type=struct_version.type;
        version_number=struct_version.number;
        version_name=struct_version.name;
        found=true;

    end

end