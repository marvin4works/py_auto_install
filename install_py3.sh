#!/bin/bash
DIR_SELF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


DIR=/data/py 
DIR_SRC=$DIR/src
DIR_VENV=$DIR/venv/py3
DIR_BIN=$DIR/py3.6.1
mkdir -p $DIR $DIR_SRC $DIR_VENV $DIR_BIN


cd $DIR_SRC

[ -f Python-3.6.1.tar.xz ] || (
    wget 'https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz'
)

[ -f $DIR_BIN/bin/python3 ] || (
    tar -xvf Python-3.6.1.tar.xz
    cd $DIR_SRC/Python-3.6.1
    ./configure prefix=$DIR_BIN && make && make install
    $DIR_BIN/bin/python3 -m pip install virtualenv
    $DIR_BIN/bin/python3 -m virtualenv $DIR_VENV
)

cat ~/.bashrc|grep auto_py3_here ||(
    echo -e "\n# auto_py3_here">>~/.bashrc
    echo "alias py3=\"source $DIR_VENV/bin/activate\"">>~/.bashrc
)


cat<<EOF>$DIR_VENV/pip.conf
[global]
index-url = https://pypi.douban.com/simple/
EOF


pushd $DIR_SELF
$DIR_VENV/bin/python3 -m pip install -r requirements.txt


echo Reset with folloing command:
echo rm -rf $DIR_BIN
echo rm -rf $DIR_SRC

echo Done.


