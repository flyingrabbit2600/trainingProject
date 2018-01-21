<#
        .SYNOPSIS
        This commandlet returns a report called output.csv.
        .DESCRIPTION
        This commandlet returns a report called output.csv listing the Server Roles, Server Names, Requirements, and Output for each Pre-Install Requirement based on input in an input.csv file.
        .PARAMETER inputPath
        String value that indicates the path of the input.csv file.
        .PARAMETER all
        Switch value that indicates all server roles should be checked for pre-install requirements.
        .PARAMETER sql
        Switch value that indicates the Primary SQL server role should be checked for pre-install requirements.
        .PARAMETER distributedSql
        Switch value that indicates the Distributed SQL server role should be checked for pre-install requirements.
        .PARAMETER serviceBus
        Switch value that indicates the Service Bus server role should be checked for pre-install requirements.
        .PARAMETER web
        Switch value that indicates the Web server role should be checked for pre-install requirements.
        .PARAMETER coreAgent
        Switch value that indicates the Core Agent server role should be checked for pre-install requirements.
        .PARAMETER dtSearchAgent
        Switch value that indicates the dtSearch Agent server role should be checked for pre-install requirements.
        .PARAMETER conversionAgent
        Switch value that indicates the Conversion Agent server role should be checked for pre-install requirements.
        .PARAMETER analytics
        Switch value that indicates the Analytics server role should be checked for pre-install requirements.
        .PARAMETER invariantSql
        Switch value that indicates the Invariant SQL server role should be checked for pre-install requirements.
        .PARAMETER queueManager
        Switch value that indicates the Queue Manager server role should be checked for pre-install requirements.
        .PARAMETER worker
        Switch value that indicates the Worker server role should be checked for pre-install requirements.
        .PARAMETER file
        Switch value that indicates the File server role should be checked for pre-install requirements.
        .PARAMETER smtp
        Switch value that indicates the SMTP server role should be checked for pre-install requirements.
        .PARAMETER input
        CSV file where each entry has a Server Role, Server Name, Roles and Features if the server role is web or agent, and Programs if the server role is worker.
        .OUTPUT
        output.csv file that contains the Server Roles, Server Names, Requirements, and Output for each Pre-Install Requirement
        .EXAMPLE
        Start-PreInstallCheck -inputPath c:\input.csv -all
        .EXAMPLE
        Start-PreInstallCheck -inputPath c:\input.csv -sql -distributedSql -serviceBus
    #>
