%% Initialization
redThresh = 0.24; % Threshold for red detection
greenThresh = 0.05; % Threshold for green detection
blueThresh = 0.15; % Threshold for blue detection

object = uint16(0);
centXRed = uint16(10);
centYRed = uint16(10);
centZRed = uint16(10);
centTRed = uint16(10);

centXGreen = uint16(20); 
centYGreen = uint16(20);
centZGreen = uint16(20);
centTGreen = uint16(20);

centXBlue = uint16(30);
centYBlue = uint16(30);
centZBlue = uint16(30);
centTBlue = uint16(30);

A = [];
B = [];
A = uint16(A);
B = uint16(B);


angle1=90;
angle2=90;
angle3=90;
angle4=90;
jawangle=0;
wristangle=0;

s1 = serial('COM7');    % define serial port
s1.BaudRate=9600;        % define baud rate
s1.InputBufferSize = 1;
s1.Timeout = 1;          %specify the time to wait for read operation(in seconds)


vidDevice = imaq.VideoDevice('winvideo', 2, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 640 480], ...
                    'ReturnedColorSpace', 'rgb');
vidDevice2 = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 640 480], ...
                    'ReturnedColorSpace', 'rgb');
                
vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
vidInfo2 = imaqhwinfo(vidDevice); % Acquire input video property

hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 80, ...
                                'MaximumBlobArea', 1000, ...
                                'MaximumCount', 1);
                            
hblobtwo = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 80, ...
                                'MaximumBlobArea', 1000, ...
                                'MaximumCount',2);
                            
hshapeinsBox = vision.ShapeInserter('BorderColorSource', 'Input port', ... % Set box handling
                                        'Fill', true, ...
                                        'FillColorSource', 'Input port', ...
                                        'Opacity', 0.4);
                                    
