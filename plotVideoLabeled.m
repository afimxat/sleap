VideoFile='R:\DataBackup\RothschildLab\utku\Gideon\c5-6-25\video\Basler_acA4024-29um__24844056__20240625_124409954_Sleap export.mp4';
exportFile='R:\DataBackup\RothschildLab\utku\Gideon\c5-6-25\video\labels.v001.000_Basler_acA4024-29um__24844056__20240625_124409954_Sleap export.analysis.h5';
matFile='R:\DataBackup\RothschildLab\utku\Gideon\c5-6-25\video\labels.v001.000_Basler_acA4024-29um__24844056__20240625_124409954_Sleap export.analysis.h5_position.mat';
load(matFile);
vidLabel=VideoWithLabels(VideoFile,exportFile);
vidLabel.setStartRelativeTime(seconds(t1.TimeRelativeSec(1)));
vidLabel.getVideoFor([minutes(22)+seconds(53) seconds(15)])