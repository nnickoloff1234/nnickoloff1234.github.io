#blunderman1 apikey=XX

apikey1=XX #blundertulpa1
apikey2=XX #blundertulpa2

starthour=(0	1	2	4	5	7	8	10	11	13	14	16	17	19	21	22	23)
startmins=(0	0	57	0	57	0	57	0	57	0	57	0	57	0	30	0	0)
durminute=(60	60	63	60	63	60	63	60	63	60	63	60	63	60	30	60	60)
clockTime=(2	3	5	1	1	2	3	3	1	5	1	3	2	3	1	3	2)
clockIncr=(0	2	0	2	0	0	2	0	2	0	0	0	0	2	0	0	0)

numoftour=17

#Epoch timestamp: 1621641600
#Timestamp in milliseconds: 1621641600000
#Date and time (GMT): Saturday, May 22, 2021 0:00:00 

may22_midnight=1621641600000
min=1000*60
hour=1000*60*60
day=24*hour
iter=2

startDate=$((may22_midnight + day*iter))

NEWLINE=$'\n'

#testCmd="echo '{\"id\":\"ZAtMNwrP\",\"createdBy\":\"blunderman1\"}'"
#name=ZH+Hourly&clockTime=3&clockIncrement=2&minutes=60&startDate=1621793783000&variant=crazyhouse&description=Bookmark+this+[https://nnickoloff1234.github.io/i.want.crazyhouse.html](https://nnickoloff1234.github.io/i.want.crazyhouse.html)%0AAlso [Crazyhouse Curator team](https://lichess.org/team/crazyhouse-curator)

for x in $( seq 0 $((numoftour-1)) )
do
echo "============================================================"
echo "= $x  ======================================================"

ts=$(( startDate+(starthour[x]*hour)+startmins[x]*min ))

echo "$ts ${durminute[x]} ${clockTime[x]} ${clockIncr[x]}"
key=$apikey1
if [ $x -gt 8 ]
then
key=$apikey2
fi

actualCmd="curl -X POST -H \"Authorization: Bearer $key\" -d 'name=Hourly+ZH&clockTime=${clockTime[x]}&clockIncrement=${clockIncr[x]}&minutes=${durminute[x]}&startDate=$ts&variant=crazyhouse&description=Bookmark+this+[https://nnickoloff1234.github.io/i.want.crazyhouse.html](https://nnickoloff1234.github.io/i.want.crazyhouse.html)%0A%0AAlso+Join+[Crazyhouse Curator team](https://lichess.org/team/crazyhouse-curator)' https://lichess.org/api/tournament"

echo "$actualCmd"

#########################################################
#create tournaments - get ids

tournamentId=$(eval $actualCmd | jq .id)
tournamentId="${tournamentId1//\"/}"

echo "------------------------------------------------------------"
echo "tournamentId=$tournamentId"

#########################################################
#join

joinCmd1="curl -X POST -H \"Authorization: Bearer $apikey1\" https://lichess.org/api/tournament/$tournamentId/join"
joinCmd2="curl -X POST -H \"Authorization: Bearer $apikey2\" https://lichess.org/api/tournament/$tournamentId/join"


echo $joinCmd1
echo $joinCmd2

$(eval $joinCmd1)
$(eval $joinCmd2)

done

