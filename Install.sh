#!/bin/bash
repo="https://github.com/cryingcavecat/mcu-flash-fix.git"
repo_name="mcu-flash-fix/"



cd /home/eden/

git clone $repo

cd $repo_name

chmod +x Upload.sh

bash Upload.sh