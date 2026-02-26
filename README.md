# Doom - Developer Utility Scripts

Doom is a collection of shell scripts designed to streamline your daily development workflow on macOS/Linux. It primarily features an SSH connection manager with a hierarchical menu system, along with utilities for switching Git accounts, managing JDK versions, and fixing MP3 files.

## Features

- **SSH Connection Manager (`login.sh`)**: Organize and connect to your remote servers using a terminal-based hierarchical menu. Supports password automation and key-based authentication.
- **Git Account Switcher (`switch_git_acc.sh`)**: Quickly toggle between different global Git configurations (e.g., Personal vs. Work).
- **JDK Version Manager (`switch_jdk_ver.sh`)**: Easily switch between different installed Java JDK versions.
- **MP3 Fixer (`fix_mp3.sh`)**: Batch process and repair MP3 files by re-encoding them, useful for fixing corrupted headers or compatibility issues.

## Prerequisites

- **OS**: macOS or Linux
- **Shell**: Bash
- **Dependencies**: 
  - `expect`: Required for automated password handling in SSH connections.
  - `ffmpeg`: Required for the MP3 fixer script.
  
  **Installation:**
  - macOS: `brew install expect ffmpeg`
  - Ubuntu/Debian: `sudo apt-get install expect ffmpeg`

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/zxpbenson/doom.git
   cd doom
   ```

2. (Optional) Create an alias for quick access. Add the following to your shell profile (e.g., `~/.bash_profile`, `~/.zshrc`):
   ```bash
   alias mlgn='/path/to/doom/login.sh'
   ```
   *Note: Replace `/path/to/doom` with the actual absolute path to the cloned repository.*

## Usage

### 1. SSH Connection Manager (`login.sh`)

This script provides a menu interface to navigate server lists and connect via SSH.

#### Configuration

1. **Hosts Directory**: The script expects a `hosts` directory in the project root (`doom/hosts`). You can create subdirectories within `hosts` to organize your servers hierarchically.
   ```
   doom/
   ├── hosts/
   │   ├── company-a/
   │   │   └── web-servers
   │   └── personal/
   │       └── vps-list
   ```

2. **Host File Format**: The files within the directories (e.g., `web-servers`) contain the server connection details. Each line represents one server.

   **Format:**
   ```
   Sequence:IP_Address:Port:Username:Password_or_Key:Description
   ```

   **Fields:**
   - `Sequence`: A number used for menu selection (e.g., `1`, `2`).
   - `IP_Address`: The IP address or hostname of the server.
   - `Port`: SSH port (e.g., `22`).
   - `Username`: SSH username.
   - `Password_or_Key`:
     - **Password**: Plain text password (login handled automatically via `expect`).
     - **Key File**: Filename of the private key (must end in `.pem` and be placed in the `doom/keys/` directory).
     - **Empty**: Leave empty to input password manually during login.
   - `Description`: A brief description displayed in the menu.

   **Example Content:**
   ```text
   1:192.168.1.10:22:root:mypassword:Main Web Server
   2:10.0.0.5:2222:admin:auth.pem:Database Server
   3:172.16.0.1:22:user::Testing (Manual Auth)
   ```

3. **Key Management**: If using PEM keys, place them in the `keys/` directory within the project root.

#### Running
```bash
# Run directly
./login.sh

# Or via alias
mlgn
```
Use the interactive menu to navigate directories and select a host.

### 2. Git Account Switcher (`switch_git_acc.sh`)

Switches the global `~/.gitconfig` by linking to a specific configuration file.

#### Setup
Create your specific git config files in your home directory (`~`):
- `~/.gitconfig.github` (for personal/github use)
- `~/.gitconfig.corp` (for corporate/work use)

#### Running
```bash
# Switch to personal config
./switch_git_acc.sh github

# Switch to corporate config
./switch_git_acc.sh corp
```

### 3. JDK Version Switcher (`switch_jdk_ver.sh`)

Updates a generic JDK symlink to point to a specific version.

#### Configuration
1. Open `switch_jdk_ver.sh` and update `TARGET_DIR` to point to the directory where your JDKs are installed (default is `~/software/`).
2. Ensure the JDK folder names in the script (e.g., `jdk1.8.0_261.jdk`) match your actual directory names.

#### Running
```bash
./switch_jdk_ver.sh 8
./switch_jdk_ver.sh 11
./switch_jdk_ver.sh 17
./switch_jdk_ver.sh 21
./switch_jdk_ver.sh 25
```

### 4. MP3 Fixer (`fix_mp3.sh`)

Batch processes MP3 files by re-encoding them (MP3 -> M4A -> MP3) to fix corruption or metadata issues. It generates a report in the output directory.

#### Running
```bash
# Basic usage
./fix_mp3.sh -i ./broken_mp3 -o ./fixed_mp3

# Dry run (simulate without changes)
./fix_mp3.sh -i ./broken_mp3 -o ./fixed_mp3 --dry-run
```

**Options:**
- `-i`: Input directory containing .mp3 files.
- `-o`: Output directory (must be empty or not exist).
- `--dry-run`: Print what would be done without making changes.
- `--continue-on-error`: Continue processing even if a file fails (default).
- `--no-continue-on-error`: Stop immediately if an error occurs.

## License

[MIT](LICENSE)
