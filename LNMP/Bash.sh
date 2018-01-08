name="john"

echo $name
echo "hello $name"
echo "hello ${name}"

echo ${#str}

//////////////////////////

${str:-val}     //$str or val 
${str:=val}     //$str or val and assign val to str
${str:+val}     //if $str is set use val
${str:?error}   //if $str not set show error message

//////////////////////////

cmd || cmd
cmd && cmd

////////////////////////////

echo "i am in $(pwd)"
echo "i am in `pwd`"

///////////////////////////

function abc() {
    echo 1
}

if [ abc() -eq 1 ]
then
   ...
fi

/////////////////////////////

if [ -z "$name" ]
then
   ...
fi

if [ -n "$name" ]
then
   ...
fi

//////////////////////////////////

echo {A,B}.js
ls {A,B{.js
echo {A,B,C}

echo {1..5}   // 1 2 3 4 5

////////////////////////////////////

str=${str/old/new}    //replace first match
str=${str//old/new}   //replace all

str=${str/%old/new}   //replace suffix
str=${str/#old/new}   // replace prefix

str=${str:0:4}  // ${str:start:len}
str=${str:3}

////////////////////////////////////

${str:-default}   // $str or $default, no assign
${str:=default}   // $str or $default,  and assign default to str

////////////////////////////////////

${str%suffix}   // remove suffix
${str#prefix}   // remove prefix
${str%%suffix}  // remove long suffix
${str##prefix}  // remove long prefix

////////////////////////////////////

STR="/path/to/foo.cpp"
echo ${STR%.cpp}    # /path/to/foo    //remove the ends
echo ${STR%.cpp}.o  # /path/to/foo.o  //remove the ends and add .o
echo ${STR%%/*}     # from end remove all /*
echo ${STR%/*}      # from end remove first /*

echo ${STR#*/}      # path/to/foo.cpp      //from begin, to remove first */
echo ${STR##*.}     # cpp (extension)      //from begin to remove *. 
echo ${STR##*/}     # foo.cpp              //from begin to remove all */

echo ${STR/foo/bar} # /path/to/bar.cpp

///////////////////////////////////////

for i in /etc/rc.* 
do
   ...
done

///////////////////////////////////////

for i in {1..5}
do
     ...
done

cat a.txt | while read line
do 
   echo $line
done

////////////////////////////////////////
//5 10 15 20

for i in {5..20..5}  
do
   echo $i
done

//////////////////////////////////////////

[ -e file ]
[ -r file ]
[ -h file ]
[ -d file ]
[ -w file ]
[ -s file ]
[ -f file ]
[ -x file ]
[ -o nocolbber ]
[ f1 -nt f2 ]  newer than
[ f1 -ot f2 ]  elder than
[ f1 -ef f2 ]  same files

////////////////////////////////////////////////

if [ ... ] && [ ... ] 
if [ ... ] || [ ... ] 

if [[ "A" =~ ".*" ]]

if [[ "str" =~ “regexp" ]]

if (( num > num ))

////////////////////////////////

arr=( "a" "b" "c" )
arr[0]="a"
arr[1]="b"

///////////////////////////////////

echo ${Fruits[0]}           # Element #0
echo ${Fruits[@]}           # All elements, space-separated
echo ${#Fruits[@]}          # Number of elements
echo ${#Fruits}             # String length of the 1st element
echo ${#Fruits[3]}          # String length of the Nth element
echo ${Fruits[@]:3:2}       # Range (from position 3, length 2)

Fruits=("${Fruits[@]}" "Watermelon")    # Push
Fruits=( ${Fruits[@]/Ap*/} )            # Remove by regex match
unset Fruits[2]                         # Remove one item
Fruits=("${Fruits[@]}")                 # Duplicate
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate
lines=(`cat "logfile"`)                 # Read from file

for i in "${arrayName[@]}"; do
  echo $i
done

/////////////////////////////////////////

$((a + 200))      # Add 200 to $a
$((RANDOM%=200))  # Random number 0..200

///////////////////////////////////////

case "$1" in
  start | up)
    vagrant up
    ;;

  *)
    echo "Usage: $0 {start|stop|ssh}"
    ;;
esac

/////////////////////////////////////////

printf "Hello %s, I'm %s" Sven Olga

///////////////////////////////////////////

cat <<END
hello world
END

//////////////////////////////////////////////

echo -n "Proceed? [y/n]: "
read ans
echo $ans

#just read one character and quit
read -n 1 ans

///////////////////////////////////////////////

$?	Exit status of last task
$!	PID of last background task
$$	PID of shell

//////////////////////////////////////////////////

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
 case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -s | --string )
    shift; string=$1
    ;;
  -f | --flag )
    flag=1
    ;;
 esac; 
 shift; 
done

if [[ "$1" == '--' ]]
then
  shift;
fi
