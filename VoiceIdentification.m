%% Voice Identification
% Signals and Systems 2 Design Project
% Rory Ribarits (s3840280)
% Ashwin Venkita Subharaman (s3783614)

clear all;
close all;
clc;

%% Load data
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

%% Convert data to MEL spectrogram

[audioIn,fs] = audioread('./Voice Dataset/p374/p374_007_mic2.flac');

S = melSpectrogram(audioIn,fs);
