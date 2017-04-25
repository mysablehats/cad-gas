%%%start kinect
function [vid,src] = startkinect(fpt)
src = [];
try
    [vid,src] = setvars_kinnect(fpt);
catch  ME
    %ME.getReport
    %disp('Couldnt open kinect')
    try
        vid = imaqfind; %in case i am already aquiring
        stop(vid)
        delete(vid)
        [vid ,src] = setvars_kinnect(fpt);
    catch  ME2
        ME2.getReport
        try
            % For macs.
            % this is dumb
            vid = videoinput('macvideo', 1);
            %depthVid = [];
        catch  ME3
            ME3.getReport
            errordlg('No webcam available');
        end
    end
end
function [vid,src] = setvars_kinnect(fpt)
depthVid = videoinput('kinect',2,'Depth_320x240');
colorVid = []; %videoinput('kinect',1);
vid = [depthVid, colorVid];
% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',fpt);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
%set(depthVid,'ReturnedColorSpace','grayscale');
triggerconfig(vid, 'Manual');
%set(vid,'TrackingMode','Skeleton')
src = getselectedsource(depthVid);
src.TrackingMode = 'Skeleton';
src.CameraElevationAngle = 0;