#!/bin/bash
# interrogates LM-X based license server for Oasys software
# features: arup d3plot primer primer_post report this x264_video_output
# note the "arup" feature is "UNLIMITED" so might not need to be considered
feature=$1
licquery=/apps/lmx/5.2/lmxendutil
$licquery -licstatxml -host amslic03 -port 6200 |xmlstarlet sel -t -v "//FEATURE[@NAME='${feature}']/@USED_LICENSES" --output \  -v "//FEATURE[@NAME='${feature}']/@TOTAL_LICENSES" --nl | (read used total ; echo $((total-used)))
