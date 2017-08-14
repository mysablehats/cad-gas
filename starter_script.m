function outcomes = starter_script(varargin)
myticvar = tic;
global VERBOSE LOGIT TEST
TEST = 0;
VERBOSE = 0;

addpath('runpars','precond','poscond','measures','debug','utils');

datavar = setdatavar(varargin{:});
datavar_ = datavar.loop;

if 1
    addpath('gas');
    params = setparams(datavar_(1).skelldef, 'init', []); %hmmm..    
    simvar_ = setsimvar(params);
else
    simvar_ = setsimvarkf;
end

simvar_ = runcore(simvar_,datavar_);
toc(myticvar)
 
try
    b = evalin('base',['outcomes' num2str(simvar_.pc)]);
catch
    b = struct();
end
% 
[b.a, b.b] = simvar_.analyze_outcomes;
% %simvar = '';
% assignin('base', ['outcomes' num2str(simvar.pc)], b);
% assignin('base', 'myidxs',simvar.Alldata);
% % if params.PLOTIT
% %     for j = 1:size(simvar.trial,2)
% %         for i = 1:size(simvar.trial(j).metrics,1)
% %             figure
% %             %plotconf(simvar.metrics(i,[2,4])) % replace 5 for : to get all the output
% %             plotconf(simvar.trial(j).metrics(i,end)) % replace 5 for : to get all the output
% %             
% %         end
% %     end
% % end


outcomes.b = b;
outcomes.trials = simvar_;
outcomes.pcid = datavar.pc;
outcomes.idxs = datavar.Alldata;%pcspecs.idxs;
outcomes.hash = datavar.env.currhash;
save([datavar.env.allmatpath 'outcomes' datavar.env.SLASH datavar.env.currhash '-SIMVAR+outcomes-' num2str(datavar.pc)], 'simvar_')
%combineoutcomes