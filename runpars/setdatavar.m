function datavar = setdatavar(varargin)

datavar = Datavar({'validationtype' 'type2all'});

%starts the dataset and do the preconditioning and feature selection.

datavar.validationtype = 'type2all'; %'type2notrandom'; 'cluster' 'quarterset' 'type2' 'type2notrandom' 'type2all'

%% Choose dataset
if isempty(varargin)
    datavar.AllSubjects = [1 2 3 4]; %% I will exclude the trouble boy...
    datavar.disablesconformskel = 0;
    datavar.generatenewdataset = false; %true;
    datavar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
    datavar.activity_type = 'act_type'; %'act_type' or 'act'
    datavar.prefilter = {'filter', 15};%{'filter',10}; % 'filter', 'none', 'median?'
    datavar.normrepair = true;
    datavar.affinerepair = false;
    datavar.affrepvel = true;
    datavar.randSubjEachIteration = false; %%% must be set to false for systematic testing
    datavar.extract = {'rand', 'wantvelocity','order',{'removeaction','still','random'}};
    datavar.preconditions =  {'nohips', 'mirrorx'};% {'nohips'};% {'nohips', 'mirrorz', 'mirrorx'}; %,'normal'};%{'nohips', 'norotatehips' ,'mirrorx'}; %,

else
    datavar.featuresall = 3;%size(varargin{1},2);

end

datavar = datavar.init;
end