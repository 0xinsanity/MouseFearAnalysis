function runAllVideos()
   %start = '';
   extinction = dir('Newer Videos/Chat Recall/extinction/*.avi'); 
   recall = dir('Newer Videos/Chat Recall/*.avi');
   recall = dir('Newer Videos/Prenatal Nicotine A thru I Vids/recall/*.avi');
   
%    % Training
%    % Tone: 120-150 sec
%    analyze(training, 'training', 'Tone', 120, 150, 3);
%    % Footshock 145-150 sec
%    analyze(training, 'training', 'Footshock', 145, 150, 3);
%    
%    % Recall
%    % Tone 120-150 sec
%    analyze(recall, 'recall', 'Tone1', 120, 150, 3);
%    % Tone 240-270 sec
%    analyze(recall, 'recall', 'Tone2', 240, 270, 3);
%    % Tone 330-360 sec
%    analyze(recall, 'recall', 'Tone3', 330, 360, 3);
%    % Tone 420-450 sec
%    analyze(recall, 'recall', 'Tone4', 420, 450, 3);
%    % Tone 570-600 sec
%    analyze(recall, 'recall', 'Tone5', 570, 600, 3);
%    % Tone 630-660 sec
%    analyze(recall, 'recall', 'Tone6', 630, 660, 3);
%    % Tone 720-750 sec
%    analyze(recall, 'recall', 'Tone7', 720, 750, 3);
%    % Tone 870-900 sec
%    analyze(recall, 'recall', 'Tone8', 870, 900, 3);
%    % Tone 960-990 sec
%    analyze(recall, 'recall', 'Tone9', 960, 990, 3);
%    % Tone 1100-1130 sec
%    analyze(recall, 'recall', 'Tone10', 1100, 1130, 3);
%    
%    % Extinction
%    % Tone 120-150 sec
%    analyze(extinction, 'extinction', 'Tone1', 120, 150, 3);
%    % Tone 240-270 sec
%    analyze(extinction, 'extinction', 'Tone2', 240, 270, 3);
%    % Tone 330-360 sec
%    analyze(extinction, 'extinction', 'Tone3', 330, 360, 3);
%    % Tone 420-450 sec
%    analyze(extinction, 'extinction', 'Tone4', 420, 450, 3);
%    % Tone 570-600 sec
%    analyze(extinction, 'extinction', 'Tone5', 570, 600, 3);
%    % Tone 630-660 sec
%    analyze(extinction, 'extinction', 'Tone6', 630, 660, 3);
%    % Tone 720-750 sec
%    analyze(extinction, 'extinction', 'Tone7', 720, 750, 3);
%    % Tone 870-900 sec
%    analyze(extinction, 'extinction', 'Tone8', 870, 900, 3);
%    % Tone 960-990 sec
%    analyze(extinction, 'extinction', 'Tone9', 960, 990, 3);
%    % Tone 1100-1130 sec
%    analyze(extinction, 'extinction', 'Tone10', 1100, 1130, 3);
   
    %for i=660:30:1880
    %    analyze(training, 'training-intervals', [num2str(i) '-' num2str(i+30) ' sec'], i, i+30, 0.1);
    %end
    
    for i=0:30:210
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 120, 180);
    end
    
    for i=210:30:360
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 210, 270);
    end
    
    for i=360:30:510
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 360, 420);
    end
    
    for i=510:30:660
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 510, 630);
    end

    for i=660:30:810
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 660, 720);
    end
    
    for i=810:30:900
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 810, 870);
    end
    
    for i=900:30:1050
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 900, 960);
    end
    
    for i=1050:30:1110
         analyzeForML(extinction, 'extinction-interval-chat', i, i+30, 0.1, 1050, 1110);
    end
    
%     for i=0:30:240
%         analyzeForML(recall, 'recall-interval-OG', i, i+30, 0.1, 120, 180);
%     end
%     for i=240:30:300
%         analyzeForML(recall, 'recall-interval-OG2', i, i+30, 0.1, 240, 300);
%     end
%     for i=300:30:420
%         analyzeForML(recall, 'recall-interval-OG3', i, i+30, 0.1, 330, 390);
%     end
%     for i=420:30:570
%         analyzeForML(recall, 'recall-interval-OG4', i, i+30, 0.1, 420, 480);
%     end
%     for i=570:30:720
%         analyzeForML(recall, 'recall-interval-OG5', i, i+30, 0.1, 570, 690);
%     end
%     for i=690:30:870
%         analyzeForML(recall, 'recall-interval-OG6', i, i+30, 0.1, 720, 780);
%     end
    
%     for i=0:30:990
%         analyze(recall, 'recall-intervals', [num2str(i) '-' num2str(i+30) ' sec'], i, i+30, 0.1);
%     end
    
    %for i=0:5:1255
    %    analyze(extinction, 'extinction-intervals', [num2str(i) '-' num2str(i+5) ' sec'], i, i+5, 0.1);
    %end
end