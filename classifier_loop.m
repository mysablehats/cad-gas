function simvar = classifier_loop(simvar,params, env,varargin)
global VERBOSE LOGIT TEST
%% Begin loop
trialcount = 0;
for architectures = simvar.ARCH_VECT
    for NODES = simvar.NODES_VECT
        for MAX_EPOCHS = simvar.MAX_EPOCHS_VECT
            for featuress = 1:simvar.featuresall
                for valaction = 1:length(simvar.ValSubjectIndexes)
                    trialcount = trialcount +1;
                    if NODES ==100000 && (simvar.MAX_EPOCHS==1||simvar.MAX_EPOCHS==1)
                        dbgmsg('Did this already',1)
                        break
                    end
                    %%%% OK, here, so that you don't make any more
                    %%%% mistakes, simvar changed, so you have to reassign
                    %%%% the parameters here. 
                    simvar.trial(trialcount) = simvar;%% does this solve
                    %the problem?
                    
                    simvar.trial(trialcount).arch = architectures;
                    simvar.trial(trialcount).NODES =  NODES;
                    simvar.trial(trialcount).MAX_EPOCHS = MAX_EPOCHS;
                    simvar.trial(trialcount).prefilter = simvar.prefilter;
                    simvar.trial(trialcount).extract = simvar.extract;
                    simvar.trial(trialcount).activity_type = simvar.activity_type;
                    simvar.trial(trialcount).labels_names = simvar.labels_names;
                    simvar.trial(trialcount).generatenewdataset = simvar.generatenewdataset;
                    params.MAX_EPOCHS = simvar.trial(trialcount).MAX_EPOCHS;
                    params.nodes = simvar.trial(trialcount).NODES; %maximum number of nodes/neurons in the gas
                    
                    %% Classifier structure definitions
                    
                    simvar.trial(trialcount).allconn = allconnset(simvar.trial(trialcount).arch, params);
                    
                    
                    %% Loading data
                    data =  makess(length(baq(simvar.trial(trialcount).allconn))); % this breaks exectution core changes...
                    if ~strcmp(simvar.datasettype,'Ext!')
                        datasetmissing = false;
                        if ~exist(simvar.trialdatafile, 'file')&&~simvar.trial(trialcount).generatenewdataset
                            dbgmsg('There is no data on the specified location. Will generate new dataset.',1)
                            datasetmissing = true;
                        end
                        if simvar.trial(trialcount).generatenewdataset||datasetmissing
                            [allskel1, allskel2, simvar.trial(trialcount).TrainSubjectIndexes, simvar.trial(trialcount).ValSubjectIndexes] = generate_skel_data(simvar.datasettype, simvar.sampling_type, simvar.TrainSubjectIndexes, simvar.ValSubjectIndexes{valaction}, simvar.randSubjEachIteration);
                            [data.train,simvar.trial(trialcount).labels_names, params.skelldef] = all3(allskel1, simvar.trial(trialcount));
                            %                         [allskel1] = conformactions(allskel1, simvar.prefilter);
                            %                         [data.train, simvar.labels_names] = extractdata(allskel1, simvar.activity_type, simvar.labels_names,simvar.extract{:});
                            %                         [data.train, params.skelldef] = conformskel(data.train, simvar.preconditions{:});
                            %                         %does same for validation data
                            
                            %%%% for debuggin only - remove or comment
                            %%%% out!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                            %                         for newindex = 1:10
                            %                             [zskel, notzeroedaction, labact] = zeromostout(allskel1);
                            %                             simvar.notzeroedaction = notzeroedaction;
                            %                             simvar.labact = labact;
                            %                             [zdata,simvar.labels_names, params.skelldef] = all3(zskel, simvar);
                            %                         end
                            %showdataset(data,simvar)
                            %%%%
                            %%%%
                            [data.val,simvar.trial(trialcount).labels_names, ~] = all3(allskel2, simvar.trial(trialcount));
                            %                         [allskel2] = conformactions(allskel2, simvar.prefilter);
                            %                         [data.val, simvar.labels_names] = extractdata(allskel2, simvar.activity_type, simvar.labels_names,simvar.extract{:});
                            %                         [data.val, ~                ] = conformskel(data.val,   simvar.preconditions{:});
                            
                            simvar.trial(trialcount).trialdatafile = savefilesave(simvar.trialdataname, {data, simvar.trial(trialcount),params},env);
                            %save(simvar.trialdataname,'data', 'simvar','params');
                            dbgmsg('Training and Validation data saved.')
                            clear datasetmissing
                        else
                            loadedtrial = loadfileload(simvar.trialdataname,env);
                            data = loadedtrial.data;
                            params.skelldef = loadedtrial.params.skelldef;
                            simvar.trial(trialcount).generatenewdataset = false;
                        end
                        simvar.trial(trialcount).datainputvectorsize = size(data.train.data,1);
                    else
                        data = varargin{1};
                        data = data(featuress);
                        simvar.datainputvectorsize = size(data.inputs,2);
                        params.skelldef = struct('length', simvar.trial(trialcount).datainputvectorsize, 'notskeleton', true, 'awk', struct('pos', [],'vel',[]), 'pos', simvar.trial(trialcount).datainputvectorsize, 'vel', []);
                        data.train.data = data.inputs'; % not empty so that the algorithm doesnt complain
                        data.train.y = data.labelsM;
                        data.train.ends = ones(1,size(data.inputs,1));
                        data.val.data = data.inputs';
                        data.val.y = data.labelsM;
                        data.val.ends = ones(1,size(data.inputs,1));
                    end
                    %% Classifier structure definitions
                    
                    simvar.trial(trialcount).allconn = allconnset(simvar.trial(trialcount).arch, params);
                    
                    %%%%%does this look like good programming?
                    
                    
                    %% Setting up different parameters for each of parallel tria
                    % Maybe you want to do that; in case you don't, then we just
                    % use a for to put the same parameters for each.
                    a = struct([]);
                    for i = 1:simvar.P
                        simvar.trial(trialcount).paramsZ(i) = params;
                        a(i).a = struct([]);
                    end
                    
                    clear a
                    b = [];
                    
                    if ~TEST % there are so many different ways I want to test it, that this definition is pretty much pointless.
                        starttime = tic;
                        while toc(starttime)< simvar.MAX_RUNNING_TIME
                            if length(b)> simvar.MAX_NUM_TRIALS
                                break
                            end
                            if simvar.PARA
                                spmd(simvar.P)
                                    a(labindex).a = executioncore_in_starterscript(simvar.trial(trialcount),labindex, data,env);
                                end
                                %b = cat(2,b,a.a);
                                for i=1:length(a)
                                    c = a{i};
                                    a{i} = [];
                                    b = [c.a b];
                                end
                                clear a c
                                a(1:simvar.P) = struct();
                            else
                                for i = 1:simvar.P
                                    a(i).a = executioncore_in_starterscript(simvar.trial(trialcount),i, data,env);
                                end
                                b = cat(2,b,a.a);
                                clear a
                                a(1:simvar.P) = struct();
                            end
                        end
                    else
                        b = executioncore_in_starterscript(simvar.trial(trialcount),1, data,env);
                    end
                    
                    simvar.trial(trialcount).metrics = gen_cst(b); %%% it takes the important stuff from b;;; hopefully
                    if isempty(varargin)
                        
                        %%%
                        %creates a structure with the results of different trials
                        %                     env.cstfilename=strcat(env.wheretosavestuff,env.SLASH,'cst.mat');
                        %                     if exist(env.cstfilename,'file')
                        %                         loadst = load(env.cstfilename,'simvar');
                        %                         if ~isfield(loadst, 'simvar')
                        %                             warning('could not find simvar on specified file.')
                        %                         end
                        %                     end
                        %                     if ~exist('simvar','var')
                        %                         simvar = struct();
                        %                     else
                        %                         simvar(end+1).nodes = [];%cst(1);
                        %                     end
                        %
                        %                     save(strcat(env.wheretosavestuff,env.SLASH,'cst.mat'),'simvar')
                        %
                        savevar = strcat('b',num2str(simvar.trial(trialcount).NODES),'_', num2str(params.MAX_EPOCHS),'epochs',num2str(size(b,2)), simvar.sampling_type, simvar.datasettype, simvar.activity_type);
                        %eval(strcat(savevar,'=simvar;'))
                        eval(strcat(savevar,'=b;'))
                        for i = 1:length(b)
                            if isfield(b(i), 'ssvalgas')
                                if b(i).simvar.paramsZ(1).PLOTIT %%% if you ever want to have custom display, this will crash
                                    distancegraph(b(i).ssvalgas)
                                end
                            end
                        end %%%% shows me intersting possible thresholds i can use
                        simvar.savesave = savefilesave(savevar, eval(savevar),env);
                        %simvar.savesave = savefilesave(savevar,'b');
                        
                        %             simvar.savesave = strcat(env.wheretosavestuff,env.SLASH,savevar,'.mat');
                        %             ver = 1;
                        %
                        %             while exist(simvar.savesave,'file')
                        %                 simvar.savesave = strcat(env.wheretosavestuff,env.SLASH,savevar,'[ver(',num2str(ver),')].mat');
                        %                 ver = ver+1;
                        %             end
                        %             save(simvar.savesave,savevar)
                        dbgmsg('Trial saved in: ',simvar.savesave,1)
                    end
                end
                clear b
            end
        end
    end
