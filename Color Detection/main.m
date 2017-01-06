clc;   
close all;  
imtool close all; 
clear;  
workspace;
fontSize = 14;
folder = 'foldername';
%Download this Image and keep it in a folder. Img - https://goo.gl/kXor1m
baseFileName = 'abc.jpg';
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
	fullFileName = baseFileName;
	if ~exist(fullFileName, 'file')
		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbImage = imread(fullFileName);
[rows columns numberOfColorBands] = size(rgbImage);
subplot(2, 4, 1);
imshow(rgbImage);
title('Original Color Image', 'FontSize', fontSize);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
subplot(2, 4, 2);
imshow(redChannel);
title('RedChannel Image', 'FontSize', fontSize);
subplot(2, 4, 3);
imshow(greenChannel);
title('Green Channel Image', 'FontSize', fontSize);
subplot(2, 4, 4);
imshow(blueChannel);
title('Blue Channel Image', 'FontSize', fontSize);
[pixelCount grayLevels] = imhist(redChannel);
subplot(2, 4, 6); 
bar(pixelCount);
grid on;
title('Histogram of original image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); 
[pixelCount grayLevels] = imhist(greenChannel);
subplot(2, 4, 7); 
bar(pixelCount);
grid on;
title('Histogram of original image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); [pixelCount grayLevels] = imhist(blueChannel);
subplot(2, 4, 8); 
bar(pixelCount);
grid on;
title('Histogram of original image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); 
[EDIT]
redMask = (redChannel > 190) & (greenChannel < 150) & (blueChannel < 90);
redMask = imfill(redMask, 'holes');
greenMask = (redChannel < 167) & (greenChannel > 160) & (blueChannel < 150);
greenMask = imfill(greenMask, 'holes'); 
blueMask = (redChannel < 120) & (greenChannel > 60) & (greenChannel < 130) & (blueChannel> 100);
blueMask = imfill(blueMask, 'holes'); 
figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(2, 3, 1);
imshow(redMask);
title('Red Mask', 'FontSize', fontSize);
subplot(2, 3, 2);
imshow(greenMask);
title('Green Mask', 'FontSize', fontSize);
subplot(2, 3, 3);
imshow(blueMask);
title('Blue Mask', 'FontSize', fontSize);
maskedRgbImage = bsxfun(@times, rgbImage, cast(redMask,class(rgbImage)));
subplot(2, 3, 4);
imshow(maskedRgbImage);
maskedRgbImage = bsxfun(@times, rgbImage, cast(greenMask,class(rgbImage)));
subplot(2, 3, 5);
imshow(maskedRgbImage);
maskedRgbImage = bsxfun(@times, rgbImage, cast(blueMask,class(rgbImage)));
subplot(2, 3, 6);
imshow(maskedRgbImage);
