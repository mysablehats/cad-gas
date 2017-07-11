function nodecount = altlabeller(bmbi, y)
%disp('hello')
numnodes = max(bmbi);
nodecount = zeros(size(y,1),numnodes);
for node =1:numnodes
    for i = 1:size(bmbi,2)
        if bmbi(i) == node
        nodecount(:,node) = nodecount(:,node) +y(:,i);
        end
    end
    nodecount(:,node) = nodecount(:,node)/sum(nodecount(:,node)); %%% so that is adds to one
end