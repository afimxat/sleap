% Define the directory to be scanned
directory = 'E:\sleap\TrackModels\exports';

% Get a list of all files and folders in the directory
filesAndFolders = dir(directory);

% Open a file for writing
outputFile = 'E:\sleap\TrackModels\exports\directory_contents.csv';
fid = fopen(outputFile, 'w');

% Write the header line
fprintf(fid, 'Animal,Start Date,Start Time,Full Path,Session Details\n');

% Function to extract start time from the file name
function [startDate, startTime] = extractStartTime(fileName)
    % Assuming the start time is embedded in the file name in the format 'YYYYMMDD_HHMMSS'
    tokens = regexp(fileName, '(\d{8})_(\d{6})', 'tokens');
    if ~isempty(tokens)
        startDate = tokens{1}{1};
        startTime = tokens{1}{2};
    else
        startDate = 'Unknown';
        startTime = 'Unknown';
    end
end

% Loop through each item in the directory
for i = 1:length(filesAndFolders)
    % Skip the '.' and '..' folders
    if strcmp(filesAndFolders(i).name, '.') || strcmp(filesAndFolders(i).name, '..')
        continue;
    end
    
    % Check if the item is a folder (animal)
    if filesAndFolders(i).isdir
        animalName = filesAndFolders(i).name;
        animalFolder = fullfile(directory, animalName);
        
        % Get a list of all files and folders in the animal folder
        sessions = dir(animalFolder);
        
        % Loop through each session in the animal folder
        for j = 1:length(sessions)
            % Skip the '.' and '..' folders
            if strcmp(sessions(j).name, '.') || strcmp(sessions(j).name, '..')
                continue;
            end
            
            % Get the session name
            sessionName = sessions(j).name;
            
            % Determine if it is a file or folder
            if sessions(j).isdir
                startDate = 'N/A';
                startTime = 'N/A';
            else
                [startDate, startTime] = extractStartTime(sessionName);
            end
            
            % Get the full path
            fullPath = fullfile(directory, animalName, sessionName);
            
            % Write the information to the CSV file with an empty session details column
            fprintf(fid, '%s,%s,%s,%s,\n', animalName, startDate, startTime, fullPath);
        end
    end
end

% Close the file
fclose(fid);

disp('Directory contents have been written to directory_contents.csv with session details column');
