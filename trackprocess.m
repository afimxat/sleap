start1fr=round(table2array(t1(1,1))*25);
add1=ones([start1fr 2])-2;
pos=table2array(t1(:,2:3));
pos=normalize(pos,1,"range",[0 200]);

pos(isnan(pos)) = -1;
pos1=[add1;pos];
pos2=resample(pos1,25,25);

% Open a file for writing
fileID = fopen('output.txt', 'w');

% Write the array to the file (assuming you want space-separated values)
fprintf(fileID, '%f %f\n', pos2');

% Close the file
fclose(fileID);