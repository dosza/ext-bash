#!/bin/bash

source ./get-shunit2

testArrayToSTring(){
    local array=({0..10..2})
    local str="0 2 4 6 8 10"
    arrayToString 
    assertFalse $?
    assertEquals "$(arrayToString array)" "$str"
}

testArraySlice(){
    local array=({0..10..2})
    local subarray=()

    arraySlice array 0 5 subarray
    assertEquals "${subarray[*]}" "0 2 4 6 8"
    array=("make -j3" "bzImage" "make modules" "make install")
    arraySlice array  0 2 subarray
    assertEquals "${subarray[0]}" "make -j3" && assertEquals "${subarray[1]}" "bzImage"
    assertFalse "[ $(arraySlice myarray 0 2 mysubarray) ]"
    assertFalse "[ $(arraySlice myarray) ]"
}

testArrayMap(){
    local packages=(gcc g++ wget)
    local str="gcc\ng++\nwget\n"
    assertEquals "$(arrayMap packages package 'echo $package')" "$(printf "%b" "$str")"

}

testArrayFilter(){
    local numbers=({357..368})
    local pares=()
    local impares=()
    
    arrayFilter numbers number pares '((number % 2 == 0))'
    assertEquals "${pares[*]}" "358 360 362 364 366 368"

    arrayFilter numbers number impares '{
        ((number %2 != 0))
    }'

    assertEquals "${impares[*]}" "357 359 361 363 365 367"
}

. $(which shunit2)

