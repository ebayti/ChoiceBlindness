function CBPilot();
%%%%%%%%%%%%%%%%%%%%%%%% Set the path for saving purposes later on %%%%%%%%%%%%%%%%%%%%%%%%
cd('/home/sysgen/Documents/Emre/ChoiceBlindness') % Path of the scritps in the lab computer
log.ExperimentFolder=pwd;

% Select langauge
    log.Language= input (' Please select the language of the experiment \n -- 0= Deutsch , 1= English \n:');
   
    if log.Language ==1
    designCB.Welcome= 'Welcome to the "Psychophysical investigations about decision making" Experiment!.\n Please read the instructions carefully .\n \n\n Please press the SPACE key to proceed.';
    designCB.Instruction1= 'During the experiment, you will be presented with a pair of women (not now) pictures for 5 seconds and will be asked some questions. \n Please attend carefully and answer honestly.\n\n Please press the SPACE key to proceed.';
    designCB.Instruction2= 'You will be using the RIGHT ARROW, LEFT ARROW and SPACE keys to answer.\n\n Please press the SPACE key to proceed.';
    designCB.Instruction3= 'Your task is to select the women picture that you like more.\n You will indicate your selection by pressing one of the arrow keys.\n\n Please press the SPACE key to proceed.';
    designCB.Trial='Which men picture did you find more attractive? \n Please press the LEFT ARROW key to indicate that you like the picture on the left, \n or press the RIGHT ARROW key to indicate that you like the picture on the right';
    designCB.Instruction4= 'Please press the LEFT ARROW key to indicate that you like the picture on the left, \n or press the RIGHT ARROW key to indicate that you like the picture on the right.\n After you have made your selection, in some trials you will be asked some question about your decision. \n You need to answer these question verbally and your answers will be recorded.\n\n Please press the SPACE key to proceed.';
    designCB.StartExp= 'The experiment will start after this page. \n\n Please press the SPACE key to start the experiment.';
    designCB.Starting='Pilot run is starting...';
    designCB.Ready='Get ready!';
    designCB.change= 'Press the SPACE key to proceed with this picture, \n press one of the ARROW keys to change your selection.';
    designCB.Explanation1= 'How attractive is he compared to the other one? \n press the SPACE key when you are done.';
    designCB.Explanation2= 'How confident are you in your selection?  press the SPACE key when you are done.';
    designCB.Explanation3= 'Explain the reasons of your decision.\n\n  press the SPACE key to proceed after you explained yourself.';
    designCB.Bye='End of the Pilot run. \n\n Now the actual experiment will start';
