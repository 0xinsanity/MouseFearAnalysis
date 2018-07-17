function runAllVideos()
   start = '';
   extinction = dir([start 'Video/extinction/*.mov']); 
   recall = dir([start 'Video/recall/*.mov']);
   training = dir([start 'Video/training/*.mov']);
   
   % Training
   % Tone: 120-150 sec
   analyze(training, 'training', 'Tone', 120, 150);
   % Footshock 145-150 sec
   analyze(training, 'training', 'Footshock', 145, 150);
   
   % Recall
   % Tone 120-150 sec
   analyze(recall, 'recall', 'Tone1', 120, 150);
   % Tone 240-270 sec
   analyze(recall, 'recall', 'Tone2', 240, 270);
   % Tone 330-360 sec
   analyze(recall, 'recall', 'Tone3', 330, 360);
   % Tone 420-450 sec
   analyze(recall, 'recall', 'Tone4', 420, 450);
   % Tone 570-600 sec
   analyze(recall, 'recall', 'Tone5', 570, 600);
   % Tone 630-660 sec
   analyze(recall, 'recall', 'Tone6', 630, 660);
   % Tone 720-750 sec
   analyze(recall, 'recall', 'Tone7', 720, 750);
   % Tone 870-900 sec
   analyze(recall, 'recall', 'Tone8', 870, 900);
   % Tone 960-990 sec
   analyze(recall, 'recall', 'Tone9', 960, 990);
   % Tone 1100-1130 sec
   analyze(recall, 'recall', 'Tone10', 1100, 1130);
   
   % Extinction
   % Tone 120-150 sec
   analyze(extinction, 'extinction', 'Tone1', 120, 150);
   % Tone 240-270 sec
   analyze(extinction, 'extinction', 'Tone2', 240, 270);
   % Tone 330-360 sec
   analyze(extinction, 'extinction', 'Tone3', 330, 360);
   % Tone 420-450 sec
   analyze(extinction, 'extinction', 'Tone4', 420, 450);
   % Tone 570-600 sec
   analyze(extinction, 'extinction', 'Tone5', 570, 600);
   % Tone 630-660 sec
   analyze(extinction, 'extinction', 'Tone6', 630, 660);
   % Tone 720-750 sec
   analyze(extinction, 'extinction', 'Tone7', 720, 750);
   % Tone 870-900 sec
   analyze(extinction, 'extinction', 'Tone8', 870, 900);
   % Tone 960-990 sec
   analyze(extinction, 'extinction', 'Tone9', 960, 990);
   % Tone 1100-1130 sec
   analyze(extinction, 'extinction', 'Tone10', 1100, 1130);
   
end

function analyze(database, name, type, frame_start, frame_end)
    % Convert seconds to frames
    framerate = 3.75;
    frame_start = frame_start*framerate;
    frame_end = frame_end*framerate;
    
    fileID = fopen(['new data/'  name '.txt'],'a');
    fprintf(fileID, [type ': \n']);
    for i = 1:1:length(database)
        fprintf(fileID, [database(i).name ': ']);
        
        full_name = [database(i).folder, '/', database(i).name];
        finalMetrics = mouseBehaviorAnalysis(full_name, 0, frame_start, frame_end);
        
        fprintf(fileID, 'Velocity: %f cm/sec. ', finalMetrics.MeanVelocity);
        fprintf(fileID, 'Distance From Center: %f cm. ', finalMetrics.DistanceCenter);
        fprintf(fileID, 'Average Placement: [%f, %f] cm.\n', finalMetrics.AveragePlacement);
        fprintf(fileID, 'Mean Area: %f cm^2\n', finalMetrics.MeanArea);
        fprintf(fileID, 'Average Movement in Place: %f sec^2\n', finalMetrics.MeanArea);
    end
    
    fprintf(fileID, '\n');
    
    fclose(fileID);
end