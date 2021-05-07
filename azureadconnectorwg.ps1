del c:\temp\azureadconnector.xml
pushd "C:\Program Files\Microsoft Azure AD Sync\Bin"
.\csexport.exe "Domain.OnMicrosoft.com - AAD" c:\temp\azureadconnector.xml /f:e /o:e
Send-MailMessage -From Server@Domain.com -Subject "AAD Connect Export Errors" -To Administrator@Domain.com -Attachments c:\temp\azureadconnector.xml -Body "AAD Connect Export Errors Attached" -SmtpServer mailrelay.Domain.com