elseif log.Language == 0
    designCB.Welcome= 'Willkommen zum Experiment "Psychophysikalische Untersuchungen zur Entscheidungsfindung"! \n Bitte lesen Sie die Anweisungen sorgfältig durch. \n \n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction1= 'Während des Experiments werden Ihnen für 5 Sekunden ein Bilderpaar von Personen präsentiert und einige Fragen gestellt. \n \n Bitte hören Sie aufmerksam zu und antworten Sie ehrlich.\n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction2= 'Sie werden die Tasten PFEIL RECHTS, PFEIL LINKS und LEERTASTE verwenden, um zu antworten.\n\n Bitte drücken Sie die LEERTASTE, um fortzufahren.';
    designCB.Instruction3= 'Ihre Aufgabe ist es, die Person auszuwählen, das Ihnen am besten gefällt.\n Sie zeigen Ihre Auswahl durch Drücken einer der Pfeiltasten an.\n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction4= 'Bitte drücken Sie die PFEILTASTE LINKS, um anzuzeigen, dass Ihnen das Bild links besser gefällt, \n oder drücken Sie die PFEILTASTE RECHTS, um anzuzeigen, dass Ihnen das Bild rechts besser gefällt.\n \n Nachdem Sie Ihre Auswahl getroffen haben, werden Ihnen in einigen Versuchen Fragen zu Ihrer Entscheidung gestellt. \n Sie müssen diese Fragen mündlich beantworten und Ihre Antworten werden aufgezeichnet.\n\n Bitte drücken Sie die LEERTASTE, um fortzufahren.'; 
    designCB.Trial='Welche Person fanden Sie attraktiver? \n Bitte drücken Sie die PFEILTASTE LINKS, um anzuzeigen, dass Ihnen das Bild links gefällt, \n oder drücken Sie die PFEILTASTE RECHTS, um anzuzeigen, dass Ihnen das Bild rechts gefällt';
    designCB.StartExp= 'Das Experiment wird nach dieser Seite gestartet. \n\n Bitte drücken Sie die Leertaste, um das Experiment zu starten.';
    designCB.Starting='Der Probelauf beginnt...';
    designCB.Ready='Machen Sie sich bereit!';
    designCB.change= 'Sie haben dieses Bild ausgewählt. Möchten Sie Ihre Auswahl ändern? \n \n Bitte drücken Sie die LEERTASTE, um mit diesem Bild fortzufahren, oder drücken Sie eine der PFEILTASTEN, um Ihre Auswahl zu ändern. ';
    designCB.Explanation1= 'Wie attraktiv ist er? \n Nachdem Sie fertig sind, drücken Sie die Leertaste.';
    designCB.Explanation2= 'Wie sicher sind Sie in Ihrer Auswahl? Drücken Sie die Leertaste, wenn Sie fertig sind.';
    designCB.Explanation3= 'Bitte erläutern Sie verbal den Grund Ihrer Entscheidung.\n\n Bitte drücken Sie die Leertaste, um fortzufahren, nachdem Sie sich erklärt haben.';
    designCB.Bye='Ende der Probelauf. \n Nun beginnt das eigentliche Experiment.';
