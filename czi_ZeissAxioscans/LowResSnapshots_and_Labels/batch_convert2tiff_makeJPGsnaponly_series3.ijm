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
       		Ext.setId(path);
       		Ext.getSeriesCount(seriesCount); //zero-based
       		print("series count = " + seriesCount);


       		appendingSt = ".jpg";
       		if (seriesCount == 7) {
				run("Bio-Formats Importer", "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_3");
				seriesNumber = 3; //not used because for simplicity I just wrote the number in the command above
       		}
       		else if (seriesCount == 6) {
				run("Bio-Formats Importer", "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_2");
				seriesNumber = 2; //not used because for simplicity I just wrote the number in the command above
			}		
			getDimensions(width, height, channels, slices, frames);
			// if it's a multi channel image
			if (channels > 1) run("Split Channels");

			// we only save the first 3 channels, which I always acquire
			// ch_nbr = nImages ; 
			for ( c = 1; c < 4; c++){
				selectImage(c);
				run("Enhance Contrast", "saturated=0.35");
			}
			if (channels > 3) {
				selectImage(4);
				close();
			}
			run("Images to Stack", "name=Stack title=[] use");
			run("8-bit");
			run("Make Composite", "display=Composite");
			filenameWrite = path+appendingSt;
			//path2 = substring(path,1,lengthOf(path)-4);  //it does not work, not sure why
			//filenameWrite = path2+appendingSt;
			saveAs("Jpeg", filenameWrite);
			run("Close All");

      }
  }
