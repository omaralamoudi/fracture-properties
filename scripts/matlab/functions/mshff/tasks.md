# 1. A single implementation for 2d and 3d images
A problem was encountered when implementing mshff for images of different dimesions. The problem has to do with the ability of accessing the last dimension of an array. I found a solution to this problem [here](https://stackoverflow.com/questions/19955653/matlab-last-dimension-access-on-ndimensions-matrix).

## How to implement the solution
```
data = rand(2, 2, 2, 5);
otherdims = repmat({':'},1,ndims(data)-1);
data(otherdims{:}, 1)
```