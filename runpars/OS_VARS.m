function [SLASH, pathtodata] = OS_VARS()
allc = allconfigs;

exthdname = allc.osv.exthdname;
if ispc
    SLASH = '\\'; % windows
    list_dir = allc.osv.drives_to_search;
    list_ind = 1;
    while (~exist([list_dir{list_ind} ':' SLASH allc.osv.path_to_data1 SLASH allc.osv.path_to_data2 SLASH],'dir'))
        list_ind = list_ind +1;
        if list_ind > length(list_dir)
            error('Could not find suitable save directory')
        end
    end
    pathtodata = [list_dir{list_ind} ':' SLASH allc.osv.path_to_data1 SLASH allc.osv.path_to_data2 SLASH];
elseif ismac
    SLASH = '/'; %
    pathtodata = ['/Volumes/' exthdname SLASH allc.osv.path_to_data1 SLASH allc.osv.path_to_data2 SLASH];
elseif isunix
    SLASH = '/'; %
    [~,cmdout] = system('echo $USER');
    pathtodata = ['/media/' cmdout(1:end-1) '/' exthdname SLASH allc.osv.path_to_data1 SLASH allc.osv.path_to_data2 SLASH];
else
    error('Cant determine OS')
end


end