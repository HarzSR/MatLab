function SimpleColorDetection()
clc;	
clear;	
close all;	
workspace;	
if(~isdeployed)
	cd(fileparts(which(mfilename))); 
end
ver
message = sprintf('This demo will illustrate very simple color detection in RGB color space.\nIt requires the Image Processing Toolbox.\nDo you wish to continue?');
reply = questdlg(message, 'Run Demo?', 'OK','Cancel', 'OK');
if strcmpi(reply, 'Cancel')
	return;
end
try
	versionInfo = ver;
	hasIPT = false;
	for k = 1:length(versionInfo)
		if strcmpi(versionInfo(k).Name, 'Image Processing Toolbox') > 0
			hasIPT = true;
		end
	end
	if ~hasIPT
		message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
		reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
		if strcmpi(reply, 'No')
			return;
		end
    end
    close all;
	fontSize = 16;
	figure;
	set(gcf, 'Position', get(0, 'ScreenSize')); 
    if(~isdeployed)
		cd(fileparts(which(mfilename)));
    end
    message = sprintf('Do you want use a standard demo image,\nOr pick one of your own?');
	reply2 = questdlg(message, 'Which Image?', 'Demo','My Own', 'Demo');
	if strcmpi(reply2, 'Demo')
	    message = sprintf('Which demo image do you want to use?');
		selectedImage = questdlg(message, 'Which Demo Image?', 'Onions', 'Peppers', 'Canoe', 'Onions');
		if strcmp(selectedImage, 'Onions')
			fullImageFileName = 'onion.png';
		elseif strcmp(selectedImage, 'Peppers')
			fullImageFileName = 'peppers.png';
		else
			fullImageFileName = 'canoe.tif';
		end
	else
		originalFolder = pwd; 
		folder = 'C:\Program Files\MATLAB\R2010a\toolbox\images\imdemos'; 
		if ~exist(folder, 'dir') 
			folder = pwd; 
		end 
		cd(folder); 
		[baseFileName, folder] = uigetfile('*.*', 'Specify an image file'); 
		fullImageFileName = fullfile(folder, baseFileName); 
		cd(originalFolder);
		selectedImage = 'My own image'; 
    end
    if ~exist(fullImageFileName, 'file')
		message = sprintf('This file does not exist:\n%s', fullImageFileName);
		uiwait(msgbox(message));
		return;
    end
    [rgbImage storedColorMap] = imread(fullImageFileName); 
	[rows columns numberOfColorBands] = size(rgbImage); 
	if strcmpi(class(rgbImage), 'uint8')
		eightBit = true;
	else
		eightBit = false;
	end
	if numberOfColorBands == 1
		if isempty(storedColorMap)
			rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
		else
			rgbImage = ind2rgb(rgbImage, storedColorMap);
			if eightBit
				rgbImage = uint8(255 * rgbImage);
			end
		end
	end 
	subplot(3, 4, 1);
	imshow(rgbImage);
	drawnow; 
	if numberOfColorBands > 1 
		title('Original Color Image', 'FontSize', fontSize); 
	else 
		caption = sprintf('Original Indexed Image\n(converted to true color with its stored colormap)');
		title(caption, 'FontSize', fontSize);
    end
    redBand = rgbImage(:, :, 1); 
	greenBand = rgbImage(:, :, 2); 
	blueBand = rgbImage(:, :, 3); 
	subplot(3, 4, 2);
	imshow(redBand);
	title('Red Band', 'FontSize', fontSize);
	subplot(3, 4, 3);
	imshow(greenBand);
	title('Green Band', 'FontSize', fontSize);
	subplot(3, 4, 4);
	imshow(blueBand);
	title('Blue Band', 'FontSize', fontSize);
	message = sprintf('These are the individual color bands.\nNow we will compute the image histograms.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		return;
	end
	fontSize = 13;
	hR = subplot(3, 4, 6); 
	[countsR, grayLevelsR] = imhist(redBand); 
	maxGLValueR = find(countsR > 0, 1, 'last'); 
	maxCountR = max(countsR); 
	bar(countsR, 'r'); 
	grid on; 
	xlabel('Gray Levels'); 
	ylabel('Pixel Count'); 
	title('Histogram of Red Band', 'FontSize', fontSize);
    hG = subplot(3, 4, 7); 
	[countsG, grayLevelsG] = imhist(greenBand); 
	maxGLValueG = find(countsG > 0, 1, 'last'); 
	maxCountG = max(countsG); 
	bar(countsG, 'g', 'BarWidth', 0.95); 
	grid on; 
	xlabel('Gray Levels'); 
	ylabel('Pixel Count'); 
	title('Histogram of Green Band', 'FontSize', fontSize);
    hB = subplot(3, 4, 8); 
	[countsB, grayLevelsB] = imhist(blueBand); 
	maxGLValueB = find(countsB > 0, 1, 'last'); 
	maxCountB = max(countsB); 
	bar(countsB, 'b'); 
	grid on; 
	xlabel('Gray Levels'); 
	ylabel('Pixel Count'); 
	title('Histogram of Blue Band', 'FontSize', fontSize);
    maxGL = max([maxGLValueR,  maxGLValueG, maxGLValueB]); 
	if eightBit 
			maxGL = 255; 
	end 
	maxCount = max([maxCountR,  maxCountG, maxCountB]); 
	axis([hR hG hB], [0 maxGL 0 maxCount]); 
    subplot(3, 4, 5); 
	plot(grayLevelsR, countsR, 'r', 'LineWidth', 2); 
	grid on; 
	xlabel('Gray Levels'); 
	ylabel('Pixel Count'); 
	hold on; 
	plot(grayLevelsG, countsG, 'g', 'LineWidth', 2); 
	plot(grayLevelsB, countsB, 'b', 'LineWidth', 2); 
	title('Histogram of All Bands', 'FontSize', fontSize); 
	maxGrayLevel = max([maxGLValueR, maxGLValueG, maxGLValueB]); 
	if eightBit 
		xlim([0 255]); 
	else 
		xlim([0 maxGrayLevel]); 
    end 
    message = sprintf('Now we will select some color threshold ranges\nand display them over the histograms.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		return;
    end
    if strcmpi(reply2, 'My Own') || strcmpi(selectedImage, 'Canoe') > 0
		redThresholdLow = graythresh(redBand);
		redThresholdHigh = 255;
		greenThresholdLow = 0;
		greenThresholdHigh = graythresh(greenBand);
		blueThresholdLow = 0;
		blueThresholdHigh = graythresh(blueBand);
		if eightBit
			redThresholdLow = uint8(redThresholdLow * 255);
			greenThresholdHigh = uint8(greenThresholdHigh * 255);
			blueThresholdHigh = uint8(blueThresholdHigh * 255);
		end
	else
		redThresholdLow = 85;
		redThresholdHigh = 255;
		greenThresholdLow = 0;
		greenThresholdHigh = 70;
		blueThresholdLow = 0;
		blueThresholdHigh = 90;
    end
    PlaceThresholdBars(6, redThresholdLow, redThresholdHigh);
	PlaceThresholdBars(7, greenThresholdLow, greenThresholdHigh);
	PlaceThresholdBars(8, blueThresholdLow, blueThresholdHigh);
	message = sprintf('Now we will apply each color band threshold range to the color band.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		return;
    end
    redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
	greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
	blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);
    fontSize = 16;
	subplot(3, 4, 10);
	imshow(redMask, []);
	title('Is-Red Mask', 'FontSize', fontSize);
	subplot(3, 4, 11);
	imshow(greenMask, []);
	title('Is-Not-Green Mask', 'FontSize', fontSize);
	subplot(3, 4, 12);
	imshow(blueMask, []);
	title('Is-Not-Blue Mask', 'FontSize', fontSize);
	redObjectsMask = uint8(redMask & greenMask & blueMask);
	subplot(3, 4, 9);
	imshow(redObjectsMask, []);
	caption = sprintf('Mask of Only\nThe Red Objects');
	title(caption, 'FontSize', fontSize);
    smallestAcceptableArea = 100; 
	message = sprintf('Note the small regions in the image in the lower left.\nNext we will eliminate regions smaller than %d pixels.', smallestAcceptableArea);
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		return;
    end
    figure;  
	set(gcf, 'Position', get(0, 'ScreenSize'));
    redObjectsMask = uint8(bwareaopen(redObjectsMask, smallestAcceptableArea));
	subplot(3, 3, 1);
	imshow(redObjectsMask, []);
	fontSize = 13;
	caption = sprintf('bwareaopen() removed objects\nsmaller than %d pixels', smallestAcceptableArea);
	title(caption, 'FontSize', fontSize);
    structuringElement = strel('disk', 4);
	redObjectsMask = imclose(redObjectsMask, structuringElement);
	subplot(3, 3, 2);
	imshow(redObjectsMask, []);
	fontSize = 16;
	title('Border smoothed', 'FontSize', fontSize);
    redObjectsMask = uint8(imfill(redObjectsMask, 'holes'));
	subplot(3, 3, 3);
	imshow(redObjectsMask, []);
	title('Regions Filled', 'FontSize', fontSize);
	message = sprintf('This is the filled, size-filtered mask.\nNow we will apply this mask to the original image.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		return;
    end
    redObjectsMask = cast(redObjectsMask, class(redBand)); 
    maskedImageR = redObjectsMask .* redBand;
	maskedImageG = redObjectsMask .* greenBand;
	maskedImageB = redObjectsMask .* blueBand;
	subplot(3, 3, 4);
	imshow(maskedImageR);
	title('Masked Red Image', 'FontSize', fontSize);
	subplot(3, 3, 5);
	imshow(maskedImageG);
	title('Masked Green Image', 'FontSize', fontSize);
	subplot(3, 3, 6);
	imshow(maskedImageB);
	title('Masked Blue Image', 'FontSize', fontSize);
	maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
	subplot(3, 3, 8);
	imshow(maskedRGBImage);
	fontSize = 13;
	caption = sprintf('Masked Original Image\nShowing Only the Red Objects');
	title(caption, 'FontSize', fontSize);
	subplot(3, 3, 7);
	imshow(rgbImage);
	title('The Original Image (Again)', 'FontSize', fontSize);
    [meanRGB, areas, numberOfBlobs] = MeasureBlobs(redObjectsMask, redBand, greenBand, blueBand);
	if numberOfBlobs > 0
		fprintf(1, '\n----------------------------------------------\n');
		fprintf(1, 'Blob #, Area in Pixels, Mean R, Mean G, Mean B\n');
		fprintf(1, '----------------------------------------------\n');
		for blobNumber = 1 : numberOfBlobs
			fprintf(1, '#%5d, %14d, %6.2f, %6.2f, %6.2f\n', blobNumber, areas(blobNumber), ...
				meanRGB(blobNumber, 1), meanRGB(blobNumber, 2), meanRGB(blobNumber, 3));
		end
	else
		message = sprintf('No red blobs were found in the image:\n%s', fullImageFileName);
		fprintf(1, '\n%s\n', message);
		uiwait(msgbox(message));
	end
	subplot(3, 3, 9);
	ShowCredits();
	message = sprintf('Done!\n\nThe demo has finished.\n\nLook the MATLAB command window for\nthe area and color measurements of the %d regions.', numberOfBlobs);
	msgbox(message);
catch ME
	errorMessage = sprintf('Error running this m-file:\n%s\n\nThe error message is:\n%s', ...
		mfilename('fullpath'), ME.message);
	errordlg(errorMessage);
end
return; 
function [meanRGB, areas, numberOfBlobs] = MeasureBlobs(maskImage, redBand, greenBand, blueBand)
	[labeledImage numberOfBlobs] = bwlabel(maskImage, 8);    
	if numberOfBlobs == 0
		meanRGB = [0 0 0];
		areas = 0;
		return;
	end
	blobMeasurementsR = regionprops(labeledImage, redBand, 'area', 'MeanIntensity');   
	blobMeasurementsG = regionprops(labeledImage, greenBand, 'area', 'MeanIntensity');   
	blobMeasurementsB = regionprops(labeledImage, blueBand, 'area', 'MeanIntensity');   
	meanRGB = zeros(numberOfBlobs, 3); 
	meanRGB(:,1) = [blobMeasurementsR.MeanIntensity]';
	meanRGB(:,2) = [blobMeasurementsG.MeanIntensity]';
	meanRGB(:,3) = [blobMeasurementsB.MeanIntensity]';
	if ~strcmpi(class(redBand), 'uint8')
		meanRGB = meanRGB * 255.0;
	end
	areas = zeros(numberOfBlobs, 3); 
	areas(:,1) = [blobMeasurementsR.Area]';
	areas(:,2) = [blobMeasurementsG.Area]';
	areas(:,3) = [blobMeasurementsB.Area]';
	return;
    function PlaceThresholdBars(plotNumber, lowThresh, highThresh)
	subplot(3, 4, plotNumber); 
	hold on;
	maxYValue = ylim;
	maxXValue = xlim;
	hStemLines = stem([lowThresh highThresh], [maxYValue(2) maxYValue(2)], 'r');
	children = get(hStemLines, 'children');
	set(children(2),'visible', 'off');
	fontSizeThresh = 14;
	annotationTextL = sprintf('%d', lowThresh);
	annotationTextH = sprintf('%d', highThresh);
	text(double(lowThresh + 5), double(0.85 * maxYValue(2)), annotationTextL, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	text(double(highThresh + 5), double(0.85 * maxYValue(2)), annotationTextH, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	return; 
    function ShowCredits()
	logoFig = subplot(3,3,9);
	caption = sprintf('A MATLAB Demo\nby TechnoBreed');
	text(0.5,1.15, caption, 'Color','r', 'FontSize', 18, 'FontWeight','b', 'HorizontalAlignment', 'Center') ;
	positionOfLowerRightPlot = get(logoFig, 'position');
	L = 40*membrane(1,25);
	logoax = axes('CameraPosition', [-193.4013 -265.1546  220.4819],...
		'CameraTarget',[26 26 10], ...
		'CameraUpVector',[0 0 1], ...
		'CameraViewAngle',9.5, ...
		'DataAspectRatio', [1 1 .9],...
		'Position', positionOfLowerRightPlot, ...
		'Visible','off', ...
		'XLim',[1 51], ...
		'YLim',[1 51], ...
		'ZLim',[-13 40], ...
		'parent',gcf);
	s = surface(L, ...
		'EdgeColor','none', ...
		'FaceColor',[0.9 0.2 0.2], ...
		'FaceLighting','phong', ...
		'AmbientStrength',0.3, ...
		'DiffuseStrength',0.6, ... 
		'Clipping','off',...
		'BackFaceLighting','lit', ...
		'SpecularStrength',1.1, ...
		'SpecularColorReflectance',1, ...
		'SpecularExponent',7, ...
		'Tag','TheMathWorksLogo', ...
		'parent',logoax);
	l1 = light('Position',[40 100 20], ...
		'Style','local', ...
		'Color',[0 0.8 0.8], ...
		'parent',logoax);
	l2 = light('Position',[.5 -1 .4], ...
		'Color',[0.8 0.8 0], ...
		'parent',logoax);
	return;
