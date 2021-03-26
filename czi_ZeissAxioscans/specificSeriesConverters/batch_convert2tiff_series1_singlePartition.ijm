/* This script will batch-convert to .tif every .czi file in all subfolders of the folder you specify (interactively).
 * Only series_1 will be converted.
 * Contrast is enhanced with 5% saturation before saving.
 * Images are saved as 8-bit.
 * 
 * written by Paola Patella, PhD. 
 * FMI, Basel, March 2021
 */
 
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

			seriesNumber = 1;
			seriesLabel = "series_"+seriesNumber;
       		print("opening " + seriesLabel);   
       		openingString = "open=" +path +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT " +seriesLabel;
       		//print(openingString);
       		run("Bio-Formats Importer", openingString);
       		saveTiff(path, seriesNumber, appendingSt);
      }
  }

function saveTiff(path, seriesNumber, appendingSt) {
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