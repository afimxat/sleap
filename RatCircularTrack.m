classdef RatCircularTrack < SleapHDF5Loader
    properties
        % Add properties specific to RatCircularTrack analysis here
        PositionTable
        Center
        Radius
        HeadDirection
    end

    methods
        % Constructor
        function obj = RatCircularTrack(filePath)
            % Call superclass constructor
            obj@SleapHDF5Loader(filePath);
            % Initialization code specific to RatCircularTrack
                        % Preallocate table
            numFrames = size(obj.Tracks, 1);
            numNodes = size(obj.Tracks, 2);

            % Flatten the data for table conversion
            [frames, nodes] = ndgrid(1:numFrames, 1:numNodes);
            xCoordinates = squeeze(obj.Tracks(:, :, 1));
            yCoordinates = squeeze(obj.Tracks(:, :, 2));

            % Creating the table
            obj.PositionTable = table(frames(:), nodes(:), xCoordinates(:), yCoordinates(:), ...
                'VariableNames', {'Frame', 'Node', 'XCoordinate', 'YCoordinate'});
            obj.PositionTable.PointScores= reshape( obj.PointScores,[],1);
            obj.PositionTable.InstanceScores= repmat( obj.InstanceScores,4,1);
            obj.Tracks=[];
            obj.PointScores=[];
            obj.TrackOccupancy=[];
            obj.TrackingScores=[];
        end

        % Example method to calculate center of circular track
        function obj = plotRawTime(obj)
            pbaspect([15 1 1])
            hold on
            pt=obj.PositionTable;
            color1=linspecer(20,'sequential');
            size1=[2 5 10 1]*3;
            alpha=[.5 .2 .1 .1];
            fr=25;
            nodes=unique(pt.Node);
            for inode=1:numel(nodes)
                pt1=pt(pt.Node==inode,:);
                x1=pt1.XCoordinate;
                y1=pt1.YCoordinate;
                time1=pt1.Frame/fr/60;
                scatter3(time1,x1,y1,size1(inode),color1(inode,:), ...
                    "filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
            end
            scatter3(time1, ...
                ones(size(time1))*obj.Center(1), ...
                ones(size(time1))*obj.Center(2), ...
                30,[.5 .5 .5],"filled", ...
                MarkerEdgeAlpha=.5,MarkerFaceAlpha=.5);
            ax=gca;
            ax.YLim=[0 1000];
            ax.ZLim=[0 1000];
        end        % Example method to calculate center of circular track
        function pos = getAngularPosition(obj)
            pt=obj.PositionTable;
            nodes=unique(pt.Node);
            pos=[];
            for inode=1:numel(nodes)
                pt1=pt(pt.Node==inode,:);
                x1=pt1.XCoordinate;
                y1=pt1.YCoordinate;
                % Adjust coordinates to be relative to the center
                x_relative = x1 - obj.Center(1);
                y_relative = y1 - obj.Center(2);

                % Calculate the angle in radians
                angleRadians = -atan2(y_relative, x_relative);
                % Convert the angle to degrees
                angleDegrees = rad2deg(angleRadians);
                % Adjust angles to be within the range [0, 360) if necessary
                pos=[pos;angleDegrees]; %#ok<AGROW>
            end
        end
        function obj = plotAngleTime(obj)
            pbaspect([15 1 1])
            hold on
            pt=obj.PositionTable;
            color1=linspecer(20,'sequential');
            size1=[5 5 1 1]*3;
            alpha=[.1 .5 .1 .1];
            fr=25;
            nodes=unique(pt.Node);
            for inode=1:numel(nodes)
                pt1=pt(pt.Node==inode,:);
                time1=pt1.Frame/fr/60;
                scatter(time1,pt1.AngularPosition,size1(inode),color1(inode,:), ...
                    "filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
            end
        end
        function [mx,my]= getHeadPositionAbsolute(obj)
            pt=obj.PositionTable;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 1: Calculate the midpoint M
            mx = (x1 + x2) / 2;
            my = (y1 + y2) / 2;
        end
        function angleDegrees = getHeadPositionAngle(obj)
            [mx,my]=obj.getHeadPositionAbsolute;
            % Adjust coordinates to be relative to the center
            x_relative = mx - obj.Center(1);
            y_relative = my - obj.Center(2);

            % Calculate the angle in radians
            angleRadians = -atan2(y_relative, x_relative);
            % Convert the angle to degrees
            angleDegrees = rad2deg(angleRadians);
        end
        function vectorAngleDegrees = getHeadDirection(obj)
            pt=obj.PositionTable;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 2: Calculate the direction (angle) of the vector from P1 to P2
            vectorAngleDegrees = rad2deg(atan2(y2 - y1, x2 - x1));

        end
        function obj = plotHeadDirectionColor(obj)
            ax=gca;
            pbaspect([20 1 1])
            hold on
            fr=25;
            angleDegrees=obj.getHeadPositionAngle;
            [colorVector, hsvColors]= obj.getDirectionColor;
            % % Ensure the angle is within the range [0, 180]
            % if angleBetweenVectors > 180
            %     angleBetweenVectors = 360 - angleBetweenVectors;
            % end
            time1=obj.PositionTable(obj.PositionTable.Node==1,:).Frame/fr/60;
            s=scatter(time1,angleDegrees,ones(size(time1))*5,colorVector, ...
                "filled", MarkerEdgeAlpha=.2,MarkerFaceAlpha=.2);
            colormap(hsvColors);
            cb=colorbar;cb.Ticks=[0 .25 .5 .75 1]; cb.TickLabels={'Inside', 'Reverse', 'Outside','Forward','Inside'};
        end
        function [colorVector, hsvColors]= getDirectionColor(obj)

            % Normalize angle to [0, 1]
            normalizedAngle = obj.HeadDirection / 360;

            % Generate HSV colormap
            numColors = 256; % You can adjust the number of colors
            hsvColors = hsv(numColors);

            % Map normalized angle to the colormap
            % Ensure the indices are within the valid range of the colormap
            colorIndices = ceil(normalizedAngle * (numColors - 1)) + 1;
            colorIndices(isnan(colorIndices))=1;
            colorVector = hsvColors(colorIndices, :);
        end

        function angleBetweenVectors = getHeadDirectionRelativeToCenter(obj)
            pt=obj.PositionTable;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 1: Calculate the midpoint M
            mx = (x1 + x2) / 2;
            my = (y1 + y2) / 2;
            % Adjust coordinates to be relative to the center
            x_relative = mx - obj.Center(1);
            y_relative = my - obj.Center(2);

            % Calculate the angle in radians
            angleRadians = -atan2(y_relative, x_relative);
            % Convert the angle to degrees
            angleDegrees = rad2deg(angleRadians);

            % Step 2: Calculate the direction (angle) of the vector from P1 to P2
            vectorAngleDegrees = rad2deg(atan2(y2 - y1, x2 - x1));

            % Calculate vector from center to midpoint
            cx = mx - obj.Center(1);
            cy = my - obj.Center(2);

            % Calculate the direction (angle) of this vector
            centerToMidpointAngleDegrees = rad2deg(atan2(cy, cx));

            % Step 3: Calculate the angle between the two vectors
            angleBetweenVectors = mod(centerToMidpointAngleDegrees - vectorAngleDegrees, 360);
        end
        function angularSpeed = getAngularSpeed(obj)
           
        end
        function obj = plotHeadDirection(obj)
            pbaspect([20 1 1])
            hold on
            pt=obj.PositionTable;
            fr=25;
            pt1=pt(pt.Node==1,:);

            angleBetweenVectors=obj.getHeadDirectionRelativeToCenter;
            % Normalize angle to [0, 1]
            normalizedAngle = angleBetweenVectors / 360;

            % Generate HSV colormap
            numColors = 256; % You can adjust the number of colors
            hsvColors = hsv(numColors);

            % Map normalized angle to the colormap
            % Ensure the indices are within the valid range of the colormap
            colorIndices = ceil(normalizedAngle * (numColors - 1)) + 1;
            colorIndices(isnan(colorIndices))=1;
            colorVector = hsvColors(colorIndices, :);

            time1=pt1.Frame/fr/60;

            scatter(time1,abs(mod(angleBetweenVectors+180,360)-180),ones(size(time1))*5,colorVector, ...
                "filled", MarkerEdgeAlpha=.2,MarkerFaceAlpha=.2)
            colormap(hsvColors);
            cb=colorbar;cb.Ticks=[0 .25 .5 .75 1]; cb.TickLabels={'Inside', 'Reverse', 'Outside','Forward','Inside'};
            ax=gca;
            ax.YTick=[0 90 180];ax.YTickLabel={'Inside', 'Straight', 'Outside'};
            yline([90]);
        end
        % Example method to calculate center of circular track
        function obj = setCenter(obj,center)
            obj.Center=center;
            obj=obj.setAngularPosition(obj.getAngularPosition);
            obj.HeadDirection=obj.getHeadDirectionRelativeToCenter();
        end
        function obj = setAngularPosition(obj,pos)
            T=table(pos,'VariableNames',{'AngularPosition'});
            obj.PositionTable=[obj.PositionTable T];
        end

        % Example method to calculate center of circular track
        function obj = calculateTrackCenter(obj)
            % Calculate the center of the circular track
            pt = obj.PositionTable;
            xCoordinates = pt.XCoordinate;
            yCoordinates = pt.YCoordinate;

            % Use the mean of the coordinates as an estimate for the center
            centerX = mean(xCoordinates);
            centerY = mean(yCoordinates);

            % Set the center property
            obj.Center = [centerX, centerY];
        end
       
        % Example method to calculate radius of circular track
        function obj = calculateTrackRadius(obj)
            % Dummy implementation - replace with actual calculation
            obj.Radius = 0; % This would be replaced with actual calculations
        end

        % Override or add new methods here for specific RatCircularTrack functionality
    end
end