function Invoke-PreInstallCheck {    
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$inputPath,
        
        [Parameter(ParameterSetName=’CheckAllServerRoles’)]
        [switch]$all,

        [Parameter(Mandatory=$true, ParameterSetName = 'CheckSpecificServerRoles')]
        [ValidateSet('sql','distributedSql','serviceBus','web','coreAgent','dtSearchAgent','conversionAgent','analytics','invariantSql','queueManager','worker','file','smtp')]
        [System.String]$serverRole
        
    )
    #region Process
    Process {
        
       #region Read computers input in from the input file.
       $csvInput = Import-Csv -Path $inputPath
       #endregion

        #region all roles {This selection will run all of the server roles.}
        if($all){        
            $sql = True
            $distributedSql = True
            $serviceBus = True
            $web = True       
            $coreAgent = True      
            $dtSearchAgent = True
            $conversionAgent = True
            $analytics = True
            $invariantSql = True
            $queueManager = True
            $worker = True
            $file = True
            $smtp = True                             
        }
        #endregion

        #region sql role
        if($sql){
            
            # Run Primary SQL Server Pre-Install Check
            $primarySqlServers = $csvInput | Where-Object{$_.ServerRole -eq "sql"} | Select-Object ServerName
            $primarySqlServers = $primarySqlServers.ServerName
            Write-Host "Running the Primary SQL Server Server Role scripts..."
            Start-SqlPreInstallCheck -computerName $primarySqlServers -serverRole "sql"
            Write-Host "The Primary SQL Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region distributed sql server role.
        if($distributedSql){

            # Run Distributed SQL Server Pre-Install Check
            $distributedSqlServers = $csvInput| Where-Object{$_.ServerRole -eq "distributedSql"} | Select-Object ServerName
            $distributedSqlServers = $distributedSqlServers.ServerName
            Write-Host "Running the Distributed SQL Server Role scripts..."
            Start-DistributedSqlPreInstallCheck -computerName $distributedSqlServers -serverRole "distributedSql"
            Write-Host "The Distributed SQL Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region service bus role
        if($serviceBus){

            # Run Service Bus Server Pre-Install Check
            $serviceBusServers = $csvInput | Where-Object{$_.ServerRole -eq "serviceBus"} | Select-Object ServerName
            $serviceBusServers = $serviceBusServers.ServerName
            Write-Host "Running the Service Bus Server Role scripts..."
            Start-ServiceBusPreInstallCheck -computerName $serviceBusServers -serverRole "serviceBus"
            Write-Host "The Service Bus Server Role Pre-Install Check is complete."

        }
        #endregion

        #region web role
        if($web){
            
            # Run Web Server Pre-Install Check
            $webServers = $csvInput | Where-Object{$_.ServerRole -eq "web"} | Select-Object ServerName
            $webServerRoles = $csvInput | Select-Object WebRolesAndFeatures | Where-Object{$_.WebRolesAndFeatures -ne ""}

            $webServerRoles = @"
web-server                                                                                                                                                                      
web-webserver                                                                                                                                                                   
web-common-http                                                                                                                                                                 
web-default-doc                                                                                                                                                                 
web-dir-browsing                                                                                                                                                                
web-http-errors                                                                                                                                                                 
web-static-content                                                                                                                                                              
web-http-redirect                                                                                                                                                               
web-health                                                                                                                                                                      
web-http-logging                                                                                                                                                                
web-request-monitor                                                                                                                                                             
web-http-tracing                                                                                                                                                                
web-performance                                                                                                                                                                 
web-stat-compression                                                                                                                                                            
web-security                                                                                                                                                                    
web-filtering                                                                                                                                                                   
web-basic-auth                                                                                                                                                                  
web-windows-auth                                                                                                                                                                
web-app-dev                                                                                                                                                                     
web-net-ext                                                                                                                                                                     
web-net-ext45                                                                                                                                                                   
web-isapi-ext                                                                                                                                                                   
web-isapi-filter                                                                                                                                                                
web-asp                                                                                                                                                                         
web-asp-net                                                                                                                                                                     
web-asp-net45                                                                                                                                                                   
web-websockets                                                                                                                                                                  
net-wcfservices45                                                                                                                                                               
net-wcf-http-activation45                                                                                                                                                       
net-wcf-pipe-activation45                                                                                                                                                       
net-wcf-tcp-activation45                                                                                                                                                        
net-wcf-tcp-portsharing45
"@

            


            $webServers = $webServers.ServerName
            $webServerRoles = $webServerRoles.WebRolesAndFeatures
            Write-Host "Running the Web Server Role scripts..."
            Start-WebPreInstallCheck -computerName $webServers -serverRole "web" -rolesAndFeatures $webServerRoles
            Write-Host "The Web Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region core agent role
        if($coreAgent){

            # Run Core Agent Server Pre-Install Check
            $coreAgentServers = $csvInput | Where-Object{$_.ServerRole -eq "coreAgent"} | Select-Object ServerName
            $coreAgentServerRoles = $csvInput | Select-Object AgentRolesAndFeatures | Where-Object{$_.AgentRolesAndFeatures -ne ""}
            $coreAgentServers = $coreAgentServers.ServerName
            $coreAgentServerRoles = $coreAgentServerRoles.AgentRolesAndFeatures
            Write-Host "Running the Core Agent Server Role scripts..."
            Start-CoreAgentPreInstallCheck -computerName $coreAgentServers -serverRole "coreAgent" -rolesAndFeatures $coreAgentServerRoles
            Write-Host "The Core Agent Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region dt search agent
        if($dtSearchAgent){
            $dtSearchAgentServers = $csvInput| Where-Object{$_.ServerRole -eq "dtSearchAgent"} | Select-Object ServerName
            $dtSearchAgentServerRoles = $csvInput | Select-Object AgentRolesAndFeatures | Where-Object{$_.AgentRolesAndFeatures -ne ""}
            $dtSearchAgentServers = $dtSearchAgentServers.ServerName
            $dtSearchServerRoles = $dtSearchServerRoles.AgentRolesAndFeatures            
            Write-Host "Running the dtSearch Agent Server Role scripts..."
            Start-dtSearchAgentPreInstallCheck -computerName $dtSearchAgentServers -serverRole "dtSearchAgent" -rolesAndFeatures $dtSearchAgentServerRoles
            Write-Host "The dtSearch Agent Server Role Pre-Install Check is complete."      
        }
        #endregion

        #region conversion agent role
        if($conversionAgent){

            # Run Conversion Agent Server Pre-Install Check
            $conversionAgentServers = $csvInput | Where-Object{$_.ServerRole -eq "conversionAgent"} | Select-Object ServerName
            $conversionAgentServerRoles = $csvInput | Select-Object AgentRolesAndFeatures | Where-Object{$_.AgentRolesAndFeatures -ne ""}
            $conversionAgentServers = $conversionAgentServers.ServerName
            $conversionServerRoles = $conversionServerRoles.AgentRolesAndFeatures  
            Write-Host "Running the Conversion Agent Server Role scripts..."
            Start-ConversionAgentPreInstallCheck -computerName $conversionAgentServers -serverRole "conversionAgent" -rolesAndFeatures $conversionAgentServerRoles
            Write-Host "The Conversion Agent Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region analytics role
        if($analytics){

            # Run Analytics Server Pre-Install Check
            $analyticsServers = $csvInput | Where-Object{$_.ServerRole -eq "analytics"} | Select-Object ServerName
            $analyticsServers = $analyticsServers.ServerName
            Write-Host "Running the Analytics Server Role scripts..."
            Start-AnalyticsPreInstallCheck -computerName $analyticsServers -serverRole "analytics"
            Write-Host "The Analytics Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region invariant sql role
        if($invariantSql){

            # Run Invariant SQL Server Pre-Install Check
            $invariantSqlServers = $csvInput | Where-Object{$_.ServerRole -eq "invariantSql"} | Select-Object ServerName
            $invariantSqlServers = $invariantSqlServers.ServerName
            Write-Host "Running the Invariant SQL Server Role scripts..."
            Start-InvariantSqlPreInstallCheck -computerName $invariantSqlServers -serverRole "invariantSql"
            Write-Host "The Invariant SQL Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region queue manager role
        if($queueManager){

            # Run Queue Manager Server Pre-Install Check
            $queueManagerServers = $csvInput | Where-Object{$_.ServerRole -eq "queueManager"} | Select-Object ServerName
            $queueManagerServers = $queueManagerServers.ServerName
            Write-Host "Running the Queue Manager Server Role scripts..."
            Start-QueueManagerPreInstallCheck -computerName $queueManagerServers -serverRole "queueManager"
            Write-Host "The Queue Manager Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region worker role
        if($worker){
            
            # Run Worker Server Pre-Install Check
            $workerServers = $csvInput | Where-Object{$_.ServerRole -eq "worker"} | Select-Object ServerName
            $programs = $csvInput | Select-Object Programs | Where-Object{$_.Programs -ne ""}
            $workerServers = $workerServers.ServerName
            $programs = $programs.Programs
            Write-Host "Running the Worker Server Role scripts..."
            Start-WorkerPreInstallCheck -computerName $workerServers -serverRole "worker" -programs $programs
            Write-Host "The Worker Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region file role
        if($file){

            # Run File Server Pre-Install Check
            $fileServers = $csvInput | Where-Object{$_.ServerRole -eq "file"} | Select-Object ServerName     
            $fileServers = $fileServers.ServerName
            Write-Host "Running the File Server Role scripts..."
            Start-FilePreInstallCheck -computerName $fileServers -serverRole "file"
            Write-Host "The File Server Role Pre-Install Check is complete."
        
        }
        #endregion

        #region smtp role
        if($smtp){

            # Run SMTP Server Pre-Install Check
            $smtpServers = $csvInput | Where-Object{$_.ServerRole -eq "smtp"} | Select-Object ServerName
            $smtpServers = $smtpServers.ServerName
            Write-Host "Running the SMTP Server Role scripts..."
            Start-SMTPPreInstallCheck -computerName $smtpServers -serverRole "smtp"
            Write-Host "The SMTP Server Role Pre-Install Check is complete."
        
        }
        #endregion
    }
    #endregion
}

function Start-SqlPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the Primary SQL server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the Primary SQL server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .EXAMPLE
        Start-SqlPreInstallCheck -computerName computer -serverRole serverRole
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole
    )
    # Call all scripts for Primary SQL Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-OsVersion -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #DONEGet-SharePermissions -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole
    #Get-dotNETVersion -computerName $computerName -serverRole $serverRole
    #Get-DtcConfig -computerName $computerName -serverRole $serverRole   
    #Get-UACSetting -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-ServiceAccountRunningSqlService -computerName $computerName -serverRole $serverRole
    #Get-EddsdboAccountName -computerName $computerName -serverRole $serverRole
    #Get-EddsdboAccountPermissions -computerName $computerName -serverRole $serverRole
    #Get-SaAccount -computerName $computerName -serverRole $serverRole
    #Get-RsaAccountName -computerName $computerName -serverRole $serverRole
    #Get-RsaAccountPermissions -computerName $computerName -serverRole $serverRole
    #Get-SqlFullTextFilterDaemonLauncherServiceInstallStatus -computerName $computerName -serverRole $serverRole
    #Get-SqlVersion -computerName $computerName -serverRole $serverRole
    #Get-SqlMixedModeAuthStatus -computerName $computerName -serverRole $serverRole
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole
    #Get-FileAllocationUnitSize -computerName $computerName -serverRole $serverRole
    #Get-OptimizeForAdHocWorkloads -computerName $computerName -serverRole $serverRole
    #Get-MaxDegreeOfParallelism -computerName $computerName -serverRole $serverRole
    #Get-CostThresholdOfParallelism -computerName $computerName -serverRole $serverRole
    #Get-SqlMaxServerMemory -computerName $computerName -serverRole $serverRole
    #Get-TempDbDatabasesInfo -computerName $computerName -serverRole $serverRole
    #Get-InstantFileInitializationStatus -computerName $computerName -serverRole $serverRole

} # End Start-SqlPreInstallCheck function

function Start-DistributedSqlPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the Distributed SQL server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the Distributed SQL server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .EXAMPLE
        Start-DistributedSqlPreInstallCheck -computerName computer -serverRole serverRole
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole
    )
    # Call all scripts for Distributed SQL Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-OsVersion -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #DONEGet-SharePermissions -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole
    #Get-dotNETVersion -computerName $computerName -serverRole $serverRole
    #Get-DtcConfig -computerName $computerName -serverRole $serverRole   
    #Get-UACSetting -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-ListOfLinkedSQLServers -computerName $computerName -serverRole $serverRole
    #Get-RemoteQueryTimeout -computerName $computerName -serverRole $serverRole
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-ServiceAccountRunningSqlService -computerName $computerName -serverRole $serverRole
    #Get-EddsdboAccountName -computerName $computerName -serverRole $serverRole
    #Get-EddsdboAccountPermissions -computerName $computerName -serverRole $serverRole
    #Get-SaAccount -computerName $computerName -serverRole $serverRole
    #Get-RsaAccountName -computerName $computerName -serverRole $serverRole
    #Get-RsaAccountPermissions -computerName $computerName -serverRole $serverRole
    #Get-SqlFullTextFilterDaemonLauncherServiceInstallStatus -computerName $computerName -serverRole $serverRole
    #Get-SqlVersion -computerName $computerName -serverRole $serverRole
    #Get-SqlMixedModeAuthStatus -computerName $computerName -serverRole $serverRole
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole
    #Get-FileAllocationUnitSize -computerName $computerName -serverRole $serverRole
    #Get-OptimizeForAdHocWorkloads -computerName $computerName -serverRole $serverRole
    #Get-MaxDegreeOfParallelism -computerName $computerName -serverRole $serverRole
    #Get-CostThresholdOfParallelism -computerName $computerName -serverRole $serverRole
    #Get-SqlMaxServerMemory -computerName $computerName -serverRole $serverRole
    #Get-TempDbDatabasesInfo -computerName $computerName -serverRole $serverRole
    #Get-InstantFileInitializationStatus -computerName $computerName -serverRole $serverRole

} # End Start-DistributedSqlPreInstallCheck function

function Start-ServiceBusPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the Service Bus server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the Service Bus server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .EXAMPLE
        Start-ServiceBusPreInstallCheck -computerName computer -serverRole serverRole
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole
    )
    # Call all scripts for Service Bus Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-OsVersion -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole
    #Get-dotNETVersion -computerName $computerName -serverRole $serverRole
    #Get-DtcConfig -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #Get-UACSetting -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole
    #DONEGet-ServiceBusConfig -computerName $computerName -serverRole $serverRole
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #DONEGet-TempDriveLocation -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole
    
} # End Start-ServiceBusPreInstallCheck function

function Start-WebPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the Web server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the Web server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .PARAMETER rolesAndFeatures
        One or more required role and features that should be installed. Accepts pipeline input.
        .EXAMPLE
        Start-WebPreInstallCheck -computerName computer -serverRole serverRole -rolesAndFeatures role
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$rolesAndFeatures
    )
    # Call all scripts for Web Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-OsVersion -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole
    #Get-dotNETVersion -computerName $computerName -serverRole $serverRole
    #Get-LegacyUnhandledExceptionPolicyStatus -computerName $computerName -serverRole $serverRole    
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #Get-UACSetting -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole
    #DONEGet-IISRolesAndFeatures -computerName $computerName -serverRole $serverRole -rolesAndFeatures $rolesAndFeatures
    #DONEGet-IISLogFileOptions -computerName $computerName -serverRole $serverRole
    #DONEGet-IISFailedRequestTracingRulesValue -computerName $computerName -serverRole $serverRole
    #DONEGet-IISExpirationHeaderInfo -computerName $computerName -serverRole $serverRole
    #DONEGet-IISWebBindingInfo -computerName $computerName -serverRole $serverRole
    #DONEGet-IISVersion -computerName $computerName -serverRole $serverRole
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole

} # End Start-WebPreInstallCheck function

