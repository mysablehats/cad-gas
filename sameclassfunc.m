function [gas, ssvot] = sameclassfunc(gas, ssvot, vot, whatIlabel, arq_connect)
%% Gas-chain Classifier
% This part executes the chain of interlinked gases. Each iteration is one
% gas, and currently it works as follows:
% 1. Function setinput() chooses based on the input defined in allconn
% 2. Run either a Growing When Required (gwr) or Growing Neural Gas (GNG)
% on this data
% 3. Generate matrix of best matching units to be used by the next gas
% architecture

dbgmsg('Starting chain structure for GWR and GNG for nodes:',num2str(labindex),0)
dbgmsg('###Using multilayer GWR and GNG ###',0)

if 0
    kindex = 1;
else
    numlabs = size(ssvot.y,1);
    kindex = 1:numlabs;
    labs = repmat('some label',12,1);  %%%% provisional. needs real labels
    %%%need to partition ssvot!
    ssvotbt = ssvot;
    ssvotbt.gas.bestmatchbyindex = [];
    ssvot = pssvot(ssvot);
    gas = repmat(gas,numlabs,1);
end

for k = kindex
    for j = 1:length(arq_connect)
        if size(ssvot(k).data,1)>0&&strcmp(vot,'train')
            [gas(k,j), ssvot(k)] = gas_method(gas(k,:), ssvot(k),vot, arq_connect(j),j, size(ssvot(k).data,1)); % I had to separate it to debug it.
        elseif ~isempty(ssvot.data)
            [~, ssvot(k) ]= gas_method(gas(k,:), ssvot(k), vot, arq_connect(j),j, size(ssvot(k).data,1)); %%%hmmm, this will not work
        end
    end
end

%construct a combined gas


for k = kindex
    for j = 1:length(arq_connect)
         ssvotbt = gas_method2(ssvotbt, gas(k,:), arq_connect(j),j,k);
    end
end

%% Gas Outcomes
if strcmp(vot,'train')
    if arq_connect(j).params.PLOTIT
        for k = kindex
            figure
            for j = 1:length(arq_connect)
                subplot(1,length(arq_connect),j)
                hist(gas(k,j).outparams.graph.errorvect)
                title([(gas(k,j).name) labs(k,:)])
            end
        end
    end
end
%% Labelling
% The current labelling procedure for both the validation and training datasets. As of this moment I label all the gases
% to see how adding each part increases the overall performance of the
% structure, but since this is slow, the variable whatIlabel can be changed
% to contain only the last gas.
%
% The labelling procedure is simple. It basically picks the label of the
% closest point and assigns to that. In a sense the gas can be seen as a
% dimensional (as opposed to temporal) filter, encoding prototypical
% action-lets.
% Specific part on what I want to label
for j = whatIlabel
    if length(kindex)==1
        dbgmsg('Applying labels for gas: ''',gas(j).name,''' (', num2str(j),') for process:',num2str(labindex),0)
        if strcmp(vot,'train')
            gas(j).nodesl = altlabeller(ssvot.gas(j).bestmatchbyindex, gas(j).nodes,ssvot.gas(j).inputs.input,ssvot.gas(j).y); %%% new labelling scheme
            %gas(j).nodesl = labeling(gas(j).nodes,ssvot.gas(j).inputs.input,ssvot.gas(j).y);
        end
        if isfield(ssvot,'gas')&&j<=length(ssvot.gas)
            ssvot.gas(j).class = labeller(gas(j).nodesl, ssvot.gas(j).bestmatchbyindex);
        end
    else
        traindist = c_dist(ssvot); %%%% maybe I should compare with this for better results. first trial won't have it though.
        ssvotbt.gas(j).class = newlabeller(ssvotbt.gas(j).distances);
        ssvot = ssvotbt; %%% so many potential errors... :(
    end
    
end

end
function ssvotp = pssvot(ssvot)
%disp('hello')
%%% at first glance this seems correct.

nssvotl = size(ssvot.y,1);
ssvotp(nssvotl) = struct;
alldatasize = size(ssvot.data,2);
for i = 1:nssvotl 
    newindex = 0;
    ends = [];
    for j = 1:alldatasize
        if ssvot.y(i,j) == 1
            newindex = newindex +1;
            ssvotp(i).data(:,newindex) = ssvot.data(:,j);
            ssvotp(i).y(:,newindex) = ssvot.y(:,j);
            ssvotp(i).index(:,newindex) = ssvot.index(j); 
            %%% now need to create ends
            %if index of next point changes or does not exist then it is an end
            if j+1>alldatasize||ssvot.index(j+1)~=ssvot.index(j)               
                ends = [ends newindex-sum(ends)];
            end
        end
    end
    ssvotp(i).ends = ends;
    ssvotp(i).seq = unique(ssvotp(i).index,'stable');
    ssvotp(i).gas = struct;
end
end