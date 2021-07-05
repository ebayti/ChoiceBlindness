function [ET,log] = EyeTrackerCB(PTBSet,log)

%%%%%%%%%%%%%%%%%%%%%%%% Solution for PsychPortAudio problem while using eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
% The problem is that the beeper() of Eyelink blocks the sound card because
% it calls PsychPortAudio(). This blocks the video presentation because
% Gstreamer cannot access the sound card. (see Email from Mario Kleiner)
fopen( [PsychtoolboxConfigDir 'Snd_use_oldstyle.txt'], 'wb' );
            
            
%%%%%%%%%%%%%%%%%%%%%%%% Initialize Eye tracker settings %%%%%%%%%%%%%%%%%%%%%%%%
% Provide Eyelink with details about the graphics environment
% and perform some initializations. The information is returned
% in a structure that also contains useful defaults
% and control codes (e.g. tracker state bit and Eyelink key values).
dummymode=0;       % set to 1 to initialize in dummymode
ET=EyelinkInitDefaults(PTBSet.screenHandle);

%%%%%%%%%%%%%%%%%%%%%%%% Modification of ET settings - in case they are needed %%%%%%%%%%%%%%%%%%%%%%%%
% Change some values: make background black and everything else white
% Please check function EyelinkInitDefaults() for more possible
% modifications (uncomment to run). For example for blackbackground and white targets:

%ET.backgroundcolour = BlackIndex(PTBSet.screenHandle); 
%ET.foregroundcolour = WhiteIndex(PTBSet.screenHandle);
%ET.msgfontcolour    = WhiteIndex(PTBSet.screenHandle);
%ET.imgtitlecolour   = WhiteIndex(PTBSet.screenHandle); 
%ET.calibrationtargetcolour =[1 1 1];

% And then Update the values with our modifications
% EyelinkUpdateDefaults(ET); 

%%%%%%%%%%%%%%%%%%%%%%%% Set keyboard for input mode %%%%%%%%%%%%%%%%%%%%%%%%
% allows listening to keyboard. Change later to value 2 to suppress
% keypresses to Matlab window
ListenChar(2);

%%%%%%%%%%%%%%%%%%%%%%%% Connection to ET %%%%%%%%%%%%%%%%%%%%%%%%
% Initialization of the connection with the Eyelink Gazetracker.
% exit program if this fails.
if ~EyelinkInit(dummymode, 1)
    fprintf('Eyelink Init aborted.\n');
    cleanup;  % cleanup function
    return;
end


%%%%%%%%%%%%%%%%%%%%%%%% Getting information about Eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
% Learn with which eye tracker we are working with
[v, vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

%%%%%%%%%%%%%%%%%%%%%%%% Decide which data to save %%%%%%%%%%%%%%%%%%%%%%%%
% Let's save every kind of data :):):):):)
Eyelink('command', 'file_event_filter = LEFT, RIGHT, FIXATION, SACCADE, BLINK, MESSAGE');
Eyelink('command', 'file_sample_data = LEFT,RIGHT,GAZE,AREA');
%set link data (used for gaze cursor)
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
% make sure that we get gaze data from the Eyelink
Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');

%%%%%%%%%%%%%%%%%%%%%%%% Open a file for saving %%%%%%%%%%%%%%%%%%%%%%%%
if strcmp (log.ParticipantID ,'test')
    log.edfFile = ['TEST_C' log.Condition  'S' log.Pictures '.edf'];
else
log.edfFile = ['s' log.ParticipantID 'C' num2str(log.Condition) 'S' num2str(log.Pictures) '.edf'];
end
status= Eyelink('Openfile', log.edfFile);

%%%%%%%%%%%%%%%%%%%%%%%% If there is an error %%%%%%%%%%%%%%%%%%%%%%%%
if status ~= 0
    error('EyeLink file is causing some troubles')
end

end
