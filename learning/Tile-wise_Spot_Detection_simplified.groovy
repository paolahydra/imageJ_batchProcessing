#@ File ndFile
#@ File stgFile
// ignore #@ String (choices={"Load dataset at once"}) performance // or "Save memory"
#@ File (style="save", label="Output file (csv)") outputFile
#@ Double radius
#@ Double threshold
#@ Integer (value=4) downsamplingFactor 

@Grab('org.apache.commons:commons-csv:1.8')

import org.apache.commons.csv.CSVPrinter
import org.apache.commons.csv.CSVFormat

import ch.fmi.stitching.visiview.VisiviewUtils

import loci.plugins.BF
import loci.plugins.in.ImporterOptions

import fiji.plugin.trackmate.detection.DownsampleLogDetector
import net.imglib2.img.display.imagej.ImageJFunctions


import ij.ImagePlus;
// load position names as coords

// load images
CSV_HEADER = ['tilePosition', 'spotID', 'xLocal', 'yLocal', 'zLocal', 'xGlobal', 'yGlobal', 'zGlobal']

options = new ImporterOptions()
options.setId(ndFile.getAbsolutePath())
options.setOpenAllSeries(true)
options.setCBegin(0,0);
options.setCEnd(0,0);

imps = BF.openImagePlus(options)

/*
i = 0;
for (ImagePlus imp : imps) {
i++;
print(i);
imp.show();
}
/*
imps = BF.openImagePlus(options)
*/

cal = imps[0].getCalibration()
println cal

positions = VisiviewUtils.positionsFromStgFile(stgFile, 1, 1)
println positions.size

ox_min = 9999999
oy_min = 9999999
for (i in 0..<positions.size) {
	if (ox_min > positions[i][0]) {
		ox_min = positions[i][0]
	}
	if (oy_min > positions[i][1]) {
		oy_min = positions[i][1]
	}
}

outputFile.withWriter { fileWriter ->
	def csvPrinter = new CSVPrinter(fileWriter, CSVFormat.DEFAULT)
	csvPrinter.printRecord(CSV_HEADER)
	for (i in 0..<imps.length) {
		peaks = detectSpots(imps[i], radius, threshold, downsamplingFactor)
		println "Found peaks: " + peaks
		shifted_pos = new float[2]
		shifted_pos[0] = positions[i][0] - ox_min
		shifted_pos[1] = positions[i][1] - oy_min
		exportCoords(i + 1, csvPrinter, peaks, shifted_pos)
	}
}

def detectSpots(imp, radius, threshold, factor) {
	calib = imp.getCalibration()
	img = ImageJFunctions.wrap(imp)
	interval = img
	calibration = [calib.pixelWidth, calib.pixelHeight, calib.pixelDepth]

	detector = new DownsampleLogDetector(img, interval, calibration as double[], radius, threshold, factor)
	if (detector.process()) {
		return detector.getResult()
	}
	return null
}

def exportCoords(pos, printer, spots, offset) {
	for (spot in spots) {
		printer.printRecord([pos,
							spot.ID(),
							spot.getDoublePosition(0),
							spot.getDoublePosition(1),
							spot.getDoublePosition(2),
							spot.getDoublePosition(0) + offset[0],
							spot.getDoublePosition(1) + offset[1],
							spot.getDoublePosition(2)])
	}
	println "saving with offset " + offset
}

/*
// Load full dataset, incl. calibration
// for each position (and specified channel), detect spots
// 

ndFileGuess = VisiviewUtils.getMatchingNdForStg(stgFile)
println ndFileGuess

//stgFile = VisiviewUtils.getMatchingStgForNd(ndFile)

//println stgFile
// get files and offsets
datasetInfo = VisiviewUtils.parseNdFile(ndFile)

//println datasetInfo

posNames = VisiviewUtils.getPositionNames(datasetInfo)
//println posNames

// loop over stage positions (=stk files), detect spots, export csv
files = VisiviewUtils.getCompanionFiles(ndFile, datasetInfo)

//println files
*/
null
