function simvar = setsimvar

%%% sets the running parameters for the classifier.

simvar = Simvar({'PARA' 0});

simvar.NODES_VECT = [10];
simvar.MAX_EPOCHS_VECT = [2];
simvar.ARCH_VECT = [1];

simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

simvar = simvar.init;

end