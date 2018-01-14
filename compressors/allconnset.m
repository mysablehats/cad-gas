function allconn = allconnset(n, parskI,parsc)

if isempty(parskI)
    parsk = repmat(struct,10);
else
    parsk = repmat(parskI(1),10);
end
for i=1:length(parskI)
    parsk(i) = parskI(i);
end
allconn_set = {...
    {... %%%% ARCHITECTURE 1
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],parsk(4),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],parsk(5),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 2
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 2],parsk(3),'knn',parsc}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 2],parsk(4),'knn',parsc}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 2],parsk(5),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 3
    {'gng1layer',   'gng',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gng2layer',   'gng',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gng3layer',   'gng',{'gng1layer'},              'pos',[3 0],parsk(3),'knn',parsc}...
    {'gng4layer',   'gng',{'gng2layer'},              'vel',[3 0],parsk(4),'knn',parsc}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},  'all',[3 0],parsk(5),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 4
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 0],parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 0],parsk(4),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 0],parsk(5),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 5
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 2 3],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 2 3],parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],parsk(4),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[3 2],parsk(5),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 6
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 4 2],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 4 2],parsk(2),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],parsk(3),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 7
    {'gwr1layer',   'gwr',{'all'},                    'all',[3 2], parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'all',[3 2], parsk(2),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 8
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[9 0], parsk(1),'knn',parsc}... %% now there is a vector where q used to be, because we have the p overlap variable...
    }...
    {...%%%% ARCHITECTURE 9
    {'gwr1layer',   'gwr',{'pos'},                    'pos',3,parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',3,parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',3,parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',3,parsk(4),'knn',parsc}...
    {'gwr5layer',   'gwr',{'gwr3layer'},              'pos',3,parsk(5),'knn',parsc}...
    {'gwr6layer',   'gwr',{'gwr4layer'},              'vel',3,parsk(6),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr6layer','gwr5layer'},  'all',3,parsk(7),'knn',parsc}
    }...
    {... %%%% ARCHITECTURE 10
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[3 2],parsk(3),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 11
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[3 2],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[3 2],parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[3 2],parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[3 2],parsk(4),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[1 0],parsk(5),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 12
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'pos',[9 0],parsk(2),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 13
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'gwr1layer'},              'vel',[9 0],parsk(2),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 14
    {'gwr1layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(1),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 15
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gwr3layer',   'gwr',{'gwr1layer'},              'pos',[2 1],parsk(3),'knn',parsc}...
    {'gwr4layer',   'gwr',{'gwr2layer'},              'vel',[2 1],parsk(4),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},  'all',[4 3],parsk(5),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 16
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    }...
    {... %%%% ARCHITECTURE 17
    {'gwr1layer',   'gwr',{'all'},                    'all',[1 0],parsk(1),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 18
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'gwr',{'vel'},                    'vel',[1 0],parsk(2),'knn',parsc}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},  'all',[100 0],parsk(3),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 19
    {'gwr1layer',   'gwr',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    {'gwr2layer',   'knn',{'gwr1layer'},              'pos',[70 0],parsk(2),'knn',parsc}...
    }...
    {...%%%% ARCHITECTURE 20
    {'gwr1layer',   'knn',{'pos'},                    'pos',[6 0],parsk(1),'svm',parsc}...
    }...
    {...%%%% ARCHITECTURE 21
    {'gwr1layer',   'knn',{'pos'},                    'pos',[7 0],parsk(1),'svm',parsc}...
    }...
    {...%%%% ARCHITECTURE 22
    {'gwr1layer',   'knn',{'pos'},                    'pos',[8 0],parsk(1),'svm',parsc}...
    }...
    {...%%%% ARCHITECTURE 23
    {'gwr1layer',   'knn',{'pos'},                    'pos',[9 0],parsk(1),'svm',parsc}...
    }...
    {...%%%% ARCHITECTURE 24
    {'gwr1layer',   'knn',{'pos'},                    'pos',[10 0],parsk(1),'svm',parsc}...
    }...
    {...%%%% ARCHITECTURE 25
    
    {'knn1layer',   'knn',{'pos'},                    'pos',[1 0],parsk(1),'knn',parsc}...
    }...
    };
allconn = allconn_set{n};
end
