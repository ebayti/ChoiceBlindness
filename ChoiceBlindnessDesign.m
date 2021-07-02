function [designCB]= ChoiceBlindnessDesign(log)

% Create required variables for setting the experimental sequence
% The whole experiment consists of 30 trials
designCB.trials = 1:30;

% design.Mtrials are the ones where we apply manipulation
designCB.Mtrials= [7, 10, 14 ,16, 20, 22, 26,29];
% This is a temp variable that I will use later on
temp= [10, 14 ,16, 20, 22, 26,29];

% Pairs that have similar attractiveness scores 
designCB.similars= [7, 10, 14 ,16];
% Pairs that have distant attractiveness scores 
designCB.distants= [20, 22, 26, 29];

% with the probability of 0.5, each piture can be located either on left or
% right, as well as the transparent color on the top of it.
designCB.leftRight=binornd(1,0.5,length(designCB.trials),1);
designCB.colorswap=binornd(1,0.5,length(designCB.trials),1);

%% Trial randomization
% The set of normal pictures
designCB.nonMtrials = setdiff(designCB.trials, designCB.Mtrials);
% Write into Pictures the normal pictures in a random order
designCB.trials(designCB.nonMtrials) = designCB.nonMtrials(randperm(numel(designCB.nonMtrials)));

%% Pictures
% Write into Pictures the diff pictures in a random order
if log.Pictures == 1
    ind = randperm(numel(designCB.similars),1); % select 4 trails out of design.Mtrials
    first = designCB.similars(ind);
    designCB.trials(designCB.Mtrials(1))=first;
    designCB.Mtrials(designCB.Mtrials==first) = []; % delete these trials
elseif log.Pictures==0
    ind = randperm(numel(designCB.distants),1); % select 4 trails out of design.Mtrials
    first = designCB.distants(ind);
    designCB.trials(designCB.Mtrials(1))=first;
    designCB.Mtrials(designCB.Mtrials==first) = []; % delete these trials
end
designCB.trials(temp) = designCB.Mtrials(randperm(numel(designCB.Mtrials)));

%% First trail selection 1= Congreunt, 0= design.inCongruent

% Order of manipulations
if log.Condition==0 %design.inCongruent as first
    ind = randperm(numel(designCB.Mtrials), 4); % select 4 trails out of design.Mtrials
    designCB.Congruent = designCB.Mtrials(ind);
    for i=1:4
        designCB.Mtrials(designCB.Mtrials==designCB.Congruent(i)) = []; % delete these trials
    end
    designCB.inCongruent=cat(2, first ,designCB.Mtrials);
    
elseif log.Condition==1 %congruent as first
    ind = randperm(numel(designCB.Mtrials), 4);
    designCB.inCongruent = designCB.Mtrials(ind);
    for i=1:4
        designCB.Mtrials(designCB.Mtrials==designCB.inCongruent(i)) = [];
    end
    designCB.Congruent=cat(2, first,designCB.Mtrials);
end

designCB.Mtrials= [7, 10, 14 ,16, 20, 22, 26,29];

%% Explanation trials
%%%%%%%%%%%%%% counterbalancing the first trial %%%%%%%%%%%%%%%%%%
% Since we discussed half of the partcipants should have different
% condition as first I decided to make it somewhat automatic rather than
% selecting it manually
% So, if log.ParticipantID is an even number first explanation will be incog
iseven= rem(log.ParticipantID,2)==0;

%%% now randomly select all exp trials
AllSelections = randperm(numel(designCB.nonMtrials), 8); % or maybe designCB.nonMtrials(2:end)???? 
designCB.AllSelections=designCB.nonMtrials(AllSelections);

firstExpLoc= find(designCB.AllSelections==min(designCB.AllSelections));
firstExp=designCB.AllSelections(firstExpLoc);
designCB.AllSelections(designCB.AllSelections==firstExp)=[];

if iseven
    ind= randperm(numel(designCB.AllSelections), 3); % select other 3
    InCogSelections = cat(2, firstExp,designCB.AllSelections(ind));
    for i=2:4
        designCB.AllSelections(designCB.AllSelections==InCogSelections(i)) = []; % delete these trials
    end
    CogSelections= designCB.AllSelections;
else
    ind= randperm(numel(designCB.AllSelections), 3); % select other 3
    CogSelections = cat(2, firstExp,designCB.AllSelections(ind));
    for i=2:4
        designCB.AllSelections(designCB.AllSelections==CogSelections(i)) = []; % delete these trials
    end
    InCogSelections= designCB.AllSelections;
end

designCB.InCogSelections= InCogSelections;
designCB.CogSelections= CogSelections;
designCB.TrialSeqeunce=designCB.trials;
designCB.AllSelections=designCB.nonMtrials(AllSelections);
designCB.Explanations= cat(2, designCB.nonMtrials(AllSelections), designCB.Mtrials);
designCB.nonExp=setdiff(designCB.trials,designCB.Explanations);


