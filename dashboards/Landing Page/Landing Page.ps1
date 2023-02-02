New-UDDashboard -Title 'Home' -Content {
    New-UDLayout -Columns 4 -Content {
        Get-PSUDashboard -Integrated | Sort-Object Name | ForEach-Object {
            if ($_.Name -eq 'Landing Page') {
                return
            }

            if ($_.Authenticated -and $User -eq $null) {
                return
            }

            $Content = { 
                New-UDElement -Tag 'div' -Content {
                    New-UDCard -Title $_.Name -Content {
                        New-UDStack -Direction column -Spacing 2 -Content {
                            New-UDTypography $_.Description
                            New-UDStack -Direction row -Content {
                                $_.Tag | ForEach-Object {
                                    if ($_ -eq $null) { return }
                                    $Tag = Get-PSUTag -Name $_ -Integrated 
                                    New-UDChip -Label $_ -Style @{
                                        borderRadius    = "0px"
                                        backgroundColor = $_.Color
                                        color           = "white"
                                    }
                                }
                            }
                        }
                    } -Style @{ 
                        minHeight = '172px'
                    }
                } -Attributes @{
                    style   = @{
                        cursor = "pointer"
                    }
                    onClick = {
                        Invoke-UDRedirect -Native $_.BaseUrl
                    }
                }
            }

            if ($_.Authenticated -and $_.Role) {
                Protect-UDSection -Role $_.Role -Content $Content
            }
            else {
                & $Content 
            }
        }
    }
} -HeaderContent {
    if (-not $User) {
        New-UDButton -Text 'Login' -OnClick {
            Invoke-UDRedirect -Native '/login'
        }
    }
}