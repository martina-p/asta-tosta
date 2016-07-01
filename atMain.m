
%% Set things up

%Clears stuff before
clear all;
clc;

KbName('UnifyKeyNames'); 

% Screen Preferences
Screen('Preference', 'VBLTimestampingMode', 3); %Add this to avoid timestamping problems
Screen('Preference', 'DefaultFontName', 'Geneva');
Screen('Preference', 'DefaultFontSize', 30); %fontsize
Screen('Preference', 'DefaultFontStyle', 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend,1+2=bold and italic.
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1); % align text on a line 
 
% Colors definition
white = [255 255 255]; 
black = [0 0 0];
red = [255 0 0]; 
green = [0 255 0];

%Keyboard parameters
keyLeft=KbName('leftArrow'); % Left arrow
keyRight=KbName('rightArrow'); % Right arrow
enter=KbName('return'); % Enter
space=KbName('space'); %space

%% Organize trials
 
A = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
Ashuffled=A(randperm(length(A)));
B = [2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 3 3];
Bshuffled=B(randperm(length(B)));
C = [3 3 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
Cshuffled=C(randperm(length(C)));

conditions = vertcat(Ashuffled,Bshuffled,Cshuffled);
nrRuns = size(conditions,1);
nrTrials = length(conditions);

%% Start exp

% Open PTB
screens=Screen('Screens');
Screen('Preference', 'SkipSyncTests', 2);
screenNumber=max(screens); % Main screen
winRect = [0,0,1680,1050];
[win,winRect] = Screen('OpenWindow',screenNumber,black);

%Declare variables
%DateTime = datestr(now,'yyyymmdd-HHMM')

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

%% Welcome screen

DrawFormattedText(win,'Benvenuto! \n \n Quando sei pronto per cominciare, premi INVIO.','center','center',white);
Screen('Flip',win);
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
[secs, keyCode, deltaSecs] = KbWait([],2);
RestrictKeysForKbCheck([]); %to turn of key presses restriction

%% Start trial loop

for j=1:nrRuns
for i=1:nrTrials
    if conditions(j,i) == 1
       DrawFormattedText(win,'La prossima asta sarà: \n \n BASE','center','center',white);
    elseif conditions(j,i) == 2
        DrawFormattedText(win,'La prossima asta sarà: \n \n SECONDA PUNTATA','center','center',white);
    elseif conditions(j,i) == 3
        DrawFormattedText(win,'La prossima asta sarà: \n \n PUNTATA VINCENTE','center','center',white);
    end
    Screen('Flip',win);
    WaitSecs(.2);
    
    if any(bigMatrix(i,:) == 7)
    permvalueObjA = valueObjA(randperm(5));
    greenValue = datasample(valueObjA,1) %pick random value from valueObjA
    row = bigMatrix(i,:) %display options
    survivingChoices = row(row < greenValue);
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
        greenValue = datasample(valueObjB,1) %pick random value from valueObjB
        row = bigMatrix(i,:) %display options
        survivingChoices = row(row < greenValue);
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
    greenValueString = num2str(greenValue);
    survivingChoicesString = num2str(survivingChoices);
    permvalueObjAString = num2str(valueObjA(randperm(5)));
    permvalueObjBString = num2str(valueObjB(randperm(5)));
    
    if ismember(greenValue, [9 12 6 19 15])
       DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjAString],'center',450,white);
       else DrawFormattedText(win,['Possibili valori oggetto:    ' permvalueObjBString],'center',450,white);
    end

    DrawFormattedText(win,['Valore reale:   ' greenValueString],'center',500,green);
    DrawFormattedText(win,['Set delle puntate:   ' rowString],500,650,white);
    Screen('Flip',win);
    WaitSecs(.2);
    
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
    
    %loop to select decision
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
    
    imp(i)=survivingChoices(ch(i)) %subject choice
    
    %determine who won
    if compChoice > imp(i)
        humanWin = 0
    elseif compChoice < imp(i)
        humanWin = 1
    elseif compChoice == imp(i)
        humanWin = sum(rand >= cumsum([0.5])) %assign 50% prob of winning in case of draw
    end
    
    %show post-choice info
    compChoiceString = num2str(compChoice);
    
    if (conditions(j,i) == 1) && (humanWin == 1)
       DrawFormattedText(win,'Hai vinto!','center','center',white);
    elseif (conditions(j,i) == 1) && (humanWin == 0)
        DrawFormattedText(win,'Hai perso!','center','center',white);
    elseif (conditions(j,i) == 2) && (humanWin == 1)
        DrawFormattedText(win,['Hai vinto! \n \n Il computer ha giocato:  ' compChoiceString],'center','center',white);
    elseif (conditions(j,i) == 2 && humanWin == 0)
        DrawFormattedText(win,['Hai perso! \n \n Il computer ha giocato:  ' compChoiceString],'center','center',white);
    elseif (conditions(j,i) == 3 && humanWin == 1)
        DrawFormattedText(win,'Hai vinto!','center','center',white);
    elseif (conditions(j,i) == 3 && humanWin == 0)
        DrawFormattedText(win,['Hai perso! \n \n Il computer ha giocato:  ' compChoiceString],'center','center',white);
    end
    Screen('Flip',win);
    WaitSecs(.2);
        
end
    %imp(i)=row(ch(i)) %subject choice
    
    %insert breaks after block 1 and block 2
    if j == 1 && i == 30
        DrawFormattedText(win,'Pausa. \n \n Premi INVIO per continuare.','center','center',white);
    elseif j == 2 && i == 30
        DrawFormattedText(win,'Pausa. \n \n Premi INVIO per continuare.','center','center',white);
    end
    Screen('Flip',win);
    RestrictKeysForKbCheck(enter); % to restrict key presses to enter
    [secs, keyCode, deltaSecs] = KbWait([],2);
    RestrictKeysForKbCheck([]); %to turn of key presses restriction
    
end
  
%Close screen
Screen('CloseAll');
sca;