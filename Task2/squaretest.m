PsychDefaultSetup(2);
imgnum=1;
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);  %actually opens screen

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


%only below here is what is necessary?
for i=1:2
    imgnum=i;
fname=getfield(d(imgnum),'name');
theImage = imread(fname);
baseRect = [0 0 300 300];

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.125 screenXpixels * 0.375 screenXpixels * .625 screenXpixels * .875];
numSquares = length(squareXpos);

% Set the colors to Red, Green and Blue

% Make our rectangle coordinates
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Pen width for the frames
penWidthPixels = 6;

% Draw the rect to the screen
Screen('FrameRect', window, [1 1 1], allRects, penWidthPixels);

imageTexture = Screen('MakeTexture', window, theImage);
[s1, s2, s3] = size(theImage);
aspectRatio = s2 / s1;

heightScalers = .25;
imageHeights = screenYpixels .* heightScalers;
imageWidths = imageHeights .* aspectRatio;

% Number of images we will draw
numImages = numel(heightScalers);

% Make the destination rectangles for our image. We will draw the image
% multiple times over getting smaller on each iteration. So we need the big
% dstRects first followed by the progressively smaller ones
dstRects = zeros(4, numImages);
for i = 1:numImages
    theRect = [0 0 imageWidths(i) imageHeights(i)];
    dstRects(:, i) = CenterRectOnPointd(theRect, screenXpixels *.125,...
        screenYpixels / 2);
end

% Draw the image to the screen, unless otherwise specified PTB will draw
% the texture full size in the center of the screen.
Screen('DrawTextures', window, imageTexture, [], dstRects);
% Flip to the screen
starttime=GetSecs;

Screen('Flip', window);

for i=1:length(sequence) %loop checks all of keys in sequence are pressed
    while 1
        % Check the state of the keyboard.
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown
            v = find(keyCode);
            if v == sequence(i)
                break;
            end
        end
    end
end
endtime=GetSecs;
responsetime = endtime - starttime;
end

% Wait for a key press====
KbStrokeWait;

% Clear the screen
sca;