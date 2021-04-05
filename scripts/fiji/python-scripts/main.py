#@ File (label="Choose image", style="directory") image_folder
#@ File (label="Choose input super folder", style="directory") input_folder
#@ File (label="Choose output super folder", style="directory") output_folder

#from ij import IJ,ImagePlus,WindowManager,ImageStack
from ij 			import IJ,ImagePlus,ImageStack
from ij.plugin 		import FolderOpener,StackWriter 			# to use to import image sequence. see: https://imagej.net/developer/api/ij/plugin/FolderOpener.html
from ij.process 	import FloatProcessor
import sys, os, shutil
from ij.gui 		import MessageDialog			# to display a message dialog and wiat for user input
from java.awt 		import Frame
from java.io 		import File

print(os.defpath)
help(os)

try:
	IJ.run("Close All","")
except Exception as e:
	print(type(e))

''' global vars'''
sep = File.separator # system dependent file path separator

	
''' methods '''
def set_pixel_as_dim(img):
	img.getCalibration().setXUnit("pixel");
	img.getCalibration().setYUnit("pixel");
	img.getCalibration().setZUnit("pixel");
	IJ.run(img, "Properties...", "channels=1 slices="+str(img.getStackSize())+" frames=1 pixel_width=1 pixel_height=1 voxel_depth=1 global");

def change_image_title(new_title):
	IJ.getImage().setTitle(new_title)

def get_new_title(img,suffix):
	return img.getTitle()+'_'+suffix
	
def zflip(img):
	new_title = get_new_title(img,'zflipped')
		
	IJ.run(img, "Flip Z", "")
	
	change_image_title(new_title)
	
def zcrop(img,slices):
	new_title = get_new_title(img,'zcropped')
	
	maxx = str(img.getWidth() - 1)
	maxy = str(img.getHeight()- 1)
	crop_input = "x-range=1," + maxx + " " + "y-range=1," + maxy + " " + "z-range="+str(slices[0])+","+str(slices[1])
	IJ.run("TransformJ Crop", crop_input)

	change_image_title(new_title)

def workflow(img,doSave):
	parent_path = output_folder.getPath()+sep
	
	# set properties
	set_pixel_as_dim(img)
	
	# flip z
	zflip(img)
	if doSave: save_output(parent_path,image_folder.getName(),'zflipped',True)
	# crop z
	top_slice 		= 172
	buttom_slice 	= 791
	z = (top_slice, buttom_slice)
	zcrop(img,z)
	if doSave: save_output(parent_path,image_folder.getName(),'zflipped_zcropped',False)

	IJ.showMessage("Workflow compoleted")
	
def save_output(parent_path,input_name,suffix,is_1st):
	parent_dir = parent_path+input_name
	
	if os.path.exists(parent_dir) and is_1st: # solution found here: https://stackoverflow.com/questions/11660605/how-to-overwrite-a-folder-if-it-already-exists-when-creating-it-with-makedirs
		shutil.rmtree(parent_dir)
		os.mkdir(parent_dir)
	elif not os.path.exists(parent_dir):
		os.mkdir(parent_dir)
	output_path = os.path.join(parent_dir,suffix)
	os.mkdir(output_path)
	
	StackWriter.save(IJ.getImage(), output_path+sep, "format=tiff digits=4 name="+input_name+"_"+suffix+"_");
	
	
	

''' script '''
input_is_manual = True

# printing the type of script parameter inputs (the first few lines of the script starting with #@.... )
# print(type(image_folder)) # java.io.File [https://www.tutorialspoint.com/java/io/java_io_file.htm]

if input_is_manual:
	doSaveIntermediateOutputs = True
	imgseq_folder_path = image_folder.getPath()+sep # see the first line with #@ File
	
	# import image sequence
	imp = FolderOpener.open(imgseq_folder_path, " filter=tif")
#	imp = FolderOpener.open(imgseq_folder_path, "virtual filter=tif");
	
	# show image sequence
	imp.show()

	# apply workflow
	workflow(imp,doSaveIntermediateOutputs)

else:
	image_names = ['0_degree','6_degree','12_degree','18_degree','24_degree','30_degree']
	for image_name in image_names:
		imgseq_folder_path = IJ.addSeparator(input_folder.getPath())+IJ.addSeparator(image_name)
		imp = FolderOpener.open(imgseq_folder_path, " filter=tif")
		

		





