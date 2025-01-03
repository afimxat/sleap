function [chm, units, pos2] = getLFPandUnits(window)
%GETLFPANDUNITS Summary of this function goes here
%   Detailed explanation goes here
interval1=seconds(window);
interval1(2)=sum(interval1);
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

posFile='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/video/labels.v001.006_Basler_acA4024-29um__24844056__20240524_135134482_Sleap export.analysis.h5_position.mat';
pos1=position.Struct(posFile);
pos2=pos1.getwindow(interval1);
pos2.table.headPosAngNormalized=movmedian(pos2.table.headPosAngNormalized,[5 5],'omitmissing');
end

