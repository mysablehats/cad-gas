function simvar = classifier_loop(simvar,params, varargin)
asmvar = simvar;
%% Begin loop
trialcount = 0;
for architectures = simvar.ARCH_VECT
    for NODES = simvar.NODES_VECT
        for MAX_EPOCHS = simvar.MAX_EPOCHS_VECT
            for featuress = 1:simvar.featuresall
                
                
                for valaction = 1:length(simvar.Alldata) %% iterate over different validation data
                    if strcmp(simvar.validationtype,'type2')||strcmp(simvar.validationtype,'type2notrandom')||strcmp(simvar.validationtype,'type2all')
                        
                        simvar.ValSubjectIndexes = valaction;
                        simvar.TrainSubjectIndexes = setdiff(1:4,[simvar.ValSubjectIndexes]);
                    else
                        
                        simvar.TrainSubjectIndexes = [];%[];%'loo';%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
                        simvar.ValSubjectIndexes = valaction;%num2cell(1:68);%, [2]};%[1,2,7];%% comment these out to have random new samples
                    end
                    
                    trialcount = trialcount +1;
                    if NODES ==100000 && (simvar.MAX_EPOCHS==1||simvar.MAX_EPOCHS==1)
                        dbgmsg('Did this already',1)
                        break
                    end
                    %%%% OK, here, so that you don't make any more
                    %%%% mistakes, simvar changed, so you have to reassign
                    %%%% the parameters here.
                    simvar.trial(trialcount) = asmvar;%% does this solve
                    %the problem?
                    %                     simvar.trial(trialcount).disablesconformskel = simvar.disablesconformskel;
                    %                     simvar.trial(trialcount).arch = architectures;
                    %                     simvar.trial(trialcount).NODES =  NODES;
                    %                     simvar.trial(trialcount).MAX_EPOCHS = MAX_EPOCHS;
                    %                     simvar.trial(trialcount).prefilter = simvar.prefilter;
                    %                     simvar.trial(trialcount).extract = simvar.extract;
                    %                     simvar.trial(trialcount).activity_type = simvar.activity_type;
                    %                     simvar.trial(trialcount).labels_names = simvar.labels_names;
                    %                     simvar.trial(trialcount).generatenewdataset = simvar.generatenewdataset;
                    params.MAX_EPOCHS = MAX_EPOCHS;% simvar.trial(trialcount).MAX_EPOCHS;
                    params.nodes = NODES;%simvar.trial(trialcount).NODES; %maximum number of nodes/neurons in the gas
                    
                  
                    
                    %% Loading data
                    data =  makess(length(baq(allconnset(architectures, [])))); % I need to know the length of architectures...
                    if ~strcmp(simvar.datasettype,'Ext!')
                        datasetmissing = false;
                        if ~exist(simvar.trialdatafile, 'file')&&~simvar.trial(trialcount).generatenewdataset
                            dbgmsg('There is no data on the specified location. Will generate new dataset.',1)
                            datasetmissing = true;
                        end
                        if simvar.trial(trialcount).generatenewdataset||datasetmissing
                            [allskel1, allskel2, simvar.trial(trialcount).TrainSubjectIndexes, simvar.trial(trialcount).ValSubjectIndexes] = generate_skel_data(simvar.datasettype, simvar.sampling_type, simvar.TrainSubjectIndexes, simvar.ValSubjectIndexes, simvar.randSubjEachIteration);
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
                            
                            simvar.trial(trialcount).trialdatafile = savefilesave(simvar.trialdataname, {data, simvar.trial(trialcount),params},simvar.env);
                            %save(simvar.trialdataname,'data', 'simvar','params');
                            dbgmsg('Training and Validation data saved.')
                            clear datasetmissing
                        else
                            loadedtrial = loadfileload(simvar.trialdataname,simvar.env);
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
                    
                    paramsP = repmat(params,5,1);
                    
                    %%% we need to enable the gas distance for first and
                    %%% second layers only
                    paramsP(1).distancetype.source = 'gas'; % or 'ext'
                    paramsP(2).distancetype.source = 'gas'; % or 'ext'
                    paramsP(1).at = 0.99983; %activity threshold
                    paramsP(2).at = 0.99999; %activity threshold
                    paramsP(3).at = 0.99995; %activity threshold
                    paramsP(4).at = 0.999998; %activity threshold
                    paramsP(5).at = 0.99999; %activity threshold
                    
                    simvar.trial(trialcount).allconn = allconnset(architectures, paramsP);
                    
                    %%%%%does this look like good programming?
                    
                    
                    %% Setting up different parameters for each of parallel trial
                    % Maybe you want to do that; in case you don't, then we just
                    % use a for to put the same parameters for each.
                    a = struct([]);
                    paramsZ = repmat(paramsP,1,simvar.P);
                    for i = 1:simvar.P
                        %paramsZ(i) = params;
                        a(i).a = struct([]);                        
                                             
                        n = randperm(size(data.train.data,2),2); 
                        paramsZ(1,i).startingpoint = [n(1) n(2)];
                        simvar.trial(trialcount).allconn{1,1}{1,6} = paramsZ(i); % I only change the initial points of the position gas
                        %pallconn{1,3}{1,6} = paramsZ; %but I want the concatenation to reflect the same position that I randomized. actually this is not going to happen because of the sliding window scheme
                        %pallconn{1,4}{1,6} = pallconn{1,2}{1,6};
                        arq_connect(i,:) = baq(simvar.trial(trialcount).allconn);
                        
                    end

                    
                    clear a
                    b = [];
                    
                    
                    starttime = tic;
                    while toc(starttime)< simvar.MAX_RUNNING_TIME
                        if length(b)> simvar.MAX_NUM_TRIALS
                            break
                        end
                        if simvar.PARA
                            spmd(simvar.P)
                                a(labindex).a = executioncore_in_starterscript(simvar.trial(trialcount), arq_connect(labindex,:), data);
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
                                a(i).a = executioncore_in_starterscript(simvar.trial(trialcount), arq_connect(i,:), data);
                            end
                            b = cat(2,b,a.a);
                            clear a
                            a(1:simvar.P) = struct();
                        end
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
                        %savevar = strcat('b',num2str(NODES),'_', num2str(params.MAX_EPOCHS),'epochs',num2str(size(b,2)), simvar.sampling_type, simvar.datasettype, simvar.activity_type);
                        %eval(strcat(savevar,'=simvar;'))
                        %eval(strcat(savevar,'=b;'))
                        for i = 1:length(b)
                            if isfield(b(i), 'ssvalgas')
                                if paramsZ(1).PLOTIT %%% if you ever want to have custom display, this will crash
                                    distancegraph(b(i).ssvalgas)
                                end
                            end
                        end %%%% shows me intersting possible thresholds i can use
                        %simvar.savesave = savefilesave(savevar, eval(savevar),simvar.env);
                        %simvar.savesave = savefilesave(savevar,'b');
                        
                        %             simvar.savesave = strcat(env.wheretosavestuff,env.SLASH,savevar,'.mat');
                        %             ver = 1;
                        %
                        %             while exist(simvar.savesave,'file')
                        %                 simvar.savesave = strcat(env.wheretosavestuff,env.SLASH,savevar,'[ver(',num2str(ver),')].mat');
                        %                 ver = ver+1;
                        %             end
                        %             save(simvar.savesave,savevar)
                        %dbgmsg('Trial saved in: ',simvar.savesave,1)
                    end
                end
                clear b
            end
        end
    end