function Start-CoreAgentPreInstallCheck { 
    

} # End Start-CoreAgentPreInstallCheck  function

function Start-dtSearchAgentPreInstallCheck { 
    
} # End Start-dtSearchAgentPreInstallCheck function

function Start-ConversionAgentPreInstallCheck { 
    
} # End Start-ConversionAgentPreInstallCheck function

function Start-AnalyticsPreInstallCheck { 
    
} # End Start-AnalyticsPreInstallCheck function

function Start-InvariantSqlPreInstallCheck { 
    
} # End Start-InvariantSqlPreInstallCheck function

function Start-QueueManagerPreInstallCheck { 
    
} # End Start-QueueManagerPreInstallCheck function

function Start-WorkerPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the Worker server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the Worker server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .PARAMETER programs
        One or more required programs that should be installed. Accepts pipeline input.
        .EXAMPLE
        Start-WorkerPreInstallCheck -computerName computer -serverRole serverRole -programs program
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$programs
    )
    # Call all scripts for Worker Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-OsVersion -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole
    #Get-dotNETVersion -computerName $computerName -serverRole $serverRole
    #Get-DesktopExperienceInstallStatus -computerName $computerName -serverRole $serverRole
    #Get-InternetExplorerEnhancedSecurityConfigurationStatus -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole
    #Get-DtcConfig -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #Get-UACSetting -computerName $computerName -serverRole $serverRole
    #DONEGet-WorkerInstalledPrograms -computerName $computerName -serverRole $serverRole -programs $programs    
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #DONEGet-TempDriveLocation -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole
        
} # End Start-WorkerPreInstallCheck function

