# -*- coding: utf-8 -*-
"""
This is python code for CT image analysis
"""
from __future__ import division
import numpy as np
import cv2
import os
import scipy
import glob
from PIL import Image
from scipy import ndimage
import matplotlib
from matplotlib import rc
rc('font',**{'family':'serif','serif':['Times New Roman']})

rc('text', usetex=True)
import matplotlib.pyplot as plt


def openstack(loc, ext):
    imagelist = sorted(glob.glob(loc + '*.' + ext))
    image = np.array([np.array(cv2.imread(imagelist[i], cv2.IMREAD_UNCHANGED)) for i in range(len(imagelist))])
    return image


def threshold(image, (thr1, thr2)):       
    return np.logical_and(image >= thr1, image <= thr2) 


def imsave16(loc, image):
    try:
        os.mkdir(loc)
    except Exception:
        pass        
    os.chdir(loc)  
#    for i in range(10):
#        cv2.imwrite(str(i+1).zfill(4) + '.tif', image[i]) 
    return 0


def imsave2(loc, image):
    try:
        os.mkdir(loc)
    except Exception:
        pass
    os.chdir(loc) 
    for i in range(len(image)):
        Image.fromarray(image[i].astype(np.uint8)).save(str(i+1).zfill(4) + '.png')
    return 0


def getrid3D(image, iterations):
     A = scipy.ndimage.morphology.binary_erosion(image, iterations = iterations)
     return(scipy.ndimage.morphology.binary_dilation(A, iterations = iterations)) 


def getrid2D(image, it):
    new = np.zeros(image.shape)
    for i in range(len(image)):
        new[i] = scipy.ndimage.morphology.binary_dilation(
        scipy.ndimage.morphology.binary_erosion(image[i], iterations = it), iterations = it)
    return new


def volume(image):
    return np.sum(image > 0)


def porefill(image):
    a = 255*np.ones((image.shape[1], image.shape[2]))
    image = np.insert(image, 0, a, axis = 0)
    image = np.vstack((image, np.expand_dims(a, axis = 0)))
    image = scipy.ndimage.morphology.binary_fill_holes(image)
    image = image[1:-1]
    return image


def surface_area(image):
    eroded = scipy.ndimage.morphology.binary_erosion(image)
    image = image > 0
    boundary = image ^ eroded
    return np.sum(boundary)


def contact_area(image, slices):
    image = image == 0
    image = np.sum(image[slices[0]:slices[1]], axis = 0)
#    image[image > 22] = 50
    return image


if __name__ == '__main__':
#    loc = './pores_filled/18/'

    loc = './pores_filled/30_ij_isodata_seg/'
# 6_seg_ML_tif    tif
# 6_slices_KMeans    tif
# 6_slices_region_grow    tif
# 6_ij_isodata_seg    tif
# 6    png (manual threshold)

    ext = 'tif'
    image = openstack(loc, ext)
#    surf_area = surface_area(image)

    image_contact = contact_area(image, (400, 450))

    plt.figure()
    my_cmap = matplotlib.cm.get_cmap('viridis')
    my_cmap.set_over('white')
    bounds = range(50)
    norm = matplotlib.colors.BoundaryNorm(bounds, my_cmap.N)
    plt.imshow(image_contact, cmap = my_cmap, norm = norm)
    plt.colorbar()
#    plt.savefig('./18stack.png', dpi = 1000)
    plt.contour(image_contact, levels = [0], colors = 'red') 
#    plt.savefig('./18_0.png', dpi = 1000)

    plt.figure()
    contact = image_contact == 0
    plt.imshow(contact, cmap = 'gray')
#    plt.savefig('./18_4_binary.png', dpi = 1000)
    contact_Ac = np.sum(contact)
    print contact_Ac

    s = np.sum(image)
    image = porefill(image)
    totalvolume = volume(image)
    surf_area = surface_area(image)
    print surf_area

#    newloc = './segmentation/18/'
#    image = threshold(image, (17028, 20560))
#    image = getrid2D(image, 2)
#    imsave2(newloc, image)


#    imsave2('./segmentation/30/', thresholded)