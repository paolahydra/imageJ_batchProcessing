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
  	   appendingSt = "lab.jpg";
       if (endsWith(path, ".czi")) {
			Ext.setId(path);
       		Ext.getSeriesCount(seriesCount); //zero-based
       		print("series count = " + seriesCount);
       		if (seriesCount == 7) {
				run("Bio-Formats Importer", "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_6");
				seriesNumber = 6; //not used because for simplicity I just wrote the number in the command above
       		}
			else if (seriesCount == 6) {
				run("Bio-Formats Importer", "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_5");
				seriesNumber = 5; //not used because for simplicity I just wrote the number in the command above
			}

			run("8-bit");
			filenameWrite = path+appendingSt;
			saveAs("Jpeg", filenameWrite);
			close();
      }
  }
  
  Ext.close();
