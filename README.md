# Linux MSI EC Controller

This is a simple linux app intended to control some features of the MSI EC of some laptops

![Application Screenshot](screenshot.png)

## Tested on laptops:
- [x] MSI GS65 Stealth 8SE

## Tested on distributions:
- [x] Fedora 37

## Dependencies
This project depends on [acpi_ec](https://github.com/musikid/acpi_ec) and for the moment must be run as root

## Roadmap
- [x] Basic information about CPU and GPU temperatures and fan speeds
- [x] Control turbo bost
- [x] Display CPU Fan Curve
- [x] Display GPU Fan Curve
- [ ] Change fan curve
- [ ] Creation and selection of profiles
- [ ] Elevation of privilegies only when necessary
- [ ] CLI utility

# Disclaimer
Write to the EC is dangerous, use it at your own risk!
