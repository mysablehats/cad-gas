function [data,labels_names, skelldef] = all3(allskel, simvar)
[allskel] = conformactions(allskel, simvar.prefilter{:});
for i= 1:length(allskel)
    allskel(i).indexact = i;
    %%%
    if isfield(simvar,'normrepair')&&simvar.normrepair
        allskel(i) = normrepair(allskel(i));
    end
    
    if isfield(simvar,'affinerepair')&&simvar.affinerepair
        allskel(i) = affinerepair(allskel(i), simvar);
    end
end

[data, labels_names] = extractdata(allskel, simvar.activity_type, simvar.labels_names,simvar.extract{:});
if 0 %isfield(simvar, 'notzeroedaction')
      
    a.train = data;
    pld = data.data.';
    figure
    plot(pld)
    %error('stops!')
    showdataset(a,simvar)
    disp('hello')
end
if simvar.disablesconformskel
    %no more conformskel!
    %erm actually i need skelldef, so i will maybe run conformskel without
    %parameters
    [data, skelldef] = conformskel(data);
else
    %in case you wish to run it:
    [data, skelldef] = conformskel(data, simvar.preconditions{:});
end
end