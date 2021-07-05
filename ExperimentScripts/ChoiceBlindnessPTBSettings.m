function PTBSet  = ChoiceBlindnessPTBSettings()

%%%%%%%%%%%%%%%%%% Tab out or not %%%%%%%%%%%%%%%%%%
% tabOut=true;
% if IsLinux & tabOut % On a linux computer, tab out to the command window
%     import java.awt.AWTException;import java.awt.Robot;import java.awt.event.KeyEvent;
%     robot=Robot;robot.keyPress(KeyEvent.VK_CONTROL);robot.keyPress(KeyEvent.VK_0);robot.keyRelease(KeyEvent.VK_0);robot.keyRelease(KeyEvent.VK_CONTROL);
% end

% lets save it' we will use it for picture fodler
PTBSet.expPath=pwd;

%%%%%%%%%%%%%%%%%%%%%%%% Cosmetic edits %%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'VisualDebugLevel', 1); % Set the start screen as black
% Screen('Preference', 'SkipSyncTests', 2); % This is to avoid errors on Linux (Windows=1)
% Screen('Preference', 'SuppressAllWarnings', 1); %Suppressing warnings...

%%%%%%%%%%%%%%%%%% Calling the standard setup for PTB %%%%%%%%%%%%%%%%%%
%{
  This function performs a few typical "boilerplate" setup operations
  at the beginning of a script to avoid repetitive code at the top of
  a script.
 
  Add it at the top of your script, so all its settings affect successive
  Psychtoolbox commands.
 
  The parameter 'featureLevel' determines what kind of setup is
  specifically performed. A higher number for 'featureLevel' will
  include all setup steps and default settings for lower numbers
  of 'featureLevel' and extend on them. E.g., a featureLevel of 2 would
  imply all setup operations of featureLevel 0 and 1, plus some new
  additional setup operations.
 
  A 'featureLevel' of 0 will do nothing but execute the AssertOpenGL command,
  to make sure that the Screen() mex file is properly installed and functional.
 
  A 'featureLevel' of 1 will additionally execute KbName('UnifyKeyNames') to
  provide a consistent mapping of keyCodes to key names on all operating
  systems.
 
  A 'featureLevel' of 2 will additionally imply the execution of
  Screen('ColorRange', window, 1, [], 1); immediately after and whenever
  PsychImaging('OpenWindow',...) is called, thereby switching the default
  color range from the classic 0-255 integer number range to the normalized
  floating point number range 0.0 - 1.0 to unify color specifications
  across differently capable display output devices, e.g., standard 8 bit
  displays vs. high precision 16 bit displays. Please note that clamping of
  valid color values to the 0 - 1 range is still active and colors will
  still be represented by 256 discrete levels (8 Bit resolution), unless
  you also use PsychImaging() commands to request unclamped color
  processing or floating point precision framebuffers. This function by
  itself only changes the range, not the precision of color specifications!

%}
PsychDefaultSetup(2);

%%%%%%%%%%%%%%%%%% To avoid accidentally typing over the script during the experiment %%%%%%%%%%%%%%%%%%
    ListenChar(2); 

%%%%%%%%%%%%%%%%%%Setup the keyboard for common naming scheme%%%%%%%%%%%%%%%%%%
%{
     to use one common naming scheme for
     all operating systems, increasing portability of scripts. It is
     recommended to call KbName('UnifyKeyNames'); at the beginning of each
     new experiment script.
%}
KbName('UnifyKeyNames');

%%%%%%%%%%%%%%%%%% Shuffling the random number generator %%%%%%%%%%%%%%%%%%
%Initializes generator based on the current time, resulting in a different sequence of random numbers after each call to rng.
PTBSet.seed= rng('shuffle');

%%%%%%%%%%%%%%%%%% Get the screen numbers; gives a number for each screen %%%%%%%%%%%%%%%%%%
PTBSet.monitors= Screen('Screens');

%%%%%%%%%%%%%%%%%% If there are multiple screens, to draw to the external monitor we need the maximum of screen numbers %%%%%%%%%%%%%%%%%%
PTBSet.screenNr=max(PTBSet.monitors);


