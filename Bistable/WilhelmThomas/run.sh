#!/bin/bash
set -e
set -x
MODEL_FILE="$1"
IMAGE_DIR=./_images/`date +%F`
if [ ! -d $IMAGE_DIR ]; then
    mkdir -p $IMAGE_DIR
fi

FILE_NAME_TIMESTAMPED="$IMAGE_DIR/$MODEL_FILE_`date +%R`.png"

mkdir -p $IMAGE_DIR

python ./load_yacml.py "$MODEL_FILE"
~/Scripts/plot_csv.py -i "$MODEL_FILE".dat -y 1-10 -s -o $MODEL_FILE.png

echo "Copying image to $FILE_NAME_TIMESTAMPED"
cp $MODEL_FILE.png $FILE_NAME_TIMESTAMPED
