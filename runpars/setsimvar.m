function simvar = setsimvar(params)

%%% sets the running parameters for the classifier.


simvar = Simvargas({'PARA' 0});

simvar.NODES_VECT = [10];
simvar.MAX_EPOCHS_VECT = [100];
simvar.ARCH_VECT = [16];

simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

simvar = simvar.init(params);

end