function finalValue = mouseBehaviorAnalysis(filename, show_work, frame_start, frame_end)
    VideoSize = [210 300];
    
    scale = 1/9.75; % centimeter/pixel
    frameRate = 3.75; % frame/second

    videoReader = vision.VideoFileReader(filename);
    videoPlayer = vision.VideoPlayer('Position',[200,200,500,400]);
    foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 500, ...
                    'InitialVariance', 0.05);
    blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
                    'MinimumBlobArea', 70);
                
    kalmanFilter = []; isTrackInitialized = false;
    velocityLabel = 0; velocityTotal = [];
    
    center = [105 150];
    oldPoints = [];
    
    for i=1:frame_start
        test = step(videoReader);
    end
    
    for i=frame_start:1:frame_end
        detectedLocationPoint = [0 0];
        
        colorImage = step(videoReader);
        bw_file = rgb2gray(colorImage);
        
        %background_img = imread('Video/accuratebackground.png'); 
        %background_img = rgb2gray(background_img);

        % get background approximation of surface (lighting and stuff)
        background = imopen(bw_file,strel('disk',35));

        % Display the Background Approximation as a Surface
        ax = gca;
        ax.YDir = 'reverse';

        % Remove Background Approximation
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

            circle = zeros(0,3);

        else 
            if isObjectDetected 
                predict(kalmanFilter);
                trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
            end
            circle = [trackedLocation 3];
            
            points = trackedLocation;
            if ~isempty(oldPoints)
                % Calculate velocity (pixels/frame)
                vel_pix = sqrt(sum((points-oldPoints).^2,2));
                velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
                velocityTotal = [velocityTotal velocityLabel];
            end
            oldPoints = points;
        end

        foregroundMask = im2single(foregroundMask);
        
        if show_work
            detectedLocationPoint = mean(detectedLocation)
            if isnan(detectedLocationPoint) ~= [1 1] & numel(detectedLocationPoint) == 2
                foregroundMask = insertObjectAnnotation(foregroundMask, 'circle', ...
                    [detectedLocationPoint 3], cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');
            end
            % ONLY IF YOU WANT TO SEE IT WORKING IN REAL TIME
            imshowpair(foregroundMask, colorImage, 'montage');
        end
        % TODO: MEASURE DISTANCE FROM CENTER
        %center-detectedLocationPoint
    end

    velocityTotal = velocityTotal(velocityTotal ~= 0);
    
    release(videoPlayer);
    meanVelocity = mean(velocityTotal);
    finalValue = meanVelocity;
end