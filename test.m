VideoSize = [210 300];

scale = 1/9.75; % centimeter/pixel
frameRate = 3.75; % frame/second

videoReader = vision.VideoFileReader('Video/test.mov');
videoPlayer = vision.VideoPlayer('Position',[200,200,500,400]);
foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 500, ...
                'InitialVariance', 0.05);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
                'MinimumBlobArea', 70);

kalmanFilter = []; isTrackInitialized = false;
velocityLabel = 0; velocityTotal = [];

center = [105 150];
oldPoints = [];

dist_from_center = [105 150];
while ~isDone(videoPlayer)
    detectedLocationPoint = [0 0];

    colorImage = step(videoReader);
    bw_file = rgb2gray(colorImage);

    foregroundMask = foregroundDetector(bw_file);
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

    else 
        if isObjectDetected 
            predict(kalmanFilter);
            trackedLocation = correct(kalmanFilter, detectedLocation(1,:));

            points = trackedLocation;
            if ~isempty(oldPoints)
                % Calculate velocity (pixels/frame)
                vel_pix = sqrt(sum((points-oldPoints).^2,2));
                velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
                velocityTotal = [velocityTotal velocityLabel];
            end
            oldPoints = points;
        end
        %circle = [trackedLocation 3];
    end


    detectedLocationPoint = mean(detectedLocation);

    if isnan(detectedLocationPoint) ~= [1 1] & numel(detectedLocationPoint) == 2
        dist_from_center = [dist_from_center; center-detectedLocationPoint];

        %foregroundMask = insertObjectAnnotation(foregroundMask, 'circle', ...
        %    [detectedLocationPoint 3], cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');
    end

    % ONLY IF YOU WANT TO SEE IT WORKING IN REAL TIME  
    if show_work
        foregroundMask = im2single(foregroundMask);
        if ~isempty(detectedLocation)
            % TODO: Find a way to fill in mouse
            %foregroundMask = regionfill(foregroundMask, [3 3 3 3], [4 4 4 4]);
        end

        for i = 1:size(detectedLocation)
            foregroundMask = insertObjectAnnotation(foregroundMask, 'circle', ...
            [detectedLocation(i,:) 3], cellstr(['Point ' num2str(i)]), 'Color', 'green');
        end

        imshowpair(foregroundMask, bw_file, 'montage');
    end
end

velocityTotal = velocityTotal(velocityTotal ~= 0);

release(videoPlayer);

center = center*scale;
meanVelocity = mean(velocityTotal);
avg_place = mean(dist_from_center, 1)*scale;
final_dist = pdist([avg_place; center])*scale;

finalValue = FinalMetrics;
finalValue.MeanVelocity= meanVelocity;
finalValue.AveragePlacement = avg_place;
finalValue.DistanceCenter = final_dist;
end
