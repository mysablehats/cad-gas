function a = executioncore_in_starterscript(arq_connect, ss)

%gases = [];
%% executioncore
% This is the main function to run the chained classifier, label and
% generate confusion matrices and recall, precision and F1 values for the
% skeleton classifier of activities using an architecture of chained neural
% gases on skeleton activities data (the STS V2 Dataset). This work is an
% attempt to implement Parisi, 2015's paper.

%%

%%% making metrics structure

metrics = struct('confusions',[],'conffig',[],'outparams',[]);

whatIlabel = 1:length(ss.gas); %change this series for only the last value to label only the last gas

%%% end of gas structures region

[ss.gas, ss.train] = sameclassfunc(ss.gas, ss.train, 'train', whatIlabel, arq_connect);
[ss.gas, ss.val] = sameclassfunc(ss.gas, ss.val, 'val', whatIlabel, arq_connect);
for j = 1:length(arq_connect)
        metrics(j).outparams = ss.gas(j).outparams;
end
%% Displaying multiple confusion matrices for GWR and GNG for nodes
% This part creates the matrices that can later be shown with the
% plotconfusion() function.

[ss, metrics] = plotconfmaker(ss, metrics,whatIlabel);


%% Actual display of the confusion matrices:
metitems = [];
for j = whatIlabel
    if arq_connect(j).params.PLOTIT
        metitems = [metitems j*arq_connect(j).params.PLOTIT];
    end
end
if ~isempty(metitems)
    figure
    plotconf(metrics(metitems));
end
%plotconf(ss.figset{:})
if isfield(ss.gas(end).fig, 'val')&&~isempty(ss.gas(end).fig.val)
    figure
    plotconfusion(ss.gas(end).fig.val{:});
end

%% Displaying this nifty distance graph to see if thresholds would make my life easier, they don't
if 0 % this is broken isfield(ss, 'val')&&isfield(ss.val, 'gas')
    a.ssvalgas = ss.val.gas;
    distancegraph(ss.val.gas);
end


%% setting output variables
%simvar.env = env;
a.mt = metrics;
a.gases = ss.gas;
a.allconn = arq_connect;

%%% collecting the models:
for i =1:size(ss.gas  ,2)
    a.mdl{i} = ss.gas(i).model;  
end
%a.simvar = simvar;

% if clearmemory
%     ss = struct();
%     for jj = size(gases,2) %%%% I was running out of memory, so this had to be made
%         gases(jj).fig = struct();
%     end
%     
% end

%save(savefilesave2('realclassifier', env),'realclass')
%[~, something_to_classify] = realvideo(realclass.outstruct, realclass.allconn, realclass.simvar,0);
% realvideo(outstruct, baq(pallconn), simvar);

%%online_classifier(chunkchunk, outstruct, baq(pallconn), simvar);
end