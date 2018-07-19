function runAllVideos()
   %start = '';
   extinction = dir('Video/extinction/*.mov'); 
   recall = dir('Video/recall/*.mov');
   training = dir('Video/training/*.mov');
   
%    % Training
%    % Tone: 120-150 sec
%    analyze(training, 'training', 'Tone', 120, 150);
%    % Footshock 145-150 sec
%    analyze(training, 'training', 'Footshock', 145, 150);
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
   
    for i=0:5:265
        analyze(training, 'training-intervals', [num2str(i) '-' num2str(i+5) ' sec'], i, i+5);
    end
    
    for i=0:5:1255
        analyze(recall, 'recall-intervals', [num2str(i) '-' num2str(i+5) ' sec'], i, i+5);
    end
    
    for i=0:5:1255
        analyze(extinction, 'extinction-intervals', [num2str(i) '-' num2str(i+5) ' sec'], i, i+5);
    end
end