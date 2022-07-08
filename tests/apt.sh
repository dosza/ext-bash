#!/bin/bash
shopt -s expand_aliases

    
apt-get(){
    if [ "$TEST_FAKE_APT_LOCK" != "" ]; then 
        unset TEST_FAKE_APT_LOCK
        return $BASH_FALSE
    fi
    return $BASH_TRUE
}

source ./get-shunit2

testCheckPackageDebIsInstalled(){
    assertTrue "[ $(CheckPackageDebIsInstalled coreutils) "$BASH_TRUE" ]"
}


testGetDebPackVersion(){
    assertEquals "$(
        dpkg -s "coreutils" | grep '^Version' | sed 's/Version:\s*//g'
        )" "$(getDebPackVersion "coreutils")"
}


testGetCurrentDebianFrontend(){
    CheckPackageDebIsInstalled $GTK_DEBIAN_FRONTEND_DEP
    local expected_gtk_debian_frontend=$?

    CheckPackageDebIsInstalled $KDE_DEBIAN_FRONTEND_DEP
    local expected_kde_debian_frontend=$?

    if ! tty | grep -q 'pts/[0-9]'; then 
        getCurrentDebianFrontend
        assertFalse '[Try getCurrent from  non pseudoterminal]' "[ "$DEBIAN_FRONTEND" "" ]"
    fi

    if tty | grep -q 'pts/[0-9]'; then 
        if [ $expected_gtk_debian_frontend = 0 ]; then
            getCurrentDebianFrontend
            assertEquals "[Try getCurrentDebianFrontend from pseudoterminal with $GTK_DEBIAN_FRONTEND_DEP installed]"\
            "$DEBIAN_FRONTEND" "gnome"
        elif [ $expected_kde_debian_frontend = 0 ]; then 
            getCurrentDebianFrontend
            assertEquals "[Try getCurrentDebianFrontend from pseudoterminal with $KDE_DEBIAN_FRONTEND_DEP installed]"\
            "$DEBIAN_FRONTEND" "kde"

        fi
    fi

}
. $(which shunit2)