#!/bin/bash

# use the tmp dir
cd $OPENSHIFT_TMP_DIR

#install python
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar jxf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure --prefix=$OPENSHIFT_DATA_DIR
make install

#Installing Setuptools
cd $OPENSHIFT_TMP_DIR
wget http://pypi.python.org/packages/source/s/setuptools/setuptools-3.6.tar.gz
tar zxf setuptools-3.6.tar.gz
cd setuptools-3.6
$OPENSHIFT_DATA_DIR/bin/python setup.py install

#Installing PIP
cd $OPENSHIFT_TMP_DIR
wget http://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz
tar zxf pip-1.5.6.tar.gz
cd pip-1.5.6
$OPENSHIFT_DATA_DIR/bin/python setup.py install

# get opencv pkg
wget http://pkgs.fedoraproject.org/repo/pkgs/opencv/OpenCV-2.4.3.tar.bz2/c0a5af4ff9d0d540684c0bf00ef35dbe/OpenCV-2.4.3.tar.bz2
tar xvf OpenCV-2.4.3.tar.bz2
rm OpenCV-2.4.3.tar.bz2
cd OpenCV-2.4.3/
rm -r 3rdparty android doc data ios samples apps
rm README
# comment lines from 448 to 472 not to compile deleted sources
sed -i '448,472 s/^/#/' CMakeLists.txt
# turn off regression and performance tests
sed -i '155,156 s/ ON/ OFF/' CMakeLists.txt
mkdir release
cd release
cmake ../OpenCV-2.4.3 -D BUILD_NEW_PYTHON_SUPPORT=ON -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=$OPENSHIFT_DATA_DIR -D PYTHON_LIBRARY=$OPENSHIFT_DATA_DIR/lib/python2.7/libpython2.7.a -D CMAKE_INCLUDE_PATH=$OPENSHIFT_DATA_DIR/include/python2.7 -D PYTHON_INCLUDE_DIR=$OPENSHIFT_DATA_DIR/include/python2.7 -D PYTHON_PACKAGES_PATH=$OPENSHIFT_DATA_DIR/lib/python2.7/site-packages -D PYTHON_EXECUTABLE=$OPENSHIFT_DATA_DIR/bin/python -D WITH_OPENEXR=OFF -D BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=ON ..
make
make install
