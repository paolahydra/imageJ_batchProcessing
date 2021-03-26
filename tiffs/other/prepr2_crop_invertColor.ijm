dir = getDirectory("image");
print(dir);
appendingSt = ".png";

run("Crop");

run("Split Channels");


run("Invert");
run("Enhance Contrast", "saturated=0.35");
fname = getTitle();
filenameWrite = dir+fname+appendingSt;
print(filenameWrite);
saveAs("PNG", filenameWrite);
close();

run("Invert");
fname = getTitle();
filenameWrite = dir+fname+appendingSt;
saveAs("PNG", filenameWrite);
close();

run("Invert");
fname = getTitle();
filenameWrite = dir+fname+appendingSt;
saveAs("PNG", filenameWrite);
close();