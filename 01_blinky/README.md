# 01_blinky

Using stable rust! No nightly features as of writing.

### Prep
To make sure formatting of the microSD card is correct, I recommend using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to first flash a working OS to the card (I chose 64-bit Raspbrian Lite but I don't think it matters).

### Build
```bash
make kernel8.img
```

Copy `kernel8.img` and `config.txt` from this directory and paste it into the micrroSD card, overwriting the files on there already.