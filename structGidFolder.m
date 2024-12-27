chans=[]; 
st=seconds(minutes(134)+seconds(35)); dur=600;
interval1=[st st+dur];
winLen=.01;slide=.0005;

basePathLFP.aud='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/aud_1250Hz.lfp';
basePathXML.aud='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/aud_1250Hz.xml';
lfp1.aud=lfp.File(basePathLFP.aud,basePathXML.aud);
chm.aud=lfp1.aud.getChannelsWithInterval(1:8:lfp1.aud.xmlParams.nChannels,interval1);


basePathLFP.vis='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/vis_1250Hz.lfp';
basePathXML.vis='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/vis_1250Hz.xml';
lfp1.vis=lfp.File(basePathLFP.vis,basePathXML.vis);
chm.vis=lfp1.vis.getChannelsWithInterval(1:8:lfp1.vis.xmlParams.nChannels,interval1);

basePathLFP.hc='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/hc_1250Hz.lfp';
basePathXML.hc='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/hc_1250Hz.xml';
lfp1.hc=lfp.File(basePathLFP.hc,basePathXML.hc);
chm.hc=lfp1.hc.getChannelsWithInterval(1:8:lfp1.hc.xmlParams.nChannels,interval1);

% Save chm.hc in EDF file format
basePathLFP.mic='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/mic.dat';
basePathXML.mic='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/mic.xml';
lfp1.mic=lfp.File(basePathLFP.mic,basePathXML.mic);
chm.mic=lfp1.mic.getChannelsWithInterval(1,interval1);
chm.micfilt=chm.mic.getDetrend.getFilteredHighPass(40);
chm.michilb=chm.micfilt.getPower([winLen slide]);


unitFile.aud='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/units/aud.mat';
units1=unit.Struct(unitFile.aud);
units.aud=units1.getwindow(interval1);

unitFile.vis='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/units/vis.mat';
units1=unit.Struct(unitFile.vis);
units.vis=units1.getwindow(interval1);

posFile='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/video/labels.v001.005_Basler_acA4024-29um__24844056__20240524_113617106_Sleap export.analysis.h5_position.mat';
pos1=position.Struct(posFile);
pos2=pos1.getwindow(interval1);
pos2.table.headPosAngNormalized=movmedian(pos2.table.headPosAngNormalized,[5 5],'omitmissing');
%%
ff=logistics.FigureFactory.instance('H:\My Drive\umich\Gid\SfN 24\poster')
colors=colororder;
color.aud=colors(1,:);
color.vis=colors(2,:);
color.hc=colors(3,:);
color.mic=colors(5,:);
color.pos=colors(4,:);
figure(1);clf;
f=gcf;f.OuterPosition=[2100 500 1000 800];
tl=tiledlayout(20,1);np=1;
ax(np)=nexttile(1,[1 1]);np=np+1;
p=chm.micfilt.plot(color.mic,1);
ylabel('Mic')
ax1=gca;ax1.XTickLabel=[];ax1.YTick=[];
ax(np)=nexttile(2);np=np+1;
p=chm.michilb.plot(color.mic,1);
ylabel('Mic Power')
ax1=gca;ax1.XTickLabel=[];ax1.YTick=[];

ax(np)=nexttile(3,[6 1]);np=np+1;
p=chm.aud.plot(color.aud,1);
ylabel('Aud Ctx')
ax1=gca;ax1.XTickLabel=[];ax1.YTick=[];

ax(np)=nexttile(9,[6 1]);np=np+1;
p=chm.vis.plot(color.vis,1);
ylabel('Vis Ctx')
ax1=gca;ax1.XTickLabel=[];ax1.YTick=[];

ax(np)=nexttile(15,[6 1]);np=np+1;
p=chm.hc.plot(color.hc,1);
ylabel('HC-CA1');
ax1=gca;ax1.YTick=[];

for isp=1:np-1
    ax(isp).Box="off";
    ax(isp).Color="none";
end
    
tl.TileSpacing="none";
linkaxes(ax(:),'x');
ff.save('f1')
%%
clear ax

figure(2);clf;
f=gcf;f.OuterPosition=[2100 0 1000 1300];

tl=tiledlayout(20,1);np=1;
ax(np)=nexttile(1,[1 1]);np=np+1;
chm.michilb.plot(color.mic,8)
ylabel('Mic Pow.')
ax1=gca;ax1.XTickLabel=[];ax1.YTickLabel=[];

ax(np)=nexttile(2,[8 1]);np=np+1;
units.aud.plotRaster(color.aud)
ylabel('Aud Ctx')
ax(np-1).YTick=20:20:300;
ax1=gca;ax1.XTickLabel=[];

ax(np)=nexttile(10,[7 1]);np=np+1;
units.vis.plotRaster(color.vis)
ylabel('Vis Ctx')
ax(np-1).YTick=20:20:300;
ax1=gca;ax1.XTickLabel=[];

ax(np)=nexttile(17,[3 1]);np=np+1;
pos2.plotAngularPos(color.pos)
ax(np-1).YTick=[0 120 240 360];
ylabel('Position_{angular} (deg)');
ax1=gca;ax1.XTickLabel=[];

ax(np)=nexttile(20,[1 1]);np=np+1;
pos2.plotAngularVel(color.pos)
ylabel('V_{angular} (deg/s)')
for isp=1:np-1
    ax(isp).Box="off";
    ax(isp).Color="none";
end
    xlabel('Time (s)')
tl.TileSpacing="none";
linkaxes(ax(:),'x');
ff.save('f2')