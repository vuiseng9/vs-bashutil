## My Bash Utility
The `vs-bashutil` project is a collection of useful Bash functions (aliases) designed to streamline and enhance your command-line experience. These functions cover a wide range of tasks, including file and folder management, GPU utilization, Conda environment management, Git operations, and Tmux session handling. By incorporating these functions into your workflow, you can save time and increase productivity when performing common tasks in the terminal.

### Setup
```bash
git clone https://github.com/vuiseng9/vs-bashutil.git
source vs-bashutil/host_var.sh
source vs-bashutil/bash_functions.sh
# or put this in .bashrc
```
### Usage
```bash
$ ls-funcs
.
.
declare -f ls-conda-env
declare -f ls-funcs
declare -f ls-tmux
.
.
```
```bash
$ ls-conda-env 
# conda environments:
#
base                  *  /home/vuiseng9/miniforge3
```
### TODOs
- [ ] Unit test with [bats](https://github.com/bats-core/bats-core)