end
end
function allconn = allconnset(n, params)
allconn_set = {...
    {... %%%% ARCHITECTURE 1
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params}...
    }...
    {...%%%% ARCHITECTURE 2
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 2],params}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 2],params}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 2],params}...
    }...
    {...%%%% ARCHITECTURE 3
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 0],params}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 0],params}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 0],params}...
    }...
    {...%%%% ARCHITECTURE 4
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 0],params}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 0],params}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 0],params}...
    }...
    {...%%%% ARCHITECTURE 5
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 2 3],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 2 3],params}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params}...
    }...
    {...%%%% ARCHITECTURE 6
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 4 2],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 4 2],params}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params}...
    }...
    {...%%%% ARCHITECTURE 7
    {'gwr1layer',   'gwr',{'all'},                    'all',[3 2], params}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'all',[3 2], params}...
    }...
    {...%%%% ARCHITECTURE 8
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[9 0], params}... %% now there is a vector where q used to be, because we have the p overlap variable...
    }...
    {...%%%% ARCHITECTURE 9
    {'gwr1layer',   'gwr',{'pos'},                    'pos',3,params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',3,params}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',3,params}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',3,params}...
    {'gwr5layer',   'gwr',{'gwr3layer'},              'pos',3,params}...
    {'gwr6layer',   'gwr',{'gwr4layer'},              'vel',3,params}...
    {'gwrSTSlayer', 'gwr',{'gwr6layer','gwr5layer'},  'all',3,params}
    }...
    {... %%%% ARCHITECTURE 10
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params}...
    }...
    {... %%%% ARCHITECTURE 11
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 2],params}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 2],params}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[1 0],params}...
    }...
    {... %%%% ARCHITECTURE 12
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'pos',[9 0],params}...
    }...
    };
