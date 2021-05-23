#blunderman1 apikey=

apikey1=XXXXXXXXXXXXXXXX #blundertulpa1
apikey2=YYYYYYYYYYYYYYYY #blundertulpa2

times=(3 3 1 1 5 2 3 3 5 2 1 1)
incrs=(0 2 0 2 0 0 2 0 0 0 2 0)
#Epoch timestamp: 1621641600
#Timestamp in milliseconds: 1621641600000
#Date and time (GMT): Saturday, May 22, 2021 0:00:00 

may22_midnight=1621641600000
hour=1000*60*60
day=24*hour
iter=0

startDate=$((may22_midnight + day*iter))

NEWLINE=$'\n'

#testCmd="echo '{\"id\":\"ZAtMNwrP\",\"createdBy\":\"blunderman1\"}'"



resultRedirect1="<script type='text/javascript'>"
resultList1="<div>"
resultRedirect2="<script type='text/javascript'>"
resultList2="<div>"

for x in {1..12}
do
echo "============================================================"
echo "============================================================"

ts1=$(( startDate+((x-1)*hour) ))
ts1_end=$(( startDate+(x*hour) ))

ts2=$(( startDate+((12+x-1)*hour) ))
ts2_end=$(( startDate+((12+x)*hour) ))

actualCmd1="curl -X POST -H \"Authorization: Bearer $apikey1\" -d 'name=HourlyZH&clockTime=${times[x-1]}&clockIncrement=${incrs[x-1]}&minutes=60&startDate=$ts1&variant=crazyhouse' https://lichess.org/api/tournament"
actualCmd2="curl -X POST -H \"Authorization: Bearer $apikey2\" -d 'name=HourlyZH&clockTime=${times[x-1]}&clockIncrement=${incrs[x-1]}&minutes=60&startDate=$ts2&variant=crazyhouse' https://lichess.org/api/tournament"

echo "$actualCmd1"
echo "$actualCmd2"

#create tournaments - get ids

tournamentId1=$(eval $actualCmd1 | jq .id)
tournamentId1="${tournamentId1//\"/}"

tournamentId2=$(eval $actualCmd2 | jq .id)
tournamentId2="${tournamentId2//\"/}"

echo "------------------------------------------------------------"
echo "tournamentId1=$tournamentId1"
echo "tournamentId2=$tournamentId2"

#generate html:
resultRedirect1="$resultRedirect1 $NEWLINE if (Date.now() >= $ts1 && Date.now() < $ts1_end ) { window.location.replace('https://lichess.org/tournament/$tournamentId1'); }"
resultList1="$resultList1 $NEWLINE <div>`TZ=UTC LC_TIME=C date +\"%b %d %H:%M\" -d @$((ts1/1000))` - `TZ=UTC LC_TIME=C date +\"%H:%M\" -d @$((ts1_end/1000))` <b>${times[x-1]}+${incrs[x-1]}</b> <a href='https://lichess.org/tournament/$tournamentId1'>https://lichess.org/tournament/$tournamentId1</a></div> "

resultRedirect2="$resultRedirect2 $NEWLINE if (Date.now() >= $ts2 && Date.now() < $ts2_end ) { window.location.replace('https://lichess.org/tournament/$tournamentId2'); }"
resultList2="$resultList2 $NEWLINE <div>`TZ=UTC LC_TIME=C date +\"%b %d %H:%M\" -d @$((ts2/1000))` - `TZ=UTC LC_TIME=C date +\"%H:%M\" -d @$((ts2_end/1000))` <b>${times[x-1]}+${incrs[x-1]}</b> <a href='https://lichess.org/tournament/$tournamentId2'>https://lichess.org/tournament/$tournamentId2</a></div> "

#join

joinCmd11="curl -X POST -H \"Authorization: Bearer $apikey1\" https://lichess.org/api/tournament/$tournamentId1/join"
joinCmd12="curl -X POST -H \"Authorization: Bearer $apikey2\" https://lichess.org/api/tournament/$tournamentId1/join"

joinCmd21="curl -X POST -H \"Authorization: Bearer $apikey1\" https://lichess.org/api/tournament/$tournamentId2/join"
joinCmd22="curl -X POST -H \"Authorization: Bearer $apikey2\" https://lichess.org/api/tournament/$tournamentId2/join"

echo $joinCmd11
echo $joinCmd12
echo $joinCmd21
echo $joinCmd22

$(eval $joinCmd11)
$(eval $joinCmd12)
$(eval $joinCmd21)
$(eval $joinCmd22)

done

resultRedirect1="$resultRedirect1$NEWLINE</script>"
resultList1="$resultList1$NEWLINE</div>"

resultRedirect2="$resultRedirect2$NEWLINE</script>"
resultList2="$resultList2$NEWLINE</div>"


echo "<html><body><b>IF YOU CAN READ THIS, IT MEANS YOU DID NOT GET AUTOMATICALLY REDIRECTED TO THE CURRENT TOURNAMENT!<br/>
PRESS <i>CTRL + F5</i> or <i>SHIFT + F5</i>  TO REFRESH THE PAGE and clear cache</b>
<br/>
<br/>
If still problematic, see if you can find the currently active tournament in the list below.
<br/>
!!! ALL TIMES ARE IN UTC !!!
<br/>
You can also check
<br/>
<a href='https://lichess.org/@/blundertulpa1/tournaments/created'>https://lichess.org/@/blundertulpa1/tournaments/created</a>
<br/>
<a href='https://lichess.org/@/blundertulpa2/tournaments/created'>https://lichess.org/@/blundertulpa2/tournaments/created</a>
<br/>
<br/>

$resultList1
$resultList2
$resultRedirect1
$resultRedirect2
</body></html>" > ./i.want.crazyhouse.html


#curl -X POST -H "Authorization: Bearer $apikey" -d 'name=asdf&clockTime=3&clockIncrement=2&minutes=60&startDate=1621522799&variant=crazyhouse' https://lichess.org/tournament/new
#
#| jq .id
