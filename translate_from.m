function a15 = translate_from(a20_ori)
%writing by hand, so that is is faster...  
%must change y and z because the definitions are different
%a20 = [a20_ori(:,1,:) a20_ori(:,3,:) -a20_ori(:,2,:)];
a20 = [a20_ori(:,1,:) a20_ori(:,2,:) a20_ori(:,3,:)];

%a20 = a20_ori;
%btw, I made a mistake with the conversion
c = 4.5691;
a15(1,:,:) = c*a20(4,:,:); 
a15(2,:,:) = c*a20(3,:,:); 
a15(3,:,:) = c*a20(2,:,:); 
a15(4,:,:) = c*a20(5,:,:); 
a15(5,:,:) = c*a20(6,:,:); 
a15(6,:,:) = c*a20(9,:,:); 
a15(7,:,:) = c*a20(10,:,:); 
a15(8,:,:) = c*a20(13,:,:); 
a15(9,:,:) = c*a20(14,:,:); 
a15(10,:,:) = c*a20(17,:,:); 
a15(11,:,:) = c*a20(18,:,:); 
a15(12,:,:) = c*a20(8,:,:); 
a15(13,:,:) = c*a20(12,:,:); 
a15(14,:,:) = c*a20(16,:,:); 
a15(15,:,:) = c*a20(20,:,:); 

% %writing by hand, so that is is faster... 
% a15(1,:,:) = a20(4,:,:); 
% a15(2,:,:) = a20(2,:,:); 
% a15(3,:,:) = a20(3,:,:); 
% a15(4,:,:) = a20(5,:,:); 
% a15(5,:,:) = a20(6,:,:); 
% a15(6,:,:) = a20(9,:,:); 
% a15(7,:,:) = a20(10,:,:); 
% a15(8,:,:) = a20(13,:,:); 
% a15(9,:,:) = a20(14,:,:); 
% a15(10,:,:) = a20(17,:,:); 
% a15(11,:,:) = a20(18,:,:); 
% a15(12,:,:) = a20(8,:,:); 
% a15(13,:,:) = a20(12,:,:); 
% a15(14,:,:) = a20(16,:,:); 
% a15(15,:,:) = a20(20,:,:); 


end