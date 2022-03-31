//key aspects learned
import ij.ImagePlus;

i = 0;

for (ImagePlus imp : imps) { //imps is a list of images
i++;
print(i);
imp.show();
}