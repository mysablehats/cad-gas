classdef Chunk
    properties
        Size = 1000;
        chunk
        IMdepth = uint8([]);
        IMcolor = uint8([]);
        times
        label = {''};
        description = 'Some description';
        framesacquired = 0;
        counter = 1;
        complete = 0;
        metadata = struct([]);
    end
    methods
        function obj  = create(obj, size, label, description, res)
            obj.Size = size;
            obj.chunk = zeros(20,3,size);
            obj.label = label;
            obj.description = description;
            obj.IMdepth = uint8(zeros(res(1),res(2),size));
            obj.IMcolor = uint8(zeros(res(1),res(2),3,size));
            obj.times = zeros(1,size);
        end
        function chunk = write(chunk, metaData, IMdepth,IMcolor, timedy_times,i, recording)
            triggersize = size(metaData,1);
            tv = chunk.counter:(chunk.counter+triggersize-1);
            %tensorskel = zeros([size(metaData(1).JointWorldCoordinates(:,:,i)),triggersize]);
            if chunk.counter == 1
                chunk = setfield(chunk, 'metadata', metaData);
            end
            for iii = tv %1:triggersize
                chunk.chunk(:,:,iii) = metaData(iii-chunk.counter+1).JointWorldCoordinates(:,:,i);
                chunk.metadata(iii) = metaData(iii-chunk.counter+1);
                %tensorskel(:,:,iii) =  metaData(iii).JointWorldCoordinates(:,:,i);                
            end
            %chunk.chunk(:,:,tv) = tensorskel; %%% this only gets one frame. if i get more frames I don't know the timestamps between them!

            %chunk = setfield(chunk,{1}, 'metadata',{(tv)}, metaData);
            chunk.IMdepth(:,:,tv) = IMdepth;
            chunk.IMcolor(:,:,:,tv) = IMcolor;
            
            dbgmsg('chunk.counter', num2str(chunk.counter),0)
            if recording
                chunk.times(chunk.counter:(chunk.counter+triggersize-1)) = timedy_times.';
                chunk.counter = chunk.counter +triggersize;
                chunk.framesacquired = chunk.framesacquired + triggersize;
            end
        end
        function chunk = finish(chunk)
            chunk.complete = 1;
            chunk.times = chunk.times - chunk.times(1);
        end
        
    end
end