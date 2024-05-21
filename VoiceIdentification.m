%% Voice Identification
% Signals and Systems 2 Design Project
% Rory Ribarits (s3840280)
% Ashwin Venkita Subharaman (s3783614)

% The VCTK Corpus dataset was used as the unknown class to detect an
% unautorised person. The group members recorded themselves saying the same
% sentences to act as the autorised people.

% IDs taken from VCTK Corpus dataset:
%   p244 F
%   p286 M
%   p326 M
%   p335 F
%   p361 F
%   p374 M

% Sentences taken from VCTK Corpus dataset:
%   006 - 024

clear;
close all;
clc;

%% Convert data to MEL spectrogram - ONLY UNCOMMENT IF DATASET NEEDS TO BE CONVERTED
% convertAudioToMelSpec('./Voice Dataset/UnknownVoices', 'UnknownVoices');
% convertAudioToMelSpec('./Voice Dataset/Andrew', 'Andrew');
% convertAudioToMelSpec('./Voice Dataset/Ash', 'Ash');
% convertAudioToMelSpec('./Voice Dataset/Ashwin', 'Ashwin');
% convertAudioToMelSpec('./Voice Dataset/Rory', 'Rory');

%% Load data
imds = imageDatastore('mel_spectrograms', ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%% Divide the data into training and validation datasets. 
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7, 'randomized');

%% Load Pretrained Network
net = alexnet;

%% Obtain required size of input layer
inputSize = net.Layers(1).InputSize;

%% Replace final layers
layersTransfer = net.Layers(1:end-3);

classNames = categories(imdsTrain.Labels);
numClasses = numel(classNames);

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
    softmaxLayer
    classificationLayer];

%% Reshape datasets to fit input size
augimdsTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain);
augimdsValidation = augmentedImageDatastore(inputSize(1:2), imdsValidation);

%% Set training options
opts = trainingOptions('sgdm', ... 
    'MiniBatchSize', 19, ... 
    'InitialLearnRate', 1e-4, ... 
    'MaxEpochs', 6, ...
    'Shuffle', 'every-epoch', ... 
    'Plots', 'training-progress', ... 
    'ValidationData', augimdsValidation, ... 
    'ValidationFrequency', 4, ... 
    'Verbose', false);

%% Train alexnet using transfer learning
netTransfer = trainNetwork(augimdsTrain, layers, opts);

%% Classify Validation Images
[YPred, scores] = classify(netTransfer, augimdsValidation);

%% Calculate accuracy
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation);

%% Save trained alexnet model to .mat file
save('voiceModel.mat', 'netTransfer');