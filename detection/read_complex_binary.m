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

% source: https://github.com/UpYou/gnuradio-tools/blob/master/matlab/read_complex_binary.m
%
% Changes: Samples can be skiped.

function v = read_complex_binary(filename, count, skip_samples)

    f = fopen(filename, 'rb');
    
    if (f < 0)
        
        error('ERROR: Cannot read file with path: %s', filename);
        
    else
        
        % check if skip samples and read samples are smaller than actual file size
        filebytes = dir(filename);

        % 2 -> real and imag, 4 -> 32-bit-float
        if((skip_samples + count)*2*4 > filebytes.bytes)
            fprintf('\nFilesize in bytes:            %d\n', filebytes.bytes);
            fprintf('\nSkip and count size in bytes: %d\n', (skip_samples + count)*2*4);       
            error('ERROR: Skip and count are larger than file.');
        end 

        % skip complex samples
        if(skip_samples > 0)
            fseek(f, skip_samples*2*4,'bof');
        end

        % read in bytes
        t = fread(f, [2, count], 'float');    
        fclose (f);
        v = t(1,:) + t(2,:)*1i;
        [r,c] = size(v);
        v = reshape (v, c, r);      
    end
end
