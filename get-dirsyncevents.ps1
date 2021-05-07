$comp = get-wmiobject win32_computersystem
$comp = $comp.name
#$filter = "<QueryList><Query><Select Path='Application'>*[System[Provider[@Name='ADSync'] and (Level=1  or Level=2 or Level=3) and ((EventID &gt;= 0 and EventID &lt;= 6940) or (EventID &gt;= 6942 and EventID &lt;= 99999)) and TimeCreated[timediff(@SystemTime) &lt;= 600000]]]</Select></Query></QueryList>"
#$filter = "<QueryList><Query><Select Path='Application'>*[System[Provider[@Name='ADSync'] and (Level=1  or Level=2) and ((EventID &gt;= 0 and EventID &lt;= 6940) or (EventID &gt;= 6942 and EventID &lt;= 99999)) and TimeCreated[timediff(@SystemTime) &lt;= 600000]]]</Select></Query></QueryList>"
#ten minutes
#$filter = "<QueryList><Query><Select Path='Application'>*[System[Provider[@Name='ADSync'] and (Level=1 or Level=2 or Level=3) and ((EventID &gt;= 0 and EventID &lt;= 6099) or (EventID &gt;= 6101 and EventID &lt;= 6104) or (EventID &gt;= 6106 and EventID &lt;= 6940) or (EventID &gt;= 6942 and EventID &lt;= 99999)) and TimeCreated[timediff(@SystemTime) &lt;= 600000]]]</Select></Query></QueryList>"
#thirty minutes
$filter = "<QueryList><Query><Select Path='Application'>*[System[Provider[@Name='ADSync'] and (Level=1 or Level=2 or Level=3) and ((EventID &gt;= 0 and EventID &lt;= 6099) or (EventID &gt;= 6101 and EventID &lt;= 6104) or (EventID &gt;= 6106 and EventID &lt;= 6940) or (EventID &gt;= 6942 and EventID &lt;= 99999)) and TimeCreated[timediff(@SystemTime) &lt;= 1800000]]]</Select></Query></QueryList>"
$body = ""
$array = ""
$array = (Get-WinEvent -ComputerName $comp -FilterXML $filter)
if($array[0].tostring() -gt ""){
foreach($item in $array){
$item
if($item.ProviderName -eq "ADSync"){

$body = $body + $item.TimeCreated + "`n"
$body = $body + "Event ID:" + $item.Id + "`n"
$body = $body + $item.Message + "`n"
$body = $body + "_______________________________________________" + "`n" + "`n"
}
}
Send-MailMessage -From SyncServer@Domain.Com -Subject "AAD Sync Events" -To Administrator@Domain.com -Body $body -SmtpServer mailrelay.Domain.com
}

