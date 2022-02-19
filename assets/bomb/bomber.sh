#!/usr/bin/env bash
CWD=$(pwd)
CountryCode="$1"
Number="$2"
signal_on_SIGINT() {
    rm -rf $CWD/api >/dev/null 2>&1
    rm -rf $CWD/api2 >/dev/null 2>&1
    exit 1
}
trap signal_on_SIGINT SIGINT
if [ -f $CWD/api ]; then
    rm -rf $CWD/api >/dev/null 2>&1
fi
cp -r $CWD/apiAssets/api $CWD
while read -r A; do
    echo "${A//€BHUTUU/$Number}"
done < $CWD/api > $CWD/api2
rm -rf $CWD/api >/dev/null 2>&1
while read -r X; do
    echo "${X//+91/$countryCode}"
done < $CWD/api2 > $CWD/api
while true; do
    bash $CWD/api > /dev/null 2>&1
done