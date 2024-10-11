classdef VideoWithLabels
    %VIDEOWITHLABELS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        video
        labels
    end
    
    methods
        function obj = VideoWithLabels(videoFile,exportFile)
            %VIDEOWITHLABELS Construct an instance of this class
            %   Detailed explanation goes here
            obj.video = VideoReader(videoFile);
            ratontrack = RatCircularTrack(exportFile);
            obj.labels=ratontrack.setCenter([500 500]);
        end
        
        function outputvidpath = getVideoFor(obj,time)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            framenumbers=seconds([time(1) time(1)+time(2)])*obj.video.FrameRate;
            framelist=framenumbers(1):framenumbers(2);
            a=obj.video.read(framenumbers);
            lbl=obj.labels;
            [headpx, headpy]=lbl.getHeadPositionAbsolute;
            headd=lbl.getHeadDirection;
            headdr=lbl.getHeadDirectionRelativeToCenter;
            color1=lbl.getDirectionColor;
            [~, name, ext] = fileparts(obj.video.Name);
            outputvidpath=fullfile(obj.video.Path,[name '_labeled_' num2str(framenumbers) ext]);
            outputVideo = VideoWriter(outputvidpath, 'MPEG-4'); % Create a new video file
            outputVideo.FrameRate = obj.video.FrameRate; % Set the frame rate (frames per second)
            open(outputVideo); % Open the video file for writing

            for iframe=1:size(a,4)
                frame1=a(:,:,:,iframe);
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
                % Write the frame to the video
                writeVideo(outputVideo, frame1);
            end
            close(outputVideo);
        end
    end
end

