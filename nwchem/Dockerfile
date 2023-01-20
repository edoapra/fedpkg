ARG         IMAGE
FROM        ${IMAGE} as stage1

#caching from host cache dir
#COPY .  /opt
#COPY req.sh  .
COPY Dockerfile cache* /tmp/

ARG CACHE_HIT
ARG ARMCI_NETWORK
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
WORKDIR /opt
#RUN  --mount=type=tmpfs.target=/dev/shm,size=256m
ARG USERNAME=nwchem
ARG USER_UID=1000
ARG USER_GID=1000

RUN ls -lrt \
&& ls -lrt /tmp \
&& df -h  /dev/shm \
&& myhostname=hostname \
&& myver6=$(cat /etc/redhat-release |cut -d " "  -f 3) || true \
&& if [ $myver6 == "6.10" ]; then curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo ; myhostname=net-tools ; curl > /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo; curl https://linuxsoft.cern.ch/cern/slc511/i386/RPM-GPG-KEYs/RPM-GPG-KEY-cern > /etc/pki/rpm-gpg/RPM-GPG-KEY-cern; yum install -y devtoolset-2-gcc-gfortran.x86_64; export PATH=/opt/rh/devtoolset-1.1/root/usr/bin:$PATH; export LD_LIBRARY_PATH=/opt/rh/devtoolset-1.1/root/usr/lib64:$LD_LIBRARY_PATH; rpm -q -l devtoolset-2-gcc-gfortran.x86_64; fi \
&& echo PATH is $PATH \
&& myver=$(grep VERSION_ID /etc/os-release |cut -d \" -f 2) || true \
&& if [ $myver == 8 ]; then dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos ; fi \
&& yum  update -y \
&&  yum install -y sudo git tar wget curl  gzip patch  \
&& env \
&& groupadd --gid $USER_GID $USERNAME \
&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME  -d /opt \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
&& chown -R nwchem /opt \
&& chgrp -R nwchem /opt

USER $USERNAME

RUN arch=$(uname -m) \
&& arch5=$(uname -m|cut -c 1-5) \
&& if [[ "$arch" == "aarch64" ]]; then export FORCETARGET=" TARGET=ARMV8 "; fi \
&& if [[ "$arch" == "ppc64le" ]]; then export FORCETARGET=" TARGET=POWER8 "; fi \
&& if [[ "$arch" == "riscv64" ]]; then export FORCETARGET=" TARGET=RISCV64_GENERIC ";fi\
&& if [[ "$arch5" == "armv6" ]]; then export FORCETARGET=" TARGET=ARMV6 "; fi \
&& if [[ "$arch5" == "armv7" ]]; then export FORCETARGET=" TARGET=ARMV7 "; fi \
&& wget -q https://github.com/edoapra/fedpkg/tarball/builtin -O - |  tar  -xzf -  \
&& mv edoapra-fedpkg-* fedpkg \
&& cd fedpkg/nwchem \
&& ls -lart \
&& echo ARMCI_NETWORK is "$ARMCI_NETWORK" \
&& sudo yum update \
&& myhostname=hostname \
&& myver6=$(cat /etc/redhat-release |cut -d " "  -f 3) || true \
&& if [ $myver6 == "6.10" ]; then myhostname=net-tools;  export PATH=/opt/rh/devtoolset-2/root/usr/bin:$PATH; export LD_LIBRARY_PATH=/opt/rh/devtoolset-2/root/usr/lib64:$LD_LIBRARY_PATH; rpm -q -l devtoolset-2-gcc-gfortran.x86_64; fi \
&& echo PATH is $PATH \
&& echo myhostname is $myhostname \
&& sudo yum install -y rpm rpmdevtools rpm-build rpmlint patch make perl python3-devel time cmake \
unzip which tar bzip2 openssh-clients rsync  \
mpich-devel openmpi-devel gcc-gfortran $myhostname  python2-devel \
&& echo "*****" \
&& echo gfortran is `which gfortran` || true \
&& echo `gfortran --version` || true  \
&& export RPMBUILD_DIR=~/rpmbuild \
&& mkdir -p $RPMBUILD_DIR/SOURCES \
&& rsync -av *patch $RPMBUILD_DIR/SOURCES/. \
&& spectool -g -R nwchem.spec \
&& rpmbuild --buildroot $RPMBUILD_DIR  -ba nwchem.spec 

FROM scratch AS export-stage
COPY --from=stage1 /opt/fedpkg/nwchem/*.rpm .
COPY --from=stage1 /opt/fedpkg/nwchem/nwchem-7.2.0/src/libext/libext.tar.bz2 .

#WORKDIR     /data
#ENTRYPOINT  ["nwchem"]

##CMD ["/bin/bash"]

