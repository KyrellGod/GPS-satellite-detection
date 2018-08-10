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

function [ref_lev] = reference_level(samp_rate, IQsamples, freq_detection)

    disp(' ')
    disp('Calculating reference level with PRN=37 (this PRN is not used) ...');

    % generate the PRN of an unused satellite
    % 1023000 is the sampling rate of the GPS satellites
    PRN_unused = cacode(37,samp_rate/1023000);
    
    % generate a time base for mixing
    time = 0 : 1/samp_rate : numel(IQsamples)/samp_rate;
    time = time(1:end-1)';    

    % run through each possible frequency offset
    temp = [];
    for freq = freq_detection.low : freq_detection.step : freq_detection.high
        
        % mix the signal in the opposite direction -> -freq
        IQsamples_mixed = IQsamples.*exp(1i*2*pi*(-freq)*time);
        
        % calculate mean of the cross correlation
        temp(end+1) = mean(abs(xcorr_cst(IQsamples_mixed, PRN_unused)));
    end

    % calculate reference level
    ref_lev = mean(temp);
    
    % display the reference level value
	fprintf('Reference level: %f\n', ref_lev);
end