%% Texts
if log.Language ==1
    designCB.Welcome= 'Welcome to the "Psychophysical investigations about decision making" Experiment!.\n Please read the instructions carefully .\n \n\n Please press the SPACE key to proceed.';
    designCB.Instruction1= 'During the experiment- not now- , you will be presented with a pair of women pictures for 5 seconds and asked some questions. \n Please attend carefully and answer honestly.\n\n Please press the SPACE key to proceed.';
    designCB.Instruction2= 'You will be using the RIGHT ARROW, LEFT ARROW and SPACE keys to answer.\n\n Please press the SPACE key to proceed.';
    designCB.Instruction3= 'Your task is to select the women picture that you like more.\n You will indicate your selection by pressing one of the arrow keys.\n\n Please press the SPACE key to proceed.';
    designCB.Trial='Which women picture did you find more attractive? \n Please press the LEFT ARROW key to indicate that you like the picture on the left, \n or press the RIGHT ARROW key to indicate that you like the picture on the right';
    designCB.Instruction4= 'Please press the LEFT ARROW key to indicate that you like the picture on the left, \n or press the RIGHT ARROW key to indicate that you like the picture on the right.\n After you have made your selection, in some trials you will be asked some question about your decision. \n You need to answer these question verbally and your answers will be recorded.\n\n Please press the SPACE key to proceed.';
    designCB.StartExp= 'The experiment will start after this page. \n\n Please press the SPACE key to start the experiment.';
    designCB.Starting='Experiment is starting...';
    designCB.Ready='Get ready!';
    designCB.change= 'Press the SPACE key to proceed with this picture, \n press one of the ARROW keys to change your selection.';
    designCB.Explanation1= 'From 1 to 10, how attractive is she? \n press the SPACE key when you are done.';
    designCB.Explanation2= 'From 1 to 10, how confident are you in your selection?  press the SPACE key when you are done.';
    designCB.Explanation3= 'Explain the reasons of your decision.\n\n  press the SPACE key to proceed after you explained yourself.';
    designCB.Weird= 'Did you notice something special about the experiment?';
    designCB.Bye='End of the experiment. \n Thanks for your participation!.\n Please wait for the experimenter.';
elseif log.Language == 0
    designCB.Welcome= 'Willkommen zum Experiment "Psychophysikalische Untersuchungen zur Entscheidungsfindung"! \n Bitte lesen Sie die Anweisungen sorgfältig durch. \n \n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction1= 'Während des Experiments -nicht jetzt- werden Ihnen für 5 Sekunden ein Paar Frauenbilder präsentiert und einige Fragen gestellt. \n \n Bitte hören Sie aufmerksam zu und antworten Sie ehrlich.\n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction2= 'Sie werden die Tasten PFEIL RECHTS, PFEIL LINKS und LEERTASTE verwenden, um zu antworten.\n\n Bitte drücken Sie die LEERTASTE, um fortzufahren.';
    designCB.Instruction3= 'Ihre Aufgabe ist es, das Frauenbild auszuwählen, das Ihnen am besten gefällt.\n Sie zeigen Ihre Auswahl durch Drücken einer der Pfeiltasten an.\n\n Bitte drücken Sie die Leertaste, um fortzufahren.';
    designCB.Instruction4= 'Bitte drücken Sie die PFEILTASTE LINKS, um anzuzeigen, dass Ihnen das Bild links besser gefällt, \n oder drücken Sie die PFEILTASTE RECHTS, um anzuzeigen, dass Ihnen das Bild rechts besser gefällt.\n \n Nachdem Sie Ihre Auswahl getroffen haben, werden Ihnen in einigen Versuchen Fragen zu Ihrer Entscheidung gestellt. \n Sie müssen diese Fragen mündlich beantworten und Ihre Antworten werden aufgezeichnet.\n\n Bitte drücken Sie die LEERTASTE, um fortzufahren.';
    designCB.StartExp= 'Das Experiment wird nach dieser Seite gestartet. \n\n Bitte drücken Sie die Leertaste, um das Experiment zu starten.';
    designCB.Starting='Das Experiment beginnt...';
    designCB.Ready='Machen Sie sich bereit!';
    designCB.change= 'Sie haben dieses Bild ausgewählt. Möchten Sie Ihre Auswahl ändern? \n \n Bitte drücken Sie die LEERTASTE, um mit diesem Bild fortzufahren, oder drücken Sie eine der PFEILTASTEN, um Ihre Auswahl zu ändern. ';
    designCB.Explanation1= 'Auf einer Skala von 1 (überhaupt nicht) bis 10 (sehr sicher), wie sicher sind Sie sich, dass Ihre Auswahl im Vergleich zu anderen attraktiver ist? \n Bitte antworten Sie mündlich und drücken Sie dann die Leertaste, wenn Sie fertig sind.';
    designCB.Explanation2= 'Auf einer Skala von 1 (überhaupt nicht) bis 10 (sehr zuversichtlich), wie zuversichtlich sind Sie bezüglich Ihrer Auswahl?  \n Bitte antworten Sie mündlich und drücken Sie dann die Leertaste, wenn Sie fertig sind.';
    designCB.Explanation3= 'Bitte erläutern Sie verbal den Grund Ihrer Entscheidung.\n\n Bitte drücken Sie die Leertaste, um fortzufahren, nachdem Sie sich erklärt haben.';
    designCB.Weird= 'Ist Ihnen bei dem Experiment etwas Besonderes aufgefallen?';
    designCB.Bye='Ende des Experiments. \n Danke für Ihre Teilnahme!.\n Bitte warten Sie auf den Experimentator.';
end
    %
    
end