end
    
     %%%%%%%%%%%%%%%%%%%%%%%% Call the essential setting functions %%%%%%%%%%%%%%%%%%%%%%%%
    % Call PTB settings from the ChoiceBlindnessPTBSettings.m file
    PTBSet= ChoiceBlindnessPTBSettings();
    designCB.distanceOfPicturesFromCenter=200;
      
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
    backgroundColor = [0.5 0.5 0.5];1
    %%%%%%%%%%%%%%%%%%%%%%%% Calling arrow drawing functions %%%%%%%%%%%%%%%%%%%%%%%%
    [arrowTex, arrowTexRot] = ptbDrawArrowModRot(PTBSet.screenHandle , arrowLength, arrowWidth, headfootRatio, footWidth, arrowColor, backgroundColor);
    
    %%%%%%%%%%%%%%%%%%%%%%%% Print info for the experimenter %%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('Pilot run');
    
    %%%%%%%%%%%%%%%%%%%%%%%% Retrieving colors for the alpha channel %%%%%%%%%%%%%%%%%%%%%%%%
    Stimulus.colorLeft=(sprintf('%s//Pictures//SHINEd_Blueish.png',PTBSet.expPath));
    Stimulus.colorRight=(sprintf('%s//Pictures//SHINEd_Redish.png',PTBSet.expPath));
    % Stimulus.BetweenTrialsPath=(sprintf('%s//Pictures//BetweenTrials.png',PTBSet.expPath)); % Or BetweenTrialsGray.png
    
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
    
    
%% Initiate the experiment loop
try
    % Instructions
    %%%%%%%%%%%%%%%%%%%%%%%% Display the instructions that are stored in the ChoiceBlindnessDesign.m file %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%% Restrict all keys except the Space Key during instructions %%%%%%%%%%%%%%%%%%%%%%%%
    RestrictKeysForKbCheck([PTBSet.Keys.spaceKey]);
    ListenChar(2);
    
    DrawFormattedText (PTBSet.screenHandle, designCB.Welcome, 'center', 'center',PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    KbWait(PTBSet.Keys.keyboardNr2);
    
    DrawFormattedText (PTBSet.screenHandle,designCB.Instruction1, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5); KbWait;
    
    DrawFormattedText (PTBSet.screenHandle,designCB.Instruction2, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5); KbWait;
    
    DrawFormattedText (PTBSet.screenHandle,designCB.Instruction3, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5);KbWait;
    
    DrawFormattedText (PTBSet.screenHandle,designCB.Instruction4, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5);KbWait;
    
    DrawFormattedText (PTBSet.screenHandle,designCB.StartExp, 'center', 'center', PTBSet.fontColor);
    Screen ('Flip', PTBSet.screenHandle);
    WaitSecs (0.5);KbWait;
    
    
    %% Add them into designCB file so you can translate it....
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
    for ii=1:3 % only 2 trials
        
        %%%%%%%%%%%%%%%%%%%%%%%% Retrieving pictures from the specified path %%%%%%%%%%%%%%%%%%%%%%%%
        % All the picture names are hardcoded as the pairs are fixed but the order of trials can be randomized.
        % Even the picture names are specificied as "left" and "right", this does not specify their presentation location during the experiment
        % designCB.LeftRigth variable will determine the location of the pictures. If it is equal to 0, picture location will be swapped.
        % That is to say, right picture will be displayed on the left if designCB.LeftRight== 0;
        
        Stimulus.pathStringLeft=sprintf('%s//Pilots//leftPilot-%d.jpg',PTBSet.expPath,ii);
        Stimulus.pathStringRight=sprintf('%s//Pilots//rightPilot-%d.jpg',PTBSet.expPath,ii);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Reading the called images and saving them to a variable %%%%%%%%%%%%%%%%%%%%%%%%
        
        % Left
        Stimulus.respondPicLeft=imread(Stimulus.pathStringLeft);
        Stimulus.leftPic=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.respondPicLeft);
        [Stimulus.ySizeLeft,Stimulus.xSizeLeft,~]=size(Stimulus.respondPicLeft);
        
        % Right
        Stimulus.respondPicRight=imread(Stimulus.pathStringRight);
        Stimulus.rightPic=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.respondPicRight);
        [Stimulus.ySizeRight,Stimulus.xSizeRight,~]=size(Stimulus.respondPicRight);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%% Display locations of the colors %%%%%%%%%%%%%%%%%%%%%%%%
        % designCB.colorswap has the same rationale as designCB.LeftRight
        % If designCB.colorswap == 0, presentation locations of the colors on the top of picutres are swapped.
        
        % blue
        [img1, ~, alpha] = imread(Stimulus.colorLeft);
        img1(:, :, 4)= alpha;
        Stimulus.BlueMask = Screen('MakeTexture', PTBSet.screenHandle, img1);
        % red
        [img2, ~, alpha] = imread(Stimulus.colorRight);
        img2(:, :, 4)= alpha;
        Stimulus.RedMask = Screen('MakeTexture', PTBSet.screenHandle , img2);
        
                %%%%%%%%%%%%%%%%%%%%%%% White Patches between Trials %%%%%%%%%%%%%%%%%%%%%%%
%         Stimulus.BtwTMx= imread(Stimulus.BetweenTrialsPath);
%         Stimulus.BetweenTrials=Screen('MakeTexture',PTBSet.screenHandle,Stimulus.BtwTMx);
%         
        
        
        %%%%%%%%%%%%%%%%%%%%%%%% Setting the locations of all drawings %%%%%%%%%%%%%%%%%%%%%%%%
        % these values are in pixels, we need to convert them to visual degress
        Stimulus.leftLocation=CenterRectOnPoint([0 0 Stimulus.xSizeLeft/5 Stimulus.ySizeLeft/5],PTBSet.xCenter-designCB.distanceOfPicturesFromCenter-10,PTBSet.yCenter-100);
        Stimulus.rightLocation=CenterRectOnPoint([0 0 Stimulus.xSizeLeft/5 Stimulus.ySizeLeft/5],PTBSet.xCenter+designCB.distanceOfPicturesFromCenter+90,PTBSet.yCenter-100);
        Stimulus.blueMaskLoc=CenterRectOnPoint([0 0 Stimulus.xSizeLeft/5 Stimulus.ySizeLeft/5],PTBSet.xCenter-designCB.distanceOfPicturesFromCenter-10,PTBSet.yCenter-100);
        Stimulus.redMaskLoc=CenterRectOnPoint([0 0 Stimulus.xSizeLeft/5 Stimulus.ySizeLeft/5],PTBSet.xCenter+designCB.distanceOfPicturesFromCenter+90,PTBSet.yCenter-100);
        Stimulus.explanationLoc= (Stimulus.leftLocation+Stimulus.rightLocation)/2;
        Stimulus.arrowLocationLeft= CenterRectOnPoint([0 0 Stimulus.xSizeLeft/10 Stimulus.ySizeLeft/15],PTBSet.xCenter-designCB.distanceOfPicturesFromCenter-50,PTBSet.yCenter+150);
        Stimulus.arrowLocationRight= CenterRectOnPoint([0 0 Stimulus.xSizeLeft/10 Stimulus.ySizeLeft/15],PTBSet.xCenter+designCB.distanceOfPicturesFromCenter+130,PTBSet.yCenter+150);
        
        %%%%%%%%%%%%%%%%%%%%%%%% Change key restrictions (add arrow and escape keys) %%%%%%%%%%%%%%%%%%%%%%%%
        RestrictKeysForKbCheck([PTBSet.Keys.escapeKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey]); % This means PTB will only look for these keypresses. RestrictKeysForKbCheck([]) if you want to allow everything.
        
        
            % Draw the fixation cross in white, set it to the center of our screen and
            % set good quality antialiasing
