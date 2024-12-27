VideoFile='R:\DataBackup\RothschildLab\utku\Gideon\c4-5-24\video\Basler_acA4024-29um__24844056__20240524_113617106_Sleap export.mp4';
exportFile='R:\DataBackup\RothschildLab\utku\Gideon\c4-5-24\video\labels.v001.005_Basler_acA4024-29um__24844056__20240524_113617106_Sleap export.analysis.h5';
matFile='R:/DataBackup/RothschildLab/utku/Gideon/c4-5-24/video/labels.v001.005_Basler_acA4024-29um__24844056__20240524_113617106_Sleap export.analysis.h5_position.mat';
load(matFile);
vidLabel=VideoWithLabels(VideoFile,exportFile);
vidLabel.relativeTime=seconds(t1.TimeRelativeSec(1));
st=minutes(134)+seconds(29); dur=seconds(15);

vidLabel.getVideoForRelativeTime([st dur])