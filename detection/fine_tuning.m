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

function [detectedCFOfine] = fine_tuning(samp_rate, IQsamples, freq_detection)

    disp(' ')
    disp('Fine tuning every satellite found ...');
    
    % for each coarse estimation we will find a fine estimation
    detectedCFOfine = zeros(size(freq_detection.detectedCFOcoarse));
    
    % generate time axis for mixing
    time = 0 : 1/samp_rate : length(IQsamples)/samp_rate;
    time = time(1:end-1)';   

    % fine tune for each found satellite
    for i=1:1:numel(freq_detection.detectedPRN)

        % regenerate PRN of detected satellite
        PRN = cacode(freq_detection.detectedPRN(i),samp_rate/1023000);       

        % search for a better approximation near the coarse value
        total_max = 0;
        low_fine = freq_detection.detectedCFOcoarse(i) - freq_detection.seach_area_fine;
        up_fine = freq_detection.detectedCFOcoarse(i) + freq_detection.seach_area_fine;
        for freq = low_fine : freq_detection.step_fine : up_fine

            % frequency shift the signal
            IQsamples_mixed = IQsamples.*exp(1i*2*pi*(-freq)*time);

            % determine correlation maximum
            curr_max = max(abs(xcorr_cst(IQsamples_mixed, PRN)));

            % check for cross correlation max.
            if curr_max > total_max
                total_max = curr_max;
                detectedCFOfine(i) = freq;
            end

            % debugging: show each correlation step for visual debugging
            %disp(' ');
            %disp(freq_detection.detectedPRN(i))
            %disp(freq)
            %disp(curr_max)
            %disp(total_max)
            %disp(detectedCFOfine(i))
            %figure(1)
            %plot(abs(xcorr_cst(IQsamples_mixed,PRN)));
            %input('blocking call');
        end
    end
    
    % show result
    for i=1:1:numel(freq_detection.detectedPRN)
        fprintf('PRN detected: %d  fine CFO: %.2f Hz\n', freq_detection.detectedPRN(i), detectedCFOfine(i));
    end
end
