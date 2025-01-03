classdef File
    %FILE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        fileLFP
        fileXML
        xmlParams
    end

    methods
        function obj = File(filelfp,filexlm)
            %FILE Construct an instance of this class
            %   TODO print a detailed description about the file
            obj.fileLFP=filelfp;
            obj.fileXML=filexlm;
            obj.xmlParams=LoadParameters(filexlm);
            
        end

        function chm = getChannelsWithInterval(obj,chans,int1)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            pr=obj.xmlParams;
            bin=bz_LoadBinary(obj.fileLFP, ...
                'frequency',pr.lfpSampleRate,...
                'start',int1(1),...
                'duration',int1(2)-int1(1), ...  % duration to read (in s, default = Inf)
                ...%    'offset',   % position to start reading (in samples per channel, default = 0)
                ...%   'samples',    % number of samples (per channel) to read (default = Inf)
                'nChannels',pr.nChannels,...  % number of data channels in the file (default = 1)
                'channels',chans,...   % channels to read, base 1 (default = all)
                'precision',sprintf('int%d',pr.nBits)...  % sample precision (default = 'int16')
                ... % 'skip',       % number of bytes to skip after each value is read%(default = 0)
                ... % 'downsample',  %factor by which to downample by (default = 1))
                );
            time=int1(1):(1/pr.lfpSampleRate):int1(2);
            time=time(1:(end-1));
            chm=lfp.ChannelMulti(double(bin)',chans, time);
        end
    end
end

