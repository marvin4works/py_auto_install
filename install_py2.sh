
#!/bin/bash
DIR_SELF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


DIR=/data/py 
DIR_SRC=$DIR/src
DIR_VENV=$DIR/venv/py2
DIR_BIN=$DIR/py2.7.13
mkdir -p $DIR $DIR_SRC $DIR_VENV $DIR_BIN


cd $DIR_SRC

[ -f Python-2.7.13.tar.xz ] || (
    wget 'https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz'
    
)

[ -f get-pip.py ] || (
    wget https://bootstrap.pypa.io/get-pip.py
)


[ -f $DIR_BIN/bin/python2 ] || (
    tar -xvf Python-2.7.13.tar.xz
    cd $DIR_SRC/Python-2.7.13
    ./configure prefix=$DIR_BIN && make && make install
    $DIR_BIN/bin/python2 $DIR_SRC/get-pip.py  
    $DIR_BIN/bin/python2 -m pip install virtualenv -i https://pypi.douban.com/simple/
    $DIR_BIN/bin/python2 -m virtualenv $DIR_VENV
)

cat ~/.bashrc|grep auto_py2_here ||(
    echo -e "\n# auto_py2_here">>~/.bashrc
    echo "alias py2=\"source $DIR_VENV/bin/activate\"">>~/.bashrc
)


cat<<EOF>$DIR_VENV/pip.conf
[global]
index-url = https://pypi.douban.com/simple/
EOF


pushd $DIR_SELF
$DIR_VENV/bin/python2 -m pip install -r requirements.txt


echo Reset with folloing command:
echo rm -rf $DIR_BIN
echo rm -rf $DIR_SRC

echo Done.



