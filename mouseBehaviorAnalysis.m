function mouseBehaviorAnalysis(filename, writingtextname)
    VideoSize = [432 528];
    
    scale = 1/9.75; % centimeter/pixel
    frameRate = 3.75; % frame/second

    videoReader = vision.VideoFileReader(filename);
    videoPlayer = vision.VideoPlayer('Position',[200,200,500,400]);
    foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 1000, ...
                    'InitialVariance', 0.05);
    blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
                    'MinimumBlobArea', 70);

    kalmanFilter = []; isTrackInitialized = false;
    oldPoints = [];
    velocityLabel = 0; velocityTotal = [];
    while ~isDone(videoReader)
        colorImage = step(videoReader);
        bw_file = rgb2gray(colorImage);
        background = imopen(bw_file,strel('disk',15));

        ax = gca;
        ax.YDir = 'reverse';

        % Remove Background Approximation and increase contrast
        bw2 = bw_file - background;

        foregroundMask = foregroundDetector(bw2);
        foregroundMask = bwareaopen(foregroundMask, 15);
        foregroundMask = imfill(foregroundMask, 'holes');
        
        detectedLocation = step(blobAnalyzer,foregroundMask); % [x,y]
        isObjectDetected = size(detectedLocation, 1) > 0;

        if ~isTrackInitialized
            if isObjectDetected
                kalmanFilter = configureKalmanFilter('ConstantAcceleration',...
                          detectedLocation(1,:), [1 1 1]*1e5, [1, 10, 10], 25);
                isTrackInitialized = true;
            end

            label = 'Initial'; circle = zeros(0,3);

        else 
            if isObjectDetected 
             predict(kalmanFilter);
             trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
             label = 'Corrected';
            else
             trackedLocation = predict(kalmanFilter);
             label = 'Predicted';
            end
            circle = [trackedLocation, 5];
            
            points = trackedLocation;
            if ~isempty(oldPoints)
                % Calculate velocity (pixels/frame)
                vel_pix = sqrt(sum((points-oldPoints).^2,2));
                velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
                velocityTotal = [velocityTotal velocityLabel];
            else
                vel_pix = 0;
                vel = 0;
            end
            oldPoints = points;
        end

        foregroundMask = im2single(foregroundMask);
        
        foregroundMask = insertObjectAnnotation(foregroundMask, 'circle', ...
          circle, cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');
      
        % ONLY IF YOU WANT TO SEE IT WORKING IN REAL TIME
        %imshowpair(foregroundMask, colorImage, 'blend');
        
    end

    velocityTotal = velocityTotal(velocityTotal ~= 0);
    meanVelocity = mean(velocityTotal);
    
    fileID = fopen([writingtextname '.txt'],'w');
    fprintf(fileID, [filename ': ']);
    fprintf(fileID, '%f', meanVelocity);
    fclose(fileID);
    
    release(videoPlayer);
end