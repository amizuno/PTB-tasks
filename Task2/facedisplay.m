function [responsetime, imgnum] = facedisplay(sequence, d, key,i, img, window)



if key=='N'
    imgnum=ceil(length(d)/2);
end
if key == 'H'
    imgnum=img(i-1)+1; %happier later
end
if key == 'S'
    imgnum=img(i-1)-1; %sad earlier
end
fname=getfield(d(imgnum),'name');
theImage = imread(fname);
imageTexture = Screen('MakeTexture', window, theImage);
Screen('DrawTextures', window, imageTexture);
Screen('Flip', window);


starttime=GetSecs;
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