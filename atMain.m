
%% Set things up

%Clears stuff before
clear all
clc

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

%% Organize trials

Cfg.run_mode = 'behav';
blocks=3;
%conditions=[1 2 3]; %1=base 2=punt_sec 3=punt_vinc
%numConditions=length(conditions);
numTrialsPerBlock=30;
%numTrials=blocks*numTrialsPerBlock;


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

ch=ones(30,1);

%% Start trials

%Welcome screen (uncomment later)
%DrawFormattedText(win,'Benvenuto! \n \n Quando sei pronto per cominciare, premi INVIO.','center','center',white);
%Screen('Flip',win);
%RestrictKeysForKbCheck(enter); % to restrict key presses to enter
%[secs, keyCode, deltaSecs] = KbWait([],2);
%RestrictKeysForKbCheck([]);

for i=1:30
    if any(bigMatrix(i,:) == 7)
    valueObjA_1 = num2str(valueObjA(1,1));
    valueObjA_2 = num2str(valueObjA(1,2));
    valueObjA_3 = num2str(valueObjA(1,3));
    valueObjA_4 = num2str(valueObjA(1,4));
    valueObjA_5 = num2str(valueObjA(1,5));
    greenValue = datasample(valueObjA,1) %pick random value from valueObjA
    row = bigMatrix(i,:) %display options
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
            valueObjB_1 = num2str(valueObjB(1,1));
            valueObjB_2 = num2str(valueObjB(1,2));
            valueObjB_3 = num2str(valueObjB(1,3));
            valueObjB_4 = num2str(valueObjB(1,4));
            valueObjB_5 = num2str(valueObjB(1,5));
        greenValue = datasample(valueObjB,1) %pick random value from valueObjB
        row = bigMatrix(i,:) %display options
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
    
    %here is where everything is draw the first time
    if ismember(greenValue, [9 12 6 19 15])
       DrawFormattedText(win,valueObjA_1,650,450,white);
       DrawFormattedText(win,valueObjA_2,700,450,white);
       DrawFormattedText(win,valueObjA_3,800,450,white);
       DrawFormattedText(win,valueObjA_4,850,450,white);
       DrawFormattedText(win,valueObjA_5,950,450,white);
       DrawFormattedText(win,'2   5   7   9   11',650,550,white);
    else DrawFormattedText(win,valueObjB_1,650,450,white)
         DrawFormattedText(win,valueObjB_2,700,450,white);
         DrawFormattedText(win,valueObjB_3,750,450,white);
         DrawFormattedText(win,valueObjB_4,850,450,white);
         DrawFormattedText(win,valueObjB_5,950,450,white);
         DrawFormattedText(win,'1   4   6   8   10',650,550,white);
    end
    
    rowString = num2str(row);
    Screen('Flip',win);
    
    keyName=''; % empty initial value
    while(~strcmp(keyName,'space')) % continues until current keyName is space

        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        switch keyName
            case 'LeftArrow' 
                ch(i)=ch(i)-1;
                if ch(i)<=1
                    ch(i)=1;
                end

            case 'RightArrow'
                ch(i)=ch(i)+1;
                %while(row(ch(i))> greenValue)
                    %ch(i)=ch(i)+1;
                %end
                if ch(i)>=6
                    ch(i)=5;
                end
        end
        
    if ismember(greenValue, [9 12 6 19 15])
       DrawFormattedText(win,valueObjA_1,650,450,white);
       DrawFormattedText(win,valueObjA_2,700,450,white);
       DrawFormattedText(win,valueObjA_3,800,450,white);
       DrawFormattedText(win,valueObjA_4,850,450,white);
       DrawFormattedText(win,valueObjA_5,950,450,white);
    else DrawFormattedText(win,valueObjB_1,650,450,white)
         DrawFormattedText(win,valueObjB_2,700,450,white);
         DrawFormattedText(win,valueObjB_3,750,450,white);
         DrawFormattedText(win,valueObjB_4,850,450,white);
         DrawFormattedText(win,valueObjB_5,950,450,white);
    end
 
        DrawFormattedText(win,rowString,650,550,white);
        DrawFormattedText(win,'^',650+50*ch(i),550+50,white);
        Screen('Flip',win);

    end
    
    imp(i)=row(ch(i)) %subject choice

    if compChoice > imp(i) %determine who won
        humanWin = 0
    elseif compChoice < imp(i)
        humanWin = 1
    elseif compChoice == imp(i)
        humanWin = 2
    end
 
end

%Close screen
Screen('CloseAll');
sca;