function Start-FilePreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the File server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the File server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .PARAMETER programs
        One or more required programs that should be installed. Accepts pipeline input.
        .EXAMPLE
        Start-FilePreInstallCheck -computerName computer -serverRole serverRole
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole
    )
    # Call all scripts for File Pre-Install Check
    #Get-ServerHostName -computerName $computerName -serverRole $serverRole
    #Get-RAMAmount -computerName $computerName -serverRole $serverRole
    #Get-NumCPU -computerName $computerName -serverRole $serverRole   
    #DONEGet-VolumeFileNames -computerName $computerName -serverRole $serverRole
    #DONEGet-VolumeStorage -computerName $computerName -serverRole $serverRole
    #Get-FirewallSettings -computerName $computerName -serverRole $serverRole
    #Get-RelativityServiceAccount -computerName $computerName -serverRole $serverRole   
    #Get-InboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-InboundTcpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundUdpPorts -computerName $computerName -serverRole $serverRole
    #Get-OutboundTcpPorts -computerName $computerName -serverRole $serverRole  
    #Get-WindowsUpdateSetting -computerName $computerName -serverRole $serverRole
    #Get-WindowsPowerPlan -computerName $computerName -serverRole $serverRole
    #Get-WindowsVisualEffects -computerName $computerName -serverRole $serverRole
    #Get-WindowsProcessorScheduling -computerName $computerName -serverRole $serverRole
    #Get-WindowsServerVirtualMemory -computerName $computerName -serverRole $serverRole
    #Get-AntivirusExclusions -computerName $computerName -serverRole $serverRole
    #Get-TLSSettings -computerName $computerName -serverRole $serverRole

} # End Start-FilePreInstallCheck function
    
