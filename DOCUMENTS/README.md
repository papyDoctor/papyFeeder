# papyFeeder feeder firmware

This project target the LPC802 NXP device integrated in the small board eboardPapyFeederV2.1. The project can be build with the MCUXpresso.

For Linux user, the lpcprog program (as well as the config file lpctools_parts.def) is included in the Debug/ folder to flash the papyFeederFW.bin on the target. Windows users can use flash magic.

The command for lpcprog is (assuming ttyUSB0 is where you have your USB to serial TTL converter):

 ./lpcprog  -d /dev/ttyUSB0 -c flash papyFeederFW.bin

Flashing is very easy, put the feeder on the rail while maintaining the button pressed, this will put the LPC802 in ISP mode. Then flash. It is important to remove all other feeders from the rail during this operation (if not, flashing will fail).

The code is very small, hence self explanatory.

Here is for information the memory map summary for the first commit:

```
Memory region	Used Size	Region Size		%age Used
PROGRAM_FLASH:	12032 B		16256 B     	74.02%
BOOT_FLASH:		0 GB		128 B      		0.00%
SRAM:			356 B		2016 B     		17.66%
IAP_SRAM:		0 GB		32 B      		0.00%
```
