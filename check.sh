#!/bin/sh

# echo `pwd`/`dirname $0`

SCRIPT_PATH=`pwd`/`dirname $0`

# Create the file we're expecting if it doesn't already exist
touch "$SCRIPT_PATH/previousstocklevel.log"

# Will be a string, eg: "available"
PREVIOUS_STOCK_LEVEL=$(cat "$SCRIPT_PATH/previousstocklevel.log")

# Will be another string, eg: "ships-to-store"
CURRENT_STOCK_LEVEL=$(curl 'http://www.apple.com/uk/shop/retailStore/availabilitySearch?parts.0=MLM62B%2FA&zip=l27pq' --silent -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://www.apple.com/uk/shop/buy-iphone/iphone-se/64gb-space-grey' -H 'X-Requested-With: XMLHttpRequest' -H $'Cookie: helpSession=436821-1297294327269; asbid=sDPYKJ7XPCJYDXTXK; s_membership=3%3Ait%3Aaid%3A3p; s_cvp35b=%5B%5B\'cdm-eu-35551\'%2C\'1331236821854\'%5D%2C%5B\'www.vodafone.co.uk\'%2C\'1331236892626\'%5D%2C%5B\'t.co\'%2C\'1331492029465\'%5D%2C%5B\'news.ycombinator.com\'%2C\'1332146779233\'%5D%2C%5B\'t.co\'%2C\'1332873628687\'%5D%5D; optimizelyEndUserId=oeu1387964830735r0.29801457771100104; dssid2=443b4e7f-2cdc-40fa-9470-df1c4ba13ebd; dssf=1; pxro=1; as_aas=TSkFse0xvLgSAjiuHIp1WovdSKK6oWlXkdzPSp8W9IGvKltA-sx94oV0PaSBuWZ85UPWpt0YuCyv62hMcu_mFQ+kic7csFMmxc+jZuFotJznasWi_KKcKsk6hODMxQ; s_vnum_n2_tv=0%7C1; xp_ci=3z3qcWJhzEslz4qXzADmzbjpyEQkX; optimizelyExp=3902381720; optimizelySegments=%7B%22340176093%22%3A%22search%22%2C%22341487600%22%3A%22none%22%2C%22341793217%22%3A%22campaign%22%2C%22341794206%22%3A%22false%22%2C%22341808126%22%3A%22false%22%2C%22341824156%22%3A%22gc%22%2C%22341865027%22%3A%22gc%22%2C%22341932127%22%3A%22none%22%7D; optimizelyBuckets=%7B%7D; a=QQAJAAAACwAx3LIGMTFsM1FvAAAAADjzy0c=; ccl=ucY/745tGhcSUjWAly8krg==; geo=GB; s_invisit_n2_uk=3%2C0; s_vnum_n2_uk=0%7C8%2C3%7C3%2C21%7C1; s_vnum_n2_us=domain%20%3D%20apple.com%3B%20path%20%3D%20%2F%2C0%7C8%2C31%7C1%2C3%7C1%2C88%7C1; s_cc=true; s_orientation=%5B%5BB%5D%5D; s_pathLength=homepage%3D2%2Cenv%3D1%2Ciphone%3D1%2Ciphone.tab%2Bother%3D1%2Ciphonese%3D1%2C; s_ppv=iphone%2520se%2520-%2520overview%2520%2528uk%2529%2C10%2C5%2C1638%2C800%3A1%7C900%3A1%7C1000%3A1%7C1100%3A1%7C1200%3A1%7C1300%3A1%7C1400%3A1%7C1500%3A1%7C1600%3A1%7C1700%3A1; s_orientationHeight=1638; s_fid=50F709C0AC742F2C-3AB3C8F34A934A9A; s_sq=%5B%5BB%5D%5D; as_sfa=Mnx1a3x1a3x8ZW5fR0J8Y29uc3VtZXJ8aW50ZXJuZXR8MHwwfDE=; as_metrics=%7B%22store%22%3A%7B%22sid%22%3A%22w2YF4JXY4AHCAJCDF%22%7D%7D; as_dc=nc' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed | jq '.body.stores | map(select(.storeName=="Liverpool ONE")) | .[0].partsAvailability."MLM62B/A".pickupDisplay' --raw-output)

# If the stock level has changed, tell us what it has changed to
if [ "$CURRENT_STOCK_LEVEL" != "$PREVIOUS_STOCK_LEVEL" ]; then

  if [ "$CURRENT_STOCK_LEVEL" == 'available' ]; then
    MESSAGE="iPhone SE is now in stock at Liverpool ONE"

  elif [ "$CURRENT_STOCK_LEVEL" == 'ships-to-store' ]; then
    MESSAGE="iPhone SE is no longer in stock at Liverpool ONE"

  else
    MESSAGE="Unexpected stock response at Liverpool ONE: $CURRENT_STOCK_LEVEL"
  fi

  EMAIL_ADDRESS=$(cat "$SCRIPT_PATH/email.txt")

  echo "$MESSAGE" | mail -s "Liverpool ONE iPhone stock: $CURRENT_STOCK_LEVEL" "$EMAIL_ADDRESS"
fi

echo $CURRENT_STOCK_LEVEL > "$SCRIPT_PATH/previousstocklevel.log"
