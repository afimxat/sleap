classdef Struct
    %STRUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        table
    end
    
    methods
        function obj = Struct(posFile)
            %STRUCT Construct an instance of this class
            %   Detailed explanation goes here
            s=load(posFile);
            obj.table=s.t1;
        end

        function obj = getwindow(obj,win)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            t1=obj.table;
            idx=t1.TimeRelativeSec>win(1)&t1.TimeRelativeSec<win(2);
            obj.table(~idx,:)=[];
        end
        function obj = plotAngularPos(obj,color)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            t1=obj.table;
            time=t1.TimeRelativeSec;
            headPos=t1.headPosAngNormalized;
            plot(time,headPos,'Color',color);
            hold on
            ax=gca;
            ax.YLim=[0 360];
            yline([120 240],'LineStyle',':',LineWidth=.25);
        end
        function obj = plotAngularVel(obj,color)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            [headVel, time]=obj.getAngularVel;
            plot(time,headVel,'Color',color);
        end        
        function [headVel, time]= getAngularVel(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            t1=obj.table;
            time=t1.TimeRelativeSec';
            headPos=t1.headPosAngNormalized';
            velt=diff(headPos);
            headVel=smooth([velt velt(end)],8)/median(diff(time));
        end
   end
end

