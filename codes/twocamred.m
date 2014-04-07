
redThresh = 0.25; % Threshold for red detection
vidDeviceFront = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 480 360], ...
                    'ReturnedColorSpace', 'rgb');

vidDeviceSide = imaq.VideoDevice('winvideo', 2, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 480 360], ...
                    'ReturnedColorSpace', 'rgb');               
vidInfo = imaqhwinfo(vidDeviceFront); % Acquire input video property
vidInfoSide = imaqhwinfo(vidDeviceSide); % Acquire input video property

nFrame = 0; % Frame number initialization


hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 800, ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 10);

hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ... % Set Red box handling
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.4);
                            

 htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'FontSize', 14);
                                
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);

hVideoIn2 = vision.VideoPlayer('Name', 'Final Video Binary Frames', ... % Output video player
                                'Position', [100 100 vidInfoSide.MaxWidth+20 vidInfoSide.MaxHeight+30]);
                          
%% Processing Loop
while(nFrame < 300)
    pause(.2); % Delaying the intake from webcam
    
    rgbFrame = step(vidDeviceFront); % Acquire single frame
    rgbFrame2 = step(vidDeviceSide);
    
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    rgbFrame2 = flipdim(rgbFrame2,2); % obtain the mirror image for displaying
    
    diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrame2 = imsubtract(rgbFrame2(:,:,1), rgb2gray(rgbFrame2)); % Get red component of the image
    
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter
    diffFrame2 = medfilt2(diffFrame2, [3 3]); % Filter out the noise by using median filter
    
    binFrame = im2bw(diffFrame, redThresh); % Convert the image into binary image with the red objects as white
    binFrame2 = im2bw(diffFrame2, redThresh); % Convert the image into binary image with the red objects as white
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    [centroid2, bbox2] = step(hblob, binFrame2); % Get the centroids and bounding boxes of the blobs
     
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps
    centroid2 = uint16(centroid2); % Convert the centroids into Integer for further steps
    
    rgbFrame(1:20,1:165,:) = 0; % put a black region on the output stream
    rgbFrame2(1:20,1:165,:) = 0; % put a black region on the output stream
    
    vidIn = step(hshapeinsRedBox, rgbFrame, bbox); % Instert the red box
    vidIn2 = step(hshapeinsRedBox, rgbFrame2, bbox2); % Instert the red box
    
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        centX = centroid(object,1); centY = centroid(object,2);
  %      X = centX+centY;
  %      display(X);
        vidIn = step(htextinsCent, vidIn, [centX centY], [centX-6 centY-9]); 
    end
    
    for object = 1:1:length(bbox2(:,1)) % Write the corresponding centroids
        centX = centroid2(object,1); centY = centroid2(object,2);
  %      X = centX+centY;
  %      display(X);
        vidIn2 = step(htextinsCent, vidIn2, [centX centY], [centX-6 centY-9]); 
    end
    
    step(hVideoIn, vidIn); % Output video stream
    step(hVideoIn2, vidIn2);
    nFrame = nFrame+1;

end
release(hVideoIn2);
release(hVideoIn); % Release all memory and buffer used
release(vidDeviceFront);
release(vidDeviceSide);
% clear all;
