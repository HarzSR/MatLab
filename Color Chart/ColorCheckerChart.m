clc;    
close all; 
imtool close all; 
clear; 
workspace; 
format longg;
format compact;
chipNames = {
'Dark Skin';
'Light Skin';
'Blue Sky';
'Foliage';
'Blue Flower';
'Bluish Green';
'Orange';
'Purple Red';
'Moderate Red';
'Purple';
'Yellow Green';
'Orange Yellow';
'Blue';
'Green';
'Red';
'Yellow';
'Magenta';
'Cyan';
'White';
'Neutral 8';
'Neutral 65';
'Neutral 5';
'Neutral 35';
'Black'};
sRGB_Values = uint32([...
115,82,68
194,150,130
98,122,157
87,108,67
133,128,177
103,189,170
214,126,44
80,91,166
193,90,99
94,60,108
157,188,64
224,163,46
56,61,150
70,148,73
175,54,60
231,199,31
187,86,149
8,133,161
243,243,242
200,200,200
160,160,160
122,122,121
85,85,85
52,52,52]);
defaultValue = {'1280', '26'};
titleBar = 'Enter an integer value';
userPrompt = {'Enter the width of the image in pixels', 'Enter the width of the grid lines in pixels'};
caUserInput = inputdlg(userPrompt, titleBar, 1, defaultValue);
if isempty(caUserInput),return,end; 
imageWidth = round(str2num(cell2mat(caUserInput(1))));
if isnan(imageWidth)
    imageWidth = defaultValue;
    message = sprintf('I said it had to be an integer.\nI will use %d and continue.', defaultValue);
    uiwait(warndlg(message));
end
gridWidth = round(str2num(cell2mat(caUserInput(2))));
if isnan(gridWidth)
	gridWidth = defaultValue;
	message = sprintf('I said it had to be an integer.\nI will use %d and continue.', defaultValue);
	uiwait(warndlg(message));
end
chipWidth = int32((imageWidth - 7 * gridWidth)/ 6);
imageHeight = 4 * (chipWidth + gridWidth) + gridWidth;
promptMessage = sprintf('Do you want to display color chip names and RGB values over the image?');
reply = questdlg(promptMessage, 'Display labels?', 'Yes', 'No', 'Yes');
if strcmpi(reply, 'Yes')
	displayLabels = true;
else
	displayLabels = false;
end
cols = (gridWidth + 1) : (chipWidth + gridWidth) : imageWidth;
rows = (gridWidth + 1) : (chipWidth + gridWidth) : imageHeight;
rgbImage = zeros(imageHeight, imageWidth, 3, 'uint8');
chipNumber = 1;
for row = 1 : 4
	row1 = rows(row);
	row2 = row1 + chipWidth;
	for col = 1 : 6
		col1 = cols(col);
		col2 = col1 + chipWidth;
		rgbImage(row1:row2, col1:col2, 1) = sRGB_Values(chipNumber, 1);
		rgbImage(row1:row2, col1:col2, 2) = sRGB_Values(chipNumber, 2);
		rgbImage(row1:row2, col1:col2, 3) = sRGB_Values(chipNumber, 3);
		chipNumber = chipNumber + 1;
	end
end
imshow(rgbImage);
axis on;
fontSize = 12;
if displayLabels
	chipNumber = 1;
	for row = 1 : 4
		row1 = rows(row) + chipWidth/2;
		for col = 1 : 6
			col1 = cols(col) + 3;
			chipName = chipNames{chipNumber};
			textLabel = sprintf('%s\nR=%3d\nG=%3d\nB=%3d', chipName, sRGB_Values(chipNumber, 1), sRGB_Values(chipNumber, 2), sRGB_Values(chipNumber, 3));
			if sum(sRGB_Values(chipNumber, :)) > 470
				text(double(col1), double(row1), textLabel, 'Color', 'k', 'FontSize', fontSize);
			else
				text(double(col1), double(row1), textLabel, 'Color', 'w', 'FontSize', fontSize);
			end
			chipNumber = chipNumber + 1;
		end 
    end
	set(gca, 'Units', 'Normalized', 'Position', [0.05 0.05 .9 .9]);
	fontSize = 14;
	yTextBottom = 15; 
	text(gridWidth, yTextBottom, 'Color Checker Chart', 'Color', 'w', 'FontSize', fontSize);
	yTextBottom = double(imageHeight - gridWidth/2);
	text(gridWidth, yTextBottom, 'X-Rite', 'Color', 'w', 'FontSize', fontSize);
end 
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
drawnow;
promptMessage = sprintf('This is the Color Checker Color Rendition Chart\nusing sRGB color values as defined by X-Rite, Inc.\nwhich is the manufacturer.\n\n Do you want to save this image?');
titleBarCaption = 'Done.  Now Save Image?';
button = questdlg(promptMessage, titleBarCaption, 'Yes, Save', 'No, Quit', 'No, Quit');
if strcmp(button, 'No, Quit')
	return;
end
promptMessage = sprintf('Do you want to save this image with or without the text?');
titleBarCaption = 'Save text annotations?';
button = questdlg(promptMessage, titleBarCaption, 'With Text', 'Without Text', 'With Text');
startingFolder = pwd;
defaultFileName = fullfile(startingFolder, 'Color Checker Chart.png');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
if baseFileName == 0
	return;
end
fullFileName = fullfile(folder, baseFileName);
set(gcf, 'Pointer', 'watch');
drawnow;
if exist(fullFileName, 'file')
	recycle on;
	delete(fullFileName); 
end
if strcmp(button, 'Without Text')
	imwrite(rgbImage, fullFileName);
	message = sprintf('Image has been saved with imwrite() to file:\n\n%s', fullFileName);
else
	hasExport_fig = ~isempty(which('export_fig'));
	if hasExport_fig
		axis('off');
		export_fig(gca, fullFileName); 
		message = sprintf('Image has been saved with export_fig() to file:\n\n%s', fullFileName);
	else
		saveas(gcf, fullFileName);
		message = sprintf('Image has been saved with saveas() to file:\n\n%s', fullFileName);
	end
end
msgbox(message);
set(gcf,'Pointer','arrow');
drawnow;
