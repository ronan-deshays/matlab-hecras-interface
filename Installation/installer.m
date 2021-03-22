% this scripts helps to install MATLAB HEC-RAS interface
%
% install new versions of the interface



%% UPDATE PROMPT



list_of_versions = get_versions_list ();
list_of_zip = ls('./Versions library');

choice1=input([' Do you want to install 0 = every',...
    ' available versions or ',...
    newline,' 1 = only a specific version ? [0] : ']);

if ~isstring(choice1) && ~isnumeric(choice1)

    choice1=0;

end

if choice1==1

    version_target_name=input(['If version full name is',...
    ' BETA 1_0_1 MATLAB HECRAS interface',newline,...
    'just write BETA 1_0_1',newline,...
    'Write version name here : '],'s');
    
    version_target_name=[version_target_name,...
        ' MATLAB HECRAS interface'];

end

for k=3:size(list_of_zip, 1)

    [~,version_full_name,~]=fileparts(list_of_zip(k,:));

    if ~exist(version_full_name,'dir') && (~choice1 ...
        || strcmp(version_target_name,version_full_name))

        % then this version is not installed
        unzip(['./Versions library/', version_full_name])

    end

end



%% VERIFY INSTALLATION



disp('Verifying essentials installation')

fid=fopen('./Installation/required_files.txt','r');
frewind(fid)
bool1=false;

while ~feof(fid)

    current_line=replace(fgets(fid),[' ',newline],'');

    if ~exist(current_line,'dir') ...
        && ~exist(current_line,'file')

        disp(['WARNING in installer',newline,...
            'essential file seems to be missing',...
            newline, current_line, newline])

        bool1=true;

    end

end

if bool1

    disp(['Some files were not found.',newline,...
        'Please read Install and update documentation page',...
        'for further informations'])

else
    
    disp('OK - no missing file')

end




