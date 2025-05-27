# Install xdg-utils to enable opening a browser from devcontainer
# Currently no out-of-the box support available see: https://github.com/devcontainers/images/issues/885
#
# Add Cloud Foundry CLI repository
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo gpg --dearmor -o /usr/share/keyrings/cli.cloudfoundry.org.gpg
echo "deb [signed-by=/usr/share/keyrings/cli.cloudfoundry.org.gpg] https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

sudo apt-get update
sudo apt-get install -y xdg-utils cf8-cli