%%%%%%%%%%%%%%%%%% (Retrieved from Vincent's ptb script) %%%%%%%%%%%%%%%%%%
% Define black and white (white= 1 and black= 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
PTBSet.white = WhiteIndex(PTBSet.screenNr);
PTBSet.black = BlackIndex(PTBSet.screenNr); 
% PTBSet.grey= PTBSet.white/2; % a simple calculation
PTBSet.grey= 0.5; % sometimes reality can be not as simple as math...........
PTBSet.backgroundColor= PTBSet.grey;



%%%%%%%%%%%%%%%%%% Preallocation for key definitions for different keyboard %%%%%%%%%%%%%%%%%%
PTBSet.KeyList1= zeros(256,1);
PTBSet.KeyList2= zeros(256,1);

%%%%%%%%%%%%%%%%%% Screen Setup %%%%%%%%%%%%%%%%%%
PsychImaging('PrepareConfiguration'); % I am not sure whether I need it?
[PTBSet.screenHandle, PTBSet.screenRect]=PsychImaging('OpenWindow',PTBSet.screenNr, PTBSet.backgroundColor); 


%%%%%%%%%%%%%%%%%% Font size and color %%%%%%%%%%%%%%%%%%
PTBSet.fontSize=Screen('TextSize',PTBSet.screenHandle,40);
PTBSet.fontColor= [0 0 0];


%%%%%%%%%%%%%%%%%% Since there are more than 1 keyboard attached to the experiment computer,
% we need to get unique indexes for each device %%%%%%%%%%%%%%%%%%
[keyboardIndices, productNames, ~] = GetKeyboardIndices();

%%%%%%%%%%%%%%%%%% Output of my personal computer %%%%%%%%%%%%%%%%%%
% productNames = {'Virtual core XT…'}    {'Power Button'}    {'Video Bus'}    {'Power Button'}    {'Sleep Button'}    {'HD Webcam: HD W…'}    {'AT Translated S…'}    {'SOUNDPEATS True…'}


%%%%%%%%%%%%%%%%%% Setting the buttons & filling the key lists with doubles (they have to be filled with) %%%%%%%%%%%%%%%%%%
PTBSet.Keys.escapeKey = KbName('ESCAPE');     PTBSet.KeyList1(PTBSet.Keys.escapeKey)=double(1);
PTBSet.Keys.spaceKey = KbName('SPACE');       PTBSet.KeyList2(PTBSet.Keys.spaceKey)=double(1);
PTBSet.Keys.leftKey = KbName('LeftArrow');    PTBSet.KeyList2(PTBSet.Keys.leftKey)=double(1);
PTBSet.Keys.rightKey = KbName('RightArrow');  PTBSet.KeyList2(PTBSet.Keys.rightKey)=double(1);
PTBSet.Keys.enterKey = KbName('Return');      PTBSet.KeyList2(PTBSet.Keys.enterKey)=double(1);
PTBSet.Keys.vKey = KbName('v');               PTBSet.KeyList2(PTBSet.Keys.vKey)=double(1);
PTBSet.Keys.cKey = KbName('c');               PTBSet.KeyList2(PTBSet.Keys.cKey)=double(1);
PTBSet.Keys.upKey = KbName('UpArrow');             PTBSet.KeyList2(PTBSet.Keys.upKey)=double(1);
PTBSet.Keys.downKey = KbName('DownArrow');         PTBSet.KeyList2(PTBSet.Keys.downKey)=double(1);

%%%%%%%%%%%%%%%%%% Restrict keys except these guys %%%%%%%%%%%%%%%%%%
RestrictKeysForKbCheck([PTBSet.Keys.enterKey PTBSet.Keys.vKey PTBSet.Keys.cKey PTBSet.Keys.escapeKey PTBSet.Keys.spaceKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey]); % This means PTB will only look for these keypresses. RestrictKeysForKbCheck([]) if you want to allow everything.


%%%%%%%%%%%%%%%%%% Assign keyboards %%%%%%%%%%%%%%%%%%

    PTBSet.Keys.keyboardNr1= -1;
    PTBSet.Keys.keyboardNr2= -1;
    fprintf('\n=> Experimenter keyboard is %u  %s \n', PTBSet.Keys.keyboardNr1, productNames{1});
    fprintf('\n=> Subject keyboard is : %u  %s \n', PTBSet.Keys.keyboardNr2, productNames{end});


if PTBSet.Keys.keyboardNr1 == PTBSet.Keys.keyboardNr2
    fprintf('Check whether participant keyboard is connected \n');
end

% KbQueue creating and starting
%{
The routines KbQueueCreate, KbQueueStart, KbQueueStop, KbQueueCheck
   KbQueueWait, KbQueueFlush and KbQueueRelease provide replacements for
   KbCheck and KbWait, providing the following advantages:
 
      1) Brief key presses that would be missed by KbCheck or KbWait
         are reliably detected
      2) The times of key presses are recorded more accurately
      3) The times of key releases are also recorded
