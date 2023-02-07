#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuidone=c2e72fb4-b01a-4fc5-8cf3-6250511dd3b2
uuidtwo=111c0441-7493-4adb-b934-d98d7fa42e56
uuidthree=933f1d7e-80f5-4618-80b6-31a4bad65fa9
uuidfour=179f6fa7-fe75-4ffd-854f-20a905e1cadf
uuidfive=27fa7630-1bb7-47b7-af2b-6eb509247442
mypath=/honggirish-tell
myport=8080


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"listen": "0.0.0.0",
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"decryption": "none",
				"clients": [
					{
						"id": "$uuidone"
					},
					{
						"id": "$uuidtwo"
					},
					{
						"id": "$uuidthree"
					},
					{
						"id": "$uuidfour"
					},
					{
						"id": "$uuidfive"
					}
				]
			
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json
