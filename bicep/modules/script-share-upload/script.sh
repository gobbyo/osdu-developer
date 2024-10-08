#!/bin/bash
set -e

echo "Waiting on Identity RBAC replication (${initialDelay})"
sleep ${initialDelay}

# Installing curl
apk add --no-cache curl

# Derive the filename from the URL
url_basename=$(basename ${URL})
echo "Derived filename from URL: ${url_basename}"

# Download the file using curl
echo "Downloading file from ${URL} to ${url_basename}"
curl -so ${url_basename} ${URL}

# Check if the URL indicates a tar.gz file
if [[ ${URL} == *.tar.gz ]]; then
    echo "URL indicates a tar.gz archive. Extracting contents..."
    
    # Create a directory for extracted files
    mkdir -p extracted_files
    
    # Extract the tar.gz file
    tar -xzf ${url_basename} --strip-components=1 -C extracted_files
    
    # Batch upload the extracted files to the file share using the specified pattern
    echo "Uploading extracted files to file share ${SHARE} with pattern ${FILE}/**"
    az storage file upload-batch -d ${SHARE} --source extracted_files --pattern "${FILE}/**" --no-progress -onone
    echo "Files from ${url_basename} uploaded to file share ${SHARE}."
else
    # Upload the file to the file share, overwriting if it exists
    echo "Uploading file ${FILE} to file share ${SHARE}"
    az storage file upload -s ${SHARE} --source ./${FILE} -onone
    echo "File ${FILE} uploaded to file share ${SHARE}, overwriting if it existed."
fi