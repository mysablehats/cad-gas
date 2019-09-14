<<<<<<< HEAD:startkinect.m
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
=======
%%%start kinect
function [vid,src] = startkinect()
src = [];
try
    [vid,src] = setvars_kinnect;
catch  ME
    %ME.getReport
    %disp('Couldnt open kinect')
    try
        vid = imaqfind; %in case i am already aquiring
        stop(vid)
        [vid,src] = setvars_kinnect;
    catch  ME2
        ME2.getReport
        try
            % For macs.
            % this is dumb
            vid = videoinput('macvideo', 1);
        catch  ME3
            ME3.getReport
            errordlg('No webcam available');
        end
    end
end
function [vid,src] = setvars_kinnect
vid = videoinput('kinect',2,'Depth_640x480');
    % Set parameters for video
    % Acquire only one frame each time
    set(vid,'FramesPerTrigger',1);
    % Go on forever until stopped
    set(vid,'TriggerRepeat',Inf);
    % Get a grayscale image
    set(vid,'ReturnedColorSpace','grayscale');
    triggerconfig(vid, 'Manual');
    %set(vid,'TrackingMode','Skeleton')
    src = getselectedsource(vid);
    src.TrackingMode = 'Skeleton';
    src.CameraElevationAngle = 0;      
>>>>>>> master:gui/startkinect.m
