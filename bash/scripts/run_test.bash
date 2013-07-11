function __pk_test_find_path_to_test_folder
{
  __PK_PATH_REGEX=$(ls -al $__PK_RELATIVE_PATH | grep "^dr" | grep "\ test$")
  if [[ $__PK_PATH_REGEX = '' ]]
  then
    __PK_ROOT_REGEX=$(ls -al $__PK_RELATIVE_PATH | grep "^dr" | grep "\ usr$")

    if [[ $__PK_ROOT_REGEX = '' ]]
    then
      __PK_RELATIVE_PATH="${__PK_RELATIVE_PATH}../"
      __pk_test_find_path_to_test_folder

    else
      __PK_UNABLE_TO_LOCATE_ROOT_FOLDER=1
    fi
  fi
}
function t()
{
  __PK_UNABLE_TO_LOCATE_ROOT_FOLDER=0
  __PK_RELATIVE_PATH="./"
  __pk_test_find_path_to_test_folder
  if [[ $__PK_UNABLE_TO_LOCATE_ROOT_FOLDER = 1 ]]
  then
    echo "Cannot locate test folder"
    return
  fi

  cd $__PK_RELATIVE_PATH

  if [[ $1 = '' ]]
  then
    __pk_test_handle_default

  elif [[ $1 =~ \.rb$ ]]
  then
    __pk_test_handle_file_case $1

  else
    __pk_test_handle_function_case $1

  fi
  cd - > /dev/null
}

function __pk_test_handle_default()
{
  __pk_test_run
}

function __pk_test_handle_file_case()
{
  if [[ $1 =~ [\/] ]]
  then
    __pk_test_handle_file_path $1

  else
    __pk_test_handle_file_name $1

  fi
}

function __pk_test_handle_file_path()
{
  # full path given
  if [[ -e "$1" ]]
  then
    __pk_test_run $1
  else
    echo "File does not exist."
  fi
}

function __pk_test_handle_file_name()
{
  # file name given, not full path

  __PK_TEST_FILE="$(find . -name $1)"

  if [[ $__PK_TEST_FILE = '' ]]
  then
    # file not found
    echo "file $1 not found"

  elif [[ $__PK_TEST_FILE =~ \.rb(.)+\.rb ]]
  then
    # found multiple files
    echo "$__PK_TEST_FILE"
    echo "Multiple test files of that name exist..."
    echo "Please use the full path."

  else
    # found the file
    __pk_test_run $__PK_TEST_FILE

  fi
}

function __pk_test_handle_function_case()
{
  # given a test name, no file given

  __PK_REGEX="^[\ ]+def[^\n]+$1"
  __PK_TEST_FILE=$(ag "$__PK_REGEX" ./test | awk -F':' '{print $1}')
  __PK_TEST_FUNCTION=$(ag "$__PK_REGEX" ./test | awk -F':' '{print $3}')
  __PK_TEST_FUNCTION="${__PK_TEST_FUNCTION:6}"

  if [[ $__PK_TEST_FILE = '' ]]
  then
    # couldn't find specified test
    echo "Could not find test function matching: $1"

  elif [[ $__PK_TEST_FILE =~ (.)+\.rb(.)+ ]]
  then
    # multiple tests found
    ag "$__PK_REGEX" ./test
    echo "Mulitple test files contain a test of that name."
    echo "This script can't handle that :("

  else
    # found the specified test
    __pk_test_run $__PK_TEST_FILE $__PK_TEST_FUNCTION
  fi
}

function __pk_test_run()
{
  __PK_RAKE_TASK="ruby -I test"
  if [[ $1 != '' ]]
  then
    __PK_RAKE_TASK="$__PK_RAKE_TASK $1"
    if [[ $2 != '' ]]
    then
      __PK_RAKE_TASK="$__PK_RAKE_TASK --name=$2"
    fi
  fi
  echo $__PK_RAKE_TASK
  ${__PK_RAKE_TASK}
}

function __pk_test_test()
{

  # To use this, turn off ${__PK_RAKE_TASK} in __pk_test_run()
  # Then it will simply show the command that it will run
  # the tests should be run in vdr, just 'cause
  echo "default =>"
  t
  echo "............"

  echo "full path =>"
  t test/unit/document_test.rb
  echo "............"

  echo "bad path =>"
  t test/unit/steve.rb
  echo "............"

  echo "filename =>"
  t document_test.rb
  echo "............"

  echo "many files =>"
  t user_test.rb
  echo "............"

  echo "test name =>"
  t pdf_engine
  echo "............"

  echo "many tests =>"
  t watermark_pdf
  echo "............"

  echo "no test =>"
  t steve
  echo "............"

}