%}
%For the first keyboard
KbQueueCreate(PTBSet.Keys.keyboardNr1, PTBSet.KeyList1);
KbQueueStart(PTBSet.Keys.keyboardNr1);

% For the second keyboard
KbQueueCreate(PTBSet.Keys.keyboardNr2, PTBSet.KeyList2);
KbQueueStart(PTBSet.Keys.keyboardNr2);

%%%%%%%%%%%%%%%%%% Get the interframe interval %%%%%%%%%%%%%%%%%%
% this will give us exact 5 seconds for presentations
PTBSet.iFi=Screen('GetFlipInterval',PTBSet.screenHandle); %this is the minimum possible time between screen drawings
PTBSet.pictureDuration= 5 - PTBSet.iFi/2; % All pictures should be displayed for 5 seconds.

%%%%%%%%%%%%%%%%%% Setting PTB as the top priority %%%%%%%%%%%%%%%%%%
PTBSet.topPriority=MaxPriority(PTBSet.screenHandle);

%%%%%%%%%%%%%%%%%% Adding the alpha channel for transparent colors %%%%%%%%%%%%%%%%%%
Screen('BlendFunction', PTBSet.screenHandle, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%%%%%%%%%%%%%%%%%% Converting from pixels to visual degrees %%%%%%%%%%%%%%%%%%
% Check them before the actual experiment %%%%%%%%%%%%%%%%%%
% Get the pixel size
PTBSet.pixelSize= Screen('PixelSize',PTBSet.screenHandle);

%Distance from the monitor
PTBSet.monitorDistance= 740; % 74 cm for now

[PTBSet.windowWidth, PTBSet.windowHeight]= Screen('WindowSize',PTBSet.screenHandle);
PTBSet.xCenter=PTBSet.screenRect(3)/2; % These are our central coordinates %
PTBSet.yCenter=PTBSet.screenRect(4)/2;

PTBSet.widthMonitor=600; % 60 cm
PTBSet.heightMonitor=340; % 34 cm

PTBSet.pixelWidth= PTBSet.widthMonitor /PTBSet.windowWidth; % single px width
PTBSet.pixelHeight= PTBSet.heightMonitor /PTBSet.windowWidth; % single px height

PTBSet.DegPerPixWidth = 2*atand((0.5*PTBSet.pixelWidth)/PTBSet.monitorDistance);
PTBSet.PixPerDegWidth = 1/PTBSet.DegPerPixWidth;
PTBSet.DegPerPixHeight = 2*atand((0.5*PTBSet.pixelHeight)/PTBSet.monitorDistance);
PTBSet.PixPerDegHeight = 1/PTBSet.DegPerPixHeight;


%%%%%%%%%%%%%%%%%% Desired Visual degrees for our stimuli %%%%%%%%%%%%%%%%%%
%%%%%%%%%% Arrow %%%%%%%%%%%%
PTBSet.VisualDegrees.arrowLength= 2;
PTBSet.VisualDegrees.arrowWidth= 2.5;
PTBSet.VisualDegrees.arrowfootWidth= 1;

%%%%%%%%%% Pictures %%%%%%%%%%
PTBSet.VisualDegrees.PicWidth=12;
PTBSet.VisualDegrees.PicHeight= 5;

%%%%%%%%%% Locations %%%%%%%%%%\
%%% Pictures
PTBSet.VisualDegrees.PicyLoc=  2 ;   % ... visual degrees away from the center of screen....
PTBSet.VisualDegrees.PicxLoc=  7;    % ... visual degrees away from the center of screen....

%%% Arrows
PTBSet.VisualDegrees.ArrowxLoc= 8 ;
PTBSet.VisualDegrees.ArrowyLoc= 2 ;
end

