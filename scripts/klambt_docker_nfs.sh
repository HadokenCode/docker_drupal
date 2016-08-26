#!/bin/bash
if [ "$USE_NFS_CLIENT" = 1 ]; then
    echo '##############################################'
    echo '#        Installing NFS-Client               #'
    echo '#                                            #'
    echo '# - Docker needs to run priviliged to work - #'
    echo '#                                            #'
    echo '#  This can be disabled during build with:   #'
    echo '#  ENV USE_NFS_CLIENT=0                      #'
    echo '#                                            #'
    echo '##############################################'

    apt-get install nfs-client -y
fi

