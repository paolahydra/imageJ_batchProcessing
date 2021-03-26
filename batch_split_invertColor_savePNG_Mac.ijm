run("Bio-Formats Macro Extensions");
setBatchMode(true);

dir = getDirectory("Choose a Directory ");
count = 0;
countFiles(dir);
print("files to process = " + count);

n = 0;
processFiles(dir);
print("Done.");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
      	print(i);
          if (endsWith(list[i], "/")){
          		// print("folder");
              processFiles(""+dir+list[i]);
          }
          else {
          	//print("not a folder");
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

	function processFile(path) {
       if (endsWith(path, ".tif")) {
			open(path);
			appendingSt = ".png";

			//makeRectangle(0, 70, 2059, 2934);
			//Crop...
			run("Split Channels");


			run("Invert");
			//run("Enhance Contrast", "saturated=0.05");
			fname = getTitle();

			filenameWrite = dir+fname+appendingSt;
			print(filenameWrite);
			saveAs("PNG", filenameWrite);
			close();

			run("Invert");
			//run("Enhance Contrast", "saturated=0.05");
			fname = getTitle();
			filenameWrite = dir+fname+appendingSt;
			saveAs("PNG", filenameWrite);
			close();

			run("Invert");
			//run("Enhance Contrast", "saturated=0.05");
			fname = getTitle();
			filenameWrite = dir+fname+appendingSt;
			saveAs("PNG", filenameWrite);
			close();
       }
	}
	
			