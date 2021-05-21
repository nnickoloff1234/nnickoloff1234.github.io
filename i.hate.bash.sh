apikey=<PUT_YOUR_KEY_HERE>

#Timestamp in milliseconds: 1621594800000
#Date and time (GMT): Friday, May 21, 2021 11:00:00 AM

may21_1100am=1621594800000
hour=1000*60*60
day=24*hour

startDate=$may21_1100am

NEWLINE=$'\n'

#testCmd="echo '{\"id\":\"ZAtMNwrP\",\"createdBy\":\"blunderman1\"}'"


result="<html><body><script type='script/javascript'>"
for x in {1..12}
do

ts=$(( startDate+((x-1)*hour) ))
ts_end=$(( startDate+(x*hour) ))

actualCmd="curl -X POST -H \"Authorization: Bearer $apikey\" -d 'name=asdf&clockTime=3&clockIncrement=2&minutes=60&startDate=$ts&variant=crazyhouse' https://lichess.org/api/tournament"

#stdOut=$(eval $actualCmd)
#echo $stdOut

tournamentId=$(eval $actualCmd | jq .id)
tournamentId="${tournamentId//\"/}"

result="$result $NEWLINE if (Date.now() >= $ts && Date.now() < $ts_end ) { window.location.replace('https://lichess.org/tournament/$tournamentId'); }"

done

result="$result $NEWLINE </script></body></html>"


echo $result
#curl -X POST -H "Authorization: Bearer $apikey" -d 'name=asdf&clockTime=3&clockIncrement=2&minutes=60&startDate=1621522799&variant=crazyhouse' https://lichess.org/tournament/new
#
#| jq .id
