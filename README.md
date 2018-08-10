# GPS-satellite-detection
This program can detect signals of GPS satellites in a record of IQ samples.

## How to use it

There are two steps you have to follow.

### 1. Record IQ samples

Various software tools can be used. I prefer GNU Radio but SDRSharp should work fine as well. On the hardware side, I use an RTL-SDR by NooElec with a 0.5PPM TCXO based on RTL2832U & R820T2. The antenna must be an active GPS antenna, otherwise the signal will be too weak. Any cheap active GPS antenna will work.

I've put an exemplary record of 50000 IQ samples in the folder *samples_recorded*. Each IQ sample has a 4 byte real part and a 4 byte imaginary part, so the total file size is 50000*(4+4)=400000 kB.

### 2. Open Matlab and run the script *GPS_satellite_detection_example.m*

The script output for the example record will look like this.

```matlab
>> GPS_satellite_detection_example
 
Calculating reference level with PRN=37 (this PRN is not used) ...
Reference level: 0.765342
 
Correlating each satellite PRN up to PRN=32 ...
1 2 3 4 5 6 7 8 9 10 
11 12 13 14 15 16 17 18 19 20 21 
22 23 24 25 26 27 28 29 30 31 32 
 
Checking if any satellites exist (comparing to threshold) ...
PRN detected: 4  coarse CFO: 1100.00 Hz
PRN detected: 7  coarse CFO: 1500.00 Hz
PRN detected: 16  coarse CFO: 100.00 Hz
 
Fine tuning every satellite found ...
PRN detected: 4  fine CFO: 1055.00 Hz
PRN detected: 7  fine CFO: 1540.00 Hz
PRN detected: 16  fine CFO: 140.00 Hz
```
Three satellites were detected. The script will also display an image with the same results.
![result](https://user-images.githubusercontent.com/20499620/43957521-61611e04-9ca8-11e8-9106-f9e524d9c1ee.jpg)