function Start-SMTPPreInstallCheck { 
    <#
        .SYNOPSIS
        This commandlet runs all scripts for the SMTP server role Pre-Install Check.
        .DESCRIPTION
        This commandlet runs all scripts for the SMTP server role Pre-Install Check.
        .PARAMETER computerName
        List of computer names to check. Accepts pipeline input.
        .PARAMETER serverRole
        Server Role Type of the computers passed into the function.
        .PARAMETER programs
        One or more required programs that should be installed. Accepts pipeline input.
        .EXAMPLE
        Start-SMTPPreInstallCheck -computerName computer -serverRole serverRole
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computerName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string]$serverRole
    )
    # Call all scripts for SMTP Pre-Install Check
    # Get-FullyQualifiedDomainNameSmtpServer

} # End Start-SMTPPreInstallCheck function

function Create-Output { 
    <#
        .SYNOPSIS
        This commandlet creates an output.csv file.
        .DESCRIPTION
        This commandlet creates an output.csv file that contains the Server Roles, Server Names, Requirements, and Output for each Pre-Install Requirement.
        .PARAMETER serverRole
        .PARAMETER serverName
        .PARAMETER requirement
        .PARAMETER output
        .EXAMPLE
        Create-Output -serverRole role -serverName name -requirement requirement -output output
    #>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory=$True)]
        [string]$serverRole,

        [Parameter(Mandatory=$True)]
        [string]$serverName,

        [Parameter(Mandatory=$True)]
        [string]$requirement,

        [Parameter(Mandatory=$True)]
        [string]$output
    )
    
    # Create custom object with all output attributes
    $fileData = @(
        [pscustomobject]@{
            ServerRole = $serverRole
            ServerName  = $serverName
            Requirement  = $requirement
            Output = $output
        }
     ) # End fileData object creation block
  
  # Write output data to CSV file
  $fileData | Export-Csv -Append -Path C:\output.csv

} # End Create-Output function

#Start-PreInstallCheck -inputPath C:\input.csv -worker