%             Screen('DrawLines', PTBSet.screenHandle, allCoords,lineWidthPix, 0, [PTBSet.xCenter PTBSet.yCenter], 2);
%             Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BetweenTrials,[],Stimulus.leftLocation);
%             Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BetweenTrials,[],Stimulus.rightLocation);
%             Screen('DrawTexture',PTBSet.screenHandle,arrowTex,[],Stimulus.arrowLocationLeft)
%             Screen('DrawTexture',PTBSet.screenHandle,arrowTexRot,[],Stimulus.arrowLocationRight)
%             Screen('Flip',PTBSet.screenHandle);
%             WaitSecs(2);
        
        choiceStartTime=GetSecs; % we will use this value for determining the drawing time of pictures
        
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
            DrawFormattedText (PTBSet.screenHandle,designCB.Trial , 'center', PTBSet.yCenter+250, PTBSet.fontColor);
            Screen('DrawTexture',PTBSet.screenHandle,arrowTex,[],Stimulus.arrowLocationLeft)
            Screen('DrawTexture',PTBSet.screenHandle,arrowTexRot,[],Stimulus.arrowLocationRight)
            Screen('Flip',PTBSet.screenHandle);
            
            
            [~,~,keyCode]=KbCheck;
            if keyCode(PTBSet.Keys.leftKey) | keyCode(PTBSet.Keys.rightKey) | keyCode(PTBSet.Keys.escapeKey)
                cont=0;
                if keyCode(PTBSet.Keys.leftKey)
                    log.Data.pressedKey(ii)=1;
                elseif keyCode(PTBSet.Keys.rightKey)
                    log.Data.pressedKey(ii)=2;
                elseif keyCode(PTBSet.Keys.escapeKey)
                    log.quitExperiment=1;
                end
            end
        end
        choiceStopTime=GetSecs;
        
        Screen('Flip',PTBSet.screenHandle);
        WaitSecs(1);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Option to change answer %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        changeSelection=1; % loop variable to ask for answer change
        RestrictKeysForKbCheck([PTBSet.Keys.escapeKey PTBSet.Keys.spaceKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey PTBSet.Keys.downKey PTBSet.Keys.upKey]);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Present the previously selected picture %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        while changeSelection==1
            if log.Data.pressedKey(ii)==1 %if the left key is pressed
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
            elseif log.Data.pressedKey(ii)==2 % if the right key is pressed
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%% Drawing the question - until a key press has been executed %%%%%%%%%%%%%%%%%%%%%%%%
        DrawFormattedText (PTBSet.screenHandle,designCB.change , 'center', PTBSet.yCenter+200, PTBSet.fontColor);
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
        choiceStopTime=GetSecs;
        
        %%%%%%%%%%%%%%%%%%%%%%%% Save responses in the Data struct %%%%%%%%%%%%%%%%%%%%%%%%
        
        Screen('Flip',PTBSet.screenHandle); % Empty screen
        WaitSecs(1)
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Explanations %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        confabs={designCB.Explanation1, designCB.Explanation2, designCB.Explanation3};
        
        for Exps=1:3
            %%%%%%%%%%%%%%%%%%%%%%%% Change key restrictions (add arrow and escape keys) %%%%%%%%%%%%%%%%%%%%%%%%
              RestrictKeysForKbCheck([PTBSet.Keys.spaceKey PTBSet.Keys.escapeKey PTBSet.Keys.leftKey PTBSet.Keys.rightKey]); % This means PTB will only look for these keypresses.
            
           click = 0;
                t1 = GetSecs;
                
                respRange = linspace(possibleMoveSpace(1), possibleMoveSpace(3), nLikertRange);
                tmpPoint = 5;
                
                while ~click
                
                %%%%%%%%%%%%%%%%%%%%%%%% Draw pictures according to participant responses %%%%%%%%%%%%%%%%%%%%%%%%
                
                if log.Data.selectionChanged (ii) == 1 % if selection was not changed during previous question
                    if log.Data.pressedKey(ii) ==2 % if the picture on the right was selected at last
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    elseif log.Data.pressedKey(ii)==1 % if the picture on the left was selected at last
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    end
      
                elseif log.Data.selectionChanged(ii)==0
                    if log.Data.pressedKey(ii)==1
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.leftPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.BlueMask,[],Stimulus.explanationLoc);
                    elseif log.Data.pressedKey(ii)==2
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.rightPic,[],Stimulus.explanationLoc);
                        Screen('DrawTexture',PTBSet.screenHandle,Stimulus.RedMask,[],Stimulus.explanationLoc);
                    end
                    end
                    
                    
                    DrawFormattedText (PTBSet.screenHandle,confabs{Exps} , 'center', PTBSet.yCenter+200, PTBSet.fontColor);
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
                                resp_for_show = (strcat([ 'Confidence: ' num2str(likert(tmpPoint)) ]));
                            end
                        else
                            if Exps==1
                                resp_for_show = (strcat([ 'Attraktivität: ' num2str(likert(tmpPoint)) ]));
                            else
                                resp_for_show = (strcat([ 'Zuversicht: ' num2str(likert(tmpPoint)) ]));
                            end
                        end
                        
                        Screen('DrawText', PTBSet.screenHandle, resp_for_show  ,cp(1)-100 , cp(2)+250 );
                        
                        % Screen('TextSize',PTBSet.screenHandle,40);
                        Screen('DrawText', PTBSet.screenHandle, '-4'  ,respRange(1)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-3'  ,respRange(2)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-2'  ,respRange(3)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '-1'  ,respRange(4)-20, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '0'  ,respRange(5)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '1'  ,respRange(6)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '2'  ,respRange(7)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '3'  ,respRange(8)-15, cp(2)+380 );
                        Screen('DrawText', PTBSet.screenHandle, '4'  ,respRange(9)-15, cp(2)+380 );
                        
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
                    
                    %%%%%%%%%%%%%%%%%%%%%%%% Break if the escape press was pressed %%%%%%%%%%%%%%%%%%%%%%%%
                end
            end

        
        %%%%%%%%%%%%%%%%%%%%%%%% End of the experiment %%%%%%%%%%%%%%%%%%%%%%%%
        cont=0; 
        while cont==0
            DrawFormattedText (PTBSet.screenHandle,designCB.Bye, 'center', 'center', PTBSet.fontColor);
            Screen ('Flip', PTBSet.screenHandle);
            WaitSecs(0.5);
            
            [~,~,keyCode]=KbCheck; KbWait;
            if keyCode(PTBSet.Keys.escapeKey)
                cont=1;
                ListenChar(0)
            end
        end
      
      sprintf('Success')
   
catch ME
    sca;
    ShowCursor
    RestrictKeysForKbCheck([]);
    ListenChar(0);
    fprintf('You failed bro:\n');
    rethrow(ME)  
end

sca; return;
end

