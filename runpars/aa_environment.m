function env = aa_environment()
[env.SLASH, env.pathtodata] = OS_VARS();
allc = allconfigs;
nameofcurrentrepo = allc.aa.nameofcurrentrepo;
env.currhash = '';
global logpath
if ismac
    env.wheretosavestuff = allc.aa.mac.env.wheretosavestuff;
    env.homepath = allc.aa.mac.env.homepath;
    env.allmatpath = allc.aa.mac.env.allmatpath; 
    [elel, gitout] = system('git rev-parse HEAD');
    if elel
        error('could not get current hash')
    end
    env.currhash = gitout(1:end-1);
    
elseif isunix
    [~,cmdout] = system('echo $USER');
    env.wheretosavestuff = ['/media/' cmdout(1:end-1) allc.aa.unix.env.wheretosavestuff];
    env.homepath = allc.aa.unix.env.homepath;
    env.allmatpath = allc.aa.unix.env.allmatpath;
    %disp('reached isunix')
    [elel, gitout] = system('git rev-parse HEAD');
    if elel
        error('could not get current hash')
    end
    env.currhash = gitout(1:end-1);
elseif ispc
    [~,cmdout] = system('echo %HOMEPATH%');
    list_dir = allc.osv.drives_to_search;
    list_ind = 1;
    while (~exist([list_dir{list_ind} allc.aa.pc.env.wheretosavestuff],'dir')) 
        list_ind = list_ind +1;
        if list_ind > length(list_dir)
            error('Could not find suitable save directory')
        end
    end
    [elel,cmdout1] = system('where /r \ git.exe');
    if any(strfind(cmdout1,'INFO:'))||elel
        error('cant find git.exe')
    end
    cmdcmd = strsplit(cmdout1,'git.exe');
    [elel, gitout] = system(['"' cmdcmd{1} 'git" rev-parse HEAD']);
    if elel
        error('could not get current hash')
    end
    env.currhash = gitout(1:end-1);
    %env.wheretosavestuff = 'd:\'; %%% should check if there is permission for saving!!!
    %env.wheretosavestuff = 'e:\'; %%% should check if there is permission for saving!!!
    env.wheretosavestuff = [list_dir{list_ind} allc.aa.pc.env.wheretosavestuff]; %%% should check if there is permission for saving!!!
    env.homepath = [allc.aa.pc.env.windowsdrive cmdout(1:end-1) allc.aa.pc.env.homepath  nameofcurrentrepo];
    env.allmatpath = [allc.aa.pc.env.windowsdrive cmdout(1:end-1) allc.aa.pc.env.allmatpath];
else
    disp('oh-oh')
end
%addpath(genpath(homepath))
%open dialog box?
%have to see how to do it

if ispc
    logpath = strcat(env.wheretosavestuff, env.SLASH , env.SLASH ,'var',env.SLASH ,env.SLASH,'log.txt');
else
    logpath = strcat(env.wheretosavestuff, env.SLASH ,'var',env.SLASH,'log.txt');
end
if ~exist(logpath,'file')
    %if this fails there may be a broken path,,, usually happens when I
    %change the computer I am using
    fid = fopen( logpath, 'wt' );
    if fid <0
        error(['the directory where I am trying to save things does not exist: ' logpath])
    else
        fprintf( fid, 'New logfile created.');
    end
    fclose(fid);
end
end