function simvar = setsimvar(varargin)

simvar = struct();

% set other additional simulation variables

simvar.PARA = 0;
if simvar.PARA
    simvar.P = feature('numCores');
else
    simvar.P = 1;
end

simvar.env = aa_environment; % load environment variables

% Each trial is trained on freshly partitioned/ generated data, so that we
% have an unbiased understanding of how the chained-gas is classifying.
%
% They are generated in a way that you can use nnstart to classify them and
% evaluated how much better (or worse) a neural network or some other
% algorithm can separate these datasets. Also, the data for each action
% example has different length, so the partition of datapoints is not
% equitative (there will be some fluctuation in the performance of putting
% every case in one single bin) and it will not be the same in validation
% and training sets. So in case this is annoying to you and you want to run
% always with a similar dataset, set
% simvar.generatenewdataset = false

simvar.validationtype = 'type2all'; %'type2notrandom';
simvar.pc = 999;
switch simvar.validationtype
    case 'wholeset'        
        simvar.Alldata = 1:68;
    case 'cluster'
        pcspecs = load([simvar.env.homepath simvar.env.SLASH '..' simvar.env.SLASH 'clust.mat']);
        simvar.Alldata = pcspecs.idxs;
        simvar.pc = pcspecs.pcid;
    case 'quarterset'
        simvar.Alldata = (1:17)+17*(randi(4,1,17)-1);
    case 'type2'
        simvar.Alldata = randperm(4,1);
    case 'type2notrandom'
        simvar.Alldata = 3;     
    case 'type2all'
        simvar.Alldata = 1:4;
end

%this probably should be a class
simvar.datainputvectorsize = [];
simvar.allconn = [];
simvar.TrainSubjectIndexes = [];
simvar.ValSubjectIndexes = []; 
%simvar.paramsZ(length(simvar.P)) = [];
simvar.metrics = struct;

simvar.disablesconformskel = 0;
%% Choose dataset
if isempty(varargin)
    simvar.featuresall = 1;
    simvar.realtimeclassifier = false;
    simvar.generatenewdataset = 1; %true;
    simvar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
    simvar.activity_type = 'act_type'; %'act_type' or 'act'
    simvar.prefilter = {'filter', 15};%{'filter',10}; % 'filter', 'none', 'median?'
    simvar.normrepair = true;
    simvar.affinerepair = false;%true;
    simvar.affrepvel = true;
    simvar.labels_names = []; % necessary so that same actions keep their order number
    if strcmp(simvar.validationtype,'type2')||strcmp(simvar.validationtype,'type2notrandom')||strcmp(simvar.validationtype,'type2all')
        simvar.sampling_type = 'type2';
        %simvar.ValSubjectIndexes = {alldata};
        %simvar.TrainSubjectIndexes = setdiff(1:4,[simvar.ValSubjectIndexes{:}]);
    else
        simvar.sampling_type = 'type1';
        %simvar.TrainSubjectIndexes = [];%[];%'loo';%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
        %simvar.ValSubjectIndexes = {alldata};%num2cell(1:68);%, [2]};%[1,2,7];%% comment these out to have random new samples
    end
    simvar.randSubjEachIteration = false; %%% must be set to false for systematic testing
    simvar.extract = {'rand', 'wantvelocity','order',{'removeaction','still','random'}};
    simvar.preconditions =  {'nohips'};%{'nohips', 'mirrorx'};% {'nohips', 'mirrorz', 'mirrorx'}; %,'normal'};%{'nohips', 'norotatehips' ,'mirrorx'}; %,
    simextractname = [simvar.extract{:}];
    simvar.trialdataname = strcat('skel',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',[simvar.prefilter{1} num2str(simvar.prefilter{2})], [simextractname{:}],[simvar.preconditions{:}]);
    simvar.trialdatafile = strcat(simvar.env.wheretosavestuff,simvar.env.SLASH,simvar.trialdataname,'.mat');
    simvar.allmatpath = simvar.env.allmatpath;
else
    simvar.featuresall = 3;%size(varargin{1},2);
    simvar.generatenewdataset = false;
    simvar.datasettype = 'Ext!';
    simvar.sampling_type = '';
    simvar.activity_type = ''; %'act_type' or 'act'
    simvar.prefilter = 'none'; % 'filter', 'none', 'median?'
    simvar.labels_names = []; % necessary so that same actions keep their order number
    simvar.TrainSubjectIndexes = [];%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
    simvar.ValSubjectIndexes = [];%[1,2,7];%% comment these out to have random new samples
    simvar.randSubjEachIteration = true;
    simvar.extract = {''};
    simvar.preconditions = {''};
    simvar.trialdataname = strcat('other',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',simvar.prefilter, [simvar.extract{:}],[simvar.preconditions{:}]);
    simvar.trialdatafile = strcat(simvar.env.wheretosavestuff,simvar.env.SLASH,simvar.trialdataname,'.mat');
end

%% Setting up runtime variables


simvar.NODES_VECT = [1000];
simvar.MAX_EPOCHS_VECT = [10];
simvar.ARCH_VECT = [1];
simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

end