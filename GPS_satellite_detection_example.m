%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

close all;
clear all;
addpath('detection/');

% sampling rate at which samples were recorded
samp_rate = 2e6;

% path to recorded samples
filepath = 'samples_recorded/50k_samples.bin';

% read 20k samples after skipping 10k samples from file and remove the mean
IQsamples = read_complex_binary(filepath, 20000, 10000);
IQsamples = IQsamples - mean(IQsamples);

% define PRNs of all the satellites have shall to be tested
freq_detection.candidatePRN = 1:32;      

% frequency search area
freq_detection.low = -10.0e3;	% lower limit, should cover doppler + crystal ppm offset
freq_detection.high = 10.0e3;	% upper limit, should cover doppler + crystal ppm offset
freq_detection.step = 100;

% to detect satellites we need a threshold
% 6.0 is an experience value
freq_detection.threshold = 6.0*reference_level(samp_rate, IQsamples, freq_detection);

% detect satellites by PRN and return a coarse CFO estimation
[detectedPRN, detectedCFOcoarse] = detection(samp_rate, IQsamples, freq_detection);

% after satellite detection the cfo is fine tuned
% 2.0 is an experience value
% 5.0 is an experience value
freq_detection.detectedPRN = detectedPRN;
freq_detection.detectedCFOcoarse = detectedCFOcoarse;
freq_detection.seach_area_fine = 2.0*freq_detection.step; 
freq_detection.step_fine = 5.0;

% fine tune the cfo offset
detectedCFOfine = fine_tuning(samp_rate, IQsamples, freq_detection);
