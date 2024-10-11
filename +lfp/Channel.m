classdef Channel
    %CHANNEL Summary of this class goes here
    % This script is part of the 'lfp' package and is located in the 'Channel.m' file.
    % 
    % The 'Channel' class/module is designed to handle operations related to 
    % LFP (Local Field Potential) channel data. This may include data acquisition, 
    % preprocessing, analysis, and visualization of LFP signals.
    % 
    
    properties
        data
        channel
        time
    end
    
    methods
        function obj = Channel(data,channel,time)
            %CHANNEL Construct an instance of this class
            %   This constructor initializes an instance of the Channel class.
            obj.data = data;
            obj.channel=channel;
            obj.time=time;
        end

        function p = plot(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            p=plot(obj.time,obj.data);
        end
    end
end

