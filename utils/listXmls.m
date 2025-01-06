% Specify the base directory
baseDir = 'R:\Research Storage\DataBackup\utku\C4\ephys';

% Get a list of all folders under the base directory
allFolders = dir(fullfile(baseDir, '**'));

% Filter out directories and locate folders with settings*.xml
settingsFolders = {};
for i = 1:length(allFolders)
    % Skip non-folder entries
    if ~allFolders(i).isdir
        continue;
    end
    
    % Check if settings*.xml exists in the current folder
    folderPath = fullfile(allFolders(i).folder, allFolders(i).name);
    if ~isempty(dir(fullfile(folderPath, 'settings*.xml')))
        settingsFolders{end+1} = folderPath; %#ok<SAGROW>
    end
end

% Initialize a cell array to store XML file paths
xmlFiles = {};

% Loop through each folder containing settings*.xml
for i = 1:length(settingsFolders)
    % Locate experiment* folders under this settings folder
    experimentFolders = dir(fullfile(settingsFolders{i}, 'experiment*'));
    
    % Loop through each experiment* folder
    for j = 1:length(experimentFolders)
        % Construct the full path of the current experiment* folder
        experimentPath = fullfile(experimentFolders(j).folder, experimentFolders(j).name);
        
        % Find all XML files in this folder
        files = dir(fullfile(experimentPath, '*.xml'));
        
        % Add the XML file paths to the list
        for k = 1:length(files)
            xmlFiles{end+1} = fullfile(files(k).folder, files(k).name); %#ok<SAGROW>
        end
    end
end

% Display the list of XML files
disp('List of XML files:');
disp(xmlFiles');
