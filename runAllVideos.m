function runAllVideos()
   start = 'MouseVideobehaviorAnalysis/';
   extinction = dir([start 'Video/extinction/*.mov']); 
   recall = dir([start 'Video/recall/*.mov']);
   training = dir([start 'Video/training/*.mov']);
   
   analyze(extinction, 'extinction');
   analyze(recall, 'recall');
   analyze(training, 'training');
   
end

function analyze(database, name)
    for i = 1:1:length(database)
        mouseBehaviorAnalysis([database(i).folder, '/', database(i).name], name);
   end
end