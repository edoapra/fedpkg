#!/bin/bash                                                                              
export RPMBUILD_DIR=~/rpmbuild
mkdir -p $RPMBUILD_DIR/SOURCES
rsync -av *patch $RPMBUILD_DIR/SOURCES/.
rpmbuild --buildroot $RPMBUILD_DIR --undefine=_disable_source_fetch -bs nwchem.spec
