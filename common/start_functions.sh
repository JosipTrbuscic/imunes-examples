#!/bin/sh

# Error check
error() {
    echo $*
    exit 2
}

# isEidRunning eid
isEidRunning() {
    err=`himage -l | grep -x $1` \
	    || error "Cannot find experiment $1. Is simulation started? Try: Experiment->Execute"
}

# isNodeRunning node eid
isNodeRunning() {
    node=$1
    if [ $# -ne 1 ]; then
	isEidRunning $2
    else
	eid=`himage -e $1` \
	    || error "Cannot find node $1. Is simulation started? Try: Experiment->Execute"
	echo "$eid"
    fi
}

# hasPackage node eid pkgName
hasPackage() {
    himage $1@$2 pkg info | grep "$3" > /dev/null 2>&1
    err=$?
    himage $1@$2 pkg_info | grep "$3" > /dev/null 2>&1
    if [ $? -ne 0 ] && [ $err -ne 0 ]; then
	error "*** Package $3 is not installed on $1@$2"
    fi
}