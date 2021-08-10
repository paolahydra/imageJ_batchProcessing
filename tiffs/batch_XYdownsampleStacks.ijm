/* This script will batch-downsample every .tif(f) file in all subfolders of the folder you specify (interactively).
 * Images are also reduced to 8-bit.
 * 
 * written by Paola Patella, PhD. 
 * FMI, Basel, July 2021
 */


// specify your settings here:
scaleFactor = 0.75;
overwrite = 0;
 


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
			
       		getDimensions(width, height, channels, slices, frames);
			newWidth = round(width*scaleFactor);
			newHeight = round(height*scaleFactor);
			runningString = "x=" +scaleFactor +" y=" +scaleFactor +" z=1.0 width=" +newWidth +" height=" +newHeight +" depth=" +slices +" interpolation=Bicubic average process create";
       		print(runningString);
       		
			run("Scale...", runningString);
			run("8-bit");

			if (overwrite == 1)
				filenameWrite = path;
			else {
				folderpath = File.getParent(path) + File.separator;
				filename = File.getName(path);
				filenameWrite = folderpath + "downsampled-" + scaleFactor + "_" + filename;
				}
			saveAs("Tiff", filenameWrite);
			run("Close All");
       }
  }

