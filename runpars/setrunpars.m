function runpar = setrunpars()
runpar.method = 'compressors';
runpar.scene = {'bathroom','bedroom','kitchen','livingroom','office'} ;%{'or'};% {'bathroom'};% {'bathroom','bedroom','kitchen','livingroom','office'} ; %{'or'}; %{'all'};
runpar.precon = 'cip';% 'pap';%'pop';% 'cip';
runpar.savesimvar = false;