#!/bin/sh

if [ -n "${EXPORT_SQLITE}" ]; then
  DB_FILE='/root/result.sqlite3'

  if [ ! -f "${DB_FILE}" ]; then
    sqlite3 "${DB_FILE}" "
      CREATE TABLE results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        download INTEGER,
        upload INTEGER,
        isp TEXT,
        ip TEXT,
        url TEXT,
        UNIQUE(timestamp)
      );
      CREATE INDEX idx_timestamp ON results (timestamp);
    "
  fi
fi

if [ -n "${EXPORT_JSONL}" ]; then
  JSONL_FILE='/root/result.jsonl'
  if [ ! -f "${JSONL_FILE}" ]; then
    touch "${JSONL_FILE}"
  fi
fi

while read -r JSON_LINE; do

  if [ -n "${EXPORT_SQLITE}" ]; then

    TIMESTAMP=$(echo "${JSON_LINE}" | jq -r '.timestamp')
    DOWNLOAD=$(echo "${JSON_LINE}" | jq -r '.download.bandwidth') # byte/s
    UPLOAD=$(echo "${JSON_LINE}" | jq -r '.upload.bandwidth')     # byte/s
    ISP=$(echo "${JSON_LINE}" | jq -r '.isp')
    IP=$(echo "${JSON_LINE}" | jq -r '.interface.externalIp')
    URL=$(echo "${JSON_LINE}" | jq -r '.result.url')

    echo "INSERT INTO results(
    timestamp, download, upload,
    isp, ip, url
  ) VALUES (
    '${TIMESTAMP}', '${DOWNLOAD}', '${UPLOAD}',
    '${ISP}', '${IP}', '${URL}'
  )" | sqlite3 "${DB_FILE}"
  fi

  if [ -n "${EXPORT_JSONL}" ]; then
    echo "${JSON_LINE}" | tee -a "${JSONL_FILE}"
  fi
done
