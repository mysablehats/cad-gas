classdef Simvar
    properties
        PARA
        P
        allconn
        metrics
        realtimeclassifier
        NODES_VECT
        MAX_EPOCHS_VECT
        ARCH_VECT
        MAX_NUM_TRIALS
        MAX_RUNNING_TIME
        numlayers
        arq_connect
    end
    methods
        function simvar = Simvar(varargin)
            simvar.realtimeclassifier = false;
            simvar.PARA = 1;
            simvar = simvar.updateparallelprocessors;
            
            simvar.allconn = [];
            simvar.metrics = struct;
            simvar.metrics = struct;
            
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
        function simvar = init(simvar)
            simvar = simvar.updateparallelprocessors;
            simvar.numlayers = (length(baq(allconnset(simvar.ARCH_VECT, []))));
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
            if isempty(simvartrial.metrics)
                error('Metrics not set! Ending.')
            end
            combsize = [size(simvartrial(1).metrics(1, 1).val) size(simvartrial(1).metrics,2)];
            combinedval = zeros(combsize);
            for i=1:size(simvartrial.metrics,3)
                for gaslayer = 1: size(simvartrial(1).metrics,2)
                    for worker =1:size(simvartrial(1).metrics,1)
                        %%doesn't exist anymore... this will break all the time if I
                        %%insist on using workers for different things.
                        %worker = 1;
                        combinedval(:,:,gaslayer) = simvartrial.metrics(worker, gaslayer,i).val + combinedval(:,:,gaslayer);
                    end
                end
            end
            endaccsize = size(simvartrial(1).metrics,2);
            endacc = zeros(endaccsize,1);
            for gaslayer = 1: endaccsize
                endacc(gaslayer) = sum(diag(combinedval(:,:,gaslayer)))/sum(sum(combinedval(:,:,gaslayer)));%%% actually some function of combinedval, but not now...
            end
        end
        function simvartrial = loop(simvar,params)
            %% Begin loop
            trialcount = 0;
            simvartrial = repmat(simvar,length(simvar.ARCH_VECT)*length(simvar.NODES_VECT)*length(simvar.MAX_EPOCHS_VECT),1);
            for architectures = simvar.ARCH_VECT
                for NODES = simvar.NODES_VECT
                    for MAX_EPOCHS = simvar.MAX_EPOCHS_VECT
                        if NODES ==100000 && (simvar.MAX_EPOCHS==1||simvar.MAX_EPOCHS==1)
                            dbgmsg('Did this already',1)
                            break
                        end
                        trialcount = trialcount +1;
                        params.MAX_EPOCHS = MAX_EPOCHS;% simvar.trial(trialcount).MAX_EPOCHS;
                        params.nodes = NODES;%simvar.trial(trialcount).NODES; %maximum number of nodes/neurons in the gas
                        
                        %%%
                        params = setparams([], 'layerdefs', params);
                        
                        simvartrial(trialcount).allconn = allconnset(architectures, params);
                        
                        %%% ATTENTION 2: PARALLEL PROCESSES ARE NO LONGER DOING WHAT THEY
                        %%% USUALLY DID. SO THEY ARE NOT STARTING THE GAS AT DIFFERENT
                        %%% RANDOM POINTS. ALTHOUGH THAT SEEMS LIKE A GOOD IDEA, I NEED
                        %%% PARALLEL PROCESSING FOR OTHER THINGS, AND THIS WILL HAVE TO
                        %%% WAIT.
                        
                        
                        %             %% Setting up different parameters for each of parallel trial
                        %             % Maybe you want to do that; in case you don't, then we just
                        %             % use a for to put the same parameters for each.
                        %             paramsZ = repmat(paramsP,1,simvar.P);
                        %             for i = 1:simvar.P
                        %                 %paramsZ(i) = params;
                        %
                        %                 n = randperm(size(data.train.data,2),2);
                        %                 paramsZ(1,i).startingpoint = [n(1) n(2)];
                        %                 simvartrial(trialcount).allconn{1,1}{1,6} = paramsZ(i); % I only change the initial points of the position gas
                        %                 %pallconn{1,3}{1,6} = paramsZ; %but I want the concatenation to reflect the same position that I randomized. actually this is not going to happen because of the sliding window scheme
                        %                 %pallconn{1,4}{1,6} = pallconn{1,2}{1,6};
                        %                 simvartrial(trialcount).arq_connect(i,:) = baq(simvartrial(trialcount).allconn);
                        %
                        %             end
                        %
                        simvartrial(trialcount).arq_connect = baq(simvartrial(trialcount).allconn);
                    end
                    
                end
            end
        end    
    end
end
