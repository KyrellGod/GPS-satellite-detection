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

function [detectedPRN, detectedCFOcoarse] = detection(samp_rate, IQsamples, freq_detection)

    disp(' ')
    disp('Correlating each satellite PRN up to PRN=32 ...');
    
    % generate a time base for mixing
    time = 0 : 1/samp_rate : numel(IQsamples)/samp_rate;
    time = time(1:end-1)';    

    % for each possible satellite
    cnt_disp = 1;
    for m = freq_detection.candidatePRN

        % show progress
        fprintf('%d ', m);
        cnt_disp = cnt_disp + 1;
        if cnt_disp > 10
            cnt_disp = 0;
            fprintf('\n');
        end

        % generate PRN
        PRN = cacode(m,samp_rate/1023000);

        % run through all possible frequency offsets
        l = 1;
        for freq = freq_detection.low : freq_detection.step : freq_detection.high

            % frequency shift the signal
            IQsamples_mixed = IQsamples.*exp(1i*2*pi*(-freq)*time);

            % check for cross correlation maximum
            corr_result(l,m) = max(abs(xcorr_cst(PRN,IQsamples_mixed)));
            
            % increase index
            l = l+1;
        end
    end

    % plot image
    figure(1)
    imagesc(abs(corr_result))
    ylabel('Frequency Offset = Doppler + Crystal oscillator')
    xlabel('PRN')
    colorbar
    yticklabels = freq_detection.low : ((freq_detection.high - freq_detection.low)/10) : freq_detection.high;      
    yticks = linspace(1, size(abs(corr_result), 1), numel(yticklabels));
    set(gca, 'YTick', yticks, 'YTickLabel', flipud(yticklabels(:)));
    title('High values indicate satellites');

    disp(' ')
    disp('Checking if any satellites exist (comparing to threshold) ...');    

    % search for signals above the threshold
    detectedPRN = [];
    detectedCFOcoarse = [];
    for i = freq_detection.candidatePRN

        % check maximum over frequency
        [i0, i1] = max(corr_result(:,i));
        if (i0 > freq_detection.threshold)
            detectedPRN(end+1) = i;
            detectedCFOcoarse(end+1) = freq_detection.low + (i1-1)*freq_detection.step;
        end
    end

    % show result
    for i=1:1:numel(detectedPRN)
        fprintf('PRN detected: %d  coarse CFO: %.2f Hz\n', detectedPRN(i), detectedCFOcoarse(i));
    end
end
