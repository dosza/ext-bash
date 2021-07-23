source ./get-shunit2


testAptGetKeys(){
    assertFalse "[ $(getAptKeys "" )]"
    assertFalse "[ $(getAptKeys  my_array) ]"
    
}

. $(which shunit2)
