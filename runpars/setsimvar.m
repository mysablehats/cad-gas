function simvar = setsimvar(varargin)

simvar = Simvar({'PARA' 0}, {'validationtype' 'type2all'});

% set other additional simulation variables



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

simvar.validationtype = 'type2all'; %'type2notrandom'; 'cluster' 'quarterset' 'type2' 'type2notrandom' 'type2all'

%% Choose dataset
if isempty(varargin)
    simvar.disablesconformskel = 0;
    simvar.generatenewdataset = 1; %true;
    simvar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
    simvar.activity_type = 'act_type'; %'act_type' or 'act'
    simvar.prefilter = {'filter', 15};%{'filter',10}; % 'filter', 'none', 'median?'
    simvar.normrepair = true;
    simvar.affinerepair = false;%true;
    simvar.affrepvel = true;
    simvar.randSubjEachIteration = false; %%% must be set to false for systematic testing
    simvar.extract = {'rand', 'wantvelocity','order',{'removeaction','still','random'}};
    simvar.preconditions =  {'nohips'};%{'nohips', 'mirrorx'};% {'nohips', 'mirrorz', 'mirrorx'}; %,'normal'};%{'nohips', 'norotatehips' ,'mirrorx'}; %,

else
    simvar.featuresall = 3;%size(varargin{1},2);

end

%% Setting up runtime variables


simvar.NODES_VECT = [100];
simvar.MAX_EPOCHS_VECT = [1];
simvar.ARCH_VECT = [1];

simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

simvar = simvar.init;
end