#!/bin/bash
if [ "$GIT_PULL_CUSTOM" = 1 ]; then
    echo '#############################################'
    echo '#        Pulling Custom git data            #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV GIT_PULL_CUSTOM=0                    #'
    echo '#                                           #'
    echo '#############################################'

    mkdir -p /tmp/custom_git_pull/
    
    cd /tmp/custom_git_pull/
    git clone https://$GIT_USERNAME:$GIT_PASSWORD@$GIT_CUSTOM_SOURCES_SERVER/$GIT_CUSTOM_SOURCES_REPOS .

    mv $GIT_CUSTOM_MODULES_PATH/* /var/www/html/sites/all/modules/custom/
    mv $GIT_CUSTOM_THEMES_PATH/* /var/www/html/sites/all/themes/custom/

    export GIT_PULL_CUSTOM=0
    export GIT_USERNAME=0
    export GIT PASSWORD=0
    cd $WORKDIR
    rm -rf /tmp/custom_git_pull/
fi

