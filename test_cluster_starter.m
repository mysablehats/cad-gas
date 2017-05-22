%test cluster primitive
env = aa_environment;
pcid = 1;

idxs = 1:7;%16:43;
save([env.homepath env.SLASH '..' env.SLASH 'clust.mat'],'pcid','idxs')