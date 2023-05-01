# RECO-TIME⏳
RECO-TIME is a web reconnaissance tool that helps to perform enumeration of necessary information, with the purpose of our saving time.

## Functions

- Identifies the tecnology working on a Web Page using `WhatWeb`
- Searches subdomains using `Subfinder`
- Discovers endpoints by means of `Waybackurls`
- Analyzes vulnerabilities in WordPress Web Pages using `WPScan`

## Install
```console
$ git clone https://github.com/lazy29t/RecoTime.git
$ cd RecoTime
$ sudo chmod +x recotime.sh
$ ./recotime.sh
```
## Usage

Use the `-d` option followed by the target DOMAIN to start the reconnaissance
```bash 
./recotime.sh -d [DOMAIN]
```
### Example
```bash
./recotime.sh -d example.com
```
The output will be displayed on your terminal and saved to a `.txt` file.


>If you encounter any issues or have any questions, you can contact to me :)


Stay Hacking💪

### Credits:
To **mhmdiaa** for give us `waybackurls.py`
