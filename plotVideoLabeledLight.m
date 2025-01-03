
VideoFile='R:\DataBackup\RothschildLab\utku\Gideon\c4-5-24\video\Basler_acA4024-29um__24844056__20240524_135134482_Sleap export.mp4';
exportFile='R:\DataBackup\RothschildLab\utku\Gideon\c4-5-24\video\labels.v001.006_Basler_acA4024-29um__24844056__20240524_135134482_Sleap export.analysis.h5';
matFile='R:\DataBackup\RothschildLab\utku\Gideon\c4-5-24\video\labels.v001.006_Basler_acA4024-29um__24844056__20240524_135134482_Sleap export.analysis.h5_position.mat';
load(matFile);
vidLabel=VideoWithLabels(VideoFile,exportFile);
vidLabel.relativeTime=seconds(t1.TimeRelativeSec(1));
%%
st=minutes(239+20)+seconds(31.1); dur=seconds(20);
[vidLabel.channels, vidLabel.units, vidLabel.position]=getLFPandUnits([st dur]);
%%
vidLabel.getVideoForRelativeTime([st dur],f2)