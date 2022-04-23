# Installation Message
VERSION=$(grep_prop version "${TMPDIR}/module.prop")
ui_print "- Installing QuoteLockX Custom Fonts ${VERSION}"

# Extract files
ui_print "- Extracting stub file"
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
touch $MODPATH/system/fonts/custom/.stub

# Migrate legacy fonts
LEGACY_FONT_DIR=$MODPATH/../../modules/quotelockx_custom_fonts/system/fonts/custom
UPDATE_FONT_DIR=$MODPATH/system/fonts/custom
if [ ! -d "$LEGACY_FONT_DIR/" ] ; then
    ui_print "- Legacy files not found"
else
    ui_print "- Migrating legacy fonts..."
    for file in `ls $LEGACY_FONT_DIR/`
    do
        if [ ! $file == ".stub" ] ; then
            ui_print "- File $file migrated"
            cp $LEGACY_FONT_DIR/$file $UPDATE_FONT_DIR/
        fi
    done
fi

# Set permission
set_perm_recursive  $MODPATH  0  0  0755  0644