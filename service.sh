#!/system/bin/sh
MODDIR=${0%/*}

FONT_PENDING_DIR=/sdcard/Android/data/com.yubyf.quotelockx/files/fonts/pending
FONT_PENDING_IMPORT_DIR=$FONT_PENDING_DIR/import
FONT_PENDING_REMOVE_DIR=$FONT_PENDING_DIR/remove
FONT_DEST_DIR=$MODDIR/system/fonts/custom
LOG_ENABLED=0

echo_date()
{
    if [ $LOG_ENABLED -eq 1 ] ; then
        echo `date +%y/%m/%dT%H:%M:%S`: $*
    fi
}

until [ $(getprop sys.boot_completed) -eq 1 ] ; do
    sleep 1
done

# Attempt 5 times to wait for sdcard to be mounted
for i in 1 2 3 4 5
do
    if [ -d "/sdcard/" ] ; then
        break
    else
        sleep 2
    fi
done

(
    if [ -f "$FONT_PENDING_DIR/log_enable" ] ; then
        LOG_ENABLED=1
    fi

    echo_date "----------------------------------------"
    echo_date "Boot completed, starting fonts sync..."
    if [ ! -d "$FONT_PENDING_IMPORT_DIR/" ] ; then
        echo_date "No fonts to import"
    elif [ ! "$(ls -A $FONT_PENDING_IMPORT_DIR/)" ] ; then
        echo_date "No fonts to import"
    else
        echo_date "Importing fonts..."
        mkdir -p $FONT_DEST_DIR
        for file in `ls $FONT_PENDING_IMPORT_DIR/`
        do
            echo_date "Move $FONT_PENDING_IMPORT_DIR/$file to $FONT_DEST_DIR/"
            mv $FONT_PENDING_IMPORT_DIR/$file $FONT_DEST_DIR/
        done
    fi
    if [ ! -d "$FONT_PENDING_REMOVE_DIR/" ] ; then
        echo_date "No fonts to remove"
    elif [ ! "$(ls -A $FONT_PENDING_REMOVE_DIR/)" ] ; then
        echo_date "No fonts to remove"
    else
        echo_date "Removing fonts..."
        for file in `ls $FONT_PENDING_REMOVE_DIR/`
        do
            echo_date "Delete $FONT_DEST_DIR/$file"
            rm $FONT_DEST_DIR/$file
            rm $FONT_PENDING_REMOVE_DIR/$file
        done
    fi

    chmod -R +r $FONT_DEST_DIR/
    echo_date "Font sync script finished"
) >> $FONT_PENDING_DIR/log 2>&1
