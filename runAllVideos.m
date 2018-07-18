function runAllVideos()
   %start = '';
   extinction = dir('Video/extinction/*.mov'); 
   recall = dir('Video/recall/*.mov');
   training = dir('Video/training/*.mov');
   
   % Training
   % Tone: 120-150 sec
   analyze(training, 'training', 'Tone', 120, 150);
   % Footshock 145-150 sec
   analyze(training, 'training', 'Footshock', 145, 150);
%    
%    % Recall
%    % Tone 120-150 sec
%    analyze(recall, 'recall', 'Tone1', 120, 150);
%    % Tone 240-270 sec
%    analyze(recall, 'recall', 'Tone2', 240, 270);
%    % Tone 330-360 sec
%    analyze(recall, 'recall', 'Tone3', 330, 360);
%    % Tone 420-450 sec
%    analyze(recall, 'recall', 'Tone4', 420, 450);
%    % Tone 570-600 sec
%    analyze(recall, 'recall', 'Tone5', 570, 600);
%    % Tone 630-660 sec
%    analyze(recall, 'recall', 'Tone6', 630, 660);
%    % Tone 720-750 sec
%    analyze(recall, 'recall', 'Tone7', 720, 750);
%    % Tone 870-900 sec
%    analyze(recall, 'recall', 'Tone8', 870, 900);
%    % Tone 960-990 sec
%    analyze(recall, 'recall', 'Tone9', 960, 990);
%    % Tone 1100-1130 sec
%    analyze(recall, 'recall', 'Tone10', 1100, 1130);
%    
%    % Extinction
%    % Tone 120-150 sec
%    analyze(extinction, 'extinction', 'Tone1', 120, 150);
%    % Tone 240-270 sec
%    analyze(extinction, 'extinction', 'Tone2', 240, 270);
%    % Tone 330-360 sec
%    analyze(extinction, 'extinction', 'Tone3', 330, 360);
%    % Tone 420-450 sec
%    analyze(extinction, 'extinction', 'Tone4', 420, 450);
%    % Tone 570-600 sec
%    analyze(extinction, 'extinction', 'Tone5', 570, 600);
%    % Tone 630-660 sec
%    analyze(extinction, 'extinction', 'Tone6', 630, 660);
%    % Tone 720-750 sec
%    analyze(extinction, 'extinction', 'Tone7', 720, 750);
%    % Tone 870-900 sec
%    analyze(extinction, 'extinction', 'Tone8', 870, 900);
%    % Tone 960-990 sec
%    analyze(extinction, 'extinction', 'Tone9', 960, 990);
%    % Tone 1100-1130 sec
%    analyze(extinction, 'extinction', 'Tone10', 1100, 1130);
   
end

function analyze(database, name, type, frame_start, frame_end)
    % Convert seconds to frames
    framerate = 3.75;
    frame_start = frame_start*framerate;
    frame_end = frame_end*framerate;
    
    %fprintf(fileID, [type ': \n']);
    printingMatrix = [type, "Velocity (cm/sec)", "Distance From Center (cm)", "Average Placement-X (cm)", "Average Placement-Y (cm)", "Mean Area (cm^2)", "Average Movement in Place (sec^2)", "Time On Wall (sec) - NOT DONE YET"];
    
    %for i = 1:1:length(database)
    for i = 1:1:2
        full_name = [database(i).folder, '/', database(i).name];
        finalMetrics = mouseBehaviorAnalysis(full_name, 0, frame_start, frame_end);
        
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
        TimeOnWall = finalMetrics.TimeOnWall;
        
        addMatrix = [string(database(i).name), MeanVelocity, DistanceFromCenter, AveragePlacementX,AveragePlacementY,MeanArea,MovementInPlace,TimeOnWall ];
        printingMatrix = [printingMatrix; addMatrix];
        
     end
    
    fileID = fopen(['new data/'  name '.csv'],'a');
    for k=1:size(printingMatrix,2)
        fprintf(fileID,'%s,',printingMatrix(1:end-1,k));
        fprintf(fileID,'%s',printingMatrix(end,k));
        fprintf(fileID,'\n');
    end
    
    fprintf(fileID, '\n');
   
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