function parsc = setparsc(k,argarg, parsc)
%% this functions sets the parameters for the classifiers

switch argarg
    case 'init'
        %%% for knn
        parsc.knn.k = k;
        parsc.knn.other = {};
        %parsc.knn.other = {'''Distance'',''hamming'''}; %use a hamming distance because pose 1 and 13 differ as much as 1 and 2
        %parsc.knn.other = {'''Distance'',@dtw'};
        %%% for svm
        parsc.svm.kernel = 'linear';
        parsc.svm.other = {};
    case 'layerdefs'
        parsc = repmat(parsc,10,1);
        %%% insert custom definitions for each layer below here
        parsc(2).knn.other = {'''Distance'',@dtw_wrapper'};
end