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

%% parsc

%%%% init
%%% for knn
allc.parsc.knn.k = 1; % default value
allc.parsc.knn.other = {};
%   allc.parsc.knn.other = {'''Distance'',''hamming'''}; %use a hamming distance because pose 1 and 13 differ as much as 1 and 2
%   allc.parsc.knn.other = {'''Distance'',@dtw'};
%%% for svm
%   allc.parsc.svm.kernel = 'linear';
allc.parsc.svm.kernel = 'gaussian';
allc.parsc.svm.other = {};

%%%% layerdefs
% this is problematic, but I will fix it when the problem comes
allc.parsc.maxlayernums = 10;
%%% insert custom definitions for each layer below here
%allc.parsc1.knn.other = {'''Distance'',@flipper'};
%parsc2.knn.other = {'''Distance'',@dtw_wrapper'};
allc.parsc2.svm.kernel = '''gaussian''';

%% parsk

allc.params.normdim = false; %% if true normalize the distance by the number of dimensions
allc.params.distancetype.source = 'gas'; % 'gas' or 'ext'
allc.params.distancetype.metric = 'euclidean';%'3dsum'; %either '3dsum' or 'euclidean'
allc.params.distancetype.noaffine = true; %if false will correct affine transformations on the distance function as well. Quite slow - if on ext.
allc.params.distancetype.cum = false;
allc.params.distance.simple = true; %if false will rotate stuff around to a better position. TO DO: all these distances have to be condensed into a single thing...
allc.params.flippoints = false;

allc.params.layertype = '';
allc.params.MAX_EPOCHS = [];
allc.params.removepoints = true;
allc.params.oldremovepoints = false;
allc.params.startdistributed = false;
allc.params.RANDOMSTART = false; % if true it overrides the .startingpoint variable
allc.params.RANDOMSET = false; %true; % if true, each sample (either alone or sliding window concatenated sample) will be presented to the gas at random
allc.params.savegas.resume = false; % do not set to true. not working
allc.params.savegas.save = false;
%allc.params.savegas.path = simvar.env.wheretosavestuff;
allc.params.savegas.parallelgases = true;
allc.params.savegas.parallelgasescount = 0;
allc.params.savegas.accurate_track_epochs = true;
%allc.params.savegas.P = simvar.P;
allc.params.startingpoint = [1 2];
allc.params.amax = 50; %greatest allowed age
allc.params.nodes = []; %maximum number of nodes/neurons in the gas
allc.params.numlayers = []; %%% will depend on the architecture used in simvar.
allc.params.en = 0.006; %epsilon subscript n
allc.params.eb = 0.2; %epsilon subscript b
allc.params.gamma = 4; % for the denoising function

allc.params.PLOTIT = false;
allc.params.plottingstep = 0; % zero will make it plot only every epoch
allc.params.plotonlyafterallepochs = true;

allc.params.alphaincrements.run = false;
allc.params.alphaincrements.zero = 0;
allc.params.alphaincrements.inc = 1;
allc.params.alphaincrements.threshold = 0.9;
allc.params.multigas = false; %%%% creates a different gas for each action sequence. at least it is faster.

%Exclusive for gwr
allc.params.STATIC = true;
%allc.params.at = 0.999832929230424; %activity threshold
allc.params.at = 0.95; %activity threshold
allc.params.h0 = 1;
allc.params.ab = 0.95;
allc.params.an = 0.95;
allc.params.tb = 3.33;
allc.params.tn = 3.33;

%Exclusive for gng
allc.params.age_inc                  = 1;
allc.params.lambda                   = 3;
allc.params.alpha                    = .5;     % q and f units error reduction constant.
allc.params.d                           = .995;   % Error reduction factor.

%Exclusive for SOM
allc.params.nodesx = 8;
allc.params.nodesy = 8;

%Labelling exclusive variables
allc.params.label.tobelabeled = true; % not used right now, to substitute whatIlabel
allc.params.label.prototypelabelling = @altlabeller; % @labeling is the old version
allc.params.label.classlabelling = @fitcknn;

%% parsk layerdefs

allc.params.layerdefsnum = 10;

  %%% we need to enable the gas distance for first and
        %%% second layers only
        
%         params(1).distancetype.source = 'gas'; % or 'ext'
%         params(2).distancetype.source = 'gas'; % or 'ext'
%         params(1).at = 0.0099983; %activity threshold
%         params(2).at = 0.0099999; %activity threshold
%         params(3).at = 0.0099995; %activity threshold
%         params(4).at = 0.00999998; %activity threshold
%         params(5).at = 0.0099999; %activity threshold

end