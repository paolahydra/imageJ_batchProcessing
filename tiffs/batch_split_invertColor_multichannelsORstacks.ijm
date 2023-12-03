run("Bio-Formats Macro Extensions");
setBatchMode(true);

dir = getDirectory("Choose a Directory ");
count = 0;
countFiles(dir);
print("files to process = " + count);

n = 0;
processFiles(dir);

   
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
          if (endsWith(list[i], ".tif")) {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path, dir);
          }
      }
  }

	function processFile(path, dir) {
       if ((endsWith(path, ".tif")) || (endsWith(path, ".tiff")) ) {
			open(path);
			suffixSt = "INV_";
			
			
			getDimensions(width, height, channels, slices, frames);
			if (channels==2){
				run("Split Channels");
			}	
			
			run("Invert");
			run("Enhance Contrast", "saturated=0.25");
			
			fname = getTitle();
			
			
			filenameWrite = dir+suffixSt+fname;
			print(filenameWrite);
			saveAs("TIFF", filenameWrite);

			run("Close All");
/*
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
			close();*/
			
       }
	}
	
			