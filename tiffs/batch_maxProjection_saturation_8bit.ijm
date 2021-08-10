// don't need to change anything below
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
			
			run("Z Project...", "projection=[Max Intensity]");
			
       		getDimensions(width, height, channels, slices, frames);
			for ( c = 1; c <= channels; c++){
				Stack.setChannel(c) 
				run("Enhance Contrast", "saturated=0.03");
			}
			
			run("8-bit");

			if (overwrite == 1)
				filenameWrite = path;
			else {
				folderpath = File.getParent(path) + File.separator;
				filename = File.getName(path);
				filenameWrite = folderpath + "MAX_" + filename;
				}
			saveAs("Tiff", filenameWrite);
			run("Close All");
       }
  }
