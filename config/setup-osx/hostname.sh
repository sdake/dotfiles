TARGET_HOSTNAME="sdake-m14"
TARGET_DOMAIN="local"

sudo scutil --set HostName "${TARGET_HOSTNAME}"
sudo scutil --set LocalHostName "${TARGET_HOSTNAME}"
sudo scutil --set ComputerName "${TARGET_HOSTNAME}"
sudo hostname "${TARGET_HOSTNAME}"
