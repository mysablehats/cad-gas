function allskel = affinerepair(allskel, simvar)

%maybe if i corrected to the torso, say shoulders and hips i wuld get the
%best results

%now we can maybe check this against our sample skeleton
%aaa = load('/Volumes/share/ar/Elements/Dropbox/all.mat/skellstoplaywith.mat');%[simvar.allmatpath 'skellstoplaywith.mat']);%allskel.skel(:,:,1);
%longsamp = aaa.a(:,1)';
aaa = load('/Volumes/share/ar/Elements/Dropbox/all.mat/askel.mat');
longsamp = makethinskel(aaa.askel)';
NN = size(allskel.skel,3);


sampskel_raw = reshape(longsamp,[],3);
assert(all(all(aaa.askel==sampskel_raw))) %% you know what you have to do...

sampskel_centered = sampskel_raw - mean(sampskel_raw);

if simvar.normrepair 
    thissize = normalizeskeleton_tensor(sampskel_centered);
    sampskel = sampskel_centered/thissize;
else
    sampskel = sampskel_centered;
end



for i = 1:NN
    %cov_ = allskel.skel(:,:,i).'*sampskel; %%maybe I will need to make it into a for
    
    %%% the skeletons need to be centered for this procedure! if they are
    %%% not, I need to offset them back
    offset = mean(allskel.skel(:,:,i));
    
    centered_allskeli = allskel.skel(:,:,i) - offset; %% implicit repmat
    
    cov_ = sampskel.'*centered_allskeli; %%maybe I will need to make it into a for

    [u,s,v] = svd(cov_);
    
    r = v*u.';
    
    rotskel = centered_allskeli*r; %or the other way around... better to change the cov_ calculation because there will be fewer operations
    %%%check whether I have the right orientation:
    longskel = reshape(centered_allskeli,1,[]);
    longrskel = reshape(rotskel,1,[]);
    a = pdist2(longsamp,longrskel,'euclidean','Smallest',1);
    b = pdist2(longsamp, longskel,'euclidean','Smallest',1);
    if a<b
        allskel.skel(:,:,i) = rotskel + offset; %% if they are centered, they should have offset zero, so I probably don't need to check
        if simvar.affrepvel
            allskel.vel(:,:,i) = allskel.vel(:,:,i)*r; %because it was also rotated
        end
    else
        if (b+0.005)<a
            warning(['Wrong order! rotation doesn''t work for skeleton: ' num2str(NN) 'will do nothing!' ])
        end
    end
    %%% all of this should be commented out!

end

end
