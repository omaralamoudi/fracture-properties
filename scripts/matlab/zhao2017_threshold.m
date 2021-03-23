% This script computes the threshold values for an 8-bit image from the
% given table 6.3 in Zhao 2017 PhD thesis
threshold16 = [18685,21200;
               17700,20300;
               17755,20449;
               17600,20560;
               19578,22453;
               16058,19077];
threshold08 = round(threshold16 *((2^8)/(2^16)))