function simvar_ = starter_script(varargin)
myticvar = tic;
global VERBOSE LOGIT TEST
env = aa_environment; % load environment variables
simvar = setsimvar;
params = setparams;

for alldata = simvar.Alldata%1:68 %2:5%68
TEST = 0;
VERBOSE = 0;

simvar_(alldata) = classifier_loop(simvar, params, env);
try
    b = evalin('base',['outcomes' num2str(pc)]);
catch
    b = struct();
end
[~, b(alldata).b] = analyze_outcomes(simvar_(alldata));
%simvar = '';
assignin('base', ['outcomes' num2str(simvar.pc)], b);
assignin('base', 'myidxs',simvar.Alldata);
% if params.PLOTIT
%     for j = 1:size(simvar.trial,2)
%         for i = 1:size(simvar.trial(j).metrics,1)
%             figure
%             %plotconf(simvar.metrics(i,[2,4])) % replace 5 for : to get all the output
%             plotconf(simvar.trial(j).metrics(i,end)) % replace 5 for : to get all the output
%             
%         end
%     end
% end
end
toc(myticvar)
outcomes.b = b;
outcomes.pcid = simvar.pc;
outcomes.idxs = simvar.Alldata;%pcspecs.idxs;
outcomes.hash = env.currhash;
save([env.allmatpath 'outcomes' env.SLASH env.currhash '-outcomes-' num2str(pc)], 'outcomes')
combineoutcomes