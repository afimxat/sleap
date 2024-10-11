
folder='R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done';
fnames.aud={...
    'Anim1Track2Cell25.fig',...
    'Anim1Track2Cell26.fig',...
    'Anim2Track1Cell59.fig',...
    'Anim3Track1Cell51.fig',...
    'Anim3Track1Cell79.fig',...
    'Anim3Track1Cell88.fig'...
    };
fnames.vis={...
    'Anim1Track1Cell16_VIS.fig',...
    'Anim1Track1Cell54_VIS.fig',...
    'Anim1Track1Cell130_VIS.fig',...
    'Anim3Track1Cell55_VIS.fig',...
    'Anim3Track1Cell65_VIS.fig',...
    'Anim3Track1Cell83_VIS.fig',...
    };

ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster\spatial');
ctx={'aud','vis'};
for ict=1:numel(ctx)
    fnames1=fnames.(ctx{ict});
    for ifil=1:numel(fnames1)
        fname=fnames1{ifil};
        fpath=fullfile(folder,fname);
        open(fpath);
        f=gcf;
        f.OuterPosition=[2040 1111 1000 300];
        a=findobj(f,'Type','axes');
        ax=a(1);
        ax.XTick=[0 120 240 360];
        ax.XTick=[120 240 360];ax.XTickLabel={'Well_1','Well_2','Well_{Reward}'};
        ax.YTick=[];
        ax.Box="off";

        ylabel('Firing Rate (au)')
        xline([120 240]);
        ax=a(2);
        ax.DataAspectRatio=[1 1 1];
        ax.XTick=[];ax.YTick=[];
        colormap(ax,"parula")
        ax.Colormap(1,:)=[01 01 01];
        % cb=colorbar(ax);cb.Ticks=[];
        ax.Box="off";
        [~,name,~]=fileparts(fpath);
        annotation('textbox',[0 1 .3 .2],String=name,Rotation=-90)
        ff.save(name)
        close
    end
end

%% speed modulation
% ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
% ax=gca
% ax.YLim=[0 .3]
% ax.XLim=[-.6 .6];
% xlabel('R');ylabel('pdf');
% ff.save('SpeedModulation')
%% AllSpatial
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\allSpatial.fig')
f=gcf;
f.OuterPosition=[1950 585 478 1200];
a=findobj(f,'Type','axes');
for ia=1:numel(a)
    ax=a(7-ia);
    ax.XTick=[120 240 360];ax.XTickLabel={'Well_1','Well_2','Well_{Reward}'};
    ax.DataAspectRatio=[4 1 1];
    xline(ax,[120 240],LineWidth=2,LineStyle="--",Color=[.9 .9 .9]);
end
ff.save('AllSpatial')
close
%% spatialFiringAverage.fig
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\spatialFiringAverage.fig')
f=gcf;
f.OuterPosition=[2000 560 478 185];
a=findobj(f,'Type','axes');
for io=1:2
    ax=a(io);
    ax.XTick=[120 240 360];ax.XTickLabel={'W_1','W_2','W_R',};
    xline(ax,[120 240]);
end
linkaxes(a)
ff.save('spatialFiringAverage')
close

%% AllSpatialDist
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\allSpatialDistribution.fig')
f=gcf;
f.OuterPosition=[2000 560 360 240];
ax=gca;
ax.XLim=[.575 4.75];
ff.save('AllSpatialDist')
close

%% foot steps
folder='R:\DataBackup\RothschildLab\utku\Gideon\imgs\newFootstepPlots\anim2\aud1';
fnames.a1aud1={...
    'cell 8.fig',...
    'cell 23.fig',...
    'cell 25.fig',...
    'cell 33.fig',...
    'cell 44.fig',...
    'cell 96.fig'...
    };
