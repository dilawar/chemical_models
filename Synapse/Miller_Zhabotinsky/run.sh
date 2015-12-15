#!/bin/bash
set -e

__ScriptVersion="0.0.1"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
        cat <<- EOT

  Usage :  $0 [options] [--]
  Options:
  -h|help       Display this message
  -v|version    Display script version
  -f|file       model file
  -d|debug      run model in debug mode, will drop you in gdb shell.

EOT
}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts "hvf:d" opt
do
    case $opt in

        h|help   )  
            usage; exit 0
            ;;

        v|version)  
            echo "$0 -- Version $__ScriptVersion"; exit 0
            ;;

        f|file   )  
            MODEL_FILE=$OPTARG
            ;;

        d|debug  )  
            DO_DEBUG=1;
            ;;

        \?       )  
            echo -e "\n  Option does not exist : $OPTARG\n"
            usage;   
            exit 1   
            ;;
    esac    # --- end of case ---
done

shift $(($OPTIND-1))

export PYTHONPATH=$HOME/Work/GITHUB/DILAWAR/moose-core/python
echo "Using moose: `python -c 'import moose; print moose.__file__'`"

PYTHON=`which python`
if [ $DO_DEBUG ];  then
    echo "++ Enabled debug"
    PYTHON="gdb -ex r --args $PYTHON"
fi

if [ ! -f "$MODEL_FILE" ]; then
    echo "File $MODEL_FILE not found"
    exit
fi

IMAGE_DIR=./_images/`date +%F`
FILE_NAME_TIMESTAMPED="$IMAGE_DIR/$MODEL_FILE_`date +%R`.png"

mkdir -p $IMAGE_DIR

$PYTHON ./run_model.py "$MODEL_FILE"

# Plot only if not in debug mode.
if [ ! $DO_DEBUG ]; then 
    ~/Scripts/plot_csv.py -i "$MODEL_FILE".dat -y 1-10 -s -o $MODEL_FILE.png
    echo "Copying image to $FILE_NAME_TIMESTAMPED"
    cp $MODEL_FILE.png $FILE_NAME_TIMESTAMPED
fi
