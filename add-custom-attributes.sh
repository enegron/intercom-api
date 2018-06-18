# this script will take a list of email addresses in plain text (one email per line)
# For each email it will add/update the value of a single intercom custom-attribute to one specified value
# useful if you want to set a bunch of users to have a value of somethign as "true" so that then you can create a targetted message
# script has a dependency on JQ: https://stedolan.github.io/jq/

#put your custom intercom Private Access Token (aka Access Token) here:
intercomPAT=''

# change these variables to customize the subscription

#location of the  file with email addresses
emailsToTag=emails.txt

# the name of the custom attribute
# needs to be created first using the intercom admin web UI for people data
# https://app.intercom.io/a/apps/qut39av2/settings/people-data
customAttribute=''

#the value you want to set for the custom attribute
#currently script just supports setting all users to one attribute with one value
customAttributeValue=''

#TODO: might need to really urlencode the email address

while read email; do
  echo -e $userEmail''
  intercomUserId=$(
    curl \
    https://api.intercom.io/users?email=$email \
    -u $intercomPAT: \
    -H 'Accept:application/json' | jq -r '.id'
  )
  echo $intercomUserId


  curl https://api.intercom.io/users/$intercomUserId \
  -u $intercomPAT: \
  -H 'Accept:application/json' | jq '.'

  #JSON object for the update:
  userJSON='{"id":"'$intercomUserId'","custom_attributes":{"'$customAttribute'":"'$customAttributeValue'"}}'


  #update the user's data
  curl https://api.intercom.io/users \
  -X POST \
  -H "Authorization:Bearer $intercomPAT" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d $userJSON \

done < $emailsToTag

exit
