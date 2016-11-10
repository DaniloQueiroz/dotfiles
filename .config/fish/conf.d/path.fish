for i in (find -H  ~/tools -maxdepth 3 -type d -name bin)
    set PATH $i $PATH
end

set PATH ~/tools/utils /opt/android-sdk/platform-tools/ $PATH

set PATH "" $PATH  # HACK: avoid eating first directory
