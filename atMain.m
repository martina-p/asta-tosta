% Script to run "asta tosta" game
% Martina Puppi & Nadège Bault, June 2016

%% Set things up

% Clears stuff before
clear all;
clc;

% Take screenshot
%Screenshot=1;
%if Screenshot==1 && ~isdir('Screenshots')
    %mkdir('Screenshots')
%end

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
grey = [150 150 150];

% Bar coordinates
width_coeff = 60;
start_coord = 50;
y_cood1 = 600;
y_cood2 = 650;

% Keyboard parameters
keyLeft=KbName('leftArrow'); % Left arrow
keyRight=KbName('rightArrow'); % Right arrow
enter=KbName('return'); % Enter
space=KbName('space'); % Space

%% Trials organization
A = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
Ashuffled=A(randperm(length(A)));
Bshuffled=A(randperm(length(A)));
Cshuffled=A(randperm(length(A)));

Practice = [1 2 3];
conditions = {Practice Ashuffled,Bshuffled,Cshuffled};
nrRuns = length(conditions);

% Instruction messages
instr1 = ['Benvenuto! \n \n Premi INVIO per cominciare 3 turni di prova.'];
pressEnter = ['Premi INVIO per continuare con le istruzioni'];
pressTrial = ['Premi INVIO per cominciare la prova'];
message = {'Fine della prova. \n \n Premi INVIO per cominciare l''esperimento'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Fine del gioco!'};

conmsg = {'La prossima asta sarà: \n \n BASE'
    'La prossima asta sarà: \n \n SECONDA PUNTATA'
    'La prossima asta sarà: \n \n PUNTATA VINCENTE'};

condname = {'BASE'
    'SECONDA PUNTATA'
    'PUNTATA VINCENTE'};

%% Variables

% The two sets of object values
valueObjA = [9 12 6 19 15];
valueObjB = [5 8 11 14 18];

% Matrix of possible bids
perA = [2 5 7 9 11];
perB = [1 4 6 8 10];
matrix90 = [repmat(perA, 45, 1); repmat(perB, 45, 1)];
bigMatrix = matrix90(randperm(90),:);

% Computer choices Nash equilibrium A
lookup{6} = 2;
lookup{12} = 7;
lookup{15} = 9;
lookup{19} = 11;
lookup{9} = 5;

% Computer choices Nash equilibrium B
lookup{5} = 1;
lookup{8} = 4;
lookup{11} = 6;
lookup{14} = 8;
lookup{18} = 10;

% Subject chioice allocation
ch=ones(90,1);

%% Start exp

% Data allocation
iSubject=input('Participant number: ');
DateTime = datestr(now,'yyyymmdd-HHMM');
if ~exist('Logfiles', 'dir')
    mkdir('Logfiles');
end
resultname = fullfile('Logfiles', strcat('Sub',num2str(iSubject),'_', DateTime, '.mat'));
backupfile = fullfile('Logfiles', strcat('Bckup_Sub',num2str(iSubject), '_', DateTime, '.mat')); %save under name composed by number of subject and session

% Open PTB
screens=Screen('Screens');
Screen('Preference', 'SkipSyncTests', 2);
screenNumber=max(screens); % Main screen
winRect = [0,0,1680,1050];
[win,winRect] = Screen('OpenWindow',screenNumber,black);

% Instructions (minimal)
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
DrawFormattedText(win,instr1,'center','center',white);
Screen('Flip',win);
[secs, keyCode, deltaSecs] = KbWait([],2);

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
            survivingChoices = row(row <= greenValueSubj)
            T_1Anr = permvalueObjA(1,1); % for later positioning with drawtext
            T_2Anr = permvalueObjA(1,2);
            T_3Anr = permvalueObjA(1,3);
            T_4Anr = permvalueObjA(1,4);
            T_5Anr = permvalueObjA(1,5);
            T_1A = num2str(T_1Anr); % for later positioning with drawtext
            T_2A = num2str(T_2Anr);
            T_3A = num2str(T_3Anr);
            T_4A = num2str(T_4Anr);
            T_5A = num2str(T_5Anr);
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
            survivingChoices = row(row <= greenValueSubj)
            T_1Bnr = permvalueObjB(1,1); % for later positioning with drawtext
            T_2Bnr = permvalueObjB(1,2);
            T_3Bnr = permvalueObjB(1,3);
            T_4Bnr = permvalueObjB(1,4);
            T_5Bnr = permvalueObjB(1,5);
            T_1B = num2str(T_1Bnr); % for later positioning with drawtext
            T_2B = num2str(T_2Bnr);
            T_3B = num2str(T_3Bnr);
            T_4B = num2str(T_4Bnr);
            T_5B = num2str(T_5Bnr);
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
         
        DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white);        
        if T_1Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_2Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_3Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_4Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_5Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_1Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_2Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_3Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_4Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
       elseif T_5Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        end
        
        RestrictKeysForKbCheck(enter); % to restrict key presses to enter
        DrawFormattedText(win,'Premi INVIO per continuare','center',1000,white);
        Screen('Flip',win);
        [secs, keyCode, deltaSecs] = KbWait([],2);
        RestrictKeysForKbCheck([]); % to restrict key presses to enter
        
        %if Screenshot==1   
            %imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            %imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) 'Screen1.jpg']) % imwrite is a Matlab function
        %end
        
        DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white);
        if T_1Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,green)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_2Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,green);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_3Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,green);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_4Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,green);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_5Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,green);
        elseif T_1Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,green)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_2Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,green);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_3Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,green);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_4Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,green);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
       elseif T_5Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,green);
        end
        
        % Draw the bar OLD
        %Screen('FillRect', win, white, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
        
        % Draw the bar NEW
        if any(bigMatrix(i,:) == 7)
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+max(perA)*width_coeff y_cood2]);
        elseif any(bigMatrix(i,:) == 10)
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+max(perB)*width_coeff y_cood2]);
        end
        
        % Draw the tick marks and numbers underneath NEW
        if any(bigMatrix(i,:) == 7)
           for r = 1:max(perA)
              Screen('DrawLine', win, white, start_coord + r*width_coeff, y_cood2, start_coord + r*width_coeff,  y_cood2+20, 1); %tick marks
              if find(r == survivingChoices)
                 DrawFormattedText(win, num2str(r), start_coord + r*width_coeff-10, y_cood2 + 70, white); %white numbers if selectable
              end
           end   
        elseif any(bigMatrix(i,:) == 10)
            for r = 1:max(perB)
                Screen('DrawLine', win, white, start_coord + r*width_coeff, y_cood2, start_coord + r*width_coeff,  y_cood2+20, 1); %tick marks
                if find(r == survivingChoices)
                   DrawFormattedText(win, num2str(r), start_coord + r*width_coeff-10, y_cood2 + 70, white); %white numbers if selectable
                end
            end
        end     
        
        %Restrict choices
        if max(row)>greenValueSubj
            if any(bigMatrix(i,:) == 7)
                Screen('FillRect', win, grey, [start_coord+greenValueSubj*width_coeff y_cood1 start_coord+max(perA)*width_coeff y_cood2]);
                for rr = find(row > greenValueSubj)
                    Screen('DrawLine', win, grey, start_coord + row(rr)*width_coeff, y_cood2, start_coord + row(rr)*width_coeff,  y_cood2+20, 1); %grey ticks
                    DrawFormattedText(win, num2str(row(rr)), start_coord + row(rr)*width_coeff-10, y_cood2 + 70, grey); %grey numbers
                end
            elseif any(bigMatrix(i,:) == 10)
                Screen('FillRect', win, grey, [start_coord+greenValueSubj*width_coeff y_cood1 start_coord+max(perB)*width_coeff y_cood2]);
                for rr = find(row > greenValueSubj)
                    Screen('DrawLine', win, grey, start_coord + row(rr)*width_coeff, y_cood2, start_coord + row(rr)*width_coeff,  y_cood2+20, 1);
                    DrawFormattedText(win, num2str(row(rr)), start_coord + row(rr)*width_coeff-10, y_cood2 + 70, grey);
                end
            end
        end
        
        %cursor
        if length(survivingChoices) > 1
            start_pos = 2;
        else
            start_pos = 1;
        end
        
        Screen('FillRect', win, white, [start_coord+survivingChoices(start_pos)*width_coeff-5 y_cood1-2 start_coord+survivingChoices(start_pos)*width_coeff+5 y_cood2+2]);
        Screen('FrameRect', win, black, [start_coord+survivingChoices(start_pos)*width_coeff-6 y_cood1-2 start_coord+survivingChoices(start_pos)*width_coeff+6 y_cood2+2]);
        DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',1000,white);
        keyCode = [];
        keyName=''; % empty initial value
        Screen('Flip',win);
        
        %if Screenshot==1   
            %imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            %imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen2.jpg']) % imwrite is a Matlab function
       % end
        
        %Selection
        pos = start_pos;
        RestrictKeysForKbCheck([]);
        while(~strcmp(keyName,'space')) % continues until current keyName is space
            [keyTime, keyCode]=KbWait([],2); 
            keyName=KbName(keyCode);
            switch keyName
                case 'LeftArrow'
                    if pos > 1
                        pos = pos - 1;
                    end
                    
                case 'RightArrow'
                    if pos < length(survivingChoices)
                        pos = pos + 1;
                    end
            end
            
        DrawFormattedText(win,condname{conditions{j}(i)},'center',400,white);
        if T_1Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,green)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_2Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,green);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_3Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,green);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_4Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,green);
            DrawFormattedText(win,['                             ' T_5A],1100,450,white);
        elseif T_5Anr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1A],700,450,white)
            DrawFormattedText(win,['                             ' T_2A],800,450,white);
            DrawFormattedText(win,['                             ' T_3A],900,450,white);
            DrawFormattedText(win,['                             ' T_4A],1000,450,white);
            DrawFormattedText(win,['                             ' T_5A],1100,450,green);
        elseif T_1Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,green)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_2Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,green);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_3Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,green);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
        elseif T_4Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,green);
            DrawFormattedText(win,['                             ' T_5B],1100,450,white);
       elseif T_5Bnr == greenValueSubj
            DrawFormattedText(win,'Possibili valori oggetto:    ',550,450,white)
            DrawFormattedText(win,['                             ' T_1B],700,450,white)
            DrawFormattedText(win,['                             ' T_2B],800,450,white);
            DrawFormattedText(win,['                             ' T_3B],900,450,white);
            DrawFormattedText(win,['                             ' T_4B],1000,450,white);
            DrawFormattedText(win,['                             ' T_5B],1100,450,green);
        end
            
        Screen('FillRect', win, white, [start_coord+survivingChoices(pos)*width_coeff-5 y_cood1-2 start_coord+survivingChoices(pos)*width_coeff+5 y_cood2+2]);
        Screen('FrameRect', win, black, [start_coord+survivingChoices(pos)*width_coeff-6 y_cood1-2 start_coord+survivingChoices(pos)*width_coeff+6 y_cood2+2]);
            
        % Draw the bar NEW
        if any(bigMatrix(i,:) == 7)
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+max(perA)*width_coeff y_cood2]);
        elseif any(bigMatrix(i,:) == 10)
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+max(perB)*width_coeff y_cood2]);
        end
        
        % Draw the tick marks and numbers underneath NEW
        if any(bigMatrix(i,:) == 7)
           for r = 1:max(perA)
              Screen('DrawLine', win, white, start_coord + r*width_coeff, y_cood2, start_coord + r*width_coeff,  y_cood2+20, 1); %tick marks
              if find(r == survivingChoices)
                 DrawFormattedText(win, num2str(r), start_coord + r*width_coeff-10, y_cood2 + 70, white); %white numbers if selectable
              end
           end   
        elseif any(bigMatrix(i,:) == 10)
            for r = 1:max(perB)
                Screen('DrawLine', win, white, start_coord + r*width_coeff, y_cood2, start_coord + r*width_coeff,  y_cood2+20, 1); %tick marks
                if find(r == survivingChoices)
                   DrawFormattedText(win, num2str(r), start_coord + r*width_coeff-10, y_cood2 + 70, white); %white numbers if selectable
                end
            end
        end     
        
        if max(row)>greenValueSubj
            if any(bigMatrix(i,:) == 7)
                Screen('FillRect', win, grey, [start_coord+greenValueSubj*width_coeff y_cood1 start_coord+max(perA)*width_coeff y_cood2]);
                for rr = find(row > greenValueSubj)
                    Screen('DrawLine', win, grey, start_coord + row(rr)*width_coeff, y_cood2, start_coord + row(rr)*width_coeff,  y_cood2+20, 1);
                    DrawFormattedText(win, num2str(row(rr)), start_coord + row(rr)*width_coeff-10, y_cood2 + 70, grey);
                end
            elseif any(bigMatrix(i,:) == 10)
                Screen('FillRect', win, grey, [start_coord+greenValueSubj*width_coeff y_cood1 start_coord+max(perB)*width_coeff y_cood2]);
                for rr = find(row > greenValueSubj)
                    Screen('DrawLine', win, grey, start_coord + row(rr)*width_coeff, y_cood2, start_coord + row(rr)*width_coeff,  y_cood2+20, 1);
                    DrawFormattedText(win, num2str(row(rr)), start_coord + row(rr)*width_coeff-10, y_cood2 + 70, grey);
                end
            end
        end
            
            Screen('FrameRect', win, black, [start_coord+survivingChoices(pos)*width_coeff-6 y_cood1-2 start_coord+survivingChoices(pos)*width_coeff+6 y_cood2+2]);
 
            DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',1000,white);
            Screen('Flip',win);
        end
        
        %if Screenshot==1   
            %imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            %imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen3.jpg']) % imwrite is a Matlab function
       % end
        
        imp{j}(i) = survivingChoices(pos) %subject choice
        Sub_ch = survivingChoices(pos);
        
        %determine who won
        if compChoice > Sub_ch
            humanWin = 0
            payoff(trialnb,1) = 0;
        elseif compChoice < Sub_ch
            humanWin = 1
            payoff(trialnb,1) = greenValueSubj - Sub_ch;
        elseif compChoice == Sub_ch
            humanWin = randi([0 1], 1, 1) %assign 50% prob of winning in case of draw
            payoff(trialnb,1) = greenValueSubj - Sub_ch;
        end
        
        %Show post-choice info screen
        compChoiceString = num2str(compChoice);
        subjChoiceString = num2str(imp{j}(i));
        
        for r = 1:greenValueSubj %length(row)
            Screen('DrawLine', win, white, start_coord + r*width_coeff, y_cood2, start_coord + r*width_coeff,  y_cood2+20, 1);
            if find(r == survivingChoices)
                DrawFormattedText(win, num2str(r), start_coord + r*width_coeff-10, y_cood2 + 70, white);
            end
        end
        
        DrawFormattedText(win,condname{conditions{j}(i)},'center',200,white);
        if (conditions{j}(i) == 1) && (humanWin == 1) %BASE
            DrawFormattedText(win,'Hai vinto!','center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+(greenValueSubj)*width_coeff y_cood2]);
            Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
        elseif (conditions{j}(i) == 1) && (humanWin == 0) %BASE
            DrawFormattedText(win,'Hai perso!','center',300,white);
            Screen('FillRect', win, red, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
        elseif (conditions{j}(i) == 2) && (humanWin == 1) %SECONDA PUNTATA
            DrawFormattedText(win,['Hai vinto! \n \n Il computer ha giocato:  ' compChoiceString],'center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+compChoice*width_coeff y_cood2]);
            Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
            Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-5 y_cood1-2 start_coord+compChoice*width_coeff+5 y_cood2+2]);
        elseif (conditions{j}(i) == 2 && humanWin == 0) %SECONDA PUNTATA
            DrawFormattedText(win,['Hai perso! \n \n Hai giocato:  ' subjChoiceString],'center',300,white); %add subjChoice
            Screen('FillRect', win, red, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
        elseif (conditions{j}(i) == 3 && humanWin == 1) %PUNTATA VINCENTE
            DrawFormattedText(win,'Hai vinto!','center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1-2 start_coord+(greenValueSubj)*width_coeff y_cood2+2]);
            Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
        elseif (conditions{j}(i) == 3 && humanWin == 0) %PUNTATA VINCENTE
            DrawFormattedText(win,['Hai perso! \n \n Il computer ha giocato:  ' compChoiceString],'center',300,white);
            if greenValueSubj>compChoice
                Screen('FillRect', win, red, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
                Screen('FillRect', win, red, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+compChoice*width_coeff y_cood2]);
                Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
                Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
                Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-5 y_cood1-2 start_coord+compChoice*width_coeff+5 y_cood2+2]);
            elseif greenValueSubj<=compChoice
                Screen('FillRect', win, red, [start_coord y_cood1 start_coord+compChoice(end)*width_coeff y_cood2]);
                Screen('FillRect', win, white, [start_coord+Sub_ch*width_coeff-5 y_cood1-2 start_coord+Sub_ch*width_coeff+5 y_cood2+2]);
                Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-5 y_cood1-2 start_coord+compChoice*width_coeff+5 y_cood2+2]);
            end
        end
        DrawFormattedText(win,'Premi INVIO per passare alla prossima asta','center',1000,white);
        Screen('Flip',win);
        %if Screenshot==1   
            %imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            %imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen4.jpg']) % imwrite is a Matlab function
       % end
        RestrictKeysForKbCheck(enter)
        [secs, keyCode, deltaSecs] = KbWait([],2);
        
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
data = [subject, runnb, [1:trialnb]', cell2mat(conditions)', cell2mat(imp)', s_value,  c_choice, s_win, payoff];
% data = table(subject, runnb, [1:trialnb]', cell2mat(conditions)', cell2mat(imp)', s_value,  c_choice, s_win, payoff);
save(resultname, 'data');

final_payoff = [];
A = cell2mat(conditions);
for i=1:3
    idx = find(A==i+1);
    picktrial = randsample(length(idx),1);
    final_payoff = [final_payoff; payoff(idx(picktrial))] ;
end

sprintf('final payoff: %d\n', sum(final_payoff))

%Close screen
Screen('CloseAll');
sca;