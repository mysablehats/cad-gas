function runpar = setrunpars()
runpar.method = 'gas';
runpar.scene = {'or'};% {'bathroom'};% {'bathroom','bedroom','kitchen','livingroom','office'} ; %{'or'}; %{'all'};
runpar.precon = 'cip';
runpar.savesimvar = false;