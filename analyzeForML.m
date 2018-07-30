function analyzeForML(database, name, sec_start, sec_end, threshold, start_tone, end_tone)
    % Convert seconds to frames
    framerate = 4;
    frame_start = sec_start*framerate;
    frame_end = sec_end*framerate;
    
    %fprintf(fileID, [type ': \n']);
    printingMatrix = ["Velocity (cm/sec)", "Distance From Center (cm)", "Average Placement-X (cm)", "Average Placement-Y (cm)", "Mean Area (cm^2)", "Average Movement in Place (sec)", "Total Distance Traveled (cm)", "Fear/No Fear"];
    addMatrix = [];
    for i = 1:1:length(database)
        full_name = [database(i).folder, '/', database(i).name];
        finalMetrics = mouseBehaviorAnalysis(full_name, 0, frame_start, frame_end, threshold);
        
%         fprintf(fileID, 'Velocity: %f cm/sec. ', finalMetrics.MeanVelocity);
%         fprintf(fileID, 'Distance From Center: %f cm. ', finalMetrics.DistanceFromCenter);
%         fprintf(fileID, 'Average Placement: [%f, %f] cm. (Upper Left Corner=[0, 0])\n', finalMetrics.AveragePlacement);
%         fprintf(fileID, 'Mean Area: %f cm^2\n', finalMetrics.MeanArea);
%         fprintf(fileID, 'Average Movement in Place: %f sec^2\n', finalMetrics.MovementInPlace);
%         fprintf(fileID, 'Time On Wall: %f sec\n', finalMetrics.TimeOnWall);
        MeanVelocity = finalMetrics.MeanVelocity;
        DistanceFromCenter = finalMetrics.DistanceFromCenter;
        AveragePlacement = finalMetrics.AveragePlacement;
        AveragePlacementX = AveragePlacement(:,1);
        AveragePlacementY = AveragePlacement(:,2);
        MeanArea = finalMetrics.MeanArea;
        MovementInPlace = finalMetrics.MovementInPlace;
        TotalDistanceTraveled = finalMetrics.TotalDistanceTraveled;
        
        % Specifically for recall
        if sec_start >= start_tone && sec_end <= end_tone
            FearNoFear = 1;
        else 
            FearNoFear = 0;
        end
        
        addMatrix = [addMatrix; MeanVelocity, DistanceFromCenter, AveragePlacementX,AveragePlacementY,MeanArea,MovementInPlace,TotalDistanceTraveled, FearNoFear];
        
    end
    
    %printingMatrix = [printingMatrix; addMatrix];
    printingMatrix = addMatrix;
    fileID = fopen(['new data/'  name '.csv'],'a');
    for k=1:size(printingMatrix,1)
        fprintf(fileID,'%f,',printingMatrix(k,1:end-1));
        fprintf(fileID,'%f',printingMatrix(k,end));
        fprintf(fileID,'\n');
    end
    
    %fprintf(fileID, '\n');
   
    fclose(fileID);

%     filename = ['new data/'  name '.csv'];
%     for i = 1:1:length(database)
%         vid_name = [database(i).folder, '/', database(i).name];
%         finalMetrics = mouseBehaviorAnalysis(vid_name, 0, frame_start, frame_end);
%         
%         MeanVelocity = finalMetrics.MeanVelocity;
%         DistanceFromCenter = finalMetrics.DistanceFromCenter;
%         AveragePlacement = finalMetrics.AveragePlacement;
%         MeanArea = finalMetrics.MeanArea;
%         MovementInPlace = finalMetrics.MovementInPlace;
%         TimeOnWall = finalMetrics.TimeOnWall;
%         
%         printingMatrix = { ... %{[type ': ' database(i).name]; ...
%             'Velocity (cm/sec)', 'Distance From Center (cm)', 'Average Placement (cm)', 'Mean Area (cm^2)', 'Average Movement in Place (sec^2)', 'Time On Wall (sec) - NOT DONE YET';...
%             MeanVelocity,         DistanceFromCenter,          AveragePlacement,         MeanArea,           MovementInPlace,                     TimeOnWall };
%         
%         xlswrite(filename, printingMatrix);
%     end
end