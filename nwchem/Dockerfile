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
&& yum  update -y \
&&  yum install -y sudo git tar wget curl  gzip patch coreutils \
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
&& sudo yum install -y rpm rpmlint patch make perl python3-devel time cmake \
unzip which tar bzip2 openssh-clients rsync  \
mpich-devel openmpi-devel gcc-gfortran hostname openssh-clients python2-devel \
&& export RPMBUILD_DIR=~/rpmbuild \
&& mkdir -p $RPMBUILD_DIR/SOURCES \
&& rsync -av *patch $RPMBUILD_DIR/SOURCES/. \
&& rpmbuild --buildroot $RPMBUILD_DIR --undefine=_disable_source_fetch -ba nwchem.spec || true \
&& echo "**********" \
&& echo grep -i alloca build/global/src/global.fh   \
&& grep -i alloca /opt/rpmbuild/BUILD/nwchem-7.2.0-beta2/src/tools/build/global/src/global.fh  ||  true \
&& echo "**********" \
&& echo build/global/src/global.fh  \
&& echo "**********" \
&& cat  /opt/rpmbuild/BUILD/nwchem-7.2.0-beta2/src/tools/build/global/src/global.fh  || true \
&& echo "**********" \
&& echo build/config.log \
&& echo "**********" \
&& cat  /opt/rpmbuild/BUILD/nwchem-7.2.0-beta2/src/tools/build/config.log || true \
&& echo "**********" \
&& echo build/config.status \
&& cat  /opt/rpmbuild/BUILD/nwchem-7.2.0-beta2/src/tools/build/config.status || true \
&& echo "**********" 


FROM scratch AS export-stage
COPY --from=stage1 /opt/fedpkg/nwchem/*.rpm .
COPY --from=stage1 /opt/fedpkg/nwchem/nwchem-7.2.0/src/libext/libext.tar.bz2 .

#WORKDIR     /data
#ENTRYPOINT  ["nwchem"]

##CMD ["/bin/bash"]

