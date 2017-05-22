%test cluster primitive
env = aa_environment;
pcid = 2;
idxs = 8:14;%44:68;
save([env.homepath env.SLASH '..' env.SLASH 'clust.mat'],'pcid','idxs')