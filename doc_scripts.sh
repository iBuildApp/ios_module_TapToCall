headerdoc2html -j -o mTapToCall/Documentation mTapToCall/mTapToCall.h     


gatherheaderdoc mTapToCall/Documentation


sed -i.bak 's/<html><body>//g' mTapToCall/Documentation/masterTOC.html
sed -i.bak 's|<\/body><\/html>||g' mTapToCall/Documentation/masterTOC.html
sed -i.bak 's|<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">||g' mTapToCall/Documentation/masterTOC.html