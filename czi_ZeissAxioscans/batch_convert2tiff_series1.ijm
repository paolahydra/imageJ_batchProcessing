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
       if (endsWith(path, ".czi")) {

       		appendingSt = ".tif";
			run("Bio-Formats Importer", "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
				seriesNumber = 1; //not used because for simplicity I just wrote the number in the command above
       			
			
			getDimensions(width, height, channels, slices, frames);
			// if it's a multi channel image
			if (channels > 1) run("Split Channels");

			for ( c = 1; c <= channels; c++){
				selectImage(c);
				run("Enhance Contrast", "saturated=0.05");
			}
			run("Images to Stack", "name=Stack title=[] use");
			run("8-bit");

			filenameWrite = path+seriesNumber+appendingSt;
			saveAs("Tiff", filenameWrite);
			close();
      }
  }
