function simvar = runcore(simvar,datavar)
a = [];
b = [];

switch simvar.method
    case 'gas'
    met_struc = struct('conffig',[],'val',[],'train',[], 'accumulatedepochs',0);
    
    for i =1:length(datavar)
        datavar(i).data = structcat2(makess(simvar.numlayers,true),datavar(i).data);
    end
    
    for ii = 1:length(simvar)
        simvar(ii).metrics =repmat(met_struc,length(datavar),simvar.numlayers);
    end
    case 'knearest'
    case 'kforget'
    case 'svm'
    otherwise
        error('classification method not defined. ')
end


for ii = 1:length(simvar)
    starttime = tic;
    while toc(starttime)< simvar(ii).MAX_RUNNING_TIME
        if length(b)> simvar(ii).MAX_NUM_TRIALS
            break
        end
        if simvar(ii).PARA
            spmd(length(datavar))
                a(labindex).a = simvar(ii).excfun(datavar(labindex).data,ii);
            end
            %b = cat(2,b,a.a);
            for i=1:length(a)
                c = a{i};
                a{i} = [];
                b = [c.a b];
            end
            clear a c
            a(1:simvar(ii).P) = struct();
        else
            for i = 1:length(datavar)
                a(i).a = simvar(ii).excfun(datavar(i).data,ii);
            end
            b = cat(2,b,a.a);
            clear a
            a(1:length(datavar)) = struct();
        end
    end
    
    for iiiii = 1:length(b)
        simvar(ii).model(iiiii).mdl = b(iiiii).mdl;
        simvar(ii).model(iiiii).IDX = b(iiiii).IDX;
    end
    
    
    simvar(ii).metrics = gen_cst(b); %%% it takes the important stuff from b;;; hopefully
    %simvar(ii).metrics(:,:) = gen_cst(b); %%% it takes the important stuff from b;;; hopefully
    
    for i = 1:length(b) %%%% this is broken. if you want to fix it change... erm... stuff
        if isfield(b(i), 'ssvalgas')
            if paramsZ(1).PLOTIT %%% if you ever want to have custom display, this will crash
                distancegraph(b(i).ssvalgas)
            end
        end
    end %%%% shows me intersting possible thresholds i can use
end