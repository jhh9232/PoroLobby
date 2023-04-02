#!/bin/bash

clean_env=0
python_name="python3"

# move to source directory
curpath=$(dirname $(realpath $0))
cd $curpath


if [ $# -eq 1 ]; then
    python_name=$1
fi

py_path=$(which $python_name)
if [[ "$py_path" == "" ]]; then
    python_name="python"
    py_path=$(which $python_name)
    if [[ "$py_path" == "" ]]; then
        echo "python is not installed. Please install python3."
        exit 1
    fi
fi


function py_version_check()
{
    py_full_version=$($py_path --version | awk -F ' ' '{print $2}')

    # debug echo
    # echo $py_full_version

    py_major=$(echo $py_full_version | awk -F '.' '{print $1}')
    pyver=$(echo $py_full_version | awk -F '.' '{print $2}')

    if [[ "$py_major" != "3" ]]; then
        echo "python3 is not installed. Please install pytthon3."
        exit 1
    fi

    if [ $pyver -lt 10 ]; then
        echo "Python version is lower than 3.10. Please install python3.10 or higher."
        exit 1
    fi

    pip_check=$($python_name -m pip --version 2>/dev/null)
    if [[ "$pip_check" == "" ]]; then
        echo "Python pip is not installed. Please install python3-pip."
        exit 1
    fi

}

py_version_check

pipenvtest=$(sudo -H $python_name -m pip list --disable-pip-version-check | grep 'pipenv')
if [[ "$pipenvtest" == "" ]]; then
    echo "pipenv is not installed. Please install pipenv."
    echo "(sudo -H $python_name -m pip install pipenv)"
    exit 1
fi


echo "start porolobby"

if [[ "$(sudo -H pipenv --venv 2>/dev/null)" == "" ]]; then
    echo "setting pipenv"
    sudo -H pipenv --python $py_path install
else
    # if clear pipenv
    if [ $clean_env -ne 0 ]; then
    sudo -H pipenv --rm
    sudo -H pipenv --python $py_path install
fi
# if clear
sudo -H pipenv run python ./porolobby.py

