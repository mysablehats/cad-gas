function labs = newlabeller(ssvotbtd)
labs = zeros(size(ssvotbtd));
for i = 1:size(ssvotbtd,2)
    [~, b] = min(ssvotbtd(:,i));
    labs(b,i) =1;
end
end