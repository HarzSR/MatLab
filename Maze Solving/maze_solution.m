function maze_solution
clc; 
close all; 
clear all; 
fontSize = 20;
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
startingFolder = 'E:\c\Hariharan\TechnoBreed - 2 Days MatLAB Workshop\CD Contents\Maze_Solution\Maze_Solution\SampleMazes';
if ~exist(startingFolder, 'dir')
	startingFolder = pwd;
end
continueWithAnother = true;
promptMessage = sprintf('Please specify a maze image (in the next window).\nThis program will attempt to solve the maze.');
button = questdlg(promptMessage, 'maze_solution', 'OK', 'Cancel', 'OK');
if strcmpi(button, 'Cancel')
	continueWithAnother = false;
end
while continueWithAnother
	defaultFileName = fullfile(startingFolder, '*.*');
	[baseFileName, folder] = uigetfile(defaultFileName, 'Select maze image file');
	if baseFileName == 0
		return;
	end
	fullFileName = fullfile(folder, baseFileName);
	originalImage = imread(fullFileName);
	[rows cols numberOfColorBands] = size(originalImage);
	if numberOfColorBands > 1
		redPlane = originalImage(:, :, 1);
		greenPlane = originalImage(:, :, 2);
		bluePlane = originalImage(:, :, 3);
		redStdDev = std(single(redPlane(:)));
		greenStdDev = std(single(greenPlane(:)));
		blueStdDev = std(single(bluePlane(:)));
		if redStdDev >= greenStdDev && redStdDev >= blueStdDev
			monoImage = single(redPlane);
		elseif greenStdDev >= redStdDev && greenStdDev >= blueStdDev
			monoImage = single(greenPlane);
		else
			monoImage = single(bluePlane);
		end
	else
		monoImage = single(originalImage);
	end
	close all;	
	subplot(2, 2, 1);
	imshow(monoImage, []);
	title('Original Image', 'FontSize', fontSize);
	set(gcf, 'Position', get(0,'Screensize'));
	maxValue = max(max(monoImage));
	minValue = min(min(monoImage));
	monoImage = uint8(255 * (single(monoImage) - minValue) / (maxValue - minValue));
	thresholdValue = uint8((maxValue + minValue) / 2);
	binaryImage = 255 * (monoImage < thresholdValue);
	subplot(2, 2, 2);
	imshow(binaryImage, []);
	title('Binary Image - The walls are white here, instead of black', 'FontSize', fontSize);
	[labeledImage numberOfWalls] = bwlabel(binaryImage, 4);   
	coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); 
	subplot(2, 2, 3);
	imshow(coloredLabels); 
	caption = sprintf('Labeled image of the %d walls, each a different color', numberOfWalls);
	title(caption, 'FontSize', fontSize);
	if numberOfWalls ~= 2
		message = sprintf('This is not a "perfect maze" with just 2 walls.\nThis maze appears to have %d walls,\nso you may get unexpected results.', numberOfWalls);
		uiwait(msgbox(message));
    end
    binaryImage2 = (labeledImage == 1);
	subplot(2, 2, 4);
	imshow(binaryImage2, []);
	title('One of the walls', 'FontSize', fontSize);
    dilationAmount = 7; 
	dilatedImage = imdilate(binaryImage2, ones(dilationAmount));
	figure; 
	set(gcf, 'Position', get(0,'Screensize'));
	subplot(2, 2, 1);
	imshow(dilatedImage, []);
	title('Dilation of one wall', 'FontSize', fontSize);
	filledImage = imfill(dilatedImage, 'holes');
	subplot(2, 2, 2);
	imshow(filledImage, []);
	title('Now filled to get rid of holes', 'FontSize', fontSize);
	erodedImage = imerode(filledImage, ones(dilationAmount));
	subplot(2, 2, 3);
	imshow(erodedImage, []);
	title('Eroded', 'FontSize', fontSize);
	solution = filledImage;
	solution(erodedImage) = 0;
	subplot(2, 2, 4);
	imshow(solution, []);
	title('The Difference = The Solution', 'FontSize', fontSize);
	if numberOfColorBands == 1
		redPlane = monoImage;
		greenPlane = monoImage;
		bluePlane = monoImage;
	end
	redPlane(solution) = 255;
	greenPlane(solution) = 0;
	bluePlane(solution) = 0;
	solvedImage = cat(3, redPlane, greenPlane, bluePlane);
	figure;
	imshow(solvedImage);
	set(gcf, 'Position', get(0,'Screensize'));
	title('Final Solution Over Original Image', 'FontSize', fontSize);
	promptMessage = sprintf('Do you want to solve another maze?');
	button = questdlg(promptMessage, 'maze_solution', 'Yes', 'No', 'No');
	if strcmpi(button, 'No')
		continueWithAnother = false;
	end
end
