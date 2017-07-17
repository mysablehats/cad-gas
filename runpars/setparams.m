function params = setparams(simvar)
% set parameters for gas:
params.normdim = true; %% if true normalize the distance by the number of dimensions 
params.distancetype.source = 'ext'; % or 'ext'
params.distancetype.metric = 'euclidean';%'3dsum'; %either '3dsum' or 'euclidean' 
params.distancetype.noaffine = true; %if false will correct affine transformations on the distance function as well. Quite slow
params.layertype = '';
params.MAX_EPOCHS = [];
params.removepoints = true;
params.oldremovepoints = false;
params.PLOTIT = true;
params.RANDOMSTART = true; % if true it overrides the .startingpoint variable
params.RANDOMSET = false; %true; % if true, each sample (either alone or sliding window concatenated sample) will be presented to the gas at random
params.savegas.resume = false; % do not set to true. not working
params.savegas.save = false;
params.savegas.path = simvar.env.wheretosavestuff;
params.savegas.parallelgases = true;
params.savegas.parallelgasescount = 0;
params.savegas.accurate_track_epochs = true;
params.savegas.P = simvar.P;
params.startingpoint = [1 2];
params.amax = 50; %greatest allowed age
params.nodes = []; %maximum number of nodes/neurons in the gas
params.en = 0.006; %epsilon subscript n
params.eb = 0.2; %epsilon subscript b
params.gamma = 4; % for the denoising function
params.plottingstep = 0; % zero will make it plot only the end-gas
params.flippoints = true;

%Exclusive for gwr
params.STATIC = true;
params.at = 0.999832929230424; %activity threshold
params.h0 = 1;
params.ab = 0.95;
params.an = 0.95;
params.tb = 3.33;
params.tn = 3.33;

%Exclusive for gng
params.age_inc                  = 1;
params.lambda                   = 3;
params.alpha                    = .5;     % q and f units error reduction constant.
params.d                           = .995;   % Error reduction factor.
end