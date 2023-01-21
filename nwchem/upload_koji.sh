#!/bin/bash
export KRB5_CONFIG=/etc/krb5.conf.fedora
NWVER=7.2.0-2
kinit edoapra@FEDORAPROJECT.ORG
timeout --preserve-status --kill-after 10 50 koji build --scratch epel7 ~/rpmbuild/SRPMS/nwchem-$NWVER.src.rpm 
#timeout --preserve-status --kill-after 10 50 koji build --scratch epel8 ~/rpmbuild/SRPMS/nwchem-$NWVER.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch f32 ~/rpmbuild/SRPMS/nwchem-$NWVER.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch f33 ~/rpmbuild/SRPMS/nwchem-$NWVER.src.rpm  
#timeout --preserve-status --kill-after 10 50 koji build --scratch rawhide ~/rpmbuild/SRPMS/nwchem-$NWVER.src.rpm 