folder='D:\sleap\TrackModels\export';
filepath=fullfile(folder,"labels.v002.004_Basler_acA4024-29um__24844056__20240124_142448039_1.analysis.h5");
loader = RatCircularTrack(filepath);
head=loader.getHeadPosition;
% Number of frames
numFrames = size(loader.Tracks, 1);

% Create a figure for the animation
figure;
    clf; % Clear current figure window
ax=gca;
ax.YDir="reverse";
    axis equal;
for frameIndex = 5000:numFrames
    positions = squeeze(loader.Tracks(frameIndex, :, :, 1));
    
    hold on;
    % plot(positions(:, 1), positions(:, 2), 'o'); % Plot points for current frame
    
    % Draw edges
    for i = 1:size(positions, 1)-3
        plot(positions(i:i+1, 1), positions(i:i+1, 2), 'k-');
    end
    
end
    xlabel('X Position');
    ylabel('Y Position');
    title(sprintf('Edges for Frame %d', frameIndex));
    % pause(0.1); % Pause to create an animation effect
    hold off;
