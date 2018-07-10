function runAllVideos()
   start = '';
   extinction = dir([start 'Video/extinction/*.mov']); 
   recall = dir([start 'Video/recall/*.mov']);
   training = dir([start 'Video/training/*.mov']);
   
   analyze(training, 'training');
   analyze(recall, 'recall');
   analyze(extinction, 'extinction');
   
end

function analyze(database, name)
    fileID = fopen([name '.txt'],'w');
    for i = 1:1:length(database)
        fprintf(fileID, [database(i).name ': ']);
        meanVelocity = mouseBehaviorAnalysis([database(i).folder, '/', database(i).name], 10, 100);
        fprintf(fileID, '%f\n', meanVelocity);
    end
    fclose(fileID);
end