allconn = allconn_set{n};
end
function a = executioncore_in_starterscript(simvar, i, data,env)
paramsZ = simvar.paramsZ(i);
allconn = simvar.allconn;

global TEST
n = randperm(size(data.train.data,2)-3,2); % -(q-1) necessary because concatenation reduces the data size!
paramsZ.startingpoint = [n(1) n(2)];
pallconn = allconn;
pallconn{1,1}{1,6} = paramsZ; % I only change the initial points of the position gas
%pallconn{1,3}{1,6} = paramsZ; %but I want the concatenation to reflect the same position that I randomized. actually this is not going to happen because of the sliding window scheme
%pallconn{1,4}{1,6} = pallconn{1,2}{1,6};

%[a.sv, a.mt] = starter_sc(data, pallconn, 1);
if TEST
    dbgmsg('TEST RUN. Generating sham output data. Data will not be saved.',1)
    confconf = struct('val','val', 'train', '');
    ouout = struct('accumulatedepochs',0);
    for i =1:4
        for j =1:5
            a.mt(i,j) = struct('conffig', 'hello','confusions', confconf,'conffvig', 'hello','outparams',ouout);
        end
    end
    
else
    %%%WE ARE RUNNING OUT OF MEMORY TOO OFTEN. WILL NO LONGER STORE SS
    %[ss, a.mt, gases] = starter_sc(data, baq(pallconn));
    ss = struct();
    [~, a.mt, gases] = starter_sc(data, baq(pallconn));    
    
    if isfield(ss, 'val')&&isfield(ss.val, 'gas')
        a.ssvalgas = ss.val.gas;    
        distancegraph(ss.val.gas)
    end
    simvar.env = env;
    
    a.gases = gases;
    for jj = size(gases,2) %%%% I was running out of memory, so this had to be made
        gases(jj).fig = struct();
    end
    a.allconn = baq(pallconn);
    a.simvar = simvar;
    %save(savefilesave2('realclassifier', env),'realclass')
    %[~, something_to_classify] = realvideo(realclass.outstruct, realclass.allconn, realclass.simvar,0);
    % realvideo(outstruct, baq(pallconn), simvar);
    
    %%online_classifier(chunkchunk, outstruct, baq(pallconn), simvar);
end
end

