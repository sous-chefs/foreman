# Limitations

## Package availability

### APT (Debian/Ubuntu)

* Foreman 3.18 is documented for Debian 12 (Bookworm) on `amd64`.
* Foreman 3.18 is documented for Ubuntu 22.04 (Jammy) on `amd64`.
* The upstream installation flow is package-based and starts by enabling vendor repositories before running the Foreman installer.

### DNF/YUM (Enterprise Linux)

* Current upstream planning guidance says Foreman server and Smart Proxy can run on Enterprise Linux 9.
* Foreman community packaging is limited to `x86_64`.
* This cookbook does not yet implement the Enterprise Linux repository flow, so the migrated resource API remains Debian/Ubuntu only.

## Architecture limitations

* Upstream community packages are documented as `x86_64` only.
* The Debian and Ubuntu quickstart guides currently list `amd64` only.

## Source or compiled installation

* Current Foreman installation guidance is package-first and uses the Foreman installer plus native system packages.
* This cookbook does not implement a source-build path.

## Known issues

* Smart Proxy helper services such as DNS, DHCP, and TFTP still depend on external cookbooks where those integrations are enabled.
* Plugin package names remain user-supplied because upstream package names vary by plugin and release.
* Local Kitchen runs on ARM hosts require an amd64-capable Docker or VM runtime. Foreman's upstream APT packages are not available for arm64, so package installation fails on native ARM guests.
