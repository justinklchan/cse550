ssh -i "Justinskey.pem" ubuntu@ec2-54-227-31-25.compute-1.amazonaws.com

# upgrade and pip
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential git python-pip libfreetype6-dev libxft-dev libncurses-dev libopenblas-dev gfortran python-matplotlib libblas-dev liblapack-dev libatlas-base-dev python-dev python-pydot linux-headers-generic linux-image-extra-virtual unzip python-numpy swig python-pandas python-sklearn unzip wget pkg-config zip g++ zlib1g-dev
sudo pip install -U pip

# cuda
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
rm cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda

# cudnn
scp jucha@barb.cs.washington.edu:~/cudnn-8.0-linux-x64-v5.1.tgz ~
tar -zxf cudnn-8.0-linux-x64-v5.1.tgz && rm cudnn-8.0-linux-x64-v5.1.tgz
sudo cp -R cuda/lib64/*.* /usr/local/cuda/lib64/
sudo cp 
sudo cp cuda/include/cudnn.h /usr/local/cuda/include/

sudo reboot

echo "export CUDA_HOME=/usr/local/cuda" >> .bashrc
echo "export CUDA_ROOT=/usr/local/cuda" >> .bashrc
echo "export PATH=$PATH:$CUDA_ROOT/bin" >> .bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64" >> .bashrc

# java
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
# Hack to silently agree license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# bezel
sudo apt-get install pkg-config zip g++ zlib1g-dev
wget https://github.com/bazelbuild/bazel/releases/download/0.4.0/bazel-0.4.0-installer-linux-x86_64.sh
chmod +x bazel-0.4.0-installer-linux-x86_64.sh
bazel-0.4.0-installer-linux-x86_64.sh --user

# tf
git clone --recurse-submodules https://github.com/tensorflow/tensorflow
cd tensorflow

TF_UNOFFICIAL_SETTING=1 ./configure
8.0 and 5.1.5

bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer
bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install --upgrade /tmp/tensorflow_pkg/tensorflow...
