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

. $(which shunit2)

