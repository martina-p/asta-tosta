% Script to run "asta tosta" game
% Martina Puppi, June 2916

%% Set things up

% Clears stuff before
clear all;
clc;

KbName('UnifyKeyNames'); 

% Screen Preferences
Screen('Preference', 'VBLTimestampingMode', 3); %Add this to avoid timestamping problems
Screen('Preference', 'DefaultFontName', 'Geneva');
Screen('Preference', 'DefaultFontSize', 30); %fontsize
Screen('Preference', 'DefaultFontStyle', 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend,1+2=bold and italic
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1); % align text on a line 
 
% Color definition
white = [255 255 255]; 
black = [0 0 0];
red = [255 0 0]; 
green = [0 255 0];
blue = [0 0 255];

% Keyboard parameters
keyLeft=KbName('leftArrow'); % Left arrow
keyRight=KbName('rightArrow'); % Right arrow
enter=KbName('return'); % Enter
space=KbName('space'); % Space

%% Trials organization
 
% A = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
A = [1 2];
Ashuffled=A(randperm(length(A)));
Bshuffled=A(randperm(length(A)));
Cshuffled=A(randperm(length(A)));
% B = [2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 3 3];
% C = [3 3 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];


Practice = [1 2 3];
conditions = {Practice Ashuffled,Bshuffled,Cshuffled};
nrRuns = length(conditions);

