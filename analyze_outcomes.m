function endacc = analyze_outcomes(simvar)
combsize = [size(simvar.trial(1).metrics(1, 1).val) size(simvar.trial(1).metrics,2)];
combinedval = zeros(combsize);
for i=1:size(simvar.trial,2)
    for gaslayer = 1: size(simvar.trial(1).metrics,2)
        for worker =1:size(simvar.trial(1).metrics,1)            
            combinedval(:,:,gaslayer) = simvar.trial(i).metrics(worker, gaslayer).val + combinedval(:,:,gaslayer);
        end
    end
end
endacc = zeros(size(simvar.trial(1).metrics,2),1);
for gaslayer = 1: size(simvar.trial(1).metrics,2)
    endacc(gaslayer) = sum(diag(combinedval(:,:,gaslayer)))/sum(sum(combinedval(:,:,gaslayer)));%%% actually some function of combinedval, but not now...
end