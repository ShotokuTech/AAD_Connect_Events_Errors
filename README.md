# AAD_Connect_Events_Errors
Scripts to automatically email you if there are AAD Connect events and errors.

Yeah I know. There is AAD Connect Health now. But I started was back in the days of Dirsync. It is still more direct and reliable for me to get these events and errors from these scripts I have developed over the years.

azureadconnectorwg.ps1 runs as a scheduled task nightly. This gives you the raw XML file with all the export errors from the "Domain.OnMicrosoft.com - AAD" connector. (Insert your domain here and also update the various send-mailmessage parameters to suit your environment).

azureadconnector-errorcheckerwg runs after azureadconnectorwg.ps1. This parses the raw XML file and tries to find the involved objects in AD to help you resolve the export errors. (Update the various send-mailmessage parameters to suit your environment).

get-dirsyncevents.ps1 runs every thirty minutes capturing events that might be of concern from the last thirty minutes of the AD Sync log. (Update the various send-mailmessage parameters to suit your environment). There are a few hash definistions here so you can learn more about using PowerShell to read event logs. You have find you need to adjust the hash to suit the current scenario.

