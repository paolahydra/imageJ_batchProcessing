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
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

	function processFile(path) {
       if ((endsWith(path, ".tif")) || (endsWith(path, ".tiff")) ) {
			open(path);
			appendingSt = ".png";
			
			getDimensions(width, height, channels, slices, frames);

			
			if (channels==1){  // if it is a stack
				// only keep the first three channels, if more are available
				if (slices==4){
					setSlice(4);
					run("Delete Slice");
				}
				run("Stack to RGB");
				run("Split Channels");
			}
			else {  //it is a multichannel image
				run("Split Channels");
				if (channels==4){
					close(); // this will close the last channel
				}
			}
			
			// channel-by-channel operations and saving 
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
	
			