end
end
function allconn = allconnset(n, paramsI)

if isempty(paramsI)
    params = repmat(struct,10);
else
    params = repmat(paramsI(1),10);
end
for i=1:length(paramsI)
    params(i) = paramsI(i);
end
allconn_set = {...
    {... %%%% ARCHITECTURE 1
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 2
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params(1)}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params(2)}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 2],params(3)}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 2],params(4)}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 3
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params(1)}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params(2)}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 0],params(3)}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 0],params(4)}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 0],params(5)}...
    }...
    {...%%%% ARCHITECTURE 4
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 0],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 0],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 0],params(5)}...
    }...
    {...%%%% ARCHITECTURE 5
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 2 3],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 2 3],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 6
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 4 2],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 4 2],params(2)}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params(3)}...
    }...
    {...%%%% ARCHITECTURE 7
    {'gwr1layer',   'gwr',{'all'},                    'all',[3 2], params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'all',[3 2], params(2)}...
    }...
    {...%%%% ARCHITECTURE 8
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[9 0], params(1)}... %% now there is a vector where q used to be, because we have the p overlap variable...
    }...
    {...%%%% ARCHITECTURE 9
    {'gwr1layer',   'gwr',{'pos'},                    'pos',3,params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',3,params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',3,params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',3,params(4)}...
    {'gwr5layer',   'gwr',{'gwr3layer'},              'pos',3,params(5)}...
    {'gwr6layer',   'gwr',{'gwr4layer'},              'vel',3,params(6)}...
    {'gwrSTSlayer', 'gwr',{'gwr6layer','gwr5layer'},  'all',3,params(7)}
    }...
    {... %%%% ARCHITECTURE 10
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params(3)}...
    }...
    {... %%%% ARCHITECTURE 11
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 2],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 2],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[1 0],params(5)}...
    }...
    {... %%%% ARCHITECTURE 12
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'pos',[9 0],params(2)}...
    }...
    {... %%%% ARCHITECTURE 13
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'vel',[9 0],params(2)}...
    }...
    {... %%%% ARCHITECTURE 14
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],params(1)}...
    }...
    {... %%%% ARCHITECTURE 15
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[2 1],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[2 1],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[4 3],params(5)}...
    }...
    {... %%%% ARCHITECTURE 16
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    }...
    };
