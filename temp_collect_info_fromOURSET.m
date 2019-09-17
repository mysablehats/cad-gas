a= 0; b = 0;
numact = zeros(14,2);
frameact = zeros(14,2);
allact = unique({allskel2.act_type});
for i = 1:length(allskel2)
    if allskel2(i).subject ==5
        a = a + size(allskel2(i).skel,3);
        for j = 1:length(allact)
            if strcmp(allskel2(i).act_type,allact{j})
                numact(j,1) = numact(j,1) + 1;
                frameact(j,1) = frameact(j,1) + size(allskel2(i).skel,3);
            end
        end
    else
        b = b+ size(allskel2(i).skel,3);
        for j = 1:length(allact)
            if strcmp(allskel2(i).act_type,allact{j})
                numact(j,2) = numact(j,2) + 1;
                frameact(j,2) = frameact(j,2) + size(allskel2(i).skel,3);
            end
        end
    end
end