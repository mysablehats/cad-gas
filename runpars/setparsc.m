function parsc = setparsc(k)
%% this functions sets the parameters for the classifiers

%%% for knn
parsc.knn.k = k;
parsc.knn.other = {};
%%% for svm
parsc.svm.kernel = 'linear';
parsc.svm.other = {};
end