allconn = allconn_set{n};
end

function a = executioncore_in_starterscript(simvar, arq_connect, ss)

%gases = [];
%% executioncore
% This is the main function to run the chained classifier, label and
% generate confusion matrices and recall, precision and F1 values for the
% skeleton classifier of activities using an architecture of chained neural
% gases on skeleton activities data (the STS V2 Dataset). This work is an
% attempt to implement Parisi, 2015's paper.

%%

%%% making metrics structure

metrics = struct('confusions',[],'conffig',[],'outparams',[]);

whatIlabel = 1:length(ss.gas); %change this series for only the last value to label only the last gas

%%% end of gas structures region

[ss.gas, ss.train] = sameclassfunc(ss.gas, ss.train, 'train', whatIlabel, arq_connect);
[ss.gas, ss.val] = sameclassfunc(ss.gas, ss.val, 'val', whatIlabel, arq_connect);
for j = 1:length(arq_connect)
        metrics(j).outparams = ss.gas(j).outparams;
end
%% Displaying multiple confusion matrices for GWR and GNG for nodes
% This part creates the matrices that can later be shown with the
% plotconfusion() function.

[ss, metrics] = plotconfmaker(ss, metrics,whatIlabel);


%% Actual display of the confusion matrices:
metitems = [];
for j = whatIlabel
    if arq_connect(j).params.PLOTIT
        metitems = [metitems j*arq_connect(j).params.PLOTIT];
    end
end
if ~isempty(metitems)
    figure
    plotconf(metrics(metitems));
end
%plotconf(ss.figset{:})
if isfield(ss.gas(end).fig, 'val')&&~isempty(ss.gas(end).fig.val)
    figure
    plotconfusion(ss.gas(end).fig.val{:});
end

%% Displaying this nifty distance graph to see if thresholds would make my life easier, they don't
if isfield(ss, 'val')&&isfield(ss.val, 'gas')
    a.ssvalgas = ss.val.gas;
    distancegraph(ss.val.gas);
end


%% setting output variables
%simvar.env = env;
a.mt = metrics;
a.gases = ss.gas;
a.allconn = arq_connect;
a.simvar = simvar;

% if clearmemory
%     ss = struct();
%     for jj = size(gases,2) %%%% I was running out of memory, so this had to be made
%         gases(jj).fig = struct();
%     end
%     
% end

%save(savefilesave2('realclassifier', env),'realclass')
%[~, something_to_classify] = realvideo(realclass.outstruct, realclass.allconn, realclass.simvar,0);
% realvideo(outstruct, baq(pallconn), simvar);

%%online_classifier(chunkchunk, outstruct, baq(pallconn), simvar);
end


