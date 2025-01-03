classdef VideoWithLabels
    %VIDEOWITHLABELS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        video
        labels
        relativeTime
        channels
        units
        position
    end

    methods
        function obj = VideoWithLabels(videoFile,exportFile)
            %VIDEOWITHLABELS Construct an instance of this class
            %   Detailed explanation goes here
            obj.video = VideoReader(videoFile);
            ratontrack = RatCircularTrack(exportFile);
            obj.labels=ratontrack.setCenter([500 500]);
        end

        function outputvidpath = getVideoFor(obj,time,fig2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            framenumbers=round(seconds([time(1) time(1)+time(2)])*obj.video.FrameRate);
            framelist=framenumbers(1):framenumbers(2);
            framelistTime=seconds(double((1:numel(framelist))-1)/obj.video.FrameRate);
            a=obj.video.read(framenumbers);
            lbl=obj.labels;
            [headpx, headpy]=lbl.getHeadPositionAbsolute;
            headd=lbl.getHeadDirection;
            headdr=lbl.getHeadDirectionRelativeToCenter;
            color1=lbl.getDirectionColor;
            [~, name, ext] = fileparts(obj.video.Name);
            outputaudpath=fullfile(obj.video.Path,[name '_labeled_' num2str(framenumbers) '.wav']);
            try
                obj.saveMic(outputaudpath);
            catch
            end
            outputvidpath=fullfile(obj.video.Path,[name '_labeled_' num2str(framenumbers) ext]);
            outputVideo = VideoWriter(outputvidpath, 'MPEG-4'); % Create a new video file
            outputVideo.FrameRate = obj.video.FrameRate; % Set the frame rate (frames per second)
            open(outputVideo); % Open the video file for writing

            st_relative=seconds(obj.position.table.TimeRelativeSec(1));
            firingRates=obj.getFiringRatesNormalizedFor(framelistTime+st_relative,seconds(.05));
            for iframe=1:size(a,4)
                frame1=a(:,:,:,iframe);
                % Add extra space on the right of the frame
                frame1 = padarray(frame1, [0, 700, 0], 'post');
                
                frno=framelist(iframe);
                x =headpx(frno);
                y=headpy(frno);
                dir1=headd(frno);
                drrel=headdr(frno);
                theta_rad = deg2rad(dir1); % Convert angle from degrees to radians
                l1=50;
                % Calculate half-length
                half_length = l1 / 2;

                % Calculate the change in x and y
                dx = half_length * cos(theta_rad);
                dy = half_length * sin(theta_rad);

                % Determine the start and end points of the line
                x_start = x - dx;
                y_start = y - dy;
                x_end = x + dx;
                y_end = y + dy;
                [mx,my]=lbl.getHeadPositionAbsolute;
                try
                    frame1=insertShape(frame1,'line',round([ ...
                        lbl.Center(1) lbl.Center(2) ;mx(frno)  my(frno)]), ...
                        'LineWidth',2,'ShapeColor','red','Opacity',.5);
                catch
                end
                try
                    frame1=insertShape(frame1,'line',round([x_start y_start ;x_end  y_end]), ...
                        'LineWidth',5,'ShapeColor',color1(frno,:),'Opacity',.5);
                catch
                end
                try
                    frame1=insertShape(frame1,'circle',[lbl.Center(1) lbl.Center(2) 450], ...
                        'LineWidth',3,'ShapeColor','white','Opacity',.5);
                catch
                end
                % fig2=figure(2);
                ax2=gca;
                windtime=seconds(st_relative)+iframe*.04;
                windst=windtime-1;
                windend=windtime;
                ax2.XLim=[windst windend];
                angvel=obj.position.getAngularVel;
                ax2.YLim=[min(angvel) max(angvel)];
                fig2frame=getframe(fig2);
                fig2frame2 = imresize(fig2frame.cdata, [1000, 700]);
                % fig2frame2 = fig2frame.cdata;
                position1=[1000 1];
                try
                    frame1(position1(2):position1(2) + ...
                        size(fig2frame2, 1) - 1, ...
                        position1(1):position1(1) + ...
                        size(fig2frame2, 2) - 1, :) = fig2frame2;
                catch
                end
                % 
                % fns=fieldnames(firingRates);
                % colormaps={'bone','hot','parula'};
                % for iprobe=1:numel(fns)
                %     firingRatesP=firingRates.(fns{iprobe});
                % 
                %     % Create a figure for the square matrix plot
                %     fig = figure('Visible', 'off');
                %     thisframefr=firingRatesP(:, iframe);
                %     % Calculate the number of rows for the matrix
                %     numRows = ceil(sqrt(numel(thisframefr)));
                %     % Pad with NaN values to make the number of elements divisible by numRows
                %     padSize = numRows^2 - numel(thisframefr);
                %     thisframefr = [thisframefr; nan(padSize, 1)];
                %     firingRatesMatrix = reshape(thisframefr, numRows, []);
                %     imagesc(firingRatesMatrix);
                %     colormap(colormaps{iprobe});
                %     clim([0 1])
                %     % colorbar;
                %     % title('Firing Rates Matrix');
                %     axis square;
                %     ax=gca;
                %     % ax.Box="off";
                %     % ax.XTick=[];
                %     % ax.YTick=[];
                %     % Capture the plot as an image
                %     framePlotMatrix = getframe(ax);
                %     close(fig);
                % 
                %     % Resize the plot image to fit on the frame
                %     plotImageMatrix = imresize(framePlotMatrix.cdata, [100, 100]);
                % 
                %     % Determine the position to insert the plot
                %     positionMatrix = round([mean([mx(frno) lbl.Center(1)])-150+(iprobe-1)*120, ...
                %         mean([my(frno) lbl.Center(2)])]);
                % 
                %     % Insert the plot image onto the frame
                %     % frame1 = insertShape(frame1, 'FilledRectangle', [positionMatrix, size(plotImageMatrix, 2), size(plotImageMatrix, 1)], 'Color', 'black', 'Opacity', 0.6);
                %     % frame1 = insertText(frame1, positionMatrix + [10, 10], 'Firing Rates Matrix', 'FontSize', 18, 'BoxColor', 'black', 'BoxOpacity', 0.4, 'TextColor', 'white');
                %     try
                %         frame1(positionMatrix(2):positionMatrix(2) + ...
                %             size(plotImageMatrix, 1) - 1, ...
                %             positionMatrix(1):positionMatrix(1) + ...
                %             size(plotImageMatrix, 2) - 1, :) = plotImageMatrix;
                %     catch
                %     end
                % end
                writeVideo(outputVideo, frame1);
                % Display progress
                progress = iframe / size(a, 4) * 100;
                fprintf('Processing frame %d of %d (%.2f%% complete)\n', iframe, size(a, 4), progress);
            end
            close(outputVideo);
        end

        function fr = getFiringRatesFor(obj,time,winsize)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fr.aud=obj.units.aud.getFiringRates(time,winsize);
            fr.vis=obj.units.vis.getFiringRates(time,winsize);
        end
        function fr = getFiringRatesNormalizedFor(obj,time,winsize)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fr.aud=obj.units.aud.getFiringRates(time,winsize);
            % Normalize each row between 0 to 1
            fr.aud = (fr.aud - min(fr.aud, [], 2)) ./ (max(fr.aud, [], 2) - min(fr.aud, [], 2));

            fr.vis=obj.units.vis.getFiringRates(time,winsize);
            % Normalize each row between 0 to 1
            fr.vis = (fr.vis - min(fr.vis, [], 2)) ./ (max(fr.vis, [], 2) - min(fr.vis, [], 2));
        end

        function outputvidpath = getLFPsFor(obj,time)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            timest=time(1)-obj.relativeTime;
            dur=time(2);
            outputvidpath=obj.getVideoFor([timest dur]);
        end
        function outputvidpath = getVideoForRelativeTime(obj,time,fig2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            timest=time(1)-obj.relativeTime;
            dur=time(2);
            outputvidpath=obj.getVideoFor([timest dur],fig2);
        end
        function []= saveMic(obj,filename1)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            array1=obj.channels.micfilt.data;
          
            % Demean the data
            mic_demeaned = array1 - mean(array1);

            % Normalize the data to the range [-1, 1]
            mic_normalized = mic_demeaned / max(abs(mic_demeaned));

            % Define the sample rate
            sample_rate = 30000; % 30 kHz

            % Save the processed data as a WAV file
            audiowrite(filename1, mic_normalized, sample_rate);
        end
    end
end