htextinsRed = vision.TextInserter('Text', 'Red   : %2d', ... % Set text for number of blobs
                                    'Location',  [5 2], ...
                                    'Color', [1 0 0], ... // red color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
                                
htextinsGreen = vision.TextInserter('Text', 'Green : %2d', ... % Set text for number of blobs
                                    'Location',  [5 18], ...
                                    'Color', [0 1 0], ... // green color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
                                
htextinsBlue = vision.TextInserter('Text', 'Blue  : %2d', ... % Set text for number of blobs
                                    'Location',  [5 34], ...
                                    'Color', [0 0 1], ... // blue color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
                                
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
                                
line = vision.ShapeInserter('Shape','Lines',...
                            'BorderColorSource', 'Input port');
                                
hVideoIn = vision.VideoPlayer('Name', 'Front Video', ... % Output video player
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
hVideoIn2 = vision.VideoPlayer('Name', 'Side Video', ... % Output video player
                                'Position', [500 100 vidInfo2.MaxWidth+20 vidInfo2.MaxHeight+30]);
                            
nFrame = 0; % Frame number initialization

%% Processing Loop
while(nFrame < 300)
    
    
    rgbFrame = step(vidDevice); % Acquire single frame
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    rgbFrame2 = step(vidDevice2); % Acquire single frame
    rgbFrame2 = flipdim(rgbFrame2,2); % obtain the mirror image for displaying
    
    diffFrameRed = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrameRed = medfilt2(diffFrameRed, [3 3]); % Filter out the noise by using median filter
    binFrameRed = im2bw(diffFrameRed, redThresh); % Convert the image into binary image with the red objects as white
    
    diffFrameRed2 = imsubtract(rgbFrame2(:,:,1), rgb2gray(rgbFrame2)); % Get red component of the image
    diffFrameRed2 = medfilt2(diffFrameRed2, [3 3]); % Filter out the noise by using median filter
    binFrameRed2 = im2bw(diffFrameRed2, redThresh); % Convert the image into binary image with the red objects as white
    
    diffFrameGreen = imsubtract(rgbFrame(:,:,2), rgb2gray(rgbFrame)); % Get green component of the image
    diffFrameGreen = medfilt2(diffFrameGreen, [3 3]); % Filter out the noise by using median filter
    binFrameGreen = im2bw(diffFrameGreen, greenThresh); % Convert the image into binary image with the green objects as white
    
    diffFrameGreen2 = imsubtract(rgbFrame2(:,:,2), rgb2gray(rgbFrame2)); % Get green component of the image
    diffFrameGreen2 = medfilt2(diffFrameGreen2, [3 3]); % Filter out the noise by using median filter
    binFrameGreen2 = im2bw(diffFrameGreen2, greenThresh); % Convert the image into binary image with the green objects as white
    
    
    diffFrameBlue = imsubtract(rgbFrame(:,:,3), rgb2gray(rgbFrame)); % Get blue component of the image
    diffFrameBlue = medfilt2(diffFrameBlue, [3 3]); % Filter out the noise by using median filter
    binFrameBlue = im2bw(diffFrameBlue, blueThresh); % Convert the image into binary image with the blue objects as white
    
    diffFrameBlue2 = imsubtract(rgbFrame2(:,:,3), rgb2gray(rgbFrame2)); % Get blue component of the image
    diffFrameBlue2 = medfilt2(diffFrameBlue2, [3 3]); % Filter out the noise by using median filter
    binFrameBlue2 = im2bw(diffFrameBlue2, blueThresh); % Convert the image into binary image with the blue objects as white
    
    
    [centroidRed, bboxRed] = step(hblobtwo, binFrameRed); % Get the centroids and bounding boxes of the red blobs
    centroidRed = uint16(centroidRed); % Convert the centroids into Integer for further steps 
    [centroidRed2, bboxRed2] = step(hblobtwo, binFrameRed2); % Get the centroids and bounding boxes of the red blobs
    centroidRed2 = uint16(centroidRed2); % Convert the centroids into Integer for further steps 
    
    [centroidGreen, bboxGreen] = step(hblob, binFrameGreen); % Get the centroids and bounding boxes of the green blobs
    centroidGreen = uint16(centroidGreen); % Convert the centroids into Integer for further steps 
    [centroidGreen2, bboxGreen2] = step(hblob, binFrameGreen2); % Get the centroids and bounding boxes of the green blobs
    centroidGreen2 = uint16(centroidGreen2); % Convert the centroids into Integer for further steps 
    
    [centroidBlue, bboxBlue] = step(hblob, binFrameBlue); % Get the centroids and bounding boxes of the blue blobs
    centroidBlue = uint16(centroidBlue); % Convert the centroids into Integer for further steps 
    [centroidBlue2, bboxBlue2] = step(hblob, binFrameBlue2); % Get the centroids and bounding boxes of the blue blobs
    centroidBlue2 = uint16(centroidBlue2); % Convert the centroids into Integer for further steps 
    
    %rgbFrame(1:50,1:90,:) = 0; % put a black region on the output stream
    vidIn = step(hshapeinsBox, rgbFrame, bboxRed, single([1 0 0])); % Instert the red box
    vidIn = step(hshapeinsBox, vidIn, bboxGreen, single([0 1 0])); % Instert the green box
    vidIn = step(hshapeinsBox, vidIn, bboxBlue, single([0 0 1])); % Instert the blue box
    vidIn2 = step(hshapeinsBox, rgbFrame2, bboxRed2, single([1 0 0])); % Instert the red box
    vidIn2 = step(hshapeinsBox, vidIn2, bboxGreen2, single([0 1 0])); % Instert the green box
    vidIn2 = step(hshapeinsBox, vidIn2, bboxBlue2, single([0 0 1])); % Instert the blue box
    
    for object = 1:1:length(bboxRed(:,1)) % Write the corresponding centroids for red
        A(object) = centroidRed(object,1); B(object) = centroidRed(object,2);
        vidIn = step(htextinsCent, vidIn, [A(object) B(object)], [A(object)-6 B(object)-9]); 
        centXRed = A(1);
        centYRed = B(1);
    end
        
    %%WRIST MOVEMENT
    if(object == 2)
        vect = double([B(1);B(2)]);
        disp = pdist(vect,'euclidean');
        x1 =double([ A(1) B(1)]);
        x2 =double([ A(2) B(2)]) ;
        x3 =double([A(2)-30 B(2)]);
        x1=x1-x2;
        x3=x3-x2;
        
        Cos = dot(x1,x3)/(norm(x1)*norm(x3));
        wristangle = acos(Cos)*180/pi;
        wristangle = uint16(wristangle);
   end
            
            
            
    for object = 1:1:length(bboxRed2(:,1)) % Write the corresponding centroids for red
         A(object) = centroidRed2(object,1); B(object) = centroidRed2(object,2);
        vidIn2 = step(htextinsCent, vidIn2, [A(object) B(object)], [A(object)-6 B(object)-9]); 
        
    end
    
    %% HAND JAW OPENINNG AND CLOSING
    if(object == 2)
        vect = double([A(1),B(1);A(2),B(2)]);
        disp = pdist(vect,'euclidean');
        centZRed = A(1);
        centTRed = B(1);
  
        
        if(disp>80)
            %% Code to open the Jaw
            %%'Jaw opened';
            jawangle = 90;
            
        else
            %%COde to close the Jaw
            jawangle = 0;
        end
        
    else
            %%COde to close the Jaw
    end
    
    
    
    
    for object = 1:1:length(bboxGreen(:,1)) % Write the corresponding centroids for green
        centXGreen = centroidGreen(object,1); centYGreen = centroidGreen(object,2);
        vidIn = step(htextinsCent, vidIn, [centXGreen centYGreen], [centXGreen-6 centYGreen-9]); 
    end
    for object = 1:1:length(bboxGreen2(:,1)) % Write the corresponding centroids for green
        centZGreen = centroidGreen2(object,1); centTGreen = centroidGreen2(object,2);
        vidIn2 = step(htextinsCent, vidIn2, [centZGreen centTGreen], [centZGreen-6 centTGreen-9]); 
    end
    
    for object = 1:1:length(bboxBlue(:,1)) % Write the corresponding centroids for blue
        centXBlue = centroidBlue(object,1); centYBlue = centroidBlue(object,2);
        vidIn = step(htextinsCent, vidIn, [centXBlue centYBlue], [centXBlue-6 centYBlue-9]); 
    end
    for object = 1:1:length(bboxBlue2(:,1)) % Write the corresponding centroids for blue
        centZBlue = centroidBlue2(object,1); centTBlue = centroidBlue2(object,2);
        vidIn2 = step(htextinsCent, vidIn2, [centZBlue centTBlue], [centZBlue-6 centTBlue-9]); 
    end
    
    angle1=f(centXBlue,centYBlue,centXGreen,centYGreen,centXGreen,centYGreen+10);
    angle2=f(centXRed,centYRed,centXBlue,centYBlue,centXGreen,centYGreen);
    angle3=f(centZBlue,centTBlue,centZGreen,centTGreen,centZGreen,centTBlue);
    
    angle1=180-angle1;
    angle2=180-angle2;
    angle4=180-angle3;
    
    str = strcat('$',num2str(angle1,'%03i'),'*',num2str(angle2,'%03i'),'*',num2str(angle3,'%03i'),'*',num2str(wristangle,'%03i'),'*',num2str(jawangle,'%03i'),'#')
    
    vidIn = step(htextinsRed, vidIn, uint8(length(bboxRed(:,1)))); % Count the number of red blobs
    vidIn = step(htextinsGreen, vidIn, uint8(length(bboxGreen(:,1)))); % Count the number of green blobs
    vidIn = step(htextinsBlue, vidIn, uint8(length(bboxBlue(:,1)))); % Count the number of blue blobs
    vidIn2 = step(htextinsRed, vidIn2, uint8(length(bboxRed2(:,1)))); % Count the number of red blobs
    vidIn2 = step(htextinsGreen, vidIn2, uint8(length(bboxGreen2(:,1)))); % Count the number of green blobs
    vidIn2 = step(htextinsBlue, vidIn2, uint8(length(bboxBlue2(:,1)))); % Count the number of blue blobs
    step(hVideoIn, vidIn); % Output video stream
    step(hVideoIn2, vidIn2); % Output video stream
    
    fopen(s1);         % Wireless transmission                   
    fwrite(s1,str);   % data send to atmega 
    fclose(s1); 
     
    
    nFrame = nFrame+1;
end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
release(hVideoIn2); % Release all memory and buffer used
release(vidDevice2);

clear all;
clc;