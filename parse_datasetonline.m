function allskel3 = parse_datasetonline()
a = dir('/Volumes/share/ar/Elements/dataset_experiment2/frederico/*.mat');
b = dir('/Volumes/share/ar/Elements/dataset_experiment2/anna/*.mat');
c = [a;b];
allskel3 = [];
for i = 1:length(c)
    if c(i).name(1) ~= '.' %skips hidden and deleted files
        filename =[c(i).folder '/' c(i).name]; 
        cc = load(filename);
        allskel = generate_skel_online(cc.chunk);
        hasname = ~contains(filename,'anna');
        allskel.subject = 5+hasname;
       
        if isempty(allskel3)
            allskel3 = allskel;
        else            
            allskel3 = [allskel3; allskel];
        end
    end
end
%a = load('/Volumes/share/ar/Elements/dataset_experiment2/frederico/frederico_chopping.mat');
%allskel3 = generate_skel_online(a.chunk);
save('/Volumes/share/ar/Elements/dataset_experiment2/fre+anna.mat','allskel3');

end
