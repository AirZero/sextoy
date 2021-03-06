<!-- -*- mode: markdown; coding: utf-8 -*- -->

# Chinese sex toy controller

## What to buy

- [18-Speed Remote Control Vibration Egg](http://www.intimategadgets.com/product/wireless-12-speed-vibration-body-massager-2-x-aaa-+-1-x-aa-71019)
- [FTDI TTL-232R-5V](http://www.ftdichip.com/Products/Cables/USBTTLSerial.htm) either the normal or wire ended version (-WE). Online
  resellers include [Elfa Distrelec](https://www.elfaelektroniikka.fi/elfa3~fi_fi/elfa/init.do?item=73-206-73&toc=0) and [Mouser](http://fi.mouser.com/ProductDetail/FTDI/TTL-232R-5V-WE/?qs=sGAEpiMZZMtf8aSAtgR7DtM6b7hTwLVv).
  The cable is so common that you may find it from your local electronic
  component reseller.

No extra components required! Just the cable and the vibrator and
basic soldering skills required!

## Modifying of the hardware

TODO. Add some photos, too.

## Installation

Installation is straight-forward with Debian derivates (like
Ubuntu). However, installation

### Ubuntu 13.04

In Ubuntu, everything is available from repositories:

	sudo apt-get install cabal-install libghc-cmdargs-dev libghc-wai-dev \
	libghc-warp-dev libftdi-dev
	cabal update
	cabal install

### Other Linux distributions:

Install the following packages from your package manager or manually
by compiling or fetching binaries from http://haskell.org/ :

	ghc
	cabal
	libftdi (with development package)

Then, you may get the following packages from your package manager:

	cmdargs
	wai
	warp
	
If aall of these are not available, it's no problem. Cabal gets them
automatically and installs locally. Install them and this library by running:

	cabal update
	cabal install

## Usage

After compilation the binary is installed to
`~/.cabal/bin/vibraserver`. You may use it directly or link to your
PATH.

The binary takes only FTDI device serial number and TCP port to listen
to incoming HTTP connections. To see usage instructions, run

	vibraserver --help

To listen for default port (3000), just provide FTDI serial number. To
get the serial number, run `usb-devices` and look for FTDI device. For
example on my system I get the following:

	T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 30 Spd=12  MxCh= 0
	D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
	P:  Vendor=0403 ProdID=6001 Rev=06.00
	S:  Manufacturer=FTDI
	S:  Product=TTL232R-3V3
	S:  SerialNumber=FTF600YU
	C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=90mA
	I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=ftdi_sio

In that case, the serial number is `FTF600YU`. In my case I start the
binary in default port (3000) by running:

	vibraserver FTF600YU
	
And then open my browser at http://localhost:3000/

Then just open your firewall and let your frined give you a go!
