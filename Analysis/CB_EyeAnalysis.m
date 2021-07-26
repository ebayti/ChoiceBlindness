%% Choice Blindness Eye Data analysis
% 22.07.2021
clear all; clc;

%%%%TO DO: calculate pupil size for each cond (CS,CD,IS,ID)

DataFolder= '/home/emre/Documents/ChoiceBlindness/Data';
cd(DataFolder);
% this came from the behavioral data script. We will use some variables from the 'Data' Struct
load BehavData.mat
%% Import and organize data
% We are skipping sub-00, sub-01, sub-02, sub-03 and sub-14
% subject 0, 1 and 14 knew choice blindness, the other 2 subjects' data were lost.
% n_subjects= 0:14;
n_subjects= 4:13;
MTrials                 = [7, 10, 14 ,16, 20, 22, 26,29];
SimilarPics     =MTrials(1:4);
DistantPics     =MTrials(5:end);

for ii=1:length(n_subjects)
    %%% Go to the directory and get the name of the .asc file
    % .asc file name will be held in the 'asciiFile.name' struct
    if n_subjects(ii)<=9
        cd(sprintf('sub-0%d/eyetrack',n_subjects(ii)));
        asciiFile = dir(fullfile(pwd,strcat('*.','asc')));
    else
        cd(sprintf('sub-%d/eyetrack',n_subjects(ii)));
        asciiFile = dir(fullfile(pwd,strcat('*.','asc')));
    end
    
    %%%% after getting the file name, we can open the file for reading / read access
    % FID = fopen(FILENAME) opens the file for read access.
    fid=fopen(asciiFile.name);
    %%%% Now let's read it with the fread function, but this will be
    %A = fread(FID) reads binary data from the specified file and writes it into matrix A
    % fread(FID,SIZE,PRECISION)
    % FID= our file
    % inf = infinite
    % char=>char = read as an character and output as a character
    % this allText variable size will be around 30000000x1 matrix, so we need to work
    % on it a bit more to make it "readable"
    allText= fread(fid, inf, 'char=>char');
    %%%% close the file
    fclose(fid);
    
    % remove carriage return if there are any
    allText(allText==uint8(sprintf('\r'))) = [];
    
    %%%% arrange the allText var with tokenize func
    % tokenize cuts a string into pieces, returning the pieces in a cell-array
    allText = tokenize(allText, uint8(newline));
    
    
    %%% preallocate the required variables
    TrialStartloc           = []; % first line of the trial in the ascii file
    TrialEndloc             = []; % last line of the trial in the ascii file
    TrialLocInfo            = []; % first row = Trial, second row= picture pair
    TrialLocations          = []; % Start and End of trials (Start and End concatenated version)
    TrialNum                = []; % counting variable for trials
    
    ChangeStartloc          = []; % first line of the change trial in the ascii file
    ChangeEndloc            = []; % last line of the change trial in the ascii file
    ChangeLocInfo           = []; % first row = Trial, second row= picture pair
    ChangeLocations         = []; % concatenated version of start and end locations
    ChgNum                  = 0;  % counting variable for change trials
    
    
    % logical variables for finding sequence of their order
    ExpTrials               = []; % explanations
    CongExp                 = []; % congruent explanations
    IncongExp               = [];
    ManTrials               = [];
    congM                   = [];
    IncongM                 = [];
    
    
    
    % Sequence variables
    SeqAllExps              = []; % all explanation sequence (1:16)
    SeqExps                 = []; % explanation trials without manipulation
    SeqMans                 = []; % order of manipulation trials within the explanations
    SeqCongMChange          = []; % Congruent manipulation order
    SeqIncongMChange        = []; % Incongruent manipulation order
    SeqInExpChange          = []; % Incongruent explanation order
    SeqCogExpChange         = []; % Congruent  explanation order
    SeqCS                   = []; % Congruent Similar manipulation order
    SeqCD                   = []; % Congruent Distant manipulation order
    SeqIS                   = []; % Incongruent Similar manipulation order
    SeqID                   = []; % Incongruent Distant manipulation order
    
    
    %% convert and analyze the text file line by line
    for i=1:numel(allText)
        
        % now, we will work line by line
        tline=allText{i};
        
        %%%%%%% Modify here according to your triggers
        
        %Trials
        if regexp(tline, 'Presented pair is')
            % Location of the change trial start trigger
            TrialStartloc=cat(1,TrialStartloc, i);
            TrialNum= TrialNum+1;
            % first number -->  Trial Nr
            % second number --> Picture Pair
            TrialLocInfo(TrialNum,:)=cat(2, TrialNum,  str2double(allText{i}(end-1:end)));
        end
        
        if regexp(tline, 'End of TRIAL')
            % location of the end of change trial trigger
            TrialEndloc=cat(1,TrialEndloc, i);
        end
        
        
        % Change trials (Manipulation + Explanations)
        if regexp(tline, 'Change question at trial')
            % Location of the change trial start trigger
            ChangeStartloc=cat(1,ChangeStartloc, i);
            ChgNum= ChgNum+1;
            % first number -->  Trial Nr for the Change question
            % second number --> Picture Pair
            if  str2double(allText{i+1}(end-1:end)) ~= 0
                ChangeLocInfo(ChgNum,:)=cat(2, str2double(allText{i}(end-1:end)),  str2double(allText{i+1}(end-1:end)));
            else
                ChangeLocInfo(ChgNum,:)=cat(2, str2double(allText{i}(end-1:end)),  str2double(allText{i+2}(end-1:end)));
            end
        end
        
        if regexp(tline, 'End of change question at')
            % location of the end of change trial trigger
            ChangeEndloc=cat(1,ChangeEndloc, i);
        end
    end
    
    % save locations in one var
    TrialLocations     = cat(2,TrialStartloc,TrialEndloc); %concatenate start and finish
    ChangeLocations    = cat(2,ChangeStartloc,ChangeEndloc); %concatenate start and finish
    %% Get all condition sequences
    
    %%%%%%%%% Explanations
    % Location/order of all explanation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        ExpTrials= find(Data{ii}.ExplanationTrials == ChangeLocInfo (CondFind,2));
        if ExpTrials
            SeqAllExps= cat(2,SeqAllExps,CondFind);
        end
    end
    
    % Location/order of Congruent explanation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        CongExp= find(Data{ii}.CongruentExpTrials == ChangeLocInfo (CondFind,2));
        if CongExp
            SeqCogExpChange= cat(2,SeqCogExpChange,CondFind);
        end
    end
    
    % Location/order of Incongruent explanation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        IncongExp= find(Data{ii}.IncongruentExpTrials == ChangeLocInfo (CondFind,2));
        if IncongExp
            SeqInExpChange= cat(2,SeqInExpChange,CondFind);
        end
    end
    
    %%%%%%% Manipulations
    
    % Location/order of all manipulation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        ManTrials= find(MTrials == ChangeLocInfo (CondFind,2));
        if ManTrials
            SeqMans= cat(2,SeqMans,CondFind);
        end
    end
    
    % Location/order of Congruent manipulation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        congM= find(Data{ii}.CongruentMTrials == ChangeLocInfo (CondFind,2));
        if congM
            SeqCongMChange= cat(2,SeqCongMChange,CondFind);
        end
    end
    
    % Location/order of Incongruent manipulation trials
    for CondFind= 1:size(ChangeLocInfo,1)
        IncongM= find(Data{ii}.IncongruentMTrials == ChangeLocInfo (CondFind,2));
        if IncongM
            SeqIncongMChange= cat(2,SeqIncongMChange,CondFind);
        end
    end
    
    % get the only explanation trials
    SeqExps            = setdiff(SeqAllExps,SeqMans); % get explanation trials without manipulation
    
    % save these guys for each participant
    EyeData{ii}.TrialLocations     = TrialLocations;
    EyeData{ii}.ChangeLocations    = ChangeLocations;
    EyeData{ii}.ChangePairInfo     = ChangeLocInfo;
    EyeData{ii}.TrialPairInfo      = TrialLocInfo;
    EyeData{ii}.CongManSeq         = SeqCongMChange;
    EyeData{ii}.InCongManSeq       = SeqIncongMChange;
    EyeData{ii}.ExplanationSeq     = SeqExps;
    EyeData{ii}.ManipulationSeq    = SeqMans;
    EyeData{ii}.IncongExpSeq       = SeqInExpChange;
    EyeData{ii}.CongExpSeq         = SeqCogExpChange;
    
    %%  Now, time to search every line for each trial
    for hk = 1: size(TrialLocations,1)
        
        % Set EyeDataDuringTrials and TrRow variables as empty to prevent
        % accumlation of all trials into them.
        EyeDataDuringTrials     = [];
        TrRow                   = 0;
        
        % create a temp variable for each line, so we can organize our data line by line
        for loopVar = TrialLocations(hk,1)+1:TrialLocations(hk,2)-1
            tempTr= allText{loopVar};
            
            if  numel(tempTr) && any(tempTr(1)=='0':'9')
                tempTr = strrep(tempTr, ' . ', ' NaN ');        % replace missing values
                tmpNumTr     = sscanf(tempTr, '%f');              % vectorize the string, create a n element vector containing numerical values
                prealocN    = numel(tmpNumTr);                   % get the size for preallocation
                TrRow = TrRow +1;
                
                % Let's get the trial durations. We already have this info  in Data.TrialsRT, but why not double check
                if loopVar== TrialLocations(hk,1)+1
                    TrStart= tmpNumTr(1);
                elseif loopVar== TrialLocations(hk,2)-1
                    TrEnd=tmpNumTr(1);
                end
                EyeDataDuringTrials(1:prealocN,TrRow )= tmpNumTr;
            end
            
        end
        EyeData{ii}.TrialPupilSize(:,hk)=mean(EyeDataDuringTrials(4,:),2);
        EyeData{ii}.TrialDuration(:,hk)= TrEnd-TrStart;
    end
    
    % Same rules for Change trials
    
    
    ExpSaveRow                 = 0;  % Counting variable for saving explanation trials
    ManSaveRow                 = 0;  % Counting variable for saving manipulation trials
    CogExpRow                  = 0;  % Counting variable for saving congruent explanations
    InCogExpRow                = 0;  % Counting variable for saving incongruent explanations
    InCogMRow                  = 0;  % Counting variable for saving incongruent manipulations
    CogMRow                    = 0;  % Counting variable for saving congruent manipulations
    
    
    for jk = 1:size(ChangeLocations,1)
        
        % We should clear the EyeDataDuringChange and all respective variables
        % before the loop below to not conatenate all change trials
        EyeDataDuringChange        = [];
        CongManEye                 = [];
        InCongManEye               = [];
        CongExp                    = [];
        InCongExp                  = [];
        Manipulations              = [];
        Explanations               = [];
        
        % Counting variables
        ChgRow                     = 0;  % Counting variable for change trials
        CmRow                      = 0;  % Counting variable Congruent manipulation trials
        ImRow                      = 0;  % Counting variable Icongruent manipulation trials
        IeRow                      = 0;  % Counting variable Incongruent explanation trials
        CeRow                      = 0;  % Counting variable Congruent explanation trials
        ExpsRow                    = 0;  % Counting variable for explanation trials
        MansRow                    = 0;  % Counting variable for manipulation trials
        CSRow                      = 0;  % Counting variable for Congurent Similar manipulations
        CDRow                      = 0;  % Counting variable for Congruent Distant manipulations
        ISRow                      = 0;  % Counting variable for Incongruent Similar manipulations
        IDRow                      = 0;  % Counting variable for Incongruent Distant manipulations
        
        for iii= ChangeLocations(jk,1)+2:ChangeLocations(jk,2)-1
            tempChg= allText{iii};
            
            if  numel(tempChg) && any(tempChg(1)=='0':'9')
                tempChg = strrep(tempChg, ' . ', ' NaN ');        % replace missing values
                tmpNumChg     = sscanf(tempChg, '%f');              % vectorize the string, create a n element vector containing numerical values
                prealocN    = numel(tmpNumChg);                   % get the size for preallocation
                ChgRow= ChgRow+1;
                
                if iii== ChangeLocations(jk,1)+2
                    ChgStart= tmpNumChg(1);
                elseif iii == ChangeLocations(jk,2)-1
                    ChgEnd=tmpNumChg(1);
                end
                EyeDataDuringChange(1:prealocN,ChgRow)= tmpNumChg;
            end
            
            %%%% Get each condition separately...
            % Manipulations (Congruent / Incongruent)
            if any(SeqCongMChange==jk)
                CmRow= CmRow+1;
                CongManEye(1:prealocN,CmRow)= tmpNumChg;
            elseif any(SeqIncongMChange==jk)
                ImRow= ImRow+1;
                InCongManEye(1:prealocN,ImRow)= tmpNumChg;
            end
            
            % Explanations (Congruent / Incongruent) -non manipulated selections
            if any(SeqCogExpChange==jk)
                CeRow= CeRow+1;
                CongExp(1:prealocN,CeRow)= tmpNumChg;
            end
            if any(SeqInExpChange==jk)
                IeRow= IeRow+1;
                InCongExp(1:prealocN,IeRow)= tmpNumChg;
            end
            
            % for combined explanations or manipulations regardless of the condition
            if any(SeqExps ==jk)
                ExpsRow=ExpsRow+1;
                Explanations(1:prealocN,ExpsRow)= tmpNumChg;
            end
            if any(SeqMans==jk)
                MansRow= MansRow+1;
                Manipulations(1:prealocN,MansRow)= tmpNumChg;
            end
        end
        
        EyeData{ii}.ChangeDuration(:,jk)= ChgEnd-ChgStart;
        
        
        %%%%%% Mean pupil sizes  %%%%%
        
        % for each change trial
        EyeData{ii}.ChangePupilSize(:,jk)=mean(EyeDataDuringChange(4,:),2);
        
        %%%% Manipulations
        % Overall manipulations
        if any(SeqMans==jk)
            ManSaveRow= ManSaveRow+1;
            EyeData{ii}.ManipulationsPupilSize(:,ManSaveRow)= mean(Manipulations(4,:),2);
        end
        
        % Congruent manipulation trials
        if any(SeqCongMChange==jk)
            CogMRow= CogMRow+1;
            EyeData{ii}.CongManPupilSize(:,CogMRow)= mean(CongManEye(4,:),2);
        end
        
        % Incongruent manipulation trials
        if any(SeqIncongMChange==jk)
            InCogMRow= InCogMRow+1;
            EyeData{ii}.InCongManPupilSize(:,InCogMRow)= mean(InCongManEye(4,:),2);
        end
        
        
        %%%% Explanations
        % Overall explanation trials
        if any(SeqExps==jk)
            ExpSaveRow= ExpSaveRow+1;
            EyeData{ii}.ExplanationsPupilSize(:,ExpSaveRow)= mean(Explanations(4,:),2);
        end
        
        SeqAllExps= cat(2,SeqAllExps,CondFind);
        
        % Congruent explanation trials
        if any(SeqCogExpChange==jk)
            CogExpRow = CogExpRow +1;
            EyeData{ii}.CongExpPupilSize(:,CogExpRow)= mean(CongExp(4,:),2);
        end
        
        % Incongruent explanation trials
        if any(SeqInExpChange==jk)
            InCogExpRow= InCogExpRow+1;
            EyeData{ii}.InCongExpPupilSize(:,InCogExpRow)= mean(InCongExp(4,:),2);
        end
        
        
    end
    
    % total mean :D
    %Exps
    EyeData{ii}.MeanPS_Exp            = mean(EyeData{ii}.ExplanationsPupilSize,2);
    EyeData{ii}.MeanPS_ICExp          = mean(EyeData{ii}.InCongExpPupilSize,2);
    EyeData{ii}.MeanPS_CExp           = mean(EyeData{ii}.CongExpPupilSize,2);  
    
    %Manipulations
    EyeData{ii}.MeanPS_Man            = mean(EyeData{ii}.ManipulationsPupilSize,2);
    EyeData{ii}.MeanPS_ICMan          = mean(EyeData{ii}.InCongManPupilSize,2);
    EyeData{ii}.MeanPS_CMan           = mean(EyeData{ii}.CongManPupilSize,2);
         
    
    cd(DataFolder);
    
end
