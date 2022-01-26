%clear all
close all
clc

% Morse database
morse = [".-" "-..." "-.-." "-.." "." "..-." "--." "...." ".." ".---" "-.-" ".-.." "--" "-." ...
    "---" ".--." "--.-" ".-." "..." "-" "..-" "...-" ".--" "-..-" "-.--" "--.." ".--.-" ".-.-" "---." "-----" ".----" ...
    "..---" "...--" "....-" "....." "-...." "--..." "---.." "----." "space" ".-.-.-" "--..--" "..--.." ...
    "-....-" "-..-." "---..." ".----." "-....-" "-.--.-" "-.-.-" "-.--." "-...-" ".--.-." ".-.-." "...---..."];
% Equivalent character database, same order as database above
char = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'å' 'ä' 'ö' ...
    '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' ' ' '.' ',' '?' '-' '/' ':' "'" '-' ')' ';' '(' '=' '@' 'END' 'SOS'];

% Import audio file, add possibility to record sound
[y,Fs] = audioread('jagheterper.wav'); % Original är ? WPM och 500 Hz
%sound(y,Fs); % play sound

% Handle sound signal
y = bandpass(inspelad,[400 600],8000); %smoothdata(y); % Smoothens sound waves
% Add filter to only store morse frequency

occurrenceLength = zeros(1,length(y));
counter = 1;

% Get an occurrence vector of all dit and dah
for k = 1:length(y)
    if y(k) ~= 0
        occurrenceLength(counter) = occurrenceLength(counter) + 1;
    else
        counter = counter + 1;
    end
end


% Loop variables
counter = 1; % Reset counter
zeroCounter = 0;
result = '';
occurrence = zeros(1,length(y));

% Morse constants
LONG = max(max(occurrenceLength)); % Define how long a dah is, might not be the best way to define dah
SHORT = LONG / 3; % Define how long a dit is
letterSpace = 4 * SHORT; % Define how long spaces between letters are
wordSpace = 8 * SHORT; % Define how long spaces between words are


uncertainty = 40 / 100; % Uncertainty percentage

for k = 1:length(y)
    if abs(y(k)) ~=0
        occurrence(counter) = occurrence(counter) + 1;


        if abs(zeroCounter - wordSpace) < uncertainty * wordSpace % Space between words
            result = [result ' space '];
        elseif abs(zeroCounter - letterSpace) < uncertainty * letterSpace % Space between letters
            result = [result ' '];
        end
        zeroCounter = 0;
    else
        if abs(occurrence(counter) - SHORT) < uncertainty * SHORT % Test if dit
            result = [result '.'];
        elseif abs(occurrence(counter) - LONG) < uncertainty * LONG % Test if dah
            result = [result '-'];
        end
        counter = counter + 1;
        zeroCounter = zeroCounter + 1;
    end
end

result = strtrim(result)
inputArray = strsplit(result, ' '); % Split result to array of morse letters




res = '';

% Loop through every morse letter and translate
for k = 1:length(inputArray)
    exact = strcmp(morse, string(inputArray(k))); % Set true where in morse array the written morse letter is, returns vector
    loc = find(exact); % Get number of where vector above has true
    
    res = strcat(res,char(loc)); % Add character at above position of database to the result
end

fprintf('Morsekoden är: %s\n', res);

% recObj = audiorecorder;
% disp('Start speaking.')
% recordblocking(recObj, 60);
% disp('End of Recording.');
% 
% %play(recObj);
% 
% inspelad = getaudiodata(recObj);








