fnames.a1aud1={...
    'cell 59.fig',...
    'cell 19.fig'
    };


ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster\psth');
ses={'a1aud1'};
for ict=1:numel(ses)
    fnames1=fnames.(ses{ict});
    for ifil=1:numel(fnames1)
        fname=fnames1{ifil};
        fpath=fullfile(folder,fname);
        open(fpath);
        f=gcf;
        f.OuterPosition=[1040 400 800 1000];
        a=findobj(f,'Type','axes');
        for i=[3 5 7 9]
            ax=a(i);
            ax.DataAspectRatio=[2 1 1];
            ax.XTick=[-1000:500:1000];
            ax.XTickLabel={'-1','-.5','0','.5','1'}
            ax.XLim=[-1000 1000];
            ax.Box="off";
            xlabel(ax,'Time (s)')
            if i==9
                ylabel(ax,'Foot Steps')
            end
            c1=colororder;
        end

        for i=[2 4 6 8]
            ax=a(i);
            ax.Position(4)=.1;ax.Position(2)=.4
            ax.XTick=[-1000:1000:1000];
            ax.XTickLabel={'-1','0','1'}
            ax.XLim=[-1000 1000]
            ax.YTick=[];
            xlabel(ax,'Time (s)')
            if i==8
                ylabel(ax,'Firing Rate (au)')
            end
            ax.Box="off";
        end
        ax=a(1);
        ax.Position(4)=.1;ax.Position(2)=.4
        ax.XTick=[-100:100:100];
        ax.XLim=[-100 100]
        xline(ax, [0],LineStyle="--",Color=c1(2,:));
        xlabel(ax,'Time (ms)')
        ax.Box="off";

        [~,name,~]=fileparts(fpath);
        annotation('textbox',[.1 .45 .1 .1],String=name)
        ff.save(name)
        close
    end
end
%% foot steps comnbi
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\footstepRasters.fig')
f=gcf;
f.OuterPosition=[1950 373 500 1000];
a=findobj(f,'Type','axes');
for ia=1:numel(a)
    ax=a(ia);
    ax.XTick=[-1000:1000:1000]
    % ax.XLim=[-500 500]
    xlabel(ax,'Time relative to footstep onset (ms)'); ylabel('Unit')
    ax.DataAspectRatio=[30 1 1];
    % xline(ax,[120 240],LineWidth=2,LineStyle="--",Color=[.9 .9 .9]);
end
ff.save('footstepRasters')
close
%% footstepModRates

ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\footstepModRates.fig')
f=gcf;
f.OuterPosition=[2000 560 240 240];
ax=gca;
ax.XLim=[.5 3.5];
ax.XTickLabel={'Rat 1','Rat 2','Rat 3'}
ff.save('footstepModRates')
close
%% footstepSectionSelectivity

ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\footstepSectionSelectivity.fig')
f=gcf;
f.OuterPosition=[2000 560 136 240];
ax=gca;
ax.XLim=[.5 3.5];
ax.XTickLabel={'Rat 1','Rat 2','Rat 3'}
ff.save('footstepSectionSelectivity')
close
%% rasterForCCExample.fig

ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\rasterForCCExample.fig')
f=gcf;
f.OuterPosition=[1580 620 550 180];
ax=gca;
% ax.XLim=[0 2];
% ax.XTickLabel={'Rat 1','Rat 2','Rat 3'}
ff.save('rasterForCCExample')
close
%% CCExample.fig
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\CCExample.fig')
f=gcf;
f.OuterPosition=[1580 620 200 200];
ax=gca;
% ax.XLim=[0 2];
% ax.XTickLabel={'Rat 1','Rat 2','Rat 3'}
ff.save('CCExample')
close
%% AC-VC_CC.fig
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\AC-VC_CC.fig')
f=gcf;
f.OuterPosition=[1600 200 800 1000];
a=findobj(f,'Type','axes');
for ia=1:3
    ax=a(10-ia);
    ax.DataAspectRatio=[1 100 1];
    ylabel(ax,'Pairs')
end
for ia=4:9
    ax=a(10-ia);
    ax.Position(4)=.1
end
% linkaxes([a(4:6)],'y')
% linkaxes([a(1:3)],'y')
ff.save('AC-VC_CC')
close
%% AC-VC_CCsleepo.fig
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster');
open('R:\DataBackup\RothschildLab\utku\Gideon\imgs\spatialExamples\done\AC-VC_CC_SLEEP_sorted.fig')
f=gcf;
f.OuterPosition=[1600 200 800 1000];
a=findobj(f,'Type','axes');
for ia=1:3
    ax=a(10-ia);
    ax.DataAspectRatio=[1 100 1];
    ylabel(ax,'Pairs')
end
for ia=4:9
    ax=a(10-ia);
    ax.Position(4)=.1
end
% linkaxes([a(4:6)],'y')
% linkaxes([a(1:3)],'y')
ff.save('AC-VC_CC_sleep')
close
