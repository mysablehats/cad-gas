%%%start kinect
function [depthVid, colorVid,src] = startkinect(fpt)
src = [];
try
    [depthVid, colorVid,src] = setvars_kinnect(fpt);
catch  ME
    %ME.getReport
    %disp('Couldnt open kinect')
    try
        vid = imaqfind; %in case i am already aquiring
        stop(vid)
        delete(vid)
        [depthVid, colorVid ,src] = setvars_kinnect(fpt);
    catch  ME2
        ME2.getReport
        try
            % For macs.
            % this is dumb
            colorVid = videoinput('macvideo', 1);
            depthVid = [];
        catch  ME3
            ME3.getReport
            errordlg('No webcam available');
        end
    end
end
function [depthVid, colorVid,src] = setvars_kinnect(fpt)
depthVid = videoinput('kinect',2,'Depth_640x480');
colorVid = videoinput('kinect',1);
set(colorVid,'Timeout',70);
set(depthVid,'Timeout',70);
% Set parameters for video
% Acquire only one frame each time
set([depthVid, colorVid],'FramesPerTrigger',fpt);
% Go on forever until stopped
set([depthVid, colorVid],'TriggerRepeat',Inf);
% Get a grayscale image
%set(depthVid,'ReturnedColorSpace','grayscale');
triggerconfig([depthVid colorVid], 'Manual');
%set(vid,'TrackingMode','Skeleton')
src = getselectedsource(depthVid);
src.TrackingMode = 'Skeleton';
src.CameraElevationAngle = -4;