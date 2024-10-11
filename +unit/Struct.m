classdef Struct
    %STRUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SpikeTableInSec
        ClusterInfo
    end
    
    methods
        function obj = Struct(file)
            %STRUCT Construct an instance of this class
            %   Detailed explanation goes here
            s=load(file);
            spikeTableInSamples=s.SpikeTableInSamples;
            spikeTableInSamples.SpikeTimes= ...
                double(spikeTableInSamples.SpikeTimes)/30000;
            obj.SpikeTableInSec=spikeTableInSamples;
            obj.ClusterInfo=s.ClusterInfo;
        end
        
        function obj = getwindow(obj,win)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            st=obj.SpikeTableInSec;
            idx=st.SpikeTimes>win(1)&st.SpikeTimes<win(2);
            obj.SpikeTableInSec(~idx,:)=[];
        end
        function obj = plotRaster(obj,color)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            st=obj.SpikeTableInSec;
            units=unique(st.SpikeCluster);
            hold on;
            for iun=1:numel(units)
                unit=units(iun);
                unidx=st.SpikeCluster==unit;
                spikes=st.SpikeTimes(unidx);
                scatter(spikes,iun,5,color, '|');
            end
        end
    end
end
