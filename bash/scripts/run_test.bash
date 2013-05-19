function pk_test_find_path_to_test_folder
{
  PK_PATH_REGEX=$(ls -al $PK_RELATIVE_PATH | grep "^dr" | grep "\ test$")
  if [[ $PK_PATH_REGEX = '' ]]
  then
    PK_ROOT_REGEX=$(ls -al $PK_RELATIVE_PATH | grep "^dr" | grep "\ usr$")

    if [[ $PK_ROOT_REGEX = '' ]]
    then
      PK_RELATIVE_PATH="${PK_RELATIVE_PATH}../"
      pk_test_find_path_to_test_folder

    else
      PK_UNABLE_TO_LOCATE_ROOT_FOLDER=1
    fi
  fi
}
function t()
{
  PK_UNABLE_TO_LOCATE_ROOT_FOLDER=0
  PK_RELATIVE_PATH="./"
  pk_test_find_path_to_test_folder
  if [[ $PK_UNABLE_TO_LOCATE_ROOT_FOLDER = 1 ]]
  then
    echo "Cannot locate test folder"
    return
  fi

  cd $PK_RELATIVE_PATH

  if [[ $1 = '' ]]
  then
    pk_test_handle_default

  elif [[ $1 =~ \.rb$ ]]
  then
    pk_test_handle_file_case $1

  else
    pk_test_handle_function_case $1

  fi
  cd - > /dev/null
}

function pk_test_handle_default()
{
  pk_test_run
}

function pk_test_handle_file_case()
{
  if [[ $1 =~ [\/] ]]
  then
    pk_test_handle_file_path $1

  else
    pk_test_handle_file_name $1

  fi
}

function pk_test_handle_file_path()
{
  # full path given
  if [[ -e "$1" ]]
  then
    pk_test_run $1
  else
    echo "File does not exist."
  fi
}

function pk_test_handle_file_name()
{
  # file name given, not full path

  PK_TEST_FILE="$(find . -name $1)"

  if [[ $PK_TEST_FILE = '' ]]
  then
    # file not found
    echo "file $1 not found"

  elif [[ $PK_TEST_FILE =~ \.rb(.)+\.rb ]]
  then
    # found multiple files
    echo "$PK_TEST_FILE"
    echo "Multiple test files of that name exist..."
    echo "Please use the full path."

  else
    # found the file
    pk_test_run $PK_TEST_FILE

  fi
}

function pk_test_handle_function_case()
{
  # given a test name, no file given

  PK_REGEX="^[\ ]+def[^\n]+$1"
  PK_TEST_FILE=$(ag "$PK_REGEX" ./test | awk -F':' '{print $1}')
  PK_TEST_FUNCTION=$(ag "$PK_REGEX" ./test | awk -F':' '{print $3}')
  PK_TEST_FUNCTION="${PK_TEST_FUNCTION:6}"

  if [[ $PK_TEST_FILE = '' ]]
  then
    # couldn't find specified test
    echo "Could not find test function matching: $1"

  elif [[ $PK_TEST_FILE =~ (.)+\.rb(.)+ ]]
  then
    # multiple tests found
    ag "$PK_REGEX" ./test
    echo "Mulitple test files contain a test of that name."
    echo "This script can't handle that :("

  else
    # found the specified test
    pk_test_run $PK_TEST_FILE $PK_TEST_FUNCTION
  fi
}

function pk_test_run()
{
  PK_RAKE_TASK="bundle exec rake test"
  if [[ $1 != '' ]]
  then
    PK_RAKE_TASK="$PK_RAKE_TASK TEST=$1"
    if [[ $2 != '' ]]
    then
      PK_RAKE_TASK="$PK_RAKE_TASK TESTOPTS=--name=$2"
    fi
  fi
  echo $PK_RAKE_TASK
  ${PK_RAKE_TASK}
}

function pk_test_test()
{
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
