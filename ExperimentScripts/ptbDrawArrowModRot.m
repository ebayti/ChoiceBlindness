function [arrowTex, arrowTexRot] = ptbDrawArrowModRot(w0n , arrowLength, arrowWidth, headfootRatio, footWidth, arrowColor, backgroundColor)
% This function creates a PTB texture containging a leftward pointing arrow
%   an arrow is described by 
% width and height of the bounding box
% ration between the withd of the cap and the leg..
% width of the leg
%
% INPUTS:
% arrowRect - arrow bounding box in ptb rect format
% headfootRatio - ration between head/foot 
% footWidth - foot width
%  0  2               
% 0|---------------|
%  | /| 3          |
%  |/ |------------|4  foot width = 5-4
% 1|\ |------------|5 
%  | \| 6          |
%  |---------------|
%     7
%   <-><---------->
%    a       b
% head-foot ratio = a/b
%
% Natalia Zaretskaya 1 April 2015
% 
% [windowPtr,rect]=Screen('OpenWindow',0, [], [0 0 400 600] );

arrowRect = [0 0 arrowLength arrowWidth];
[w,]=Screen('OpenOffscreenWindow',-1, backgroundColor, arrowRect);

[cx, cy] = RectCenter(arrowRect);
footStrtX = arrowLength*headfootRatio;
footStrtY = cy-footWidth/2; %modified
footStopY = cy+footWidth/2; %modified

arrowCoords = [0 cy;... % correct
    footStrtX 0;...  % correct
    footStrtX footStrtY;... % correct 
    arrowLength footStrtY;... % correct
    arrowLength footStopY;... % correct 
    footStrtX footStopY;... % correct
    footStrtX arrowWidth]; % correct

Screen('FillPoly', w, arrowColor, arrowCoords, 1);
mtx=Screen('GetImage', w); % ones and zeros
mtxRot=rot90(mtx,2);

arrowTex   = Screen('MakeTexture', w0n, mtx); % img
arrowTexRot      = Screen('MakeTexture', w0n, mtxRot); % img
end

