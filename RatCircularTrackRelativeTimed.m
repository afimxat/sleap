classdef RatCircularTrackRelativeTimed < RatCircularTrack
    properties
        RelativeTime % Column for relative time
    end
    
    methods
        function obj = RatCircularTrackRelativeTimed(initialRelativeTime)
            obj = obj@RatCircularTrack(); % Call the constructor of the parent class
            obj.RelativeTime = initialRelativeTime; % Set the initial relative time
            obj.PositionTable = [obj.PositionTable, table(initialRelativeTime, 'VariableNames', {'RelativeTime'})]; % Add the relative time column
        end
        
        function obj = updatePositionTable(obj, frameTime)
            % Update the relative time for each frame
            newRelativeTime = obj.RelativeTime + frameTime;
            obj.RelativeTime = newRelativeTime;
            obj.PositionTable = [obj.PositionTable; table(newRelativeTime, 'VariableNames', {'RelativeTime'})]; % Append new relative time to the position table
        end
    end
end