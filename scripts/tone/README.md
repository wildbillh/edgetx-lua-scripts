# Throttle Tone Generating Function Script

## Description

An example LUA function script for EdgeTX transmittlers. When called from a 
special function, this script generates tones based on the current throttle position,
somewhat emulating engine noise.

## Getting Started

### WARNING
This script has been tested on my RadioMaster TX16s Max 3 and EdgeTx Companion. 

**USE AT YOUR OWN RISK!**

### Modifications and Global Variables
There are four parameters that are defaulted but configurable in the script:

- **Duration (GV12)** - The number of milliseconds the tone will play for each run() execution.
- **Min Frequency (GV13)** - The frequency for the lowest used throttle position.
- **Max Frequency (GV14)** - The frequency for the highest used throttle position.
- **Min Throttle (GV15)** - The throttle position to begin emitting tones. 

To use a different set of global variables, modify the declared indexes in the script:

`local GVI_DURATION = 11`

`local GVI_MIN_FREQ = 12`

`local GVI_MAX_FREQ = 13`

`local GVI_MIN_THROTTLE = 14`

If a global variable is not assigned (=0), the default value will be used. 
You can disable the checking of global variables by setting this value in the script:

`local USE_GLOBAL_VARIABLES = false`

Modify these lines to change the defaults in the script:

`local PLAY_DURRATION_MS = 100`

`local MIN_FREQ = 300`

`local MAX_FREQ = 800`

`local MIN_THROTTLE = -950`


### Installing

Copy tone.lua to the SCRIPTS/FUNCTIONS folder of your transmitter. Select LUA as the source in the 
special function and then select the tone script. 

### Tips
- If the tones start to stack up, set the Duration down until there is a slight pause between tones. This 
gives a more realistic engine sound.
- In order to see new changes based on the global variables, you may need to disable and then enable your
special function to unload and reload the script into memory.  


## License
This project is licensed under the MIT License. See [LICENSE](/LICENSE) file for details.
