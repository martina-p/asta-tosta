function astatosta
% Script to run "asta tosta" game
% Martina Puppi & Nadège Bault, June 2016

%% Set things up

% Take screenshot
Screenshot=0;      % 1 to take screenshots in each trial, 0 to not take any screenshot
if Screenshot==1 && ~isdir('Screenshots')
    mkdir('Screenshots')
end

% Set Logfiles
iSubject=input('Participant number: ');
DateTime = datestr(now,'yyyymmdd-HHMM');
if ~exist('Logfiles', 'dir')
    mkdir('Logfiles');
end
resultname = fullfile('Logfiles', strcat('Sub',num2str(iSubject),'_', DateTime, '.mat'));
backupfile = fullfile('Logfiles', strcat('Bckup_Sub',num2str(iSubject), '_', DateTime, '.mat')); %save under name composed by number of subject and session

KbName('UnifyKeyNames');

% Screen Preferences
Screen('Preference', 'VBLTimestampingMode', 3); %Add this to avoid timestamping problems
Screen('Preference', 'DefaultFontName', 'Geneva');
Screen('Preference', 'DefaultFontSize', 30); %fontsize
Screen('Preference', 'DefaultFontStyle', 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend,1+2=bold and italic
%Screen('Preference', 'DefaultTextYPositionIsBaseline', 1); % align text on a line

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
% keyLeft=KbName('leftArrow'); % Left arrow
% keyRight=KbName('rightArrow'); % Right arrow
enter=KbName('return'); % Enter
% space=KbName('space'); % Space

%% Trials organization
A = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
Ashuffled=A(randperm(length(A)));
Bshuffled=A(randperm(length(A)));
Cshuffled=A(randperm(length(A)));

Practice = [1 2 3];
conditions = {Practice, Ashuffled, Bshuffled, Cshuffled};
nrRuns = length(conditions);

% Instruction messages
instr1 = 'Benvenuto! \n \n Premi INVIO per cominciare 3 turni di prova.';
% pressEnter_msg = 'Premi INVIO per continuare con le istruzioni';
% pressTrial_msg = 'Premi INVIO per cominciare la prova';
message = {'Fine della prova. \n \n Premi INVIO per cominciare l''esperimento'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Pausa. \n \n Premi INVIO per continuare.'
    'Fine del gioco!'};

% conmsg = {'La prossima asta sarà: \n \n BASE'
%     'La prossima asta sarà: \n \n SECONDA PUNTATA'
%     'La prossima asta sarà: \n \n PUNTATA VINCENTE'};

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
lookup{6} = 2; lookup{12} = 7; lookup{15} = 9; lookup{19} = 11; lookup{9} = 5;

% Computer choices Nash equilibrium B
lookup{5} = 1; lookup{8} = 4; lookup{11} = 6; lookup{14} = 8; lookup{18} = 10;

%% Start exp
% Open PTB
screens=Screen('Screens');
Screen('Preference', 'SkipSyncTests', 2);
screenNumber=max(screens); % Main screen
% winRect = [0,0,1680,1050];
[win,winRect] = Screen('OpenWindow',screenNumber,black);

% Instructions (minimal)
RestrictKeysForKbCheck(enter); % to restrict key presses to enter
DrawFormattedText(win,instr1,'center','center',white);
Screen('Flip',win);
[secs, keyCode, deltaSecs] = KbWait([],2);  %#ok<*ASGLU>

%% Trial loop
trialnb = 0;

for j=1:nrRuns
    nrTrials = length(conditions{j});
    for i=1:nrTrials
        save(backupfile)   % backs the entire workspace up just in case we have to do a nasty abort
        trialnb = trialnb + 1;
        runnb(trialnb,1) = j; %#ok<*AGROW>
        
        %         DrawFormattedText(win, conmsg{conditions{j}(i)},'center','center',white);
        %         Screen('Flip',win);
        %         WaitSecs(.2);
        
        if any(bigMatrix(i,:) == 7)
            valueObj = valueObjA;
        elseif any(bigMatrix(i,:) == 10)
            valueObj = valueObjB;
        end
        
        permvalueObj = valueObj(randperm(5));
        greenValueSubj = datasample(valueObj,1);
        greenValue = datasample(valueObj,1);
        row = bigMatrix(i,:); %set of options
        survivingChoices = row(row <= greenValueSubj);
        
        compChoice = lookup{greenValue};
        disp_values
        
        %%
        %         RestrictKeysForKbCheck(enter); % to restrict key presses to enter
        %         DrawFormattedText(win,'Premi INVIO per continuare','center',1000,white);
        Screen('Flip',win);
        WaitSecs(1);
        %         [secs, keyCode, deltaSecs] = KbWait([],2);
        %         RestrictKeysForKbCheck([]); % to restrict key presses to enter
        
        if Screenshot==1
            imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) 'Screen1.jpg']) % imwrite is a Matlab function
        end
        
        disp_values
        disp_bars
        disp_ticks
        
        %% Cursor
        %random placement of cursor
        randomcursor = datasample(survivingChoices,1);
        disp_cursor(randomcursor)
        
        DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',1000,white);
        keyCode = []; %#ok<NASGU>
        keyName=''; % empty initial value
        Screen('Flip',win);
        
        if Screenshot==1
            imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen2.jpg']) % imwrite is a Matlab function
        end
        
        %% Selection
        Time_start = GetSecs;
        pos = find(survivingChoices==randomcursor);
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
            
            disp_values;
            disp_bars;
            disp_ticks;
            disp_cursor(survivingChoices(pos));
            DrawFormattedText(win,'Premi SPAZIO per confermare la tua scelta','center',1000,white);
            Screen('Flip',win);
        end
        
        Time_end = GetSecs;
        Choice_RT(trialnb,1) = Time_end - Time_start;
        
        if Screenshot==1
            imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen3.jpg']) % imwrite is a Matlab function
        end
        
        imp{j}(i) = survivingChoices(pos); %subject choice
        Sub_ch = survivingChoices(pos);
        
        %% determine who won
        if compChoice > Sub_ch
            humanWin = 0;
            payoff(trialnb,1) = 0;
        elseif compChoice < Sub_ch
            humanWin = 1;
            payoff(trialnb,1) = greenValueSubj - Sub_ch;
        elseif compChoice == Sub_ch
            humanWin = randi([0 1], 1, 1); %assign 50% prob of winning in case of draw
            payoff(trialnb,1) = greenValueSubj - Sub_ch;
        end
        
        %% Show post-choice info screen
        compChoiceString = num2str(compChoice);
        subjChoiceString = num2str(imp{j}(i));
        
        disp_ticks;
        DrawFormattedText(win, num2str(greenValueSubj), start_coord + greenValueSubj*width_coeff-10, y_cood2 + 50, green);
        
        DrawFormattedText(win,condname{conditions{j}(i)},'center',200,white);
        if (conditions{j}(i) == 1) && (humanWin == 1) %BASE
            DrawFormattedText(win,'Hai vinto!','center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+(greenValueSubj)*width_coeff y_cood2]);
            disp_cursor(Sub_ch)
        elseif (conditions{j}(i) == 1) && (humanWin == 0) %BASE
            DrawFormattedText(win,'Hai perso!','center',300,white);
            Screen('FillRect', win, red, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            disp_cursor(Sub_ch)
        elseif (conditions{j}(i) == 2) && (humanWin == 1) %SECONDA PUNTATA
            DrawFormattedText(win,['Hai vinto! \n \n Il computer ha giocato:  ' compChoiceString],'center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+compChoice*width_coeff y_cood2]);
            Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            disp_cursor(Sub_ch)
            Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-7 y_cood1-10 start_coord+compChoice*width_coeff+7 y_cood2+10]);
        elseif (conditions{j}(i) == 2 && humanWin == 0) %SECONDA PUNTATA
            DrawFormattedText(win,['Hai perso! \n \n Hai giocato:  ' subjChoiceString],'center',300,white); %add subjChoice
            Screen('FillRect', win, red, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
            disp_cursor(Sub_ch)
        elseif (conditions{j}(i) == 3 && humanWin == 1) %PUNTATA VINCENTE
            DrawFormattedText(win,'Hai vinto!','center',300,white);
            Screen('FillRect', win, white, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
            Screen('FillRect', win, green, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+(greenValueSubj)*width_coeff y_cood2]);
            disp_cursor(Sub_ch)
        elseif (conditions{j}(i) == 3 && humanWin == 0) %PUNTATA VINCENTE
            DrawFormattedText(win,['Hai perso! \n \n Il computer ha giocato:  ' compChoiceString],'center',300,white);
            if greenValueSubj>compChoice
                Screen('FillRect', win, red, [start_coord y_cood1 start_coord+Sub_ch*width_coeff y_cood2]);
                Screen('FillRect', win, red, [start_coord+Sub_ch*width_coeff y_cood1 start_coord+compChoice*width_coeff y_cood2]);
                Screen('FillRect', win, blue, [start_coord+compChoice*width_coeff y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
                disp_cursor(Sub_ch)
                Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-7 y_cood1-10 start_coord+compChoice*width_coeff+7 y_cood2+10]);
            elseif greenValueSubj<=compChoice
                Screen('FillRect', win, red, [start_coord y_cood1 start_coord+compChoice(end)*width_coeff y_cood2]);
                disp_cursor(Sub_ch)
                Screen('FillRect', win, grey, [start_coord+compChoice*width_coeff-7 y_cood1-10 start_coord+compChoice*width_coeff+7 y_cood2+10]);
            end
        end
        DrawFormattedText(win,'Premi INVIO per passare alla prossima asta','center',1000,white);
        Screen('Flip',win);
        
        if Screenshot==1
            imageArray = Screen('GetImage', win); % GetImage call. Alter the rect argument to change the location of the screen shot
            imwrite(imageArray, ['Screenshots\Trial' num2str(trialnb) '_Screen4.jpg']) % imwrite is a Matlab function
        end
        
        RestrictKeysForKbCheck(enter)
        [secs, keyCode, deltaSecs] = KbWait([],2);
        
        s_value(trialnb,1) = greenValueSubj;
        s_fulloptions{trialnb} = row;
        s_options{trialnb} = survivingChoices;
        c_choice(trialnb,1) = compChoice;
        s_win(trialnb,1) = humanWin;
    end
    
    %% Insert breaks after block 1 and block 2
    DrawFormattedText(win,message{j},'center','center',white);
    Screen('Flip',win);
    RestrictKeysForKbCheck(enter); % to restrict key presses to enter
    [secs, keyCode, deltaSecs] = KbWait([],2);
    RestrictKeysForKbCheck([]); %to turn of key presses restriction
    
end

%% save data
subject(1:trialnb,1) = iSubject;
data = [subject, runnb, [1:trialnb]', cell2mat(conditions)', cell2mat(imp)', s_value,  Choice_RT, c_choice, s_win, payoff, s_fulloptions, s_options]; %#ok<NBRAK,NASGU>
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

%% display functions
    function disp_values
        pos_horz = [1000 1100 1200 1300 1400];
        DrawFormattedText(win,condname{conditions{j}(i)},'center',350,white);
        DrawFormattedText(win,'Possibili valori oggetto:',550,450,white)
        for tt=1:5
            DrawFormattedText(win, num2str(permvalueObj(1,tt)),pos_horz(tt),450,white)
        end
        DrawFormattedText(win, num2str(greenValueSubj),pos_horz(greenValueSubj == permvalueObj),450,green);
    end

    function disp_bars
        Screen('FillRect', win, white, [start_coord y_cood1 start_coord+greenValueSubj*width_coeff y_cood2]);
    end

    function disp_ticks
        
        % Draw the tick marks and numbers underneath NEW
        for rr = 1:greenValueSubj
            Screen('DrawLine', win, white, start_coord + rr*width_coeff, y_cood2, start_coord + rr*width_coeff,  y_cood2+20, 1); %tick marks
            if find(rr == survivingChoices)
                Screen('TextStyle',win, 1);
                DrawFormattedText(win, num2str(rr), start_coord + rr*width_coeff-10, y_cood2 + 50, white); %white numbers if selectable
            end
            Screen('TextStyle',win, 0);
            %           DrawFormattedText(win, num2str(greenValueSubj), start_coord + greenValueSubj*width_coeff-10, y_cood2 + 50, green);
        end
        
        %Gray out unbiddable values
        if max(row)>greenValueSubj
            Screen('FillRect', win, grey, [start_coord+greenValueSubj*width_coeff y_cood2-5 start_coord+max(bigMatrix(i,:))*width_coeff y_cood2]); %bar
            for rrr = find(row > greenValueSubj)
                Screen('DrawLine', win, grey, start_coord + row(rrr)*width_coeff, y_cood2, start_coord + row(rrr)*width_coeff,  y_cood2+20, 1) %tick marks; %grey ticks
                DrawFormattedText(win, num2str(row(rrr)), start_coord + row(rrr)*width_coeff-10, y_cood2 + 50, grey); %gnumbers
            end
        end
    end

    function disp_cursor(horiz_pos)
        Screen('FillRect', win, white, [start_coord+horiz_pos*width_coeff-7 y_cood1-16 start_coord+horiz_pos*width_coeff+7 y_cood2+16]);
        Screen('FrameRect', win, black, [start_coord+horiz_pos*width_coeff-8 y_cood1-16 start_coord+horiz_pos*width_coeff+8 y_cood2+16]);
    end

end