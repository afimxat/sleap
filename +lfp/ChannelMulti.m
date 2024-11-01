classdef ChannelMulti
    %CHANNELMULTI Summary of this class goes here
    %   Detailed explanation goes here

    properties
        data
        channels
        time
    end

    methods
        function obj = ChannelMulti(data,channels,time)
            %CHANNELMULTI Construct an instance of this class
            %   Detailed explanation goes here
            obj.data = data;
            obj.channels=channels;
            obj.time=time;
        end

        function chan = getChannel(obj,ch)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            chind=obj.channels==ch;
            chan=lfp.Channel(obj.data(chind,:),ch,obj.time);
        end
        function p = plot(obj,color,amp)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            chns=obj.channels;
            max1=max(max(obj.data));
            min1=min(min(obj.data));
            div1=max(abs([max1 min1]));
            obj.data=obj.data/div1*amp;
            for ich=1:numel(chns)
                obj.data(ich,:)=obj.data(ich,:)-ich;
            end
            p=plot(obj.time,obj.data,Color=color);
            ax=gca;
            ax.YLim=[-numel(chns)-1 0];
            ax.XLim=[obj.time(1) obj.time(end)];
        end
        function obj = getDetrend(obj)
            ft_defaults;
            obj.data=ft_preproc_detrend(obj.data);
        end
        function sr = getSampleRate(obj)
            sr=round(1/median(diff(obj.time)));
        end
        function obj = getFilteredHighPass(obj,Hz)
            obj.data=ft_preproc_highpassfilter( ...
                obj.data,obj.getSampleRate,Hz);
        end
        function obj = getHilbert(obj)
            obj.data=ft_preproc_hilbert(obj.data);
        end
        function obj = getPower(obj,winLenSlide)
            chns=obj.channels;
            % Define frame size (e.g., 1024 samples per frame)
            winLenSlidesample = obj.getSampleRate*winLenSlide;
            slide=winLenSlidesample(2);
            frameSize=winLenSlidesample(1);
            numFrames=floor((size(obj.data,2)-frameSize)/slide)+1;
            % Initialize array to store power values
            powerValues = zeros(numel(chns), numFrames);
            for ich=1:numel(chns)
                ch1=obj.data(ich,:);
                % Loop over each frame and calculate the power
                for ifr = 1:numFrames
                    frame = ch1((ifr-1)*slide + 1 : (ifr-1)*slide + frameSize ); % Extract the frame
                    powerValues(ich,ifr) = mean(frame.^2); % Calculate power (mean squared amplitude)
                end
            end
            obj.time=double(frameSize/2:slide:(size(obj.data,2)-frameSize/2))/obj.getSampleRate+obj.time(1);
            obj.data=powerValues;
        end
        function saveToEDF(obj, filename)
            % Save the object's data to an EDF (European Data Format) file
            % Create a structure to hold the EDF data
            hdr = [];
            hdr.Fs = obj.getSampleRate; % Sampling rate
            hdr.nChans = numel(obj.channels); % Number of channels
            hdr.label = arrayfun(@(x) ['Ch' num2str(x)], obj.channels, 'UniformOutput', false); % Channel labels
            hdr.duration = length(obj.time) / hdr.Fs; % Duration of the recording
            hdr.orig = 'MATLAB'; % Origin of the data

            % Save the data to EDF file
            data = obj.data;
            savesignal(filename, data, hdr);
        end

    end
end

