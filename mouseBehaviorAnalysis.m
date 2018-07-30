%
%   filename=name of video file link
%   show_work=play the images in figures
%   frame_start=beginning frame
%   frame_end=end frame
%
function finalValue = mouseBehaviorAnalysis(filename, show_work, frame_start, frame_end, threshold)
    VideoSize = [210 300];
    
    scale = 1/9.75; % centimeter/pixel
    frameRate = 4; % frame/second

    videoReader = vision.VideoFileReader(filename);
    videoReader_averagebg = vision.VideoFileReader(filename);
    videoPlayer = vision.VideoPlayer('Position',[200,200,500,400]);
    %foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 500, ...
    %                'InitialVariance', 0.05);
    %blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    %                'MinimumBlobArea', 70);
                
    %kalmanFilter = []; isTrackInitialized = false;
    %oldPoints = [];
    
    % Get average background
    meanImage = double(step(videoReader_averagebg));
    for i=2:1:100
        img = step(videoReader_averagebg);
        meanImage = meanImage + double(img);
    end
    meanImage = meanImage / 100;
    %figure, imshow(meanImage);
    
    for i=1:frame_start
        test = step(videoReader);
    end
    
    %figure
    velocityTotal = []; areaTotal = [];
    center = [105 150];
    place = [];
    frames_on_wall = 0;
    previous_centroid = []; initialized = 0; previous_screen = 0; total_dist = 0;
    if show_work
        figure
    end
    for i=frame_start:1:frame_end
        %detectedLocationPoint = [0 0];
        velocityLabel = 0;
        
        accurateBg = meanImage;
        %accurateBg = imcrop(accurateBg, [52 15 167 179]);
        accurateBg = rangefilt(rgb2gray(accurateBg));
        accurateBg = edge(accurateBg,'canny');
        accurateBg = bwmorph(accurateBg, 'thick');
        
        colorImage = step(videoReader);
        %colorImage = imcrop(colorImage, [52 15 167 179]);
        bw_file = rangefilt(rgb2gray(colorImage));
        
        % EDGE AND SUBTRACTION
        %bw_file = imsubtract(im2single(imread('Video/accuratebackground.png')), im2single(colorImage));
        bw_file = edge(bw_file,'canny');
        bw_file_first = imcomplement(bw_file-accurateBg);
        bw_file = bw_file_first;
        %bw_file = setdiff(bw_file,[-1 0 -1]);

        bw_file(bw_file == 1) = 0;
        %bw_file(bw_file == -1) = 1;

        % remove horizontal thin lines
         x = bw_file.';
         y=find(~x);
         change=y(diff(y)==2);
         x(change+1)=0;
         bw_file = x.';
%         
%         % remove vertical thin lines for grid
         x = bw_file;
         y=find(~x);
         change=y(diff(y)==2);
         x(change+1)=0;
         bw_file = x;
         %bw_file_first = bw_file;
         bw_file = imclose(bw_file,strel('sphere', 4));
%         
          %bw_file = bwmorph(bw_file, 'thick');
          bw_file = imfill(bw_file, 'holes');
