%% Choice Blindness Behavioral Data analysis
% 12.07.2021
clear all; 
DataFolder= '/home/emre/Documents/ChoiceBlindness/Data';
cd(DataFolder);

%% Import and organize data
% We do not import subject 0,2 and 3 because of missing data.
n_subjects      =[4:13];
% Manipulation trials
MTrials         =[7, 10, 14 ,16, 20, 22, 26,29];
SimilarPics     =MTrials(1:4);
DistantPics     =MTrials(5:end);


for ii=1:length(n_subjects)
    %%% Change directory to the subject folder
    if n_subjects(ii)<=9
        cd(sprintf('sub-0%d',n_subjects(ii)));
    else
        cd(sprintf('sub-%d',n_subjects(ii)));
    end
    % load required .mat files
    load('Design.mat');
    load('log.mat');
    
    % pre-allocate
    ExpSeq              =[];          % Sequence of all exp trials
    NonMExpSeq          =[];          % Sequence of non manipulated exp trials
    SeqIMChange         =[];          % Sequence of incongruent manipulation trials
    SeqCMChange         =[];          % Sequence of congruent manipulation trials
    SeqCongChange       =[];          % Sequence of congruent explanation trials
    SeqInCongChange     =[];          % Sequence of incongruent explanation trials
    SeqSimilar          =[];          % Sequence of similar pairs
    SeqDistant          =[];          % Sequence of distant pairs
    
    OrderSimilarMan     =[];          % Order of manipulation trials with similar pairs
    OrderDistantMan     =[];          % Order of manipulation trials with distant pairs
    OrderCogMan         =[];          % Order of manipulation trials with distant pairs
    OrderInCogMan       =[];          % Order of manipulation trials with distant pairs
    
    
    % Getting rid of unwanted zeros in our data
    %(this is bc, all trials were saved even though there were no explanation, change and likert ratings)
    for tmp=1:30
        find( designCB.Explanations== designCB.TrialSeqeunce(tmp));
        if ans>=1
            ExpSeq=cat(2,ExpSeq,tmp);
        end
    end
    
    for tmp=1:30
        find( designCB.AllSelections== designCB.TrialSeqeunce(tmp));
        if ans>=1
            NonMExpSeq=cat(2,NonMExpSeq,tmp);
        end
    end
    
    
    %%% Save all data to a new struct
    Data{ii}.TrialSeqeunce          =designCB.TrialSeqeunce';
    Data{ii}.ExplanationTrials      =designCB.Explanations';
    Data{ii}.leftRight              =designCB.leftRight ;
    Data{ii}.ColorSwap              =designCB.colorswap ;
    Data{ii}.CongruentMTrials       =designCB.Congruent' ;
    Data{ii}.IncongruentMTrials     =designCB.inCongruent' ;
    Data{ii}.CongruentExpTrials     =designCB.CogSelections' ;
    Data{ii}.IncongruentExpTrials   =designCB.InCogSelections';
    Data{ii}.SelectionChange        =log.Data.selectionChanged(ExpSeq)';
    Data{ii}.TrialsRT               =log.Data.trialRTime;
    Data{ii}.ChangeTrialsRT         =log.Data.trialRTime(ExpSeq);
    Data{ii}.ChangeRT               =log.Data.ChangeRTime(ExpSeq);
    Data{ii}.ChangeRTMan            =log.Data.ChangeRTime(MTrials);
    Data{ii}.ChangeRTExp            =log.Data.ChangeRTime(NonMExpSeq);
    Data{ii}.Likert                 =log.Data.Likert(ExpSeq',:);
    Data{ii}.ExplanationSequence    =ExpSeq';
    Data{ii}.edfFile                =log.edfFile;
    Data{ii}.ManipulationOrder      =designCB.TrialSeqeunce(MTrials);
    Data{ii}.ChangeManipulations    =log.Data.selectionChanged(MTrials);
    Data{ii}.ExplanationOrder       =designCB.TrialSeqeunce(NonMExpSeq)';
    Data{ii}.ChangeExplanations     =log.Data.selectionChanged(NonMExpSeq)';
    Data{ii}.ManipulationOrder      =designCB.TrialSeqeunce(MTrials);
    
    
    
    
    %%% Let's find change responses in each participant for each condition
    
    % Change responses in inCongruent manipulation trials
    for tmp= 1:30
        find(designCB.TrialSeqeunce(tmp)==designCB.inCongruent);
        if ans>=1
            SeqIMChange=cat(2,SeqIMChange,tmp);
        end
    end
    Data{ii}.ChangeMInCog    =log.Data.selectionChanged(SeqIMChange)';
    % Reaction Times in inCongruent Manipulations
    Data{ii}.InCogManRT      =log.Data.ChangeRTime(SeqIMChange)';
    
    % Change responses in Congruent manipulation trials
    for tmp= 1:30
        find(designCB.TrialSeqeunce(tmp)==designCB.Congruent);
        if ans>=1
            SeqCMChange=cat(2,SeqCMChange,tmp);
        end
    end
    Data{ii}.ChangeMCog    =log.Data.selectionChanged(SeqCMChange)';
    % Reaction Times in Congruent Manipulations
    Data{ii}.CogManRT      =log.Data.ChangeRTime(SeqCMChange)';
    
    % Change responses in Congruent explanation trials
    for tmp= 1:30
        find(designCB.TrialSeqeunce(tmp)==designCB.CogSelections);
        if ans>=1
            SeqCongChange=cat(2,SeqCongChange,tmp);
        end
    end
    Data{ii}.ChangeExpCog    =log.Data.selectionChanged(SeqCongChange)';
    
    % Change responses in inCongruent explanation trials
    for tmp= 1:30
        find(designCB.TrialSeqeunce(tmp)==designCB.InCogSelections);
        if ans>=1
            SeqInCongChange=cat(2,SeqInCongChange,tmp);
        end
    end
    Data{ii}.ChangeExpInCog    =log.Data.selectionChanged(SeqInCongChange)';
    
    % Change responses in similar pairs
        for tmp=1:30
        find(designCB.TrialSeqeunce(tmp)== SimilarPics);
        if ans>=1
            SeqSimilar= cat(2,SeqSimilar,tmp);
        end
    end
    Data{ii}.ChangeManSimilar     =log.Data.selectionChanged(SeqSimilar)';
    Data{ii}.ChangeSimilarRT      =log.Data.ChangeRTime(SeqSimilar)';
    
        % Change responses in distant pairs
        for tmp=1:30
        find(designCB.TrialSeqeunce(tmp)== DistantPics);
        if ans>=1
            SeqDistant= cat(2,SeqDistant,tmp);
        end
    end
    Data{ii}.ChangeManDistant     =log.Data.selectionChanged(SeqDistant)';
    Data{ii}.ChangeDistantRT      =log.Data.ChangeRTime(SeqDistant)';
    
    
    %%% print the starting condition
    if str2num(log.edfFile(5))==1  && str2num(log.edfFile(7))==1;
        Data{ii}.Condition = "Congruent Similar";
        Data{ii}.StartingCond= 1;
    elseif str2num(log.edfFile(5))==1 && str2num(log.edfFile(7))==0;
        Data{ii}.Condition = "Congruent Distant";
        Data{ii}.StartingCond= 2;
    elseif str2num(log.edfFile(5))==0 && str2num(log.edfFile(7))==1;
        Data{ii}.Condition = "Incongruent Similar";
        Data{ii}.StartingCond= 3;
    else str2num(log.edfFile(5))==0 && str2num(log.edfFile(7))==0;
        Data{ii}.Condition = "Incongruent Distant";
        Data{ii}.StartingCond= 4;
    end
    
    % Let's see the all manipulations in order (similar*congruent etc)
    tempMan= designCB.TrialSeqeunce(MTrials);  %temp value for storing manipulation orders
    %Interaction of manipulations
    Interaction=zeros(8,1);
    % lets assign codes for each condition;
    % Congruent & similar   = 1
    % Congruent % distant   = 2
    % Incongruent % similar = 3
    % Incongruent & distant = 4
    % let's fill the interaction matrix with these values
    
    for tmp=1:4
        if designCB.Congruent(tmp)<20
            Condition(tmp)=1;                % Congruent & similar   = 1
        else
            Condition(tmp)=2;                % Congruent % distant   = 2
        end
        
        if designCB.inCongruent(tmp)<20
            inCondition(tmp)=3;              % Incongruent % similar = 3
        else
            inCondition(tmp)=4;               % Incongruent & distant = 4
        end
    end
    
    
    
    for tmp=1:8
        temp1=find(tempMan(tmp)== designCB.Congruent(:));
        if temp1>=1
            Interaction(tmp)=Condition(temp1);
        end
        temp2=find(tempMan(tmp)== designCB.inCongruent(:));
        if temp2>=1
            Interaction(tmp)=inCondition(temp2);
        end
    end
    Data{ii}.ConditionOrder       =Interaction;
    

    
    %%%% Go back to the meta folder
cd(DataFolder)

end


% clearvars -except Data n_subjects

%%%% combine all participant data in different variables

for i=1:length(n_subjects)
    %%% Reaction times
    %Trials RT
    ReactionTimeTrial(:,i)          =Data{i}.TrialsRT;
    
    % Reation times for change question
    ReactionTimeChTrials(:,i)       =Data{i}.ChangeTrialsRT;
    ReactionTimeChange(:,i)         =Data{i}.ChangeRT;
    ReactionTimeExps(:,i)           =Data{i}.ChangeRTExp;
    ReactionTimeMans(:,i)           =Data{i}.ChangeRTMan;
    ReactionTimeDistant(:,i)        =Data{i}.ChangeDistantRT; 
    ReactionTimeSimilar(:,i)        =Data{i}.ChangeSimilarRT;
    ReactionTimeCogMan (:,i)        =Data{ii}.CogManRT;
    ReactionTimeInCogMan(:,i)       =Data{ii}.InCogManRT;
    
    %%%% Detection rates
    % Overall experiment
    ChangeAll(:,i)                  =Data{i}.SelectionChange;
    
    % All Manipulations
    ChangeManipulations(:,i)        =Data{i}.ChangeManipulations;
    
    % Explanations
    ChangeExplanations(:,i)         =Data{i}.ChangeExplanations;
    
    % Congruent Manipulations
    ChangeCogM(:,i)                 =Data{i}.ChangeMCog;
    
    % Similar Manipulations
    ChangeSimilar(:,i)              =Data{i}.ChangeManSimilar;
    
    % Distant Manipulations 
    ChangeDistant(:,i)              =Data{i}.ChangeManDistant;
   
    % Incongruent Manipulations
    ChangeInCogM(:,i)               =Data{i}.ChangeMInCog;
    
    % Congruent Exp
    ChangeCogExp(:,i)               =Data{i}.ChangeExpCog;
    
    % Incongruent Exp
    ChangeInCogExp(:,i)             =Data{i}.ChangeExpInCog;
    
end

%%%% Mean calc
% Mean detection rates for each participant
ChangeRateAll               =mean(ChangeAll,1);                        %Detection rate of whole experiment
ChangeRateManipulations     =mean(ChangeManipulations,1);              %Detection rate of all manipulations
ChangeRateExplanations      =mean(ChangeExplanations,1);               %Detection rate of all explanations
ChangeRateMCog              =mean(ChangeCogM,1);                       %Detection rate of all congruent manipulations
ChangeRateMInCog            =mean(ChangeInCogM,1);                     %Detection rate of all incongruent manipulations
ChangeRateExpCog            =mean(ChangeCogExp,1);                     %Detection rate of all congruent explanations
ChangeRateExpInCog          =mean(ChangeInCogExp,1);                   %Detection rate of all incgonruent explanations
ChangeRateSimilar           =mean(ChangeSimilar ,1);                %Detection rate of all similar pairs
ChangeRateDistant           =mean(ChangeDistant ,1);                %Detection rate of all distant pairs

% Reaction time mean
MeanTrialRT                 =mean(ReactionTimeTrial,1);                %Mean reaction time of whole experiment
MeanRTofChangeTrials        =mean(ReactionTimeChTrials,1);             %Mean reaction time of change trials
MeanChangeRT                =mean(ReactionTimeChange,1);               %Mean reaction time of change questions
MeanExpChangeRT             =mean(ReactionTimeExps,1);                 %Mean reaction time of change for explanations
MeanManChangeRT             =mean(ReactionTimeMans,1);                 %Mean reaction time of change for manipulations
MeanDistantRT               =mean(ReactionTimeDistant,1);              %Mean reaction time of change for distant pairs
MeanSimilarRT               =mean(ReactionTimeSimilar ,1);             %Mean reaction time of change for similar pairs
CogManRT                    =mean(ReactionTimeCogMan ,1);              % mean reaction time for Congruent manipulations
InCogManRT                  =mean(ReactionTimeInCogMan ,1);            %mean reaction time for Incongruent manipulations


ConditionRTs=[];
for ii=1:length(n_subjects)
    ConditionRTs=cat(2,Data{ii}.ChangeRTMan ,Data{ii}.ConditionOrder);
    ConditionChangeRate= cat(2,Data{ii}.ChangeManipulations' ,Data{ii}.ConditionOrder);
    CS= ConditionRTs(:,2)==1;
    CD= ConditionRTs(:,2)==2;
    IS= ConditionRTs(:,2)==3;
    ID= ConditionRTs(:,2)==4;
    
    Data{ii}.meanCS_rt= mean(ConditionRTs(CS));
    Data{ii}.meanCD_rt= mean(ConditionRTs(CD));
    Data{ii}.meanIS_rt= mean(ConditionRTs(IS));
    Data{ii}.meanID_rt= mean(ConditionRTs(ID));
    
    
    Data{ii}.meanCS_ch= mean(ConditionChangeRate(CS));
    Data{ii}.meanCD_ch= mean(ConditionChangeRate(CD));
    Data{ii}.meanIS_ch= mean(ConditionChangeRate(IS));
    Data{ii}.meanID_ch= mean(ConditionChangeRate(ID));
    
end

clear CS IS CD ID

for i=1:length(n_subjects)
    StartingCond(i) =Data{i}.StartingCond;
    CS_meanCHR(i)   =Data{i}.meanCS_ch;
    CD_meanCHR(i)   =Data{i}.meanCD_ch; 
    IS_meanCHR(i)   =Data{i}.meanIS_ch; 
    ID_meanCHR(i)   =Data{i}.meanID_ch;
    
    CS_meanRT(i)       =Data{i}.meanCS_rt;
    CD_meanRT(i)       =Data{i}.meanCD_rt;
    IS_meanRT(i)       =Data{i}.meanIS_rt;
    ID_meanRT(i)       =Data{i}.meanID_rt;
    
    
end

SPSS=[n_subjects', StartingCond' ChangeRateManipulations' ChangeRateExplanations' ChangeRateExpCog' ChangeRateExpInCog'  ...
      ChangeRateSimilar' ChangeRateDistant' ChangeRateMCog' ChangeRateMInCog' CS_meanCHR' CD_meanCHR' IS_meanCHR' ID_meanCHR' ...
      MeanTrialRT' MeanManChangeRT' MeanExpChangeRT' MeanSimilarRT' MeanDistantRT' CogManRT' InCogManRT' ...
      CS_meanRT' CD_meanRT' IS_meanRT'  ID_meanRT'];

save('BehavData','Data','SPSS');
clear all;
clc;