message = {'Fine della prova. \n \n Premi INVIO per cominciare l''esperimento'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Fine del gioco!'};

conmsg = {'La prossima asta sar�: \n \n BASE'
          'La prossima asta sar�: \n \n SECONDA PUNTATA'
          'La prossima asta sar�: \n \n PUNTATA VINCENTE'};
      
 condname = {'BASE'
     'SECONDA PUNTATA'
     'PUNTATA VINCENTE'};     

%% Variables
valueObjA = [9 12 6 19 15];
valueObjB = [5 8 11 14 18];

%computer choices nash equilibrium A
lookup{6} = 2; 
lookup{12} = 7;
lookup{15} = 9;
lookup{19} = 11;
lookup{9} = 5;

%computer choices nash equilibrium B
lookup{5} = 1; 
lookup{8} = 4;
lookup{11} = 6;
lookup{14} = 8;
lookup{18} = 10;

%create random matrix of possible values A
perA = perms([2 5 7 9 11]);
matrixWholeA = perA(randperm(length(perA)),:);
matrix45A = matrixWholeA(1:45,:);

%create random matrix of possible values B
perB = perms([1 4 6 8 10]);
matrixWholeB = perB(randperm(length(perB)),:);
matrix45B = matrixWholeB(1:45,:);

%create one single big matrix, with rows shuffled
matrix90 = [matrix45A; matrix45B];
bigMatrix = matrix90(randperm(90),:);

ch=ones(90,1);

%% Start exp

%data allocation stuff
iSubject=input('Participant number: ');
DateTime = datestr(now,'yyyymmdd-HHMM');
if ~exist('Logfiles', 'dir')
    mkdir('Logfiles');
end
resultname = strcat('Sub',num2str(iSubject),'_', DateTime, '.mat');
backupfile = fullfile('Logfiles', strcat('Bckup_Sub',num2str(iSubject), '_', DateTime, '.mat')); %save under name composed by number of subject and session

% Open PTB
screens=Screen('Screens');
Screen('Preference', 'SkipSyncTests', 2);
screenNumber=max(screens); % Main screen
winRect = [0,0,1680,1050];
[win,winRect] = Screen('OpenWindow',screenNumber,black);

% Instructions
DrawFormattedText(win,'Benvenuto! \n \n Quando sei pronto per cominciare, premi INVIO.','center','center',white);
Screen('Flip',win);
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
[secs, keyCode, deltaSecs] = KbWait([],2);
RestrictKeysForKbCheck([]); %to turn of key presses restriction

DrawFormattedText(win,'ISTRUZIONI 1','center','center',white);
DrawFormattedText(win,'Premi INVIO per continuare.','center',950,white);
Screen('Flip',win);
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
[secs, keyCode, deltaSecs] = KbWait([],2);
RestrictKeysForKbCheck([]); %to turn of key presses restriction

DrawFormattedText(win,'ISTRUZIONI 2','center','center',white);
DrawFormattedText(win,'Premi INVIO per continuare','center',950,white);
Screen('Flip',win);
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
[secs, keyCode, deltaSecs] = KbWait([],2);
RestrictKeysForKbCheck([]); %to turn of key presses restriction

DrawFormattedText(win,'ISTRUZIONI 3 \n \n Di seguito ci saranno tre trials di prova. ','center','center',white);
DrawFormattedText(win,'Premi INVIO per continuare','center',950,white);
Screen('Flip',win);
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
[secs, keyCode, deltaSecs] = KbWait([],2);
RestrictKeysForKbCheck([]); %to turn of key presses restriction

%% Trial loop
trialnb = 0;

for j=1:nrRuns
    nrTrials = length(conditions{j});
for i=1:nrTrials
    save(backupfile)   % backs the entire workspace up just in case we have to do a nasty abort
    trialnb = trialnb + 1;
    runnb(trialnb,1) = j;
    
    DrawFormattedText(win, conmsg{conditions{j}(i)},'center','center',white);

    Screen('Flip',win);
    WaitSecs(.2);
    
    if any(bigMatrix(i,:) == 7)
    permvalueObjA = valueObjA(randperm(5));
    greenValueSubj = datasample(valueObjA,1)
    greenValue = datasample(valueObjA,1)
    row = bigMatrix(i,:) %set of options
    survivingChoices = row(row < greenValueSubj);
        if greenValue == 6
        compChoice = lookup{6}
        elseif greenValue == 12
        compChoice = lookup{12}
        elseif greenValue == 9
        compChoice = lookup{9}
        elseif greenValue == 19
        compChoice = lookup{19}
        elseif greenValue == 15
        compChoice = lookup{15}
        end
    elseif any(bigMatrix(i,:) == 10)
        permvalueObjB = valueObjB(randperm(5));
        greenValueSubj = datasample(valueObjB,1)
        greenValue = datasample(valueObjB,1)
        row = bigMatrix(i,:) %set of options
        survivingChoices = row(row < greenValueSubj);
            if greenValue == 5
            compChoice = lookup{5}
            elseif greenValue == 8
            compChoice = lookup{8}
            elseif greenValue == 11
            compChoice = lookup{11}
            elseif greenValue == 14
            compChoice = lookup{14}
            elseif greenValue == 18
            compChoice = lookup{18}
            end     
    end
    
    rowString = num2str(row);
    greenValueString = num2str(greenValueSubj);
    survivingChoicesString = num2str(survivingChoices);
    permvalueObjAString = num2str(valueObjA(randperm(5)));
    permvalueObjBString = num2str(valueObjB(randperm(5)));
    
    DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white);
    
    if ismember(greenValue, [9 12 6 19 15])
       DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjAString],'center',450,white);
       else DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjBString],'center',450,white);
    end

    DrawFormattedText(win,['Valore reale:   ' greenValueString],'center',500,green);
    DrawFormattedText(win,['Set delle puntate:   ' rowString],500,650,white);
    Screen('Flip',win);
    WaitSecs(.2);
        
   DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white);
   if ismember(greenValue, [9 12 6 19 15])
      DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjAString],'center',450,white);
   else DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjBString],'center',450,white);
   end

    DrawFormattedText(win,['Valore reale:   ' greenValueString],'center',500,green);
    DrawFormattedText(win,['Set delle puntate:   ' rowString],500,650,white);
    DrawFormattedText(win,'Puntate possibili:     ',500,700,white);
    DrawFormattedText(win,survivingChoicesString,900,700,white);
    DrawFormattedText(win,'^',830+70*2,750,white);
    DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',950,white);
    Screen('Flip',win);
    
    %Selection
    keyName=''; % empty initial value
    while(~strcmp(keyName,'space')) % continues until current keyName is space
        
        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        if length(survivingChoices) == 1
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                %ch(i)=ch(i);
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                %ch(i)=ch(i);
                if ch(i)>=2
                    ch(i)=1;
                end        
        end
        elseif length(survivingChoices) == 2
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                if ch(i)>=3
                    ch(i)=2;
                end        
        end
        elseif length(survivingChoices) == 3
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                if ch(i)>=4
                    ch(i)=3;
                end        
        end
        elseif length(survivingChoices) == 4
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                if ch(i)>=5
                    ch(i)=4;
                end        
        end
        elseif length(survivingChoices) == 5
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                if ch(i)>=6
                    ch(i)=5;
                end        
        end
        end
        
       DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white); 
       if ismember(greenValue, [9 12 6 19 15])
          DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjAString],'center',450,white);
       else DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjBString],'center',450,white);
       end
       
        DrawFormattedText(win,['Valore reale:   ' greenValueString],'center',500,green);
        DrawFormattedText(win,['Set delle puntate:   ' rowString],500,650,white);
        DrawFormattedText(win,'Puntate possibili:     ',500,700,white);
        DrawFormattedText(win,survivingChoicesString,900,700,white);
        DrawFormattedText(win,'^',830+70*ch(i),750,white);
        DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',950,white);
        Screen('Flip',win);

    end
    
    imp{j}(i) = survivingChoices(ch(i)) %subject choice
    Sub_ch = survivingChoices(ch(i));
    
    %determine who won
    if compChoice > Sub_ch
        humanWin = 0
    elseif compChoice < Sub_ch
        humanWin = 1
    elseif compChoice == Sub_ch
        humanWin = randi([0 1], 1, 1) %assign 50% prob of winning in case of draw
    end
    
    %Show post-choice info screen
    compChoiceString = num2str(compChoice);
    subjChoiceString = num2str(imp{j}(i));
    width_coeff = 70;
    start_coord = 200;
    
    if (conditions{j}(i) == 1) && (humanWin == 1) %BASE
       DrawFormattedText(win,'Hai vinto!','center','center',white);
       Screen('FillRect', win, white, [start_coord 200 start_coord+Sub_ch(end)*width_coeff 250]);
       Screen('FillRect', win, green, [start_coord+Sub_ch(end)*width_coeff 200 start_coord+(greenValueSubj)*width_coeff 250]);
    elseif (conditions{j}(i) == 1) && (humanWin == 0) %BASE
        DrawFormattedText(win,'Hai perso!','center','center',white);
        Screen('FillRect', win, red, [start_coord 200 start_coord+greenValueSubj*width_coeff 250]);
    elseif (conditions{j}(i) == 2) && (humanWin == 1) %SECONDA PUNTATA
        DrawFormattedText(win,['Hai vinto! \n \n Il computer ha giocato:  ' compChoiceString],'center','center',white);
        Screen('FillRect', win, white, [start_coord 200 start_coord+compChoice*width_coeff 250]);
        Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff 200 start_coord+Sub_ch(end)*width_coeff 250]);
        Screen('FillRect', win, green, [start_coord+Sub_ch(end)*width_coeff 200 start_coord+greenValueSubj*width_coeff 250]);
    elseif (conditions{j}(i) == 2 && humanWin == 0) %SECONDA PUNTATA
        DrawFormattedText(win,['Hai perso! \n \n Hai giocato:  ' subjChoiceString],'center','center',white); %add subjChoice
        Screen('FillRect', win, red, [start_coord 200 start_coord+greenValueSubj*width_coeff 250]);
    elseif (conditions{j}(i) == 3 && humanWin == 1) %PUNTATA VINCENTE
        DrawFormattedText(win,'Hai vinto!','center','center',white);
        Screen('FillRect', win, white, [start_coord 200 start_coord+Sub_ch(end)*width_coeff 250]);
        Screen('FillRect', win, green, [start_coord+Sub_ch(end)*width_coeff 200 start_coord+(greenValueSubj)*width_coeff 250]);
    elseif (conditions{j}(i) == 3 && humanWin == 0) %PUNTATA VINCENTE
        DrawFormattedText(win,['Hai perso! \n \n Il computer ha giocato:  ' compChoiceString],'center','center',white);
        if greenValueSubj>compChoice
            Screen('FillRect', win, red, [start_coord 200 start_coord+Sub_ch(end)*width_coeff 250]);
            Screen('FillRect', win, red, [start_coord+Sub_ch(end)*width_coeff 200 start_coord+compChoice*width_coeff 250]);
            Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff 200 start_coord+greenValueSubj*width_coeff 250]);
        elseif greenValueSubj<=compChoice
            Screen('FillRect', win, red, [start_coord 200 start_coord+compChoice(end)*width_coeff 250]);
        end
    end
    Screen('Flip',win);
    WaitSecs(3);
    
    s_value(trialnb,1) = greenValueSubj;
    s_fulloptions{trialnb} = row;
    s_options{trialnb} = survivingChoices;
    c_choice(trialnb,1) = compChoice;     
    s_win(trialnb,1) = humanWin;
end
    
    %Insert breaks after block 1 and block 2
    DrawFormattedText(win,message{j},'center','center',white);
    Screen('Flip',win);
    RestrictKeysForKbCheck(enter); % to restrict key presses to enter
    [secs, keyCode, deltaSecs] = KbWait([],2);
    RestrictKeysForKbCheck([]); %to turn of key presses restriction
    
end

subject(1:trialnb,1) = iSubject;
%save data
data = table(subject, runnb, [1:trialnb]', cell2mat(conditions)', cell2mat(imp)', s_value, s_options,  c_choice, s_win);
%save(resultname, 'data');

%Close screen
Screen('CloseAll');
sca;