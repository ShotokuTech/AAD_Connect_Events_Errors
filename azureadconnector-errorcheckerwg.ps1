import-module activedirectory
$nl = [Environment]::NewLine
remove-item c:\temp\errors_out.txt -force
#"" | out-file c:\temp\errors_out.txt
$i = select-xml -XPath "//error-literal" -path c:\temp\azureadconnector.xml
foreach($item in $i){
$checkarray = @()
$outarray = @()
$itemerr = $item.node.InnerXML
"error____________________________________________________________________" | out-file c:\temp\errors_out.txt -append
$nl | out-file c:\temp\errors_out.txt -append
$itemerr | out-file c:\temp\errors_out.txt -append
$itemerr = $itemerr.substring($itemerr.indexof('[')+1,$itemerr.indexof(']')-$itemerr.indexof('[')-1)
#proxyaddresses
if($itemerr.startswith("ProxyAddresses") -eq "TRUE"){
$itemerr = $itemerr -replace "ProxyAddresses ",""
#need to trap x500, x400 handle differently
if($itemerr.startswith("X500") -eq "TRUE"){
$x500 = $itemerr.substring($itemerr.indexof('cn=Recipients/cn=')+17,$itemerr.indexof(';')-$itemerr.indexof('cn=')-16)
$x500 = $x500 -replace ";","*"
$checkarray = $checkarray + $x500
}
if($itemerr.startswith("SMTP:") -or $itemerr.startswith("smtp:") -eq "TRUE"){
$itemerr = $itemerr -replace "SMTP:",""
$itemerr = $itemerr -replace "smtp:",""
$itemerr = $itemerr -replace "Mail ",""
$itemerr = $itemerr -replace "UserPrincipalName ",""
$itemerr = $itemerr -replace "SipProxyAddress ",""
$proxyaddresses = $itemerr -Split ";"
$proxyaddresses = $proxyaddresses -Split ","
$proxyaddresses = $proxyaddresses -Split "\s"
#"proxyaddress"
$checkarray = $checkarray + $proxyaddresses
}
}
if($itemerr.startswith("Mail") -eq "TRUE"){
$itemerr = $itemerr -replace "Mail ",""
$mail = $itemerr -Split ";"
$mail = $mail -Split ","
$mail = $mail -Split "\s"
#"mail"
$checkarray = $checkarray + $mail
}
if($itemerr.startswith("SipProxyAddress") -eq "TRUE"){
#$itemerr 
$itemerr = $itemerr -replace "SipProxyAddress ",""
$sipproxyaddresses = $itemerr -Split ";"
$sipproxyaddresses = $sipproxyaddresses -Split ","
$sipproxyaddresses = $sipproxyaddresses -Split "\s"
$sipproxyaddress = $sipproxyaddresses -replace "\s",""
$sipproxyaddress = $sipproxyaddress[0]
#"sipproxyaddress"
$checkarray = $checkarray + $sipproxyaddress
}
$checkarray = $checkarray | select -unique
#$checkarray | out-file c:\temp\errors_out.txt -append

foreach($check in $checkarray){
if($check -ne $null -and $check -gt " "){
$outarray = $outarray + (dsquery * -filter ("userprincipalname=$check"))
$outarray = $outarray + (dsquery * -filter ("mail=$check"))
$outarray = $outarray + (dsquery * -filter ("proxyaddresses=smtp:$check"))
$outarray = $outarray + (dsquery * -filter ("proxyaddresses=sip:$check"))
$outarray = $outarray + (dsquery * -filter ("msRTCSIP-PrimaryUserAddress=sip:$check"))
}

}
$nl | out-file c:\temp\errors_out.txt -append
"objects with conflict:" | out-file c:\temp\errors_out.txt -append
$outarray | select -unique  | out-file c:\temp\errors_out.txt -append
"____________________________________________________________________" | out-file c:\temp\errors_out.txt -append
$nl | out-file c:\temp\errors_out.txt -append
}

Send-MailMessage -From Server@Domain.com -Subject "AAD Connect Export Error Checks" -To Administrator@Domain.com -Attachments c:\temp\errors_out.txt -Body "AAD Connect Export Error Checks Attached" -SmtpServer mailrelay.Domain.com

#Purge run history beyound the last 7 days if desired
#Start-ADSyncPurgeRunHistory -PurgeRunHistoryInterval 7