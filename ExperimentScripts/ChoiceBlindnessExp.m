%% Psychophysical investigations about decision making
% author : Emre Baytimur
% Supervisor: Pablo Rogrido Grassi
% Experiment paradigm: Choice Blindness
% pthers
% to be written (exp,design etc)
% Voice artist: DAVID

function ChoiceBlindnessExp ()

%%%%%%%%%%%%%%%%%%%%%%%% Set the path for saving purposes later on %%%%%%%%%%%%%%%%%%%%%%%%
% cd('/home/sysgen/Documents/Emre/ChoiceBlindness') % Path of the scritps in the lab computer
log.ExperimentFolder=pwd;

qs=2:4; % we will use this variable later on for calling voice files

%% Initiate the experiment loop
try
    %%%%%%%%%%%%%%%%%%%%%%%% Create log struct %%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%% Determine the eye tracker situation %%%%%%%%%%%%%%%%%%%%%%%%
    log.skipEyeTracking= false; %if true, skips the do not run Eye Tracker
    
    %%%%%%%%%%%%%%%%%%%%%%%% This one obviously hides the cursor...
    HideCursor;
    
    %%%%%%%%%%%%%%%%%%%%%%%% This variable is for giving input into the log structre
    checkInput=true;
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Set the experiment paradigms and save them in the log structure %%%%%%%%%%%%%%%%%%%%%%%%
    
    while checkInput % input mode is on
        
        log.ParticipantID= input('Enter participant ID:\n','s');
        
        % these paradigms will determine the first manipulation pair and the intended manipulation condition again for the first pair
        log.Condition= input('Congruency? (1= Congruent , 0= Incongruent) \n: '); %Select the first condition type
        log.Pictures= input('Similarity? (1= Similar , 0= Dissimilar) \n: '); % select the first pair type
        
        
        %%%%%%%%%%%%%%%%%%%%%%%% Check whether there is an error or not %%%%%%%%%%%%%%%%%%%%%%%%
        % if yes, warn the experimenter and kindly ask to re-type inputs
        
        if log.Condition==0 || log.Condition==1 ...
                && log.Pictures==0||log.Pictures==1
            checkInput=false; % input mode is off
        else
            disp('Something is wrong, please be careful this time') % kind warning
            log.Condition= input('Congruency? (1= Congruent , 0= Incongruent) \n :'); %Select the first condition type
            log.Pictures= input('Similarity? (1= Similar , 0= Dissimilar) \n: '); % select the first pair type
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%  Select the experiment's langauge %%%%%%%%%%%%%%%%%%%%%%%%
        
        log.Language= input (' Please select the language of the experiment \n -- 0= Deutsch , 1= English \n:');
        if log.Language==1 || log.Language==0
            checkInput=false; % input mode is off
        else % If there is something wrong kindly warn the experimenter and ask to re-type
            disp('Selected language is wrong, please be careful this time')
            log.Language= input (' Please select the language of the experiment \n -- 0= Deutsch , 1= English \n:');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%% Print the starting condition to inform the experimenter %%%%%%%%%%%%%%%%%%%%%%%%
        
        if log.Condition==1
            if log.Pictures == 1
                finalCheck= ['Participant ' log.ParticipantID ' will start with a Congruent and Similar condition'];
            elseif log.Pictures == 0
                finalCheck= ['Participant ' log.ParticipantID ' will start with a Congruent and Distant condition'];
            end
        elseif log.Condition==0
            if log.Pictures == 1
                finalCheck= ['Participant ' log.ParticipantID ' will start with Incongruent and Similar condition'];
            elseif log.Pictures == 0
                finalCheck= ['Participant ' log.ParticipantID ' will start with Incongruent and Distant condition'];
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%% Print the language of the experiment %%%%%%%%%%%%%%%%%%%%%%%%
        
        if log.Language ==1
            finalCheck=  [finalCheck newline 'The experiment will be conducted in English'];
        elseif log.Language ==0
            finalCheck=  [finalCheck newline 'The experiment will be conducted in German \n'];
        end
        
        disp(finalCheck) % print the experiment paradigms based on given input
        
        % final question for starting the experiment, if the given answer
        % is yes restart the input mode
        
        check=input('Are these settings correct? (Please type yes or no) \n :','s');
        if strcmp(check,'yes')
            checkInput=false; % end the input mode if the given answer is 'yes'
        else
            checkInput=true; % restart the input mode if the given answer is 'no'
        end
        log.finalCheck=finalCheck; % save the final message to the log struct
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% Create a file %%%%%%%%%%%%%%%%%%%%%%%%
    c=clock; % this gives the current date and time as date vector
    
    if log.Condition==1
        if log.Pictures == 1
            log.fileName=['sub-' log.ParticipantID '/Congruent_/Similar__' num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))];
        elseif log.Pictures == 0
            log.fileName=['sub-' log.ParticipantID '/Congruent_/Distant__' num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))];
        end
    elseif log.Condition==0
        if log.Pictures == 1
            log.fileName=['sub-' log.ParticipantID '/Incongruent_/Similar__' num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))];
        elseif log.Pictures == 0
            log.fileName=['sub-' log.ParticipantID '/Incongruent_/Distant__' num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))];
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% Create a folder for the current participant %%%%%%%%%%%%%%%%%%%%%%%%
    if ~isfolder (['sub-' log.ParticipantID ])
        mkdir (['sub-' log.ParticipantID ])
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% Change directory and save the directory to a variable %%%%%%%%%%%%%%%%%%%%%%%%
    % PRG --> will break if the ParticipantID is NOT a number.
    cd(sprintf('sub-%d%d',str2double(log.ParticipantID(1)),str2double(log.ParticipantID(2))));
    log.IDfolder=pwd;
    
    %%%%%%%%%%%%%%%%%%%%%%%% Create the Explanation subfolder %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%% Change directory and save the directory to a variable %%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~isfolder (['recordings' log.ParticipantID])
        mkdir (['recordings'])
    end
    
    cd(sprintf('recordings'));
    log.RecordingssaveFolder=pwd;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%% Go back to the experiment folder and create another subfolder %%%%%%%%%%%%%%%%%%%%%%%%
    cd(sprintf(log.IDfolder));
    
    %%%%%%%%%%%%%%%%%%%%%%%% Creating the eyetracking folder
    if ~isfolder (['eyetrack' ])
        mkdir (['eyetrack'])
    end
    
    cd(sprintf('eyetrack'));
    log.EyeTrackingFolder=pwd;
    
    %%%%%%%%%%%%%%%%%%%%%%%% Go back to the experiment folder to run experiment %%%%%%%%%%%%%%%%%%%%%%%%
    cd(sprintf(log.ExperimentFolder));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%% Call the essential setting functions %%%%%%%%%%%%%%%%%%%%%%%%
    % Call PTB settings from the ChoiceBlindnessPTBSettings.m file
    PTBSet= ChoiceBlindnessPTBSettings();
    % Call the remaining design settings from the ChoiceBlindnessDesign.m file
    [designCB]= ChoiceBlindnessDesign(log);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%% Arrows %%%%%%%%%%%%%%%%%%%%%%%%
    % Required inputs for drawing arrows
    % Please see ptbDrawArrowMod.m function for details
    w0n=PTBSet.screenHandle ;
    %%%%%%%%%%%%%%%%%%%%%%%%  pixel per visual degree x desired visual degree %%%%%%%%%%%%%%%%%%%%%%%%
    arrowLength= PTBSet.PixPerDegHeight*PTBSet.VisualDegrees.arrowLength; %6 visual degrees - 583.4738px
    arrowWidth= PTBSet.PixPerDegWidth * PTBSet.VisualDegrees.arrowWidth; % 11 visual degrees - 606.1645px
    headfootRatio=1/3;
    footWidth=PTBSet.PixPerDegWidth * PTBSet.VisualDegrees.arrowfootWidth;% 3.5 visual degrees - 192.8705px
    
    arrowColor= [0 0 0];
    backgroundColor = [0.5 0.5 0.5];
    %%%%%%%%%%%%%%%%%%%%%%%% Calling arrow drawing functions %%%%%%%%%%%%%%%%%%%%%%%%
    [arrowTex, arrowTexRot] = ptbDrawArrowModRot(PTBSet.screenHandle , arrowLength, arrowWidth, headfootRatio, footWidth, arrowColor, backgroundColor);
    
    %%%%%%%%%%%%%%%%%%%%%%%% Print info for the experimenter %%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n\n Trial order will be: \n');
    fprintf(' %d -' , designCB.trials(:));
    fprintf('\n Congruent explanation trials will be:');
    fprintf(' %d -' , sort(designCB.CogSelections(:)));
    fprintf('\n Incongruent explanation trials will be:');
    fprintf(' %d -' , sort(designCB.InCogSelections(:)));
    fprintf('\n Congruent pairs: %d - %d - %d - %d' , designCB.Congruent(1), designCB.Congruent(2), designCB.Congruent(3), designCB.Congruent(4));
    fprintf('\n Incongruent ones: %d - %d - %d - %d' , designCB.inCongruent(1), designCB.inCongruent(2), designCB.inCongruent(3), designCB.inCongruent(4));
    fprintf('\n ');
    
    %%%%%%%%%%%%%%%%%%%%%%%% Preallocating data structure and saving some info %%%%%%%%%%%%%%%%%%%%%%%%
    log.Data.TrialSeqeunce=designCB.TrialSeqeunce;
    log.Data.ExplanationTrials=designCB.AllSelections;
    log.Data.CongruentTrials=designCB.Congruent;
    log.Data.IncogruentTrials=designCB.inCongruent;
    log.Data.PictureDisplayCongruent=designCB.leftRight;
    log.Data.ColorDisplayCongruent=designCB.colorswap;
    log.Data.pressedKey=zeros(length(designCB.TrialSeqeunce),1);
    log.Data.pickedPicture=zeros(length(designCB.TrialSeqeunce),1);
    
    %%%%%%%%%%%%%%%%%%%%%%%% Retrieving colors for the alpha channel %%%%%%%%%%%%%%%%%%%%%%%%
    Stimulus.colorLeft=(sprintf('%s//Pictures//SHINEd_Blueish.png',PTBSet.expPath));
    Stimulus.colorRight=(sprintf('%s//Pictures//SHINEd_Redish.png',PTBSet.expPath));
    %Stimulus.BetweenTrialsPath=(sprintf('%s//Pictures//BetweenTrials.png',PTBSet.expPath)); % Or BetweenTrialsGray.png
    
    %%%%%%%%%%%%%%%%%%%%%%%% Setting necessary values für likert slider %%%%%%%%%%%%%%%%%%%%%%%%
    screenColor = [PTBSet.backgroundColor PTBSet.backgroundColor PTBSet.backgroundColor];
    screenRect =PTBSet.screenRect;
    win= PTBSet.screenHandle;
    winRect=  PTBSet.screenRect;
    nLikertRange = 9; % from -4 to 4
    
    
    %%%%%%%%%%%%%%%%%%%%%%%% Fixation cross  %%%%%%%%%%%%%%%%%%%%%%%%
    % Retrieved from http://www.peterscarfe.com/fixationcrossdemo.html
    % Here we set the size of the arms of our fixation cross
    fixCrossDimPix = 20;
    % Now we set the coordinates (these are all relative to zero we will let
    % the drawing routine center the cross in the center of our monitor for us)
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];
    
    % Set the line width for our fixation cross
    lineWidthPix = 6;

    
    %% Start Eye Tracker
    %%%%%%%%%%%%%%%%%%%%%%%% Call the Eye tracker settings and start the eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~log.skipEyeTracking % run these lines if eye tracker is not disabled at the beginning
        [ET,log] = EyeTrackerCB(PTBSet,log); % call the preset settings in the EyeTrackerCB.m file
        
        %%%%%%%%%%%%%%%%%%%%%%%% Calibration and Validation (these are the default settings) %%%%%%%%%%%%%%%%%%%%%%%%
        EyelinkDoTrackerSetup(ET);
        EyelinkDoDriftCorrection(ET);
        
        % Start recording eye position
        Eyelink('StartRecording');
        % Record a few samples before we actually start displaying
        WaitSecs(0.1);
        % Mark zero-plot time in data file
        Eyelink('Message', 'SYNCTIME');
        % sets EyeUsed to -1 because we do not know which eye we use. This is
        % asked before we sample
        EyeUsed = -1;
    end
    
    %% Instructions
    
    %%%%%%%%%%%%%%%%%%%%%%%% Display the instructions that are stored in the ChoiceBlindnessDesign.m file %%%%%%%%%%%%%%%%%%%%%%%%
    % We dont do that anymore
    %%%%%%%%%%%%%%%%%%%%%%%% Restrict all keys except the Space Key during instructions %%%%%%%%%%%%%%%%%%%%%%%%
    RestrictKeysForKbCheck([PTBSet.Keys.spaceKey PTBSet.Keys.escapeKey]);
    ListenChar(2); % PRG --> Is this necessary? This can make it impossible to stop with sca or ctrl+c.
    % Not necessary but typing c, v and spaces might give an error such as
    % (unknownn function or etc)
    
    %%%%%%%%%%%%%%%%%%%%%%%% Experiment is starting messages %%%%%%%%%%%%%%%%%%%%%%%%
    DrawFormattedText (PTBSet.screenHandle,designCB.StartExp, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5);KbWait;
    Screen('Flip',PTBSet.screenHandle);
    WaitSecs(0.5);
    DrawFormattedText(PTBSet.screenHandle,designCB.Starting,'center','center',PTBSet.fontColor);
    Screen('Flip',PTBSet.screenHandle);
    WaitSecs(1);
    Screen('Flip',PTBSet.screenHandle);
    WaitSecs(0.5);
    DrawFormattedText(PTBSet.screenHandle,designCB.Ready,'center','center',PTBSet.fontColor);
    Screen('Flip',PTBSet.screenHandle);
    WaitSecs(1);
    Screen('Flip',PTBSet.screenHandle);
    WaitSecs(0.5);
    
    %%%%%%%%%%%%%%%%%%%%%%%%  Stop and remove events in queue %%%%%%%%%%%%%%%%%%%%%%%%
    KbQueueStop(PTBSet.Keys.keyboardNr2);
    KbEventFlush(PTBSet.Keys.keyboardNr2);
    KbQueueStop(PTBSet.Keys.keyboardNr1);
    KbEventFlush(PTBSet.Keys.keyboardNr1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%  Start KbQueues a%%%%%%%%%%%%%%%%%%%%%%%%
    KbQueueStart(PTBSet.Keys.keyboardNr1); % Participant
    KbQueueStart(PTBSet.Keys.keyboardNr2); % Experimenter
    
    log.quitExperiment=0; % This variable will be in use when the Escape key is pressed.
    
    %%%%%%%%%%%%%%%%%%%%%%%% Likert settings %%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRG --> Likert setting ONLY WORK IN THIS ONE SCREEN
    scale_position = - floor(PTBSet.screenRect(4) * .33)+20; % Move vertically
    text_position = - floor(PTBSet.screenRect(4) * .4)+20; % Below the Scale
    
    % Scale Parameters
    likert=-4:4;
    hori_bar_mat = 0 * ones([floor(PTBSet.screenRect(4)*(.1/10)) floor(PTBSet.screenRect(3)*(1/2))]);
    hori_bar_texture = Screen('MakeTexture', PTBSet.screenHandle, hori_bar_mat);
    hori_bar_size = size(hori_bar_mat);
    vert_bar_mat = 0 * ones([floor(PTBSet.screenRect(4)*(.25/10)) floor(PTBSet.screenRect(3)*(1/300))]);
    vert_bar_texture = Screen('MakeTexture', PTBSet.screenHandle, vert_bar_mat);
    vert_bar_size = size(vert_bar_mat);
    
    % Scale Markers Specification
    ovalSize = 35;
    ovalWidth = 35;
    ovalColor = [200 0 0];
    
    %% #2. Assessment method
    cp = [floor(PTBSet.screenRect(3)*.5) floor(PTBSet.screenRect(4)*.5)]; %Center point
    hori_bar_pos = [floor(cp(1) - .5*hori_bar_size(2)),...
        floor(cp(2) - .5*hori_bar_size(1)) - scale_position,...
        floor(cp(1) + .5*hori_bar_size(2)),...
        floor(cp(2) + .5*hori_bar_size(1)) - scale_position];
    %%%%%%%%%%%%%%%%%%%%
    nScaleColumns = nLikertRange;
    
    % Possible mouse positions and limit its movement
    possibleMoveSpace = [     ...
        round(hori_bar_pos(1)+screenRect(1)),   ...
        round(.5 * (hori_bar_pos(2)+hori_bar_pos(4)) + screenRect(2)),   ...
        round(hori_bar_pos(3)+screenRect(1)),   ...
        round(.5 * (hori_bar_pos(2)+hori_bar_pos(4)) + screenRect(2) + 1)   ...
        ];
    
    initialPos = round((possibleMoveSpace(3) - possibleMoveSpace(1)));
    
    %% Experiment loop
    % PRG --> It woudl be best to have n_trials
    for ii=1:30 % ii= 30 since we have 30 trials
        
        %%%%%%%%%%%%%%%%%%%%%%%% Retrieving pictures from the specified path %%%%%%%%%%%%%%%%%%%%%%%%
        % All the picture names are hardcoded as the pairs are fixed but the order of trials can be randomized.
        % Even the picture names are specificied as "left" and "right", this does not specify their presentation location during the experiment
        % designCB.LeftRigth variable will determine the location of the pictures. If it is equal to 0, picture location will be swapped.
        % That is to say, right picture will be displayed on the left if designCB.LeftRight== 0;
        
        if designCB.leftRight(ii)==1
            Stimulus.pathStringLeft=sprintf('%s//Pictures//leftTrial-%d.jpg',PTBSet.expPath,designCB.trials(ii));
            Stimulus.pathStringRight=sprintf('%s//Pictures//rightTrial-%d.jpg',PTBSet.expPath,designCB.trials(ii));
        elseif designCB.leftRight(ii)==0
            Stimulus.pathStringRight=sprintf('%s//Pictures//leftTrial-%d.jpg',PTBSet.expPath,designCB.trials(ii));
            Stimulus.pathStringLeft=sprintf('%s//Pictures//rightTrial-%d.jpg',PTBSet.expPath,designCB.trials(ii));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%% Reading the called images and saving them to a variable %%%%%%%%%%%%%%%%%%%%%%%%
        % Left
        Stimulus.MxPicLeft=imread(Stimulus.pathStringLeft);
        Stimulus.leftPic=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.MxPicLeft);
        % Right
        Stimulus.MxPicRight=imread(Stimulus.pathStringRight);
        Stimulus.rightPic=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.MxPicRight);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Getting the one size is enough here since they have identical sizes (2444x1718) %%%%%%%%%%%%%%%%%%%%%%%%
        %[Stimulus.PicHeight,Stimulus.PicWidth,~]=size(Stimulus.MxPicLeft);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Size in viusal degrees %%%%%%%%%%%%%%%%%%%%%%%%
        Stimulus.PicHeight= PTBSet.PixPerDegHeight * PTBSet.VisualDegrees.PicHeight;
        Stimulus.PicWidth = PTBSet.PixPerDegWidth * PTBSet.VisualDegrees.PicWidth;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%% Display locations of the colors %%%%%%%%%%%%%%%%%%%%%%%%
        % designCB.colorswap has the same rationale as designCB.LeftRight
        % If designCB.colorswap == 0, presentation locations of the colors on the top of picutres are swapped.
        [img1, ~, alpha] = imread(Stimulus.colorLeft);
        img1(:, :, 4)= alpha;
        [img2, ~, alpha] = imread(Stimulus.colorRight);
        img2(:, :, 4)= alpha;
        if designCB.colorswap(ii)==1
            % blue
            Stimulus.BlueMask = Screen('MakeTexture', PTBSet.screenHandle, img1);
            % red
            Stimulus.RedMask = Screen('MakeTexture', PTBSet.screenHandle , img2);
        elseif designCB.colorswap(ii)==(0)
            Stimulus.RedMask = Screen('MakeTexture', PTBSet.screenHandle, img1);
            % red
            Stimulus.BlueMask = Screen('MakeTexture', PTBSet.screenHandle , img2);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%% White Patches between Trials %%%%%%%%%%%%%%%%%%%%%%%
        % PRG --> commented. 
        %Stimulus.BtwTMx= imread(Stimulus.BetweenTrialsPath);
        %Stimulus.BetweenTrials=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.BtwTMx);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Stimuli locations %%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%% Locations in visual degrees %%%%%%%%%%
        Stimulus.xDistance= PTBSet.PixPerDegWidth * PTBSet.VisualDegrees.PicxLoc;
        Stimulus.yDistance= PTBSet.PixPerDegHeight * PTBSet.VisualDegrees.PicyLoc;
        Stimulus.ArrowxDistance= PTBSet.PixPerDegWidth * PTBSet.VisualDegrees.ArrowxLoc ;
        Stimulus.ArrowyDistance= PTBSet.PixPerDegHeight * PTBSet.VisualDegrees.ArrowyLoc ;
        
        %%%%%%%%%%%%%%%%%%%%%%%% Set the locations for drawing %%%%%%%%%%%%%%%%%%%%%%%%
        % newRect = CenterRectOnPoint(rect,x,y)
        Stimulus.leftLocation=CenterRectOnPoint([0 0 Stimulus.PicWidth Stimulus.PicHeight],PTBSet.xCenter-Stimulus.xDistance,PTBSet.yCenter-Stimulus.yDistance);
        Stimulus.rightLocation=CenterRectOnPoint([0 0 Stimulus.PicWidth Stimulus.PicHeight],PTBSet.xCenter+Stimulus.xDistance,PTBSet.yCenter-Stimulus.yDistance);
        Stimulus.blueMaskLoc=CenterRectOnPoint([0 0 Stimulus.PicWidth Stimulus.PicHeight],PTBSet.xCenter-Stimulus.xDistance,PTBSet.yCenter-Stimulus.yDistance);
        Stimulus.redMaskLoc=CenterRectOnPoint([0 0 Stimulus.PicWidth Stimulus.PicHeight],PTBSet.xCenter+Stimulus.xDistance,PTBSet.yCenter-Stimulus.yDistance);
        Stimulus.explanationLoc= (Stimulus.leftLocation+Stimulus.rightLocation)/2;
        Stimulus.arrowLocationLeft= CenterRectOnPoint([0 0 arrowLength arrowWidth],PTBSet.xCenter-Stimulus.ArrowxDistance,PTBSet.yCenter+Stimulus.ArrowyDistance);
        Stimulus.arrowLocationRight= CenterRectOnPoint([0 0 arrowLength arrowWidth],PTBSet.xCenter+Stimulus.ArrowxDistance,PTBSet.yCenter+Stimulus.ArrowyDistance);
        

        %%%%%%%%%%%%%%%%%%%%%%%% Change key restrictions (add arrow and escape keys) %%%%%%%%%%%%%%%%%%%%%%%%
        RestrictKeysForKbCheck([PTBSet.Keys.escapeKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey PTBSet.Keys.spaceKey]); % This means PTB will only look for these keypresses. RestrictKeysForKbCheck([]) if you want to allow everything.
        
        %%%%%%%%%%%%%%%%%%%%%%%% Printing messages for eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
        if ~log.skipEyeTracking
            trialNr = ii;
            Eyelink('Message', sprintf('TRIAL %u Starting', trialNr)); % trial number
            Eyelink('Message', sprintf('Blank page before trial %u',trialNr)); % Pair number as stated in /Pictures/leftTrail"NR"...
        end
        
            % Draw the fixation cross in white, set it to the center of our screen and
            % set good quality antialiasing
            % PRG --> commented the white squares and fixation cross.
            %Screen('DrawLines', PTBSet.screenHandle, allCoords,lineWidthPix, 0, [PTBSet.xCenter PTBSet.yCenter], 2);
            %Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BetweenTrials,[],Stimulus.leftLocation);
            %Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BetweenTrials,[],Stimulus.rightLocation);
            Screen('DrawTexture',PTBSet.screenHandle,arrowTex,[],Stimulus.arrowLocationLeft)
            Screen('DrawTexture',PTBSet.screenHandle,arrowTexRot,[],Stimulus.arrowLocationRight)
            Screen('Flip',PTBSet.screenHandle);
            WaitSecs(2);
        
        choiceStartTime=GetSecs; % we will use this value for determining the drawing time of pictures
        
                %%%%%%%%%%%%%%%%%%%%%%%% Printing messages for eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
        if ~log.skipEyeTracking
            trialNr = ii;
            Eyelink('Message', sprintf('TRIAL %u', trialNr)); % trial number
            Eyelink('Message', sprintf('Presented pair is Nr %u', designCB.trials(ii))); % Pair number as stated in /Pictures/leftTrail"NR"...
        end
        
        cont=1; % this is a loop value for drawing trials
        
        %%%%%%%%%%%%%%%%%%%%%%%% Drawing stimuli %%%%%%%%%%%%%%%%%%%%%%%%
        while cont==1
            if GetSecs-choiceStartTime<=PTBSet.pictureDuration % display the pictures and colors for 5 seconds
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.leftLocation);
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.rightLocation);
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.blueMaskLoc);
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.redMaskLoc);
            end
            %%%%%%%%%%%%%%%%%%%%%%%% Drawing the question - until a key press has been executed %%%%%%%%%%%%%%%%%%%%%%%%
            Screen('DrawTexture',PTBSet.screenHandle,arrowTex,[],Stimulus.arrowLocationLeft)
            Screen('DrawTexture',PTBSet.screenHandle,arrowTexRot,[],Stimulus.arrowLocationRight)
            Screen('Flip',PTBSet.screenHandle);
            
            % make pressedKey an array/list
            [~,~,keyCode]=KbCheck;
            if keyCode(PTBSet.Keys.leftKey) | keyCode(PTBSet.Keys.rightKey) | keyCode(PTBSet.Keys.escapeKey)
                cont=0;
                if keyCode(PTBSet.Keys.leftKey)
                    log.Data.pressedKey(ii)=1;
                elseif keyCode(PTBSet.Keys.rightKey)
                    log.Data.pressedKey(ii)=2;
                elseif keyCode(PTBSet.Keys.escapeKey)
                    log.quitExperiment=1;
                    break;
                end
            end
        end
        choiceStopTime=GetSecs;

                        %%%%%%%%%%%%%%%%%%%%%%%% Printing messages for eye tracker %%%%%%%%%%%%%%%%%%%%%%%%
        if ~log.skipEyeTracking
            trialNr = ii;
            Eyelink('Message', sprintf('End of TRIAL %u', trialNr)); % trial number
            Eyelink('Message', sprintf('Presented pair was Nr %u', designCB.trials(ii))); % Pair number as stated in /Pictures/leftTrail"NR"...
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save pressed keys and picked picture  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        log.Data.trialRTime(ii,1)=choiceStopTime-choiceStartTime;
        log.Data.presentedPair(ii,1)=designCB.trials(ii);
        
        if log.quitExperiment==1
            log.end = 'Escape'; % Finished by escape key
            ListenChar(1);
            log.ExpNotes = input('Notes:','s');
            warning('Experiment was terminated by Escapekey');
            log.end= 'Finished by ESC key';
            cd(log.IDfolder);
            save('ExpData_ESC','log');
            save('Design_ESC', 'designCB');
            save('PTBData_ESC','PTBSet');
            save('Simulus_ESC','Stimulus');
            
            if ~log.skipEyeTracking
                Eyelink('StopRecording');
                Eyelink('CloseFile');
                WaitSecs(1);
                cd(log.EyeTrackingFolder);
                
                try
                    fprintf('Receiving data file ''%s''\n',  log.edfFile);
                    status=Eyelink('ReceiveFile');
                    Waitsecs(2);
                    if status > 0
                        fprintf('ReceiveFile status %d\n', status);
                    end
                    if 2==exist(log.edfFile, 'file')
                        fprintf('Data file ''%s'' can be found in ''%s''\n',  log.edfFile, pwd );
                    end
                catch rdf
                    fprintf('Problem receiving data file ''%s''\n', log.edfFile );
                    rdf;
                end
            end
            cd(log.IDfolder);
            Screen('CloseAll'),sca;
            
            return;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Option to change answer %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if designCB.trials(ii)~=designCB.nonExp % This part of the experiment will be displayed only in 16 trials (8 manipulations, 8 randomly selected trials)
            trialNr = ii;
            changeSelection=1; % loop variable to ask for answer change
            RestrictKeysForKbCheck([PTBSet.Keys.escapeKey PTBSet.Keys.spaceKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey PTBSet.Keys.downKey PTBSet.Keys.upKey]);
            Screen('Flip',PTBSet.screenHandle);
            WaitSecs (1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PsychPortAudio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            InitializePsychSound;
            
            % Frequency of the sound. Sample rates of 44.1 & 48kHz are more than capable of capturing the full range of the human audible spectrum.
            freq = 44100;  % when recording using a sample rate of 44.1kHz. 44100 samples are being captured each second by your audio recording device.
            % As such, the vast majority of digital music available by typical distribution methods (streaming on Spotify/Apple Music, CDs) is at a 44.1kHz sample rate, audio for film tends to be at 48kHz3
            % (https://support.focusrite.com/hc/en-gb/articles/115004120965-Sample-Rate-Bit-Depth-Buffer-Size-Explained)
            
            %%%%%%%%%%%%%%%%%%%%%%%% RecordSound %%%%%%%%%%%%%%%%%%%%%%%%
            % Open Psych-Audio port, with the follow arguements
            % pahandleRecord = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
            % (1) [] = default sound device
            % (2) 2  = sound capture
            % (3) 0  = This mode works always and with all settings, plays nicely with other sound applications.
            % (4) Requested frequency in samples per second
            % (5) 2  = stereo output
            pahandleRecord = PsychPortAudio('Open', [], 2, 0, freq, 2);
            
            % the amount of time allowed for your computer to process the audio
            allocatedBufferSize=1000; %In seconds
            
            % PsychPortAudio('GetAudioData', pahandleRecord [, amountToAllocateSecs][, minimumAmountToReturnSecs][, maximumAmountToReturnSecs][, singleType=0]);
            PsychPortAudio('GetAudioData', pahandleRecord, allocatedBufferSize);
            % PsychPortAudio('Start', pahandleRecord [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf] [, resume=0]);
            % (1) pahandleRecord = the handle of the device to start
            % (2) 0 = how often the playback of the sound data should be repeated.A setting of zero will cause infinite repetitions, ie., until manually stopped via the 'Stop' subfunction
            % (3) 0 = defines the starttime of playback. The start time of capture is related to the start time of playback in duplex mode, but it isn't the same. In pure capture mode (without playback), 'when' will be ignored and capture always starts immediately
            % (4) 1 = we wait for the device to really start
            PsychPortAudio('Start', pahandleRecord, 0, 0, 0);
            recordedAudio = [];
            recordingTimeStamp=GetSecs;
            voiceRecordingStartTime=GetSecs;
            
            %%%%%%%%%%%%%%%%%%%%%%%% Voice files %%%%%%%%%%%%%%%%%%%%%%%%
            % read the 'Change' sound file (David)
            if log.Language==1 % English
                [bufferdata ~] = audioread(sprintf('%s//Voice//ENG//Q1.wav',PTBSet.expPath));
            elseif log.Language==0 % Deutsch
                [bufferdata ~] = audioread(sprintf('%s//Voice//DE//Q1.wav',PTBSet.expPath));
            end
            
            
            % pahandlePlay = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
            % (1) [] = default sound device
            % (2) 1 = playback
            % (3) 0 = This mode works always and with all settings, plays nicely with other sound applications.
            % (4) Requested frequency in samples per second
            % (5) 2 = stereo output
            pahandlePlay = PsychPortAudio('Open', [], 1, 1, freq, 2);
            
            % Set the volume (1= 100%)
            PsychPortAudio('Volume', pahandlePlay, 1);
            
            % Fill the audio playback buffer with the audio data
            PsychPortAudio('FillBuffer', pahandlePlay, bufferdata');
            
            % Start audio playback
            % PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf] [, resume=0]);
            % (1) pahandlePlay = device
            % (2) 1 = play once then stop
            % (3) 0 = start immediately
            PsychPortAudio('Start', pahandlePlay, 1);
            
           if ~log.skipEyeTracking
                trialNr = ii;
                Eyelink('Message', sprintf('Change question at trial %u', trialNr));
                Eyelink('Message', sprintf('Change question for pair Nr %u', designCB.trials(ii)));
            end
            
            Screen ('Flip', PTBSet.screenHandle);
            
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing messages for eye tracker %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            changeStartTime=GetSecs;
            
            while changeSelection==1
                if log.Data.pressedKey(ii)==1 %if the left key is pressed
                    if designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    end
                elseif log.Data.pressedKey(ii)==2 % if the right key is pressed
                    if designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    end
                else
                    fprintf('Something weird !!!!!!!!!\n');
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%% Drawing the question - until a key press has been executed %%%%%%%%%%%%%%%%%%%%%%%%
%                 WaitSecs (1)
                Screen ('Flip', PTBSet.screenHandle);
                WaitSecs (0.5); KbWait;
                
                [keyIsDown,t,keyCode]=KbCheck;
                if keyCode(PTBSet.Keys.leftKey) | keyCode(PTBSet.Keys.rightKey) | keyCode(PTBSet.Keys.spaceKey)| keyCode(PTBSet.Keys.escapeKey) | keyCode(PTBSet.Keys.upKey) | keyCode(PTBSet.Keys.downKey)
                    changeSelection=0;
                    if keyCode(PTBSet.Keys.leftKey) | keyCode(PTBSet.Keys.upKey) | keyCode(PTBSet.Keys.downKey)| keyCode(PTBSet.Keys.rightKey)
                        log.Data.selectionChanged(ii)=1;
                    elseif keyCode(PTBSet.Keys.spaceKey)
                        log.Data.selectionChanged(ii)=0;
                    elseif keyCode(PTBSet.Keys.escapeKey)
                        log.quitExperiment=1;
                    end
                end
            end
            
            changeStopTime=GetSecs;
            
            if ~log.skipEyeTracking
                trialNr = ii;
                Eyelink('Message', sprintf('End of change question at trial %u', trialNr));
                Eyelink('Message', sprintf('End of change question for pair Nr %u', designCB.trials(ii)));
            end
            
            audiodata = PsychPortAudio('GetAudioData', pahandleRecord);
            recordedAudio = [recordedAudio audiodata];
            % Stop and close the playback device
            PsychPortAudio('Stop', pahandlePlay, 1);
            PsychPortAudio('Close', pahandlePlay);
            % Stop and close the recording device
            PsychPortAudio('Stop', pahandleRecord);
            PsychPortAudio('Close', pahandleRecord);
            
            % Screen('Flip',PTBSet.screenHandle);
            WaitSecs(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%% save the recording %%%%%%%%%%%%%%%%%%%%%%%%
            cd(log.RecordingssaveFolder);
            wavfilename=sprintf('Trial%d_Change_Pair%d.wav',trialNr,designCB.trials(ii));
            psychwavwrite(transpose(recordedAudio), 44100, 16, wavfilename);
            cd(log.ExperimentFolder);
            clear recordedAudio;
            
            
            if log.quitExperiment==1
                log.end = 'Escape'; % Finished by escape key
                ListenChar(1);
                log.ExpNotes = input('Notes:','s');
                warning('Experiment was terminated by Escapekey');
                log.end= 'Finished by ESC key';
                cd(log.IDfolder);
                save('ExpData_ESC','log');
                save('Design_ESC', 'designCB');
                save('PTBData_ESC','PTBSet');
                save('Simulus_ESC','Stimulus');
                
                if ~log.skipEyeTracking
                    Eyelink('StopRecording');
                    Eyelink('CloseFile');
                    WaitSecs(1);
                    cd(log.EyeTrackingFolder);
                    
                    try
                        fprintf('Receiving data file ''%s''\n',  log.edfFile);
                        status=Eyelink('ReceiveFile');
                        Waitsecs(2);
                        if status > 0
                            fprintf('ReceiveFile status %d\n', status);
                        end
                        if 2==exist(log.edfFile, 'file')
                            fprintf('Data file ''%s'' can be found in ''%s''\n',  log.edfFile, pwd );
                        end
                    catch rdf
                        fprintf('Problem receiving data file ''%s''\n', log.edfFile );
                        rdf;
                    end
                end
                cd(log.IDfolder);
                Screen('CloseAll'),sca;
                return;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%% Save responses in the Data struct %%%%%%%%%%%%%%%%%%%%%%%%
            
            log.Data.ChangeRTime(ii,1)=changeStopTime-changeStartTime;
            log.Data.presentedChangePair(ii,1)=designCB.trials(ii);
            % Screen('Flip',PTBSet.screenHandle); % Empty screen
            WaitSecs(0.5)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Explanations %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            confabs={designCB.Explanation1, designCB.Explanation2, designCB.Explanation3};
            
            for Exps=1:3
                %%%%%%%%%%%%%%%%%%%%%%%% Change key restrictions (add arrow and escape keys) %%%%%%%%%%%%%%%%%%%%%%%%
                RestrictKeysForKbCheck([PTBSet.Keys.rightKey PTBSet.Keys.leftKey PTBSet.Keys.spaceKey PTBSet.Keys.escapeKey]); % This means PTB will only look for these keypresses.
                
                %%%%%%%%%%%%%%%%%%%%%%%% RecordSound %%%%%%%%%%%%%%%%%%%%%%%%
                pahandleRecord = PsychPortAudio('Open', [], 2, 0, freq, 2);
                % Open the playback device, set the volume, fill the buffer and play
                pahandlePlay = PsychPortAudio('Open', [], 1, 1, freq, 2);
                PsychPortAudio('Volume', pahandlePlay, 1);
                % the amount of time allowed for your computer to process the audio
                allocatedBufferSize=1000; %In seconds
                % PsychPortAudio('GetAudioData', pahandleRecord [, amountToAllocateSecs][, minimumAmountToReturnSecs][, maximumAmountToReturnSecs][, singleType=0]);
                PsychPortAudio('GetAudioData', pahandleRecord, allocatedBufferSize);
                % PsychPortAudio('Start', pahandleRecord [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf] [, resume=0]);
                % (1) pahandleRecord = the handle of the device to start
                % (2) 0 = how often the playback of the sound data should be repeated.A setting of zero will cause infinite repetitions, ie., until manually stopped via the 'Stop' subfunction
                % (3) 0 = defines the starttime of playback. The start time of capture is related to the start time of playback in duplex mode, but it isn't the same. In pure capture mode (without playback), 'when' will be ignored and capture always starts immediately
                % (4) 1 = we wait for the device to really start
                PsychPortAudio('Start', pahandleRecord, 0, 0, 0);
                recordedAudio = [];
                recordingTimeStamp=GetSecs;
                voiceRecordingStartTime=GetSecs;
                
                %%%%%%%%%%%%%%%%%%%%%%%% Playback %%%%%%%%%%%%%%%%%%%%%%%%
                % Get the voice files
                if log.Language==1 % English
                    [bufferdata ~] = audioread(sprintf('%s//Voice//ENG//Q%d.wav',PTBSet.expPath,qs(Exps)));
                elseif log.Language==0 % Deutsch
                    [bufferdata ~] = audioread(sprintf('%s//Voice//DE//Q%d.wav',PTBSet.expPath,qs(Exps)));
                end
                
                % Fill buffer and play
                PsychPortAudio('FillBuffer', pahandlePlay, bufferdata');
                
                if ~log.skipEyeTracking
                    trialNr = ii;
                    Eyelink('Message', sprintf('Explanation %u', trialNr));
                    Eyelink('Message', sprintf('Explanation for pair %u', designCB.trials(ii)));
                end
                
                
                PsychPortAudio('Start', pahandlePlay, 1);
                
                %%%%%%%%%%%%%%%%%%%%%%%%  Likert settings for getting response %%%%%%%%%%%%%%%%%%%%%%%%
                click = 0;
                t1 = GetSecs;
                
                respRange = linspace(possibleMoveSpace(1), possibleMoveSpace(3), nLikertRange);
                tmpPoint = 5;
                
                while ~click
                    %%%%%%%%%%%%%%%%%%%%%%%% Draw pictures according to participant responses %%%%%%%%%%%%%%%%%%%%%%%%
                    if log.Data.selectionChanged (ii) == 1 % if selection was not changed during previous question
                        if log.Data.pressedKey(ii) ==2 % if the picture on the right was selected at last
                            if  designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            end
                        elseif log.Data.pressedKey(ii)==1 % if the picture on the left was selected at last
                            if designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            end
                        end
                    elseif log.Data.selectionChanged(ii)==0
                        if log.Data.pressedKey(ii)==1
                            if designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            end
                        elseif log.Data.pressedKey(ii)==2
                            if designCB.trials(ii)== designCB.CogSelections(1) | designCB.trials(ii)== designCB.CogSelections(2) | designCB.trials(ii)== designCB.CogSelections(3) | designCB.trials(ii)== designCB.CogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.InCogSelections(1) | designCB.trials(ii)== designCB.InCogSelections(2) | designCB.trials(ii)== designCB.InCogSelections(3) | designCB.trials(ii)== designCB.InCogSelections(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.Congruent(1) |designCB.trials(ii)== designCB.Congruent(2) | designCB.trials(ii)== designCB.Congruent(3) | designCB.trials(ii)== designCB.Congruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                            elseif designCB.trials(ii)== designCB.inCongruent(1) | designCB.trials(ii)== designCB.inCongruent(2) | designCB.trials(ii)== designCB.inCongruent(3) | designCB.trials(ii)== designCB.inCongruent(4)
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                            end
                        end
                    end
                    
                    if Exps ~= 3
                        %%%%%%%%%%%%%%%%%%%%%%%%  Hori bar draw %%%%%%%%%%%%%%%%%%%%%%%%
                        Screen('DrawTexture', PTBSet.screenHandle, hori_bar_texture,...
                            [0 0 hori_bar_size(2) hori_bar_size(1)], hori_bar_pos);
                        %%%%%%%%%%%%%%%%%%%%%%%%  Vert bars draw %%%%%%%%%%%%%%%%%%%%%%%%
                        xRange = linspace(hori_bar_pos(1),hori_bar_pos(3),nScaleColumns);
                        
                        for xPos = xRange
                            vert_bar_pos = [ xPos - vert_bar_size(2),...
                                mean([hori_bar_pos(2) hori_bar_pos(4)]) - (.5*vert_bar_size(1)),...
                                xPos + vert_bar_size(2),...
                                mean([hori_bar_pos(2) hori_bar_pos(4)]) + (.5*vert_bar_size(1)),...
                                ];
                            Screen('DrawTexture', PTBSet.screenHandle, vert_bar_texture,...
                                [0 0 vert_bar_size(2) vert_bar_size(1)], vert_bar_pos);
                        end
                        
                        if log.Language ==1
                            if Exps==1
                                resp_for_show = (strcat([ 'Attractiveness: ' num2str(likert(tmpPoint)) ]));
                            else
                                resp_for_show = (strcat([ 'Confidence: ' num2str(tmpPoint) ]));
                            end
                        else
                            if Exps==1
                                resp_for_show = (strcat([ 'Attraktivität: ' num2str(likert(tmpPoint)) ]));
                            else
                                resp_for_show = (strcat([ 'Zuversicht: ' num2str(tmpPoint) ]));
                            end
                        end
                        
                        Screen('DrawText', PTBSet.screenHandle, resp_for_show  ,cp(1)-100 , cp(2)+250 );
                        
			if Exps == 1
                        Screen('DrawText', PTBSet.screenHandle, '-4'  ,respRange(1)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-3'  ,respRange(2)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-2'  ,respRange(3)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-1'  ,respRange(4)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '0'  ,respRange(5)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '1'  ,respRange(6)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '2'  ,respRange(7)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '3'  ,respRange(8)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '4'  ,respRange(9)-15, cp(2)+380 );
                        else
                        Screen('DrawText', PTBSet.screenHandle, '1'  ,respRange(1)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '2'  ,respRange(2)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '3'  ,respRange(3)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '4'  ,respRange(4)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '5'  ,respRange(5)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '6'  ,respRange(6)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '7'  ,respRange(7)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '8'  ,respRange(8)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '9'  ,respRange(9)-15, cp(2)+380 );
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%% Get Response %%%%%%%%%%%%%%%%%%%%%%%%
                        [~,~,keyCode]=KbCheck;
                        if keyCode(PTBSet.Keys.leftKey)
                            tmpPoint = tmpPoint - 1;
                            if tmpPoint < 1
                                tmpPoint = 1;
                            end
                            
                        elseif  keyCode(PTBSet.Keys.rightKey)
                            tmpPoint = tmpPoint + 1;
                            if tmpPoint > 9
                                tmpPoint = 9;
                            end
                        end
                        
                        xPos = respRange(tmpPoint);
                        yPos =  .5 * (vert_bar_pos(2)+vert_bar_pos(4)) + screenRect(2);
                        
                        Screen('FrameOval', PTBSet.screenHandle, ovalColor,...
                            [ xPos-ovalSize*.5, yPos - ovalSize*.5,...
                            xPos+ovalSize*.5, yPos + ovalSize*.5 ], ovalWidth);
                        
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%  Flip and check for keypresssssssssssssss %%%%%%%%%%%%%%%%%%%%%%%%
                    Screen('Flip', PTBSet.screenHandle);
                    WaitSecs(0.1);
                    [~,~,keyCode]= KbCheck;
                    if keyCode(PTBSet.Keys.spaceKey)
                        click = 1;
                        if Exps ~= 3
                            log.Data.Likert(ii,Exps)= tmpPoint-5;
                        end
                    elseif keyCode(PTBSet.Keys.escapeKey)
                        log.quitExperiment=1;
                    end
                end
                
              if ~log.skipEyeTracking
                    trialNr = ii;
                    Eyelink('Message', sprintf('End of explanation %u', trialNr));
                    Eyelink('Message', sprintf('End of explanation for pair %u', designCB.trials(ii)));
                end
                
                
                if GetSecs-recordingTimeStamp > allocatedBufferSize/1.5 %This is just an arbitrary, safe location to save the collected audio data. The rule is that it has to be shorter than the 10 seconds allocated for the buffer.
                    audiodata = PsychPortAudio('GetAudioData', pahandleRecord); %calling this automatically clears the buffer (restores the recording capacity)
                    recordedAudio = [recordedAudio audiodata];
                    recordingTimeStamp=GetSecs;
                end
                voiceRecordingStopTime=GetSecs;
                
                
                audiodata = PsychPortAudio('GetAudioData', pahandleRecord);
                recordedAudio = [recordedAudio audiodata];
                % Stop and close the playback device
                PsychPortAudio('Stop', pahandlePlay, 1);
                PsychPortAudio('Close', pahandlePlay);
                % Stop and close the recording device
                PsychPortAudio('Stop', pahandleRecord);
                PsychPortAudio('Close', pahandleRecord);
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%% save the recording %%%%%%%%%%%%%%%%%%%%%%%%
                cd(log.RecordingssaveFolder);
                wavfilename=sprintf('Trial%d_Exp%d_Pair%d.wav',trialNr,Exps,designCB.trials(ii));
                psychwavwrite(transpose(recordedAudio), 44100, 16, wavfilename);
                cd(log.ExperimentFolder);
                clear recordedAudio;
                
                %%%%%%%%%%%%%%%%%%%%%%%% Break if the escape press was pressed %%%%%%%%%%%%%%%%%%%%%%%%
                if log.quitExperiment==1
                    log.end = 'Escape'; % Finished by escape key
                    ListenChar(1);
                    log.ExpNotes = input('Notes:','s');
                    warning('Experiment was terminated by Escapekey');
                    log.end= 'Finished by ESC key';
                    cd(log.IDfolder);
                    save('ExpData_ESC','log');
                    save('Design_ESC', 'designCB');
                    save('PTBData_ESC','PTBSet');
                    save('Simulus_ESC','Stimulus');
                    
                    
                    if ~log.skipEyeTracking
                        Eyelink('StopRecording');
                        Eyelink('CloseFile');
                        WaitSecs(1);
                        cd(log.EyeTrackingFolder);
                        
                        try
                            fprintf('Receiving data file ''%s''\n',  log.edfFile);
                            status=Eyelink('ReceiveFile');
                            Waitsecs(2);
                            if status > 0
                                fprintf('ReceiveFile status %d\n', status);
                            end
                            if 2==exist(log.edfFile, 'file')
                                fprintf('Data file ''%s'' can be found in ''%s''\n',  log.edfFile, pwd );
                            end
                        catch rdf
                            fprintf('Problem receiving data file ''%s''\n', log.edfFile );
                            rdf;
                        end
                    end
                    cd(log.IDfolder);
                    Screen('CloseAll'),sca;
                    return;
                end
            end
        end
    end
    
    
    cont=1;
    
    cd(log.IDfolder);
    save('log','log');
    save('Design', 'designCB')
    save('PTBSet','PTBSet');
    save('Simulus','Stimulus');
    
    if ~log.skipEyeTracking
        Eyelink('StopRecording');
        Eyelink('CloseFile');
        WaitSecs(1);
        cd(log.EyeTrackingFolder);
        
        try
            fprintf('Receiving data file ''%s''\n',  log.edfFile);
            status=Eyelink('ReceiveFile');
            Waitsecs(2);
            if status > 0
                fprintf('ReceiveFile status %d\n', status);
            end
            if 2==exist(log.edfFile, 'file')
                fprintf('Data file ''%s'' can be found in ''%s''\n',  log.edfFile, pwd );
            end
        catch rdf
            fprintf('Problem receiving data file ''%s''\n', log.edfFile );
            rdf;
        end
    end
    cd(log.IDfolder);

    
    while cont==1
        
        %%%%%%%%%%%%%%%%%%%%%%%% Recording for did you notice sth????? %%%%%%%%%%%%%%%%%%%%%%%%
        %     InitializePsychSound;
        % Frequency of the sound.
        freq = 44100;
        % Open PsychPortAudio, details are given before (see line 425)
        pahandleRecord = PsychPortAudio('Open', [], 2, 0, freq, 2);
        allocatedBufferSize=1000; %In seconds
        PsychPortAudio('GetAudioData', pahandleRecord, allocatedBufferSize);
        PsychPortAudio('Start', pahandleRecord, 0, 0, 0);
        recordedAudio = [];
        recordingTimeStamp=GetSecs;
        voiceRecordingStartTime=GetSecs;
        
        %%%%%%%%%%%%%%%%%%%%%%%% Drawing explanation question until a key press %%%%%%%%%%%%%%%%%%%%%%%%
        DrawFormattedText(PTBSet.screenHandle,designCB.Weird,'center','center',PTBSet.fontColor);
        Screen ('Flip', PTBSet.screenHandle);
        WaitSecs (0.1); KbWait(PTBSet.Keys.keyboardNr1);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Check for key presses %%%%%%%%%%%%%%%%%%%%%%%%
        [keyIsDown,t,keyCode]=KbCheck(PTBSet.Keys.keyboardNr1);
        if keyCode(PTBSet.Keys.spaceKey)
            cont=0;
        elseif keyCode(PTBSet.Keys.escapeKey)
            log.quitExperiment=1;
        end
        
        if GetSecs-recordingTimeStamp > allocatedBufferSize/1.5 %This is just an arbitrary, safe location to save the collected audio data. The rule is that it has to be shorter than the 10 seconds allocated for the buffer.
            audiodata = PsychPortAudio('GetAudioData', pahandleRecord); %calling this automatically clears the buffer (restores the recording capacity)
            recordedAudio = [recordedAudio audiodata];
            recordingTimeStamp=GetSecs;
        end
        voiceRecordingStopTime=GetSecs;
        
        
        audiodata = PsychPortAudio('GetAudioData', pahandleRecord);
        recordedAudio = [recordedAudio audiodata];
        % Stop and close the recording device
        PsychPortAudio('Stop', pahandleRecord);
        PsychPortAudio('Close', pahandleRecord);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%% save the recording %%%%%%%%%%%%%%%%%%%%%%%%
        cd(log.RecordingssaveFolder);
        wavfilename=sprintf('Weird.wav');
        psychwavwrite(transpose(recordedAudio), 44100, 16, wavfilename);
        cd(log.ExperimentFolder);
        clear recordedAudio;
        
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%% End of the experiment %%%%%%%%%%%%%%%%%%%%%%%%
    cont=0;
    while cont==0
        DrawFormattedText (PTBSet.screenHandle,designCB.Bye, 'center', 'center', PTBSet.fontColor);
        Screen ('Flip', PTBSet.screenHandle);
        
        [~,~,keyCode]=KbCheck; KbWait;
        if keyCode(PTBSet.Keys.escapeKey)
            cont=1;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% Save all %%%%%%%%%%%%%%%%%%%%%%%%
    % Save in the folder
    cd(log.IDfolder);
    Screen('Flip',PTBSet.screenHandle);
    KbStrokeWait;%;KbStrokeWait;
    
    % PRG ListenChar was 0 - is this correct?
    ListenChar(0); % So that we can use the keyboard again. You'll need to press Ctrl+c if you quit by force or if the script crashes for some reason.
    sca; % This just wraps everything up. It stands for Screen('CloseAll');
    
catch ME
    ShowCursor
    RestrictKeysForKbCheck([]);
    ListenChar(0);  % PRG ListenChar was 0 - is this correct?
    log.end= 'Finished by error';
    save('logERROR','log');
    save('DesignERROR', 'designCB')
    save('PTBSetERROR','PTBSet');
    save('SimulusERROR','Stimulus');
    fprintf('You failed bro:\n');
    rethrow(ME)
    if ~log.skipEyeTracking
        Eyelink('StopRecording');
        Eyelink('CloseFile');
        WaitSecs(2);
    end
    sca;
end
end

