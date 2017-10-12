function drawerrorskels(fivenn,tn,range)
figure
skeldraw(fivenn.datavar(tn, 1).data.val.data(:,range),fivenn.datavar(1, 1).skelldef,'A')
skeldraw(fivenn.datavar(tn, 1).data.train.data(:,fivenn.trials.model(tn).IDX(range)),fivenn.datavar(1, 1).skelldef,'W')