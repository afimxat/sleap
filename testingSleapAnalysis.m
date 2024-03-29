

folder='D:\sleap\TrackModels\export';
files=dir(fullfile(folder,'*.h5'));
for ifile=1:numel(files)
    filename1=files(ifile).name;
    filepath=fullfile(folder,filename1);
    ratontrack = RatCircularTrack(filepath);
    ratontrack=ratontrack.setCenter([550 500]);
    ff=logistics.FigureFactory.instance(folder);ff.ext={'.png'};ff.resolution=600;
    figure(1);clf
    % ratontrack1=ratontrack.getHeadPosition
    ax=gca;
    ax.ZDir="reverse";
    ax.XDir="reverse";
    ratontrack.plotRawTime;
    view(90,-60)
    ff.save(strcat(filename1,'_raw.png'))
    figure(2);clf; tiledlayout("vertical","TileSpacing","none");t1=nexttile;
    ratontrack.plotRawTime;
    view(-30,0)
    t2=nexttile;
    ratontrack.plotAngleTime;
    t3=nexttile;
    ratontrack.plotHeadDirectionColor;
    t4=nexttile;
    ratontrack.plotHeadDirection;
    linkaxes([t1 t2 t3 t4],'x')
    ff.save(strcat(filename1,'_angle+direction.png'))
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
