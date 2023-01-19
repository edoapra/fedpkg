#!/bin/bash
export RPMBUILD_DIR=/data/edo/rpmbuild
export KRB5_CONFIG=/etc/krb5.conf.fedora
kinit edoapra@FEDORAPROJECT.ORG
timeout --preserve-status --kill-after 10 50 koji build --scratch epel7 ~/rpmbuild/SRPMS/nwchem-7.0.2-103.src.rpm 
#timeout --preserve-status --kill-after 10 50 koji build --scratch epel8 ~/rpmbuild/SRPMS/nwchem-7.0.2-103.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch f32 ~/rpmbuild/SRPMS/nwchem-7.0.2-103.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch f33 ~/rpmbuild/SRPMS/nwchem-7.0.2-103.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch rawhide ~/rpmbuild/SRPMS/nwchem-7.0.2-103.src.rpm 
