function outcomes = starter_script(varargin)
myticvar = tic;
global VERBOSE LOGIT TEST
TEST = 0;
VERBOSE = 0;

addpath('gas','runpars','precond','poscond','measures','debug','utils');

simvar = setsimvar(varargin{:});
params = setparams(simvar);

simvar_ = classifier_loop(simvar, params);
toc(myticvar)
 
try
    b = evalin('base',['outcomes' num2str(simvar.pc)]);
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
outcomes.pcid = simvar.pc;
outcomes.idxs = simvar.Alldata;%pcspecs.idxs;
outcomes.hash = simvar.env.currhash;
save([simvar.env.allmatpath 'outcomes' simvar.env.SLASH simvar.env.currhash '-SIMVAR+outcomes-' num2str(simvar.pc)], 'simvar_')
%combineoutcomes