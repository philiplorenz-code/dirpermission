$Output = @()
$DirOverview = Get-ChildItem "PATH" | Select BaseName, FullName 
foreach ($dir in $DirOverview){
    $DirACL = Get-Acl $dir.FullName
    $item = New-Object PSObject
    $item | Add-Member -type NoteProperty -Name 'Studio' -Value $dir.BaseName
    $item | Add-Member -type NoteProperty -Name 'Owner' -Value $DirACL.Owner

    $count = 0
    foreach ($AccessObject in $DirACL.Access){
        $item | Add-Member -type NoteProperty -Name "Object $count" -Value $AccessObject.IdentityReference
        $item | Add-Member -type NoteProperty -Name "Rights $count" -Value $AccessObject.FileSystemRights
        $count++
    }
    $Output += $item
}

$DirOverview | export-csv -LiteralPath "PATH" -NoTypeInformation -Delimiter ";"
