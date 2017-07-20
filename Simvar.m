classdef Simvar
    properties
        PARA
        P
        env
        validationtype
        sampling_type
        pc
        Alldata
        datainputvectorsize
        allconn
        TrainSubjectIndexes
        ValSubjectIndexes
        metrics
        featuresall
        realtimeclassifier
        disablesconformskel
        generatenewdataset
        datasettype
        activity_type
        prefilter
        normrepair
        affinerepair
        affrepvel
        labels_names
        randSubjEachIteration
        extract
        preconditions
        trialdataname
        trialdatafile
        allmatpath
        NODES_VECT
        MAX_EPOCHS_VECT
        ARCH_VECT
        MAX_NUM_TRIALS
        MAX_RUNNING_TIME
    end
    methods
        function simvar = Simvar(varargin)
            simvar.featuresall = 1;
            simvar.realtimeclassifier = false;
            simvar.PARA = 1;
            simvar = simvar.updateparallelprocessors;
            
            simvar.env = aa_environment; % load environment variables
            simvar.datainputvectorsize = [];
            simvar.allconn = [];
            simvar.TrainSubjectIndexes = [];
            simvar.ValSubjectIndexes = [];
            %simvar.paramsZ(length(simvar.P)) = [];
            simvar.metrics = struct;
            simvar.labels_names = []; % necessary so that same actions keep their order number
            simvar.disablesconformskel = 0;
            simvar.pc = 999;
            simvar.metrics = struct;
            
            simvar.generatenewdataset = false;
            simvar.datasettype = 'Ext!';
            simvar.sampling_type = '';
            simvar.activity_type = ''; %'act_type' or 'act'
            simvar.prefilter = {'none' 0}; % 'filter', 'none', 'median?'
            simvar.labels_names = []; % necessary so that same actions keep their order number
            simvar.TrainSubjectIndexes = [];%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
            simvar.ValSubjectIndexes = [];%[1,2,7];%% comment these out to have random new samples
            simvar.randSubjEachIteration = true;
            simvar.extract = {''};
            simvar.preconditions = {''};
            simvar.trialdataname = strcat('other',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',simvar.prefilter, [simvar.extract{:}],[simvar.preconditions{:}]);
            simvar.trialdatafile = strcat(simvar.env.wheretosavestuff,simvar.env.SLASH,simvar.trialdataname,'.mat');
            
            simvar.NODES_VECT = [3]; %%% minimum number is 3
            simvar.MAX_EPOCHS_VECT = [1];
            simvar.ARCH_VECT = [1];
            simvar.MAX_NUM_TRIALS = 1;
            simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this
            
            
            if nargin>0
                for i = 1:nargin
                    switch varargin{i}{1}
                        case 'PARA'
                            simvar.PARA = varargin{i}{2};
                            simvar = simvar.updateparallelprocessors;
                        case 'validationtype'
                            simvar.validationtype = varargin{i}{2};
                            simvar = simvar.updatevalidationtype;
                    end
                end
            end
        end
        function simvar = updateparallelprocessors(simvar)
            if simvar.PARA
                simvar.P = feature('numCores');
            else
                simvar.P = 1;
            end
            
        end
        function simvar = updatevalidationtype(simvar)
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
            if strcmp(simvar.validationtype,'type2')||strcmp(simvar.validationtype,'type2notrandom')||strcmp(simvar.validationtype,'type2all')
                simvar.sampling_type = 'type2';
                %simvar.ValSubjectIndexes = {alldata};
                %simvar.TrainSubjectIndexes = setdiff(1:4,[simvar.ValSubjectIndexes{:}]);
            else
                simvar.sampling_type = 'type1';
                %simvar.TrainSubjectIndexes = [];%[];%'loo';%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
                %simvar.ValSubjectIndexes = {alldata};%num2cell(1:68);%, [2]};%[1,2,7];%% comment these out to have random new samples
            end
        end
        function simvar = updatesavenames(simvar)
            simextractname = [simvar.extract{:}];
            simvar.trialdataname = strcat('skel',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',[simvar.prefilter{1} num2str(simvar.prefilter{2})], [simextractname{:}],[simvar.preconditions{:}]);
            simvar.trialdatafile = strcat(simvar.env.wheretosavestuff,simvar.env.SLASH,simvar.trialdataname,'.mat');
            simvar.allmatpath = simvar.env.allmatpath;
        end
        function simvar = init(simvar)
            simvar = simvar.updatevalidationtype;
            simvar = simvar.updateparallelprocessors;
            simvar = simvar.updatesavenames;
        end
        function confusions = showmetrics(simvar)
            confusions = plotconf(simvar.metrics);
            function confusions = plotconf(mt)
                %%% Reads metrics structure, loading targets and outputs and shows
                %%% confusion matrices, as well as display some nice
                %
                if size(mt,1)~=1
                    error('cannot deal well with multiply dimensions. What do you want me to do?')
                end
                
                al = length(mt);
                if isfield(mt(1).conffig, 'val')&&~isempty(mt(1).conffig.val)
                    figset = cell(6*al,1);
                    for i = 1:al
                        figset((i*6-5):i*6) = [mt(i).conffig.val mt(i).conffig.train];
                    end
                else
                    figset = cell(3*al,1);
                    for i = 1:al
                        figset((i*3-2):i*3) = mt(i).conffig.train;
                    end
                    
                end
                %%%%%%%%%%%% ->>>>> uncomment to show!
                %plotconfusion(figset{:})
                %%%%%%%%%%%% ->>>>> uncomment to show!
                confusions.a = zeros(size(figset{1},1), size(figset{1},1),size(mt,2));
                confusions.b = confusions.a;
                for i=1:size(figset,1)/6
                    index = (i-1)*6 +1;
                    [~, confusions.a(:,:,i)] = confusion(figset{index}, figset{index+1});
                    [~, confusions.b(:,:,i)] = confusion(figset{index+3}, figset{index+4});
                end
                cc.b = confusions.a;
                disp('validation')
                analyze_outcomes(cc)
                disp('training')
                analyze_outcomes(confusions)
            end
        end
        function [endacc, combinedval] = analyze_outcomes(simvartrial)
            combsize = [size(simvartrial(1).metrics(1, 1).val) size(simvartrial(1).metrics,2)];
            combinedval = zeros(combsize);
            for i=1:size(simvartrial,2)
                for gaslayer = 1: size(simvartrial(1).metrics,2)
                    for worker =1:size(simvartrial(1).metrics,1)
                        combinedval(:,:,gaslayer) = simvartrial(i).metrics(worker, gaslayer).val + combinedval(:,:,gaslayer);
                    end
                end
            end
            endaccsize = size(simvartrial(1).metrics,2);
            endacc = zeros(endaccsize,1);
            for gaslayer = 1: endaccsize
                endacc(gaslayer) = sum(diag(combinedval(:,:,gaslayer)))/sum(sum(combinedval(:,:,gaslayer)));%%% actually some function of combinedval, but not now...
            end
        end
    end
end
