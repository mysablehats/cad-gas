function allc = allconfigs()
%% datavar

allc.datavar.init = {'validationtype' 'type2all'};

%starts the dataset and do the preconditioning and feature selection.

allc.datavar.validationtype = 'type2all'; %'type2notrandom'; 'cluster' 'quarterset' 'type2' 'type2notrandom' 'type2all'

allc.datavar.AllSubjects = [1 2 3 4];%2 %[1 2 3 4]; %%
allc.datavar.disablesconformskel = 0;
allc.datavar.generatenewdataset = false; %true;
allc.datavar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
allc.datavar.activity_type = 'act_type'; %'act_type' or 'act'
allc.datavar.prefilter = {'none', 15};%{'filter',10}; % 'filter', 'none', 'median?'
allc.datavar.normrepair = false;
allc.datavar.affinerepair = false;
allc.datavar.affrepvel = false;
allc.datavar.randSubjEachIteration = false; %%% must be set to false for systematic testing
allc.datavar.extract = {'rand', 'wantvelocity','order'};
allc.datavar.featuresall = 3;

%% runpars

allc.runpar.method = 'compressors';
allc.runpar.scene = {'or'};% {'bathroom'};% {'bathroom','bedroom','kitchen','livingroom','office'} ; %{'or'}; %{'all'};
allc.runpar.precon = 'pap';% 'pap';%'pop';% 'cip';
allc.runpar.savesimvar = false;

%% simvar

%%% sets the running parameters for the classifier.

allc.simvar.init = {'PARA' 1};

allc.simvar.NODES_VECT = [35];
allc.simvar.MAX_EPOCHS_VECT = [1];
allc.simvar.ARCH_VECT = [22];

allc.simvar.MAX_NUM_TRIALS = 1;
allc.simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

end