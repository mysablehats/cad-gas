function outcomes = starter_script(varargin)
myticvar = tic;
global VERBOSE LOGIT TEST
TEST = 0;
VERBOSE = 0;

addpath('runpars','precond','poscond','measures','debug','utils');

runpars = setrunpars;
method = runpars.method;
precond = runpars.precon;
scene = runpars.scene;

%%%%%%%%%
%if iscell(runpars.scene)
if ~isempty(varargin)&&isa(varargin{1},'Datavar')
maxindexofscenes = 1;
scene = 'customdataset';
else
maxindexofscenes = length(runpars.scene);
end
%end

for indexofscenes = 1:maxindexofscenes
    if ~isempty(varargin)&&isa(varargin{1},'Datavar')
        datavar_ = varargin{1};
    else
        datavar = setdatavar(varargin{:});
        datavar_ = datavar.loop;
    end
    
    switch method
        case 'gas'
            addpath('gas');
            params = setparams(datavar_(1).skelldef, 'init', []); %hmmm..
            simvar_ = setsimvar(params);
        case 'kforget'
            addpath('..\k-forget')
            simvar_ = simpar;
        case 'knn'
            addpath('../svm-knn')
            simvar_ = SimvarKNN;
            %simvar_ = SimvarMC;
        case 'svm'
            addpath('../svm-knn')
            simvar_ = SimvarMC;
    end
    
    
    simvar_ = runcore(simvar_,datavar_);
    toc(myticvar)
    
    try
        b = evalin('base',['outcomes(indexofscenes)' num2str(simvar_.pc)]);
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
    
    
    outcomes(indexofscenes).b = b;
    outcomes(indexofscenes).trials = simvar_;
    outcomes(indexofscenes).pcid = datavar_(1).pc;
    outcomes(indexofscenes).idxs = datavar_(1).Alldata;%pcspecs.idxs;
    outcomes(indexofscenes).hash = datavar_(1).env.currhash;
    outcomes(indexofscenes).datavar = datavar_;
    save([datavar_(1).env.allmatpath 'outcomes' datavar_(1).env.SLASH datavar_(1).env.currhash '-SIMVAR+outcomes-' num2str(datavar_(1).pc)], 'simvar_')
    %combineoutcomes
end
for i = 1:length(outcomes)
    a = outcomes(i);
    save(['../' scene{indexofscenes} method precond],'a')
end