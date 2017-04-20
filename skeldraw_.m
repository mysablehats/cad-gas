function [A] = skeldraw_(skel,doIdraw)

    A = other_stick_draw(skel);

end

function a = stick_draw(tdskel)

%
%in the end the end the text command upstairs was what did the job and I
%wrote down the connection of the skeleton points
%it is as follows:
% 1-2-21-3 torso
% 3-4 head
%
% 5-6-7 right arm
% 8 22 23 right hand
% 
% 9-10-11 left arm
% 12 24 25 left hand
%
% 5-21-9 shoulder
%
% 13-1-17 hip
%
% 13-14-15 right leg
% 15-16 right foot
%
% 17-18-19 left leg
% 19-20 left foot

a = draw_1_stick(tdskel, 1,2);
%draw_1_stick(tdskel, 2,3)
a= [a draw_1_stick(tdskel, 2,21)];
a= [a draw_1_stick(tdskel, 21,3)];
a= [a draw_1_stick(tdskel, 3,4)];

a= [a draw_1_stick(tdskel, 5,21)];
a= [a draw_1_stick(tdskel, 21,9)];

a= [a draw_1_stick(tdskel, 5,6)];
a= [a draw_1_stick(tdskel, 6,7)];

a= [a draw_1_stick(tdskel, 7,8)]; % unsure

a= [a draw_1_stick(tdskel, 8,22)];
a= [a draw_1_stick(tdskel, 22,23)]; % unsure
a= [a draw_1_stick(tdskel, 8,23)]; % unsure

a= [a draw_1_stick(tdskel, 9,10)];
a= [a draw_1_stick(tdskel, 10,11)];

a= [a draw_1_stick(tdskel, 11,12)]; % unsure
a= [a draw_1_stick(tdskel, 12,24)];
a= [a draw_1_stick(tdskel, 12,25)]; % unsure
a= [a draw_1_stick(tdskel, 24,25)];
a= [a draw_1_stick(tdskel, 13,1)];
a= [a draw_1_stick(tdskel, 1,17)];
a= [a draw_1_stick(tdskel, 13,17)]; % draw a thick hip, because we like hips

a= [a draw_1_stick(tdskel, 13,14)];
a= [a draw_1_stick(tdskel, 14,15)];
a= [a draw_1_stick(tdskel, 15,16)];
a= [a draw_1_stick(tdskel, 17,18)];
a= [a draw_1_stick(tdskel, 18,19)];
a= [a draw_1_stick(tdskel, 19,20)];

end
function a = other_stick_draw(tdskel)

a = draw_1_stick(tdskel, 1,2);
a= [a draw_1_stick(tdskel, 2,3)];
a= [a draw_1_stick(tdskel, 3,4)];
a= [a draw_1_stick(tdskel, 3,5)];
a= [a draw_1_stick(tdskel, 5,6)];
a= [a draw_1_stick(tdskel, 6,7)];
a= [a draw_1_stick(tdskel, 7,8)];
a= [a draw_1_stick(tdskel, 3,9)];
a= [a draw_1_stick(tdskel, 9,10)];
a= [a draw_1_stick(tdskel, 10,11)];
a= [a draw_1_stick(tdskel, 11,12)];
a= [a draw_1_stick(tdskel, 1,17)];
a= [a draw_1_stick(tdskel, 17,18)];
a= [a draw_1_stick(tdskel, 18,19)];
a= [a draw_1_stick(tdskel, 19,20)];
a= [a draw_1_stick(tdskel, 1,13)];
a= [a draw_1_stick(tdskel, 13,14)];
a= [a draw_1_stick(tdskel, 14,15)];
a= [a draw_1_stick(tdskel, 15,16)];

end
function a = another_stick_draw()
a = draw_1_stick(tdskel, 1,2);
a= [a draw_1_stick(tdskel, 2,3)];
end
function A = draw_1_stick(tdskel, i,j)
A = [[tdskel(i,1) tdskel(j,1) NaN]; [tdskel(i,2) tdskel(j,2) NaN]];% [tdskel(i,3) tdskel(j,3) NaN]];
end
