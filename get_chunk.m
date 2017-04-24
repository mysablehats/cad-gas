function chunk = get_chunk(metaData, IMdepth,IMcolor,chunk,i)
triggersize = size(metaData,1);
tv = chunk.counter:(chunk.counter+triggersize-1);

%chunk.chunk(:,:,2:end) = chunk.chunk(:,:,1:end-1);
%tensorskel = zeros([size(metaData(1).JointWorldCoordinates(:,:,i)),triggersize]);
for iii = tv
    chunk.chunk(:,:,iii) =  metaData(iii-chunk.counter+1).JointWorldCoordinates(:,:,i);
    chunk.MetaData(iii) = metaData(iii-chunk.counter+1);
    %tensorskel(:,:,iii) =  metaData(iii).JointWorldCoordinates(:,:,i);
end
%chunk.chunk(:,:,tv) = tensorskel; %%% this only gets one frame. if i get more frames I don't know the timestamps between them!

chunk.IMdepth(:,:,tv) = IMdepth;
chunk.IMcolor(:,:,:,tv) = IMcolor;


dbgmsg('chunk.counter', num2str(chunk.counter),0)
if chunk.counter>triggersize
    chunk.times(chunk.counter-triggersize) = toc(chunk.timers(chunk.counter-triggersize));
end
chunk.timers(chunk.counter) = tic;
chunk.counter = chunk.counter +triggersize;