classdef allconfigvars
    properties
        runpar
        simvar
        datavarcommon
        datavarmakedata
        datavarmakedataextract_
    end
    methods
        function [runpar,allc] = setrunpar(allc)
            runpar = allc.runpar;
            
            %% setrunpar
            runpar.method = 'compressors';
            runpar.scene = {'or'};% {'bathroom'};% {'bathroom','bedroom','kitchen','livingroom','office'} ; %{'or'}; %{'all'};
            runpar.precon = 'pap';% 'pap';%'pop';% 'cip';
            runpar.savesimvar = false;
            
            allc.runpar = runpar;
        end
        function [simvar,allc] = setsimvar(allc)
            simvar = allc.simvar;
            %% setsimvar
            
            
            simvar = Simvargas({'PARA' 1});
            
            simvar.NODES_VECT = [35];
            simvar.MAX_EPOCHS_VECT = [1];
            simvar.ARCH_VECT = [22];
            
            simvar.MAX_NUM_TRIALS = 1;
            simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this
            
            allc.simvar = simvar;
        end
        function [datavarcommon,allc] = setdatavarcommon(allc)
            %%% compiler is right, this might be useless.
            datavarcommon = allc.datavarcommon;
            %% setdatavar common
            datavarcommon = Datavar({'validationtype' 'type2all'});
            
            %starts the dataset and do the preconditioning and feature selection.
            
            datavarcommon.validationtype = 'type2all'; %'type2notrandom'; 'cluster' 'quarterset' 'type2' 'type2notrandom' 'type2all'
            
            allc.datavarcommon = datavarcommon;
        end
        function [datavarmakedata,allc] = setdatavarmakedata(allc)
            datavarmakedata = allc.datavarmakedata;
            %% setdatavar makedata
            
            datavarmakedata.AllSubjects = [1 2 3 4];%2 %[1 2 3 4]; %%
            datavarmakedata.disablesconformskel = 0;
            datavarmakedata.generatenewdataset = false; %true;
            datavarmakedata.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
            datavarmakedata.activity_type = 'act_type'; %'act_type' or 'act'
            datavarmakedata.prefilter = {'none', 15};%{'filter',10}; % 'filter', 'none', 'median?'
            datavarmakedata.normrepair = false;
            datavarmakedata.affinerepair = false;
            datavarmakedata.affrepvel = false;
            datavarmakedata.randSubjEachIteration = false; %%% must be set to false for systematic testing
            
            %   datavarmakedata.extract = {'rand', 'wantvelocity','order',{'removeaction','still','random'}};
            
            allc.datavarmakedata = datavarmakedata;
        end
        function [datavarmakedataextract_, allc] = ng(allc)
            %% another part of datavar
            datavarmakedataextract_ = {'rand', 'wantvelocity','order'};
            
            allc.datavarmakedataextract_ =             datavarmakedataextract_;
        end
            %             %% creates the structure
            %             allc.simvar = simvar;
            %             allc.runpar = runpar;
            %             allc.datavarcommon = datavarcommon;
            %             allc.datavarmakedata = datavarmakedata;
            %
            
        end
    end
