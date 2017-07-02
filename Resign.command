#!/bin/sh -e
echo "Drag IPA File"
read IPA
echo "Drag Provision File"
read PROVISION
echo "Drag Entitlements File"
read ENTITLEMENTS
CERTIFICATE="" # must be in keychain
# unzip the ipa
unzip -q "$IPA"
# remove the signature
rm -rf Payload/*.app/_CodeSignature Payload/*.app/CodeResources
# replace the provision
cp "$PROVISION" Payload/*.app/embedded.mobileprovision
# sign with the new certificate
/usr/bin/codesign -f -s "$CERTIFICATE" --entitlements "$ENTITLEMENTS" Payload/*.app
# zip it back up
FILENAME=$(basename "$IPA")
zip -qr "$FILENAME" Payload
rm -r Payload
while :
do
  echo "Drag IPA File"
  read IPA
  # unzip the ipa
  unzip -q "$IPA"
  # remove the signature
  rm -rf Payload/*.app/_CodeSignature Payload/*.app/CodeResources
  # replace the provision
  cp "$PROVISION" Payload/*.app/embedded.mobileprovision
  # sign with the new certificate
  /usr/bin/codesign -f -s "$CERTIFICATE" --entitlements "$ENTITLEMENTS" Payload/*.app
  # zip it back up
  FILENAME=$(basename "$IPA")
  zip -qr "$FILENAME" Payload
  rm -r Payload
done