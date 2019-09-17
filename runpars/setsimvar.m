function simvar = setsimvar(params,parsc,useroptions)

%%% sets the running parameters for the classifier.


simvar = Simvargas({'PARA' 0});

simvar.NODES_VECT = [1000];
simvar.MAX_EPOCHS_VECT = [1];
%simvar.ARCH_VECT = [22]; %[22] is default knn winner 1-nn without anything else
%simvar.ARCH_VECT = [2]; 
%simvar.ARCH_VECT = [1]; 
%simvar.ARCH_VECT = [22 1 2 ]; %not working
simvar.ARCH_VECT = [27]; 


simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

simvar = simvar.init(params,parsc,useroptions);

end