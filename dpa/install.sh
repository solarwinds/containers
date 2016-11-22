#!/bin/bash
GZIP_FILE=dpa.tar.gz
TAR_FILE=`echo $GZIP_FILE | sed 's/\.gz//g'`
echo "PRODUCT_GZIP_FILE     : $GZIP_FILE"
echo "PRODUCT_TAR FILE      : $TAR_FILE"
echo "PRODUCT_DOWNLOAD_DIR  : $PRODUCT_DOWNLOAD_DIR"
echo "PRODUCT_DOWNLOAD_NAME : $PRODUCT_DOWNLOAD_NAME"

PRODUCT_INSTALL_DIR=`echo $PRODUCT_DOWNLOAD_NAME | cut -d '-' -f2- | sed 's/[-.]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/64bit.*/x64_installer/g'`
PRODUCT_INSTALL_SCRIPT="$PRODUCT_INSTALL_DIR".sh

echo "PRODUCT_INSTALL_DIR    : $PRODUCT_INSTALL_DIR"
echo "PRODUCT_INSTALL_SCRIPT : $PRODUCT_INSTALL_SCRIPT"

if [ -f "$GZIP_FILE" ]
then
  gunzip $GZIP_FILE
  if [ -f "$TAR_FILE" ]
  then
    tar xvf $TAR_FILE
    if [ ! -d "$PRODUCT_INSTALL_DIR" ]
    then
     echo "$PRODUCT_INSTALL_DIR does not exists. Please check the tar file"
     exit -1;
    fi
    if [ ! -f "$PRODUCT_INSTALL_DIR/$PRODUCT_INSTALL_SCRIPT" ]
    then
     echo "$PRODUCT_INSTALL_DIR/$PRODUCT_INSTALL_SCRIPT does not exists. Please check the tar file"
     exit -1;
    fi
    chmod 744 "$PRODUCT_INSTALL_DIR/$PRODUCT_INSTALL_SCRIPT"
    ./"$PRODUCT_INSTALL_DIR/$PRODUCT_INSTALL_SCRIPT"
  else
    exit -1
  fi
fi


