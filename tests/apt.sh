source ./get-shunit2.sh


testAptGetKeys(){
    assertFalse "[ $(getAptKeys "" )]"
    assertFalse "[ $(getAptKeys  my_array) ]"
    
}

. $(which shunit2)
