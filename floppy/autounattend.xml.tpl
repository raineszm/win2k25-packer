<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">

  <!-- ============================================================
       windowsPE pass: drivers, disk layout, image selection
       ============================================================ -->
  <settings pass="windowsPE">

    <component name="Microsoft-Windows-International-Core-WinPE"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <SetupUILanguage>
        <UILanguage>en-US</UILanguage>
      </SetupUILanguage>
      <InputLocale>en-US</InputLocale>
      <SystemLocale>en-US</SystemLocale>
      <UILanguage>en-US</UILanguage>
      <UILanguageFallback>en-US</UILanguageFallback>
      <UserLocale>en-US</UserLocale>
    </component>

    <component name="Microsoft-Windows-PnpCustomizationsWinPE"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <DriverPaths>
        <PathAndCredentials wcm:action="add" wcm:keyValue="1">
          <Path>E:\drivers</Path>
        </PathAndCredentials>
      </DriverPaths>
    </component>

    <component name="Microsoft-Windows-Setup"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">

      <DiskConfiguration>
        <Disk wcm:action="add">
          <DiskID>0</DiskID>
          <WillWipeDisk>true</WillWipeDisk>
          <CreatePartitions>
            <!-- Partition 1: Windows RE (300 MB) -->
            <CreatePartition wcm:action="add">
              <Order>1</Order>
              <Size>300</Size>
              <Type>Primary</Type>
            </CreatePartition>
            <!-- Partition 2: EFI System (100 MB) -->
            <CreatePartition wcm:action="add">
              <Order>2</Order>
              <Size>100</Size>
              <Type>EFI</Type>
            </CreatePartition>
            <!-- Partition 3: Microsoft Reserved (128 MB) -->
            <CreatePartition wcm:action="add">
              <Order>3</Order>
              <Size>128</Size>
              <Type>MSR</Type>
            </CreatePartition>
            <!-- Partition 4: OS (remaining space) -->
            <CreatePartition wcm:action="add">
              <Order>4</Order>
              <Extend>true</Extend>
              <Type>Primary</Type>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <ModifyPartition wcm:action="add">
              <Order>1</Order>
              <PartitionID>1</PartitionID>
              <Label>WINRE</Label>
              <Format>NTFS</Format>
              <TypeID>DE94BBA4-06D1-4D40-A16A-BFD50179D6AC</TypeID>
            </ModifyPartition>
            <ModifyPartition wcm:action="add">
              <Order>2</Order>
              <PartitionID>2</PartitionID>
              <Label>System</Label>
              <Format>FAT32</Format>
            </ModifyPartition>
            <ModifyPartition wcm:action="add">
              <Order>3</Order>
              <PartitionID>3</PartitionID>
            </ModifyPartition>
            <ModifyPartition wcm:action="add">
              <Order>4</Order>
              <PartitionID>4</PartitionID>
              <Label>Windows</Label>
              <Format>NTFS</Format>
              <Letter>C</Letter>
            </ModifyPartition>
          </ModifyPartitions>
        </Disk>
      </DiskConfiguration>

      <ImageInstall>
        <OSImage>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>4</PartitionID>
          </InstallTo>
          <InstallFrom>
            <MetaData wcm:action="add">
              <Key>/IMAGE/NAME</Key>
              <Value>${windows_image_name}</Value>
            </MetaData>
          </InstallFrom>
          <WillShowUI>OnError</WillShowUI>
        </OSImage>
      </ImageInstall>

      <UserData>
        <AcceptEula>true</AcceptEula>
        <FullName>Administrator</FullName>
        <Organization>Canonical</Organization>
        <ProductKey>
          <WillShowUI>OnError</WillShowUI>
        </ProductKey>
      </UserData>

      <EnableFirewall>false</EnableFirewall>

    </component>
  </settings>

  <!-- ============================================================
       offlineServicing pass
       ============================================================ -->
  <settings pass="offlineServicing">

    <component name="Microsoft-Windows-PnpCustomizationsNonWinPE"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <DriverPaths>
        <PathAndCredentials wcm:action="add" wcm:keyValue="1">
          <Path>E:\drivers</Path>
        </PathAndCredentials>
      </DriverPaths>
    </component>

    <component name="Microsoft-Windows-LUA-Settings"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <EnableLUA>false</EnableLUA>
    </component>
  </settings>

  <!-- ============================================================
       specialize pass
       ============================================================ -->
  <settings pass="specialize">

    <component name="Microsoft-Windows-Shell-Setup"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <TimeZone>UTC</TimeZone>
      <!-- No ComputerName: Cloudbase-Init sets hostname from metadata -->
    </component>

    <component name="Microsoft-Windows-ServerManager-SvrMgrNc"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon>
    </component>

    <component name="Microsoft-Windows-Security-SPP-UX"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <SkipAutoActivation>true</SkipAutoActivation>
    </component>

    <component name="Microsoft-Windows-OutOfBoxExperience"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon>
    </component>

    <component name="Networking-MPSSVC-Svc"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <FirewallGroups>
        <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
          <Active>false</Active>
          <Group>@FirewallAPI.dll,-28752</Group>
          <Profile>all</Profile>
        </FirewallGroup>
      </FirewallGroups>
    </component>

  </settings>

  <!-- ============================================================
       oobeSystem pass
       ============================================================ -->
  <settings pass="oobeSystem">

    <component name="Microsoft-Windows-Shell-Setup"
               processorArchitecture="amd64"
               publicKeyToken="31bf3856ad364e35"
               language="neutral"
               versionScope="nonSxS"
               xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">

      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideLocalAccountScreen>true</HideLocalAccountScreen>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Work</NetworkLocation>
        <ProtectYourPC>3</ProtectYourPC>
        <VMModeOptimizations>
            <SkipWinREInitialization>true</SkipWinREInitialization>
        </VMModeOptimizations>
      </OOBE>

      <UserAccounts>
        <AdministratorPassword>
          <Value>${admin_password}</Value>
          <PlainText>true</PlainText>
        </AdministratorPassword>
      </UserAccounts>

      <AutoLogon>
        <Username>Administrator</Username>
        <Password>
          <Value>${admin_password}</Value>
          <PlainText>true</PlainText>
        </Password>
        <Enabled>true</Enabled>
        <LogonCount>1</LogonCount>
      </AutoLogon>

      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy RemoteSigned -Force"</CommandLine>
          <Description>Set PowerShell execution policy</Description>
          <RequiresUserInput>false</RequiresUserInput>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>2</Order>
          <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -File A:\enable-winrm.ps1</CommandLine>
          <Description>Enable WinRM for Packer</Description>
          <RequiresUserInput>false</RequiresUserInput>
        </SynchronousCommand>

      </FirstLogonCommands>

    </component>

  </settings>

</unattend>
