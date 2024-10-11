% Read the contents of the CSV file "files.csv" into a table.
% The table is stored in the variable 'filestable'.
% The delimiter used in the CSV file is a comma.
filestable=readtable("files.csv", 'Delimiter', ',');
% This script is used for testing SLEAP analysis in MATLAB.
% The folder variable specifies the path to the directory where the SLEAP model export files are located.
% folder='E:\sleap\ModelSfn\export';
% files=dir(fullfile(folder,'*.h5'));
% Loop through each file in the filestable
% 
% Parameters:
%   filestable (table): A table containing file information.
% 
% Variables:
%   ifile (int): Index of the current file in the loop.
for ifile=1:height(filestable)
    fileexp=dir(char(filestable(ifile,:).export));
    filevid=dir(char(filestable(ifile,:).video));
    relativeTime=seconds(filestable(ifile,:).relativeTime);
    filenameexp=fileexp.name;
    folderexp=fileexp.folder;
    filenamevid=filevid.name;
    foldervid=filevid.folder;
    filepathexp=fullfile(folderexp,filenameexp);
    filepathvid=fullfile(foldervid,filenamevid);
    videoWithLabels=VideoWithLabels(filepathvid,filepathexp);
    ratontrack = RatCircularTrack(filepathexp);
    ratontrack=ratontrack.setCenter([500 500]);
    ff=logistics.FigureFactory.instance(folderexp);ff.ext={'.png'};ff.resolution=600;
    figure(1);clf
    % ratontrack1=ratontrack.getHeadPosition
    ax=gca;
    ax.ZDir="reverse";
    ax.XDir="reverse";
    ratontrack.plotRawTime;
    view(90,-60)
    ff.save(strcat(filenameexp,'_raw.png'))
    figure(2);clf; tiledlayout("vertical","TileSpacing","none");t1=nexttile;
    ratontrack.plotRawTime;xlabel('Time (m)')
    view(-30,0)
    t2=nexttile;
    ratontrack.plotAngleTime;xlabel('Time (m)');ylabel('Angular Position');
    ylim([-180 180]);
    t3=nexttile;
    ratontrack.plotHeadDirectionColor;ylabel('Angular Position');
    ylim([-180 180])
    t4=nexttile;
    ratontrack.plotHeadDirection;ylabel('Head Direction');
    ylim([0 180])
    linkaxes([t1 t2 t3 t4],'x')
    ff.save(strcat(filenameexp,'_angle+direction.png'))
    [headPosAbsX, headPosAbsY]=ratontrack.getHeadPositionAbsolute;
    headDirRel=ratontrack.getHeadDirectionRelativeToCenter;
    headPosAng=ratontrack.getHeadPositionAngle;
    TimeRelativeSec=(1:numel(headPosAbsX))/25+seconds(relativeTime);
    t1=array2table([TimeRelativeSec' headPosAbsX headPosAbsY ...
        headDirRel headPosAng],"VariableNames",{'TimeRelativeSec', ...
        'headPosAbsX','headPosAbsY','headDirRel','headPosAng'});
    save(strcat(fullfile(folderexp,filenameexp),'_position.mat'),'t1')
end
% head=ratontrack.getHeadPosition;
% 
% % Number of frames
% numFrames = size(ratontrack.Tracks, 1);
% 
% % Create a figure for the animation
%     clf; % Clear current figure window
% 
% for frameIndex = 5000:numFrames
%     positions = squeeze(ratontrack.Tracks(frameIndex, :, :, 1));
% 
%     hold on;
%     % plot(positions(:, 1), positions(:, 2), 'o'); % Plot points for current frame
% 
%     % Draw edges
%     for i = 1:size(positions, 1)-3
%         plot(positions(i:i+1, 1), positions(i:i+1, 2), 'k-');
%     end
% 
% end
%     xlabel('X Position');
%     ylabel('Y Position');
%     title(sprintf('Edges for Frame %d', frameIndex));
%     % pause(0.1); % Pause to create an animation effect
%     hold off;