%         
%         % Fill in lines
%         x = bw_file.';
%         y=find(x);
%         change=y(diff(y)<=3);
%         x(change+1)=1;
%         x(change+2)=1;
%         x(change+3)=1;
%         bw_file = x.';
%         
%         x = bw_file;
%         y=find(x);
%         change=y(diff(y)<=2);
%         x(change+1)=1;
%         x(change+2)=1;
%         bw_file = x;
%         
% % 
%          bw_file = imfill(bw_file, 'holes');
%         
%         %bw_file = bwmorph(bw_file, 'thin');
%         
%         bw_file = bwareaopen(bw_file, 200);
         bw_file = ExtractNLargestBlobs(bw_file, 1);
        
        s = regionprops(bw_file,'centroid');
        area = regionprops(bw_file, 'Area');
        areaTotal = [areaTotal area.Area];
        centroids = cat(1, s.Centroid);
        centroid = centroids(1,:);
        
        if initialized
            vel_pix = pdist2(centroid, previous_centroid, 'euclidean');
            place = [place; centroid];
            
            subtractedImg = rgb2gray(colorImage-previous_screen);
            subtractedImg(x<0.1) = 0;
            subtractedImg = imbinarize(subtractedImg, threshold);
            subtractedImg = subtractedImg(:);
            if ~any(subtractedImg)
                velocityLabel = 0;
            else 
                velocityLabel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * centimeter/pixels
            end
            velocityTotal = [velocityTotal velocityLabel];
            total_dist = total_dist + vel_pix;
            
            x = centroid(:,1);
            y = centroid(:,2);
            
            % TODO: Configure with all images
            if ~(x>50 && x<200 && y>25 && y<190)
                frames_on_wall = frames_on_wall + 1;
            end
        else
            initialized = 1;
        end
        
        previous_centroid = centroid;
        previous_screen = colorImage;
        
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
            %if ~isempty(detectedLocation)
                %foregroundMask = regionfill(foregroundMask, [3 3 3 3], [4 4 4 4]);
            %end
            
            %bw_file = im2single(bw_file);

            newImage = colorImage;
            %newImage(bw_file == 0) = 0;
            newImage = bsxfun(@times, newImage, cast(bw_file, 'like', newImage));
            newImage = rgb2gray(newImage);
            %newImage = imclose(bwmorph(bwareaopen(edge(rangefilt(newImage),'prewitt'), 10), 'majority'), strel('disk',20));
        
            newImage = insertObjectAnnotation(newImage, 'circle', ...
            [centroid 3], cellstr([num2str(velocityLabel) ' cm/sec']), 'Color', 'green');
        
            imshowpair(im2single(colorImage), im2single(newImage), 'montage');
        end
    end

    
    release(videoPlayer);
    
    % Calculate Final Metrics and Return Them
    [row, col] = size(velocityTotal(velocityTotal == 0));
    movementInPlace = col / frameRate;
    mean_velocity = mean(velocityTotal);
    mean_area = mean(areaTotal)*(scale^2);
    avg_place = mean(place);
    final_dist = pdist([avg_place; center])*scale;
    
    finalValue = FinalMetrics;
    finalValue.MeanVelocity= mean_velocity;
    finalValue.AveragePlacement = avg_place*scale;
    finalValue.DistanceFromCenter = final_dist;
    finalValue.MeanArea = mean_area;
    finalValue.MovementInPlace = movementInPlace;
    finalValue.TotalDistanceTraveled = total_dist*scale;
end

% Function to return the specified number of largest or smallest blobs in a binary image.
% If numberToExtract > 0 it returns the numberToExtract largest blobs.
% If numberToExtract < 0 it returns the numberToExtract smallest blobs.
% Example: return a binary image with only the largest blob:
%   binaryImage = ExtractNLargestBlobs(binaryImage, 1)
% Example: return a binary image with the 3 smallest blobs:
%   binaryImage = ExtractNLargestBlobs(binaryImage, -3)
function binaryImage = ExtractNLargestBlobs(binaryImage, numberToExtract)
try
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	[labeledImage, numberOfBlobs] = bwlabel(binaryImage);
	blobMeasurements = regionprops(labeledImage, 'area');
	% Get all the areas
	allAreas = [blobMeasurements.Area];
	if numberToExtract > 0
		% For positive numbers, sort in order of largest to smallest.
		% Sort them.
		[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
	elseif numberToExtract < 0
		% For negative numbers, sort in order of smallest to largest.
		% Sort them.
		[sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
		% Need to negate numberToExtract so we can use it in sortIndexes later.
		numberToExtract = -numberToExtract;
	else
		% numberToExtract = 0.  Shouldn't happen.  Return no blobs.
		binaryImage = false(size(binaryImage));
		return;
	end
	% Extract the "numberToExtract" largest blob(a)s using ismember().
	biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
	% Convert from integer labeled image into binary (logical) image.
	binaryImage = biggestBlob > 0;
catch ME
	errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
end