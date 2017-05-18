%test cluster primitive
env = aa_environment;
pcid = 1;
idxs = 1:2;
save([env.homepath env.SLASH '..' env.SLASH 'clust.mat'],'pcid','idxs')