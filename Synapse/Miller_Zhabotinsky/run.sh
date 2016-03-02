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

MODEL_FILE="$1"

if [ ! -f "$MODEL_FILE" ]; then
    echo "File $MODEL_FILE not found or no model file given"
    echo "Usage: $0 yacml_file"
    exit
fi

IMAGE_DIR=./_images/`date +%F`
FILE_NAME_TIMESTAMPED="$IMAGE_DIR/$MODEL_FILE_`date +%R`"

mkdir -p $IMAGE_DIR

$PYTHON ./run_model.py "$MODEL_FILE"

#-y 1:20 \
# Plot only if not in debug mode.
rm -f "$MODEL_FILE.svg"
if [ ! $DO_DEBUG ]; then 
    ~/Scripts/plot_csv.py -i "$MODEL_FILE".dat \
        -y "PP1.N,PP1.conc,x0y0.N,x1y0.N,x1y1.N,x3y0,x6y0.N,ca.conc" \
        -s -o $MODEL_FILE.svg
    echo "Copying image to $FILE_NAME_TIMESTAMPED".svg
    cp $MODEL_FILE.svg $FILE_NAME_TIMESTAMPED.svg
    dot -Tpng ./camkii.yacml.dot > camkii.png
fi
