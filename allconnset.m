function allconn = allconnset(n, paramsI)

if isempty(paramsI)
    params = repmat(struct,10);
else
    params = repmat(paramsI(1),10);
end
for i=1:length(paramsI)
    params(i) = paramsI(i);
end
allconn_set = {...
    {... %%%% ARCHITECTURE 1
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 2
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params(1)}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params(2)}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 2],params(3)}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 2],params(4)}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 3
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],params(1)}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],params(2)}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 0],params(3)}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 0],params(4)}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 0],params(5)}...
    }...
    {...%%%% ARCHITECTURE 4
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 0],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 0],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 0],params(5)}...
    }...
    {...%%%% ARCHITECTURE 5
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 2 3],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 2 3],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],params(5)}...
    }...
    {...%%%% ARCHITECTURE 6
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 4 2],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 4 2],params(2)}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params(3)}...
    }...
    {...%%%% ARCHITECTURE 7
    {'gwr1layer',   'gwr',{'all'},                    'all',[3 2], params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'all',[3 2], params(2)}...
    }...
    {...%%%% ARCHITECTURE 8
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[9 0], params(1)}... %% now there is a vector where q used to be, because we have the p overlap variable...
    }...
    {...%%%% ARCHITECTURE 9
    {'gwr1layer',   'gwr',{'pos'},                    'pos',3,params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',3,params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',3,params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',3,params(4)}...
    {'gwr5layer',   'gwr',{'gwr3layer'},              'pos',3,params(5)}...
    {'gwr6layer',   'gwr',{'gwr4layer'},              'vel',3,params(6)}...
    {'gwrSTSlayer', 'gwr',{'gwr6layer','gwr5layer'},  'all',3,params(7)}
    }...
    {... %%%% ARCHITECTURE 10
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],params(3)}...
    }...
    {... %%%% ARCHITECTURE 11
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 2],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 2],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[1 0],params(5)}...
    }...
    {... %%%% ARCHITECTURE 12
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'pos',[9 0],params(2)}...
    }...
    {... %%%% ARCHITECTURE 13
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'vel',[9 0],params(2)}...
    }...
    {... %%%% ARCHITECTURE 14
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],params(1)}...
    }...
    {... %%%% ARCHITECTURE 15
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],params(2)}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[2 1],params(3)}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[2 1],params(4)}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[4 3],params(5)}...
    }...
    {... %%%% ARCHITECTURE 16
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],params(1)}...
    }...
    {... %%%% ARCHITECTURE 17
    {'gwr1layer',   'gwr',{'all'},                    'all',[1 0],params(1)}...
    }...
    };
allconn = allconn_set{n};
end