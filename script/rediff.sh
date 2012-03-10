#!/bin/sh

VENDOR_KEY="NDUzOXxDNDRCQjE3QzJDNjQ0NDVDM0EwQ0MwRjVGRjE5Mzc5NXxpSHlQVzVZV0t4emw="
START_DATE=$(date +'%d/%m/%Y')
END_DATE=$(date +'%d/%m/%Y')
let OUT_FORMAT_TYPE=0
QUERY_TYPE="A"
URL="www.fnp.in/fnp/faces/rediffResponse"
output_file=/tmp/rediff_output.$(date +%s)

#lynx -accept-all-cookies "$URL?vendorkey=${VENDOR_KEY}&startdt=${START_DATE}&enddt=${END_DATE}&optype=${OUT_FORMAT_TYPE}&querytype=${QUERY_TYPE}&submit1=Send"
curl --output $output_file -s "$URL?vendorkey=${VENDOR_KEY}&startdt=${START_DATE}&enddt=${END_DATE}&optype=${OUT_FORMAT_TYPE}&querytype=${QUERY_TYPE}&submit1=Send"
