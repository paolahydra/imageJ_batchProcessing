/* This script will batch-convert to .tif every .czi file in all subfolders of the folder you specify (interactively).
 * Only the highest-resolution series (the first series and any other first ones if acquisition was split in several parts)
 * will be converted.
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
       if (endsWith(path, ".lif")) {
			Ext.setId(path);
       		Ext.getSeriesCount(seriesCount); //zero-based
       		print("series count = " + seriesCount);
/*
			Ext.getMetadataValue("Scaling|Distance|Value #1", value);
			print(value);
			
       		value = 1000000*value;
       		appendingSt = "_" +value+ "umppx.tif";

       		seriesNumber = 1;
       		Ext.setSeries(0); //note that the index in this case is zero-based. This corresponds to series 1.
			Ext.getSizeX(prevSizeX);
			Ext.getSizeY(prevSizeY);
       		seriesLabel = "series_"+seriesNumber;
       		print("opening " + seriesLabel);   
       		openingString = "open=" +path +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT " +seriesLabel;
       		//print(openingString);
       		run("Bio-Formats Importer", openingString);
       		saveTiff(path, seriesNumber, appendingSt);
*/			
			
			
			for (seriesNumber=1; seriesNumber<=seriesCount; seriesNumber++) {
				//print(seriesNumber);
				Ext.setSeries(seriesNumber-1);
				/*
				Ext.getSizeX(sizeX);
				Ext.getSizeY(sizeY);
				prevsz = prevSizeX*prevSizeY;
				currsz = sizeX*sizeY;
				*/
				//print("previous squaresize: " +prevsz );
				//print("current squaresize: " +currsz );
				seriesLabel = "series_"+seriesNumber;
       			print("opening " + seriesLabel);   
				openingString = "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT " +seriesLabel; 
       			//print(openingString);
       			run("Bio-Formats Importer", openingString);
				saveTiff(path, seriesNumber);
/*
				if (prevsz < currsz) {
					seriesLabel = "series_"+seriesNumber;
       				print("opening " + seriesLabel);   
					openingString = "open=[&path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT " +seriesLabel; 
       				//print(openingString);
       				run("Bio-Formats Importer", openingString);
       				saveTiff(path, seriesNumber, appendingSt);
				}
				prevSizeX = sizeX;
				prevSizeY = sizeY;
*/
			}				
      }
  }

  function saveTiff(path, seriesNumber) {
	getDimensions(width, height, channels, slices, frames);
	// if it's a multi channel image
	if (channels > 1) {
		run("Arrange Channels...", "new=21");
		run("Make Composite");
	}
	run("8-bit");
	
	filenameWrite = path+"_comp_"+seriesNumber;
	
	//print("series " +seriesNumber);
	print("saving: " +filenameWrite);
	saveAs("Tiff", filenameWrite);
	close();
  }
  
