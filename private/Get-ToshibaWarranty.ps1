function get-ToshibaWarranty
([Parameter(Mandatory = $true)]$SourceDevice, [Parameter(Mandatory=$false)] [string]$ModelNumber,[Parameter(Mandatory=$false)] [string]$client)  {
    $today = Get-Date -Format yyyy-MM-dd
    $APIURL = "http://support.toshiba.com/support/warrantyResults?sno=" + $SourceDevice + "&mpn=" + $modelnumber
    $Req = Invoke-RestMethod -Uri $APIURL -Method get
    if ($req.commonBean) {
        #$warlatest = $Req.EndDate | sort-object | select-object -last 1 
        $WarrantyState = if ($req.commonBean.warrantyExpiryDate -le $today) { "Expired" } else { "OK" }       
        $WarObj = [PSCustomObject]@{
            'Serial'                = $req.commonBean.serialNumber
            'Warranty Product name' = ($Req.serviceTypes.Carry.svcDesc -replace '<[^>]+>','')
            'StartDate'             = $req.commonBean.warOnsiteDate
            'EndDate'               = $req.commonBean.warrantyExpiryDate
            'Warranty Status'       = $WarrantyState
            'Client'                = $Client
        }
    }
    else {
        $WarObj = [PSCustomObject]@{
            'Serial'                = $SourceDevice
            'Warranty Product name' = 'Could not get warranty information'
            'StartDate'             = $null
            'EndDate'               = $null
            'Warranty Status'       = 'Could not get warranty information'
            'Client'                = $Client
        }
    }
    return $WarObj
 
 
}