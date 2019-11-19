clear
clc

% load the data from folder
imagePath = fullfile('d:\', 'deep_learning', 'recgonize');
img = imageDatastore(imagePath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% count the num of the data
count_list = countEachLabel(img);
count = sum(count_list.Count);

% resize all the image to the same size
% THIS WILL CHANGE THE FILES IN YOUR FOLDER, Please Uncommon 
% for i = 1: count
%    I = imread(img.Files{i});
%    J = imresize(I, [255 255]);
%    imwrite(J, img.Files{i});
%    clc
%    disp(i + " / " + count)
% end

% load the data again from file
imagePath = fullfile('d:\', 'deep_learning', 'recgonize');
img = imageDatastore(imagePath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% set the number of the training set
TrainNum = count_list.Count(1);

% split the training and validation into two parts
[TrainImage, ValidationImage] = splitEachLabel(img, 200, 'randomized');

% set the layers
layers = [
    imageInputLayer([255 255 3])
    
    convolution2dLayer(3,8,'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3,16,'Padding' ,'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    dropoutLayer(0.2)
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions(...
    'sgdm',...
    'InitialLearnRate', 0.01,...
    'MaxEpochs', 30,...
    'Shuffle', 'every-epoch',...
    'ValidationData', ValidationImage,...
    'ValidationFrequency', 15,...
    'Verbose', false,...
    'Plots', 'training-progress');

net = trainNetwork(TrainImage, layers, options);