function finalValue = mouseBehaviorAnalysisTraining(filename, show_work, frame_start, frame_end)
    %VideoSize = [210 300];
    
    scale = 1/9.75; % centimeter/pixel
    frameRate = 3.75; % frame/second

    videoReader = vision.VideoFileReader(filename);
    videoPlayer = vision.VideoPlayer('Position',[200,200,500,400]);
    %foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 500, ...
    %                'InitialVariance', 0.05);
    %blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    %                'MinimumBlobArea', 70);
                
    %kalmanFilter = []; isTrackInitialized = false;
    velocityTotal = [];
    
    center = [105 150];
    %oldPoints = [];
    
    for i=1:frame_start
        test = step(videoReader);
    end
    
    figure
    dist_from_center = [105 150];
    previous_centroid = []; initialized = 0;
    for i=frame_start:1:frame_end
        %detectedLocationPoint = [0 0];
        velocityLabel = 0;
        
        accurateBg = imread('./MouseVideobehaviorAnalysis/trainingNOMOUSE.png');
        accurateBg = imcrop(accurateBg, [52 15 167 179]);
        accurateBg = rgb2gray(accurateBg);
        accurateBg = edge(accurateBg,'canny');
        accurateBg = bwmorph(accurateBg, 'thick');
        
        colorImage = step(videoReader);
        colorImage = imcrop(colorImage, [52 15 167 179]);
        bw_file = rgb2gray(colorImage);
        
        % EDGE AND SUBTRACTION
        %bw_file = imsubtract(im2single(imread('Video/accuratebackground.png')), im2single(colorImage));
        bw_file = edge(bw_file,'canny');
        bw_file_first = (bw_file-accurateBg);
        bw_file = bw_file_first;
        %bw_file = setdiff(bw_file,[-1 0 -1]);
        bw_file(bw_file == 1) = -1;
        bw_file(bw_file == -1) = 1;
        bw_file_first = bw_file;
        
        % remove thin lines
        x = bw_file.';
        y=find(~x);
        change=y(diff(y)==2);
        x(change+1)=0;
        bw_file = x.';
        
        bw_file = bwareaopen(bw_file, 10);
        bw_file = bwmorph(bw_file, 'thick');
        
        % Fill in lines
        x = bw_file.';
        y=find(x);
        change=y(diff(y)<=3);
        x(change+1)=1;
        x(change+2)=1;
        x(change+3)=1;
        bw_file = x.';
        
        bw_file = imfill(bw_file, 'holes');
        bw_file = bwmorph(bw_file, 'thin');
        bw_file = bwareaopen(bw_file, 200);
        %bw_file = bwmorph(bw_file, 'thick');
        s = regionprops(bw_file,'centroid');
        centroids = cat(1, s.Centroid);
        centroid = centroids(1,:);
        
        if initialized
            vel_pix = pdist2(centroid, previous_centroid, 'euclidean');
            velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
            velocityTotal = [velocityTotal velocityLabel];
        else
            initialized = 1;
        end
        
        previous_centroid = centroid;
%         foregroundMask = foregroundDetector(im2single(bw_file));
%         foregroundMask = bwareaopen(foregroundMask, 15);
%         %foregroundMask = imfill(foregroundMask, 'holes');
%         
%         detectedLocation = step(blobAnalyzer,foregroundMask); % [x,y]
%         
%         isObjectDetected = size(detectedLocation, 1) > 0;
% 
%         if ~isTrackInitialized
%             if isObjectDetected
%                 kalmanFilter = configureKalmanFilter('ConstantAcceleration',...
%                           detectedLocation(1,:), [1 1 1]*1e5, [1, 10, 10], 25);
%                 isTrackInitialized = true;
%             end
% 
%         else 
%             if isObjectDetected 
%                 predict(kalmanFilter);
%                 trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
%                 
%                 points = trackedLocation;
%                 if ~isempty(oldPoints)
%                     % Calculate velocity (pixels/frame)
%                     vel_pix = sqrt(sum((points-oldPoints).^2,2));
%                     velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
%                     velocityTotal = [velocityTotal velocityLabel];
%                 end
%                 oldPoints = points;
%             end
%             %circle = [trackedLocation 3];
%         end
% 
%         
%         detectedLocationPoint = mean(detectedLocation);
%             
%         if isnan(detectedLocationPoint) ~= [1 1] & numel(detectedLocationPoint) == 2
%             dist_from_center = [dist_from_center; center-detectedLocationPoint];
%             
%             %foregroundMask = insertObjectAnnotation(foregroundMask, 'circle', ...
%             %    [detectedLocationPoint 3], cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');
%         end
            
        % ONLY IF YOU WANT TO SEE IT WORKING IN REAL TIME  
        if show_work
            %foregroundMask = im2single(foregroundMask);
            bw_file = im2single(bw_file);
            %if ~isempty(detectedLocation)
                % TODO: Find a way to fill in mouse
                %foregroundMask = regionfill(foregroundMask, [3 3 3 3], [4 4 4 4]);
            %end
            
            bw_file = insertObjectAnnotation(bw_file, 'circle', ...
            [centroid 3], cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');

            imshowpair(im2single(colorImage), im2single(bw_file), 'montage');
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