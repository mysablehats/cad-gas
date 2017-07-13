function [sstgasj, sstv] = gas_method(sstgas, sstv, vot, arq_connect,j, dimdim)
%% Gas Method
% This is a function to go over a gas of the classifier, populate it with the apropriate input and generate the best matching units for the next layer.
%% Setting up some labels
sstgasj = sstgas(j);
sstgasj.name = arq_connect.name;
sstgasj.method = arq_connect.method;
sstgasj.layertype = arq_connect.layertype;
arq_connect.params.layertype = arq_connect.layertype;

%% Choosing the right input for this layer
% This calls the function set input that chooses what will be written on the .inputs variable. It also handles the sliding window concatenations and saves the .input_ends properties, so that this can be done recursevely.
% After some consideration, I have decided that all of the long inputing
% will be done inside setinput, because it it would be easier.
dbgmsg('Working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,' for process:',num2str(labindex),0)

[sstv.gas(j).inputs.input_clip, sstv.gas(j).inputs.input, sstv.gas(j).inputs.input_ends, sstv.gas(j).y, sstv.gas(j).inputs.oldwhotokill, sstv.gas(j).inputs.index, sstv.gas(j).inputs.awk ]  = setinput(arq_connect, sstgas, dimdim, sstv); %%%%%%

%%
% After setting the input, we can actually run the gas, either a GNG or the
% GWR function we wrote.
if strcmp(vot, 'train')
    %DO GNG OR GWR
    [sstgasj.nodes, sstgasj.edges, sstgasj.outparams, sstgasj.gasgas] = gas_wrapper(sstv.gas(j).inputs.input_clip,arq_connect);
    %%%% POS-MESSAGE
    dbgmsg('Finished working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,'.Num of nodes reached:',num2str(sstgasj.outparams.graph.nodesvect(end)),' for process:',num2str(labindex),0)
    
end

%% Best-matching units
% The last part is actually finding the best matching units for the gas.
% This is a simple procedure where we just find from the gas units (nodes
% or vectors, as you wish to call them), which one is more like our input.
% It is a filter of sorts, and the bestmatch matrix is highly repetitive.

% I questioned if I actually need to compute this matrix here or maybe
% inside the setinput function. But I think this doesnt really matter.
% Well, for the last gas it does make a difference, since these units will
% not be used... Still I will  not fix it unless I have to.
%PRE MESSAGE
dbgmsg('Finding best matching units for gas: ''',sstgasj.name,''' (', num2str(j),') for process:',num2str(labindex),0)
[sstv.gas(j).distances, ~, sstv.gas(j).bestmatchbyindex] = genbestmmatrix(sstgasj.nodes, sstv.gas(j).inputs.input, arq_connect.layertype, arq_connect.q, arq_connect.params.distancetype, sstgasj.gasgas); %assuming the best matching node always comes from initial dataset!

%% Post-conditioning function
%This will be the noise removing function. I want this to be optional or allow other things to be done to the data and I
%am still thinking about how to do it. Right now I will just create the
%whattokill property and let setinput deal with it.
if arq_connect.params.oldremovepoints
    dbgmsg('Flagging noisy input for removal from gas: ''',sstgasj.name,''' (', num2str(j),') with points with more than',num2str(arq_connect.params.gamma),' standard deviations, for process:',num2str(labindex),0)
    sstv.gas(j).whotokill = removenoise(sstgasj.nodes, sstv.gas(j).inputs.input, sstv.gas(j).inputs.oldwhotokill, arq_connect.params.gamma, sstv.gas(j).inputs.index);
else
    dbgmsg('Skipping removal of noisy input for gas:',sstgasj.name,0)
end
end
function [ distances, matmat, matmat_byindex] = genbestmmatrix(nodes, data, ~,q, distancetype, gasgas)
if strcmp(distancetype.source,'ext')
if distancetype.noaffine
    [ matmat, matmat_byindex, distances] = genbestmmatrix_Iconip(nodes, data, q, distancetype.metric);
else
    distfun = @(x,y)distancekernel(x,y);
    dnodes = @(x,y,z)distnodes(x,y,z);
    [ matmat, matmat_byindex, distances] = genbestmmatrix_new(nodes, data, [],[],dnodes, distfun);
end
elseif strcmp(distancetype.source,'gas')
    
    %distfun = @(x,y)distancekernel(x,y);
    dnodes = @(eta, ~, ~)gasgas.fnearest(eta);
    %[eta, n1,  n2,  ni1,  ni2, d1, d2,  distvector] = findnearest(gasgas,eta)
    %dnodes = @(x,y,z)distnodes(x,y,z); %% this should be a gas method! but how are we going to access the gas structure from here?
    [ matmat, matmat_byindex, distances] = genbestmmatrix_new(nodes, data, [],[],dnodes, []);
else
    error('Unknown distance metric source!')
end
end
function [ matmat, matmat_byindex, distances] = genbestmmatrix_Iconip(nodes, data,q, metric)

if strcmp(metric,'3dsum')
    [distances ,matmat_byindex] = pdist2(nodes',data',@(x,y) tdsum(x,y,q(1)),'Smallest',1);
else
    [distances ,matmat_byindex] = pdist2(nodes',data',metric,'Smallest',1);
end
matmat = nodes(:,matmat_byindex);

if 0
    %%%this makes a nice graph:
    %maybe a gfc and restore stuff later...
    currfig = gcf;
    figure
    a = reshape(data(:,1),45,[]); %%% it is going be a rubish skeleton for all layers that are not with positions... maybe it will mix nice and rubish for the last one...
    b = reshape(nodes(:,1),45,[]);
    skeldraw(a)
    skeldraw(b)
    %%% or you can get the closest to the first one, like
    figure
    getskel = nodes(:,matmat_byindex(1));
    c = reshape(getskel,45,[]);
    skeldraw(a)
    skeldraw(c);
    
    figure(currfig)
end


end
function [ matmat, matmat_byindex, distances] = genbestmmatrix_new(nodes, data, ~,~, dnodes, distfun)

matmat = [];
%[~,matmat_byindex] = pdist2(nodes',data','euclidean','Smallest',1);
%matmat = nodes(:,matmat_byindex);
matmat_byindex = nan(1,size(data,2));
distances = inf(size(matmat_byindex));
for i = 1:size(data,2)
    %tic
    a = data(:,i);
    distancesA = dnodes(a,nodes,distfun);
    [dd,ind] = min(distancesA);
    matmat_byindex(i) = ind;
    distances(i) = dd;
    %toc
end


end
function distances = distnodes(a,nodes,distfun)
distances = nan(1,size(nodes,2));
    for j = 1:size(nodes,2)
        b = nodes(:,j);
        distances(j) = distfun(a,b);
    end
end
function dis = distancekernel(a,b)

mata = reshape(a,[],3);
matb = reshape(b,[],3);

meana = mean(mata);
meanb = mean(matb);

ca = mata - meana;
cb = matb - meanb;

cov_ = ca.'*cb;

[u,s,v] = svd(cov_);

r = v*u.';

tsb = cb*r;
tsa = (r*ca.').';

longa = a(:,1);
longb = b(:,1);

longca = reshape(ca,[],1);
longcb = reshape(cb,[],1);

longtsb = reshape(tsb,[],1);
longtsa = reshape(tsa,[],1);

%calculate the distance without any change between vectors a and b

%disp('Original distance:')
%dis = pdist2(longa',longb','euclidean','Smallest',1);

%calculate the distance with means removed (centered around the centroids)

%disp('Distance with means removed (a and b centered):')
%ndis = pdist2(longca',longcb','euclidean','Smallest',1);

%if dis<ndis
%    disp('Removing centroids is actually worse!!!!')
%else
%    dis = ndis;
%end

%calculates the distance with svd rotation matrix

%disp('Distance with rotation on a, b just centered:')
ndis1 = pdist2(longtsa',longcb','euclidean','Smallest',1);

%disp('Distance with rotation on a and b:')
%ndis2 = pdist2(longtsa',longtsb','euclidean','Smallest',1);% this shouldnt
%be the fastest

%disp('Distance with rotation on b, a just centered:')
ndis3 = pdist2(longtsb',longca','euclidean','Smallest',1);

dis = min([ndis1 ndis3]); %nndis = min([ndis1 ndis2 ndis3]);

%disp(ind)

% if dis<nndis
%     disp('Applying rotation is actually worse than just removing centroids!!!')
% else
%     dis = nndis;
% end
end