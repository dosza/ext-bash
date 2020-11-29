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
    local buttons=(button{Um,Dois,Tres})
    local sounds=(one two three)
    local strButtons='view.findViewById(R.id.buttonUm)\nview.findViewById(R.id.buttonDois)\nview.findViewById(R.id.buttonTres)\n'
    local strButtonsAct="case R.id.${buttons[0]}:\n\tmediaPlayer = MediaPlayer(getActivity(),R.raw.${sounds[0]});\n\tbreak;\ncase R.id.${buttons[1]}:\n\tmediaPlayer = MediaPlayer(getActivity(),R.raw.${sounds[1]});\n\tbreak;\ncase R.id.${buttons[2]}:\n\tmediaPlayer = MediaPlayer(getActivity(),R.raw.${sounds[2]});\n\tbreak;\n"
   
    assertEquals "$(arrayMap packages package 'echo $package')" "$(printf "%b" "$str")"
    assertEquals "$(arrayMap buttons button index 'echo view.findViewById\(R.id.$button\)')" "$(printf "%b" "$strButtons")"
    assertEquals "$(arrayMap buttons button index 'printf "%b" "case R.id.$button:\n\tmediaPlayer = MediaPlayer(getActivity(),R.raw.${sounds[$index]});\n\tbreak;\n"')" "$(printf "%b" "$strButtonsAct")"

}

testArrayFilter(){
    local numbers=({357..368})
    local pares=()
    local impares=()

    local names=('Daniel' 'Davros' 'Elis' 'Etel')
    local matchDNames=()

    arrayFilter numbers number pares '((number % 2 == 0))'
    assertEquals "${pares[*]}" "358 360 362 364 366 368"

    arrayFilter numbers number impares '{
        ((number %2 != 0))
    }'

    assertEquals "${impares[*]}" "357 359 361 363 365 367"

    arrayFilter  names name matchDNames 'echo "$name" | grep ^D>/dev/null'
    assertEquals "${matchDNames[*]}" "Daniel Davros"

    arrayFilter  names name index matchDNames 'echo "${name[index]}" | grep ^D>/dev/null'
    assertEquals "${matchDNames[*]}" "Daniel Davros"
}

. $(which shunit2)

