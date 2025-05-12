### Download and Install the Latest Release

1. **Navigate to the Releases Page**  
    Visit the [Releases](https://github.com/axonops/axonops-cqlsh-binary-github/releases) section of the repository to find the latest version.

2. **Download the Release**  
    Locate the latest release and download the appropriate binary or source code for your platform.

3. **Verify the Download**  
    (Optional) Verify the checksum or signature of the downloaded file to ensure its integrity.

4. **Install the Release**

For Debian-based distributions (e.g., Ubuntu):
- Download the `.deb` package from the release page.
- Install the package using the following command:

```bash
sudo dpkg -i <package-name>.deb
```

- Resolve any missing dependencies by running:

```bash
sudo apt-get install -f
```

For RedHat-based distributions (e.g., CentOS, Fedora):
- Download the `.rpm` package from the release page.
- Install the package using the following command:

```bash
sudo rpm -ivh <package-name>.rpm
```

- If there are missing dependencies, use:

```bash
sudo yum install -y <package-name>.rpm
```
or for newer systems:
```bash
sudo dnf install -y <package-name>.rpm
```

- For Debian and RedHat based distros, it is installed to /opt/AxonOps/bin. You can add it to your path

```sh
export PATH=/opt/AxonOps/bin:$PATH
```

For Mac:

- Download the `.pkg` installer from the release page.  
- Double-click the downloaded `.pkg` file to launch the installer.  
- Follow the on-screen instructions to complete the installation.  

Alternatively, you can install the package via the terminal using the following command:  
```bash
sudo installer -pkg <package-name>.pkg -target /
```

Replace `<package-name>` with the actual name of the downloaded `.pkg` file.

- `axonops-cqlsh` is installed by default to `/usr/local/bin`
