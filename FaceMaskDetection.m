
clc
clear all
close all;
cam=webcam;
while true
e=cam.snapshot;% Face_Detection_From_camera
% e = imread('3.jpg');
%Face_Detection_From_camera
% Call "vision" toolbox using "viola jones" algorithm
faceDetector = vision.CascadeObjectDetector;
% Mouth detection 
FDetect=vision.CascadeObjectDetector('Mouth','MergeThreshold',92);
I=e;
BB_Mouth=step(FDetect,I);
imshow(I);
hold on;

% Nose detection
FDetect=vision.CascadeObjectDetector('Nose','MergeThreshold',22);
I=e;
BB_Nose=step(FDetect,I);
imshow(I);
hold on;

% When wearing mask
if(sum(sum(BB_Nose))==0 && sum(sum(BB_Mouth))==0)
    FDetect=vision.CascadeObjectDetector('FrontalFaceLBP','MergeThreshold',9);
    BB_Mouth=step(FDetect,I);
    
    %When hands  covering
    if(sum(sum(BB_Mouth))~=0)  
        title('Remove Hand Please');
    % Voice Warning  
    defaultString = 'Remove Hand from face.';
    NET.addAssembly('System.Speech');
    obj = System.Speech.Synthesis.SpeechSynthesizer;
    obj.Volume = 100;
    Speak(obj, defaultString);
   
    % Indeed wearing a mask
    else
        title('Mask present');
    % Voice Warning
    defaultString = 'Thank You for wearing Mask.';
    NET.addAssembly('System.Speech');
    obj = System.Speech.Synthesis.SpeechSynthesizer;
    obj.Volume = 100;
    Speak(obj, defaultString);
    end

% When not wearing properly detected by creating sliding window
elseif((sum(sum(BB_Nose))~=0 && sum(sum(BB_Mouth))==0)||(sum(sum(BB_Nose))==0 && sum(sum(BB_Mouth))~=0))

    for i=1:size(BB_Nose,1)
        rectangle('Position',BB_Nose(i,:),'Linewidth',5,'LineStyle','-','EdgeColor','r');
    end
    for i=1:size(BB_Mouth,1)
        rectangle('Position',BB_Mouth(i,:),'Linewidth',5,'LineStyle','-','EdgeColor','r');
    end
    
title('Please wear mask properly');
% Voice Warning
defaultString = 'Please wear mask properly.'; 
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, defaultString);

% When not wearing mask
else
    for i=1:size(BB_Nose,1) %
        rectangle('Position',BB_Nose(i,:),'Linewidth',5,'LineStyle','-','EdgeColor','r');
    end
    
    for i=1:size(BB_Mouth,1)
        rectangle('Position',BB_Mouth(i,:),'Linewidth',5,'LineStyle','-','EdgeColor','r');
    end
    
title('Please wear mask');
% Voice Warning
defaultString = 'Please wear mask.';
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, defaultString);
end
pause
end
