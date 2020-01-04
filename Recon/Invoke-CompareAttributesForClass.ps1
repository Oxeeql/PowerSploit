﻿function Get-AllAttributesForClass
{<#
.Synopsis
   Gets all AD Schema attributes for class
.DESCRIPTION
   This function will get all attributes for a class from AD.
.EXAMPLE
   PS C:\> Get-AllAttributesForAClass -class user
.EXAMPLE
   PS C:\> Get-AllAttributesForAClass -class computer
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]
        $Class
    )

    Process {
        #Custom object
        $ListOfAttributesFromAD = @()

        #lets get all classes and store in a variable.
        $NextClass = $Class
        $AllClasses = Do
        {
            $CurrentClass = $NextClass
            $NextClass = Get-ADObjectPowerView -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $NextClass} -properties subClassOf |Select-Object -ExpandProperty subClassOf
            $CurrentClass
        }
        While($CurrentClass -ne $NextClass)
        #Now that we have our classes in $allClasses lets turn to the attributes
        $attributAttributes = 'MayContain','MustContain','systemMayContain','systemMustContain'
        Write-verbose "Attempting to find all attributes for the AD Object: $($ADObj.Name)"
        $AllAttributes = ForEach ($Class in $AllClasses)
        {
            $ClassInfo = Get-ADObjectPowerView -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $Class} -properties $attributAttributes 
            ForEach ($attribute in $attributAttributes)
            {
                $ListOfAttributesFromAD += $ClassInfo.$attribute
                $ClassInfo.$attribute
            }
        }
    $ListOfAttributesAD = $ListOfAttributesFromAD | Sort-Object -Unique
    write-output $ListOfAttributesAD
    }
    End
    {
    }
}


function Invoke-CompareAttributesForClass
{
<#
.Synopsis
    Author: @oddvarmoe
    Required Dependencies: Search-ADAccounts, Set-ADComputer, Get-ADForest, Get-ADDomain,
    Optional Dependencies: None
    Compares list of attributes with active attributes in Active Directory. Currently only works with user and computer class.

.DESCRIPTION
    Compares list of attributes with active attributes in Active Directory.
    This function is used to spot unusal attributes.
    
    Example where an attribute is found in AD and not in compare list:
    InputObject                   SideIndicator                                              
    -----------                   -------------                                              
    TopSecretAttribute            =>                                                         


.EXAMPLE
    PS C:\> Invoke-CompareAttributesForClass -Class user

.EXAMPLE
    PS C:\> Invoke-CompareAttributesForClass -Class computer
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("User","Computer")]
        [String]
        $Class
    )

    Process {
        #https://msdn.microsoft.com/en-us/library/ms683980(v=vs.85).aspx
        #List of attributes generated from demo AD with Exchange schema changes on Server 2016 DC
        #TODO: Attributes based on AD Domain level or Schema version.
        if($Class -eq "user"){
                $UserAttributeListFromAD = Get-AllAttributesForClass -Class user

        $UserAttributelist = @(
        "accountExpires",
        "aCSPolicyName",
        "adminCount",
        "adminDescription",
        "adminDisplayName",
        "allowedAttributes",
        "allowedAttributesEffective",
        "allowedChildClasses",
        "allowedChildClassesEffective",
        "assistant",
        "attributeCertificateAttribute",
        "audio",
        "badPasswordTime",
        "badPwdCount",
        "bridgeheadServerListBL",
        "businessCategory",
        "businessRoles",
        "c",
        "canonicalName",
        "carLicense",
        "cn",
        "co",
        "codePage",
        "comment",
        "company",
        "controlAccessRights",
        "countryCode",
        "createTimeStamp",
        "dBCSPwd",
        "defaultClassStore",
        "department",
        "departmentNumber",
        "description",
        "desktopProfile",
        "destinationIndicator",
        "directReports",
        "displayName",
        "displayNamePrintable",
        "distinguishedName",
        "division",
        "dSASignature",
        "dSCorePropagationData",
        "dynamicLDAPServer",
        "employeeID",
        "employeeNumber",
        "employeeType",
        "extensionName",
        "facsimileTelephoneNumber",
        "flags",
        "fromEntry",
        "frsComputerReferenceBL",
        "fRSMemberReferenceBL",
        "fSMORoleOwner",
        "generationQualifier",
        "givenName",
        "groupMembershipSAM",
        "groupPriority",
        "groupsToIgnore",
        "homeDirectory",
        "homeDrive",
        "homePhone",
        "homePostalAddress",
        "houseIdentifier",
        "initials",
        "instanceType",
        "internationalISDNNumber",
        "ipPhone",
        "isCriticalSystemObject",
        "isDeleted",
        "isPrivilegeHolder",
        "isRecycled",
        "jpegPhoto",
        "kMServer",
        "l",
        "labeledURI",
        "lastKnownParent",
        "lastLogoff",
        "lastLogon",
        "lastLogonTimestamp",
        "lmPwdHistory",
        "localeID",
        "lockoutTime",
        "logonCount",
        "logonHours",
        "logonWorkstation",
        "mail",
        "managedObjects",
        "manager",
        "masteredBy",
        "maxStorage",
        "memberOf",
        "mhsORAddress",
        "middleName",
        "mobile",
        "modifyTimeStamp",
        "msCOM-PartitionSetLink",
        "msCOM-UserLink",
        "msCOM-UserPartitionSetLink",
        "msDFSR-ComputerReferenceBL",
        "msDFSR-MemberReferenceBL",
        "msDRM-IdentityCertificate",
        "msDS-AllowedToActOnBehalfOfOtherIdentity",
        "msDS-AllowedToDelegateTo",
        "msDS-Approx-Immed-Subordinates",
        "msDS-AssignedAuthNPolicy",
        "msDS-AssignedAuthNPolicySilo",
        "msDS-AuthenticatedAtDC",
        "msDS-AuthenticatedToAccountlist",
        "msDS-AuthNPolicySiloMembersBL",
        "msDS-Cached-Membership",
        "msDS-Cached-Membership-Time-Stamp",
        "msDS-ClaimSharesPossibleValuesWithBL",
        "msDS-CloudAnchor",
        "mS-DS-ConsistencyChildCount",
        "mS-DS-ConsistencyGuid",
        "mS-DS-CreatorSID",
        "msDS-EnabledFeatureBL",
        "msDS-FailedInteractiveLogonCount",
        "msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon",
        "msDS-HABSeniorityIndex",
        "msDS-HostServiceAccountBL",
        "msDS-IsDomainFor",
        "msDS-IsFullReplicaFor",
        "msDS-IsPartialReplicaFor",
        "msDS-IsPrimaryComputerFor",
        "msDS-KeyCredentialLink",
        "msDS-KeyPrincipalBL",
        "msDS-KrbTgtLinkBl",
        "msDS-LastFailedInteractiveLogonTime",
        "msDS-LastKnownRDN",
        "msDS-LastSuccessfulInteractiveLogonTime",
        "msDS-LocalEffectiveDeletionTime",
        "msDS-LocalEffectiveRecycleTime",
        "msDs-masteredBy",
        "msds-memberOfTransitive",
        "msDS-MembersForAzRoleBL",
        "msDS-MembersOfResourcePropertyListBL",
        "msds-memberTransitive",
        "msDS-NCReplCursors",
        "msDS-NCReplInboundNeighbors",
        "msDS-NCReplOutboundNeighbors",
        "msDS-NC-RO-Replica-Locations-BL",
        "msDS-NcType",
        "msDS-NonMembersBL",
        "msDS-ObjectReferenceBL",
        "msDS-ObjectSoa",
        "msDS-OIDToGroupLinkBl",
        "msDS-OperationsForAzRoleBL",
        "msDS-OperationsForAzTaskBL",
        "msDS-parentdistname",
        "msDS-PhoneticCompanyName",
        "msDS-PhoneticDepartment",
        "msDS-PhoneticDisplayName",
        "msDS-PhoneticFirstName",
        "msDS-PhoneticLastName",
        "msDS-PrimaryComputer",
        "msDS-PrincipalName",
        "msDS-PSOApplied",
        "msDS-ReplAttributeMetaData",
        "msDS-ReplValueMetaData",
        "msDS-ReplValueMetaDataExt",
        "msDS-ResultantPSO",
        "msDS-RevealedDSAs",
        "msDS-RevealedListBL",
        "msDS-SecondaryKrbTgtNumber",
        "msDS-Site-Affinity",
        "msDS-SourceAnchor",
        "msDS-SourceObjectDN",
        "msDS-SupportedEncryptionTypes",
        "msDS-SyncServerUrl",
        "msDS-TasksForAzRoleBL",
        "msDS-TasksForAzTaskBL",
        "msDS-TDOEgressBL",
        "msDS-TDOIngressBL",
        "msDS-User-Account-Control-Computed",
        "msDS-UserPasswordExpiryTimeComputed",
        "msDS-ValueTypeReferenceBL",
        "msExchAcceptedDomainBL",
        "msExchAccountForestBL",
        "msExchArchiveDatabaseBL",
        "msExchAssociatedAcceptedDomainBL",
        "msExchAuthPolicyBL",
        "msExchAuxMailboxParentObjectIdBL",
        "msExchAvailabilityOrgWideAccountBL",
        "msExchAvailabilityPerUserAccountBL",
        "msExchCatchAllRecipientBL",
        "msExchConferenceMailboxBL",
        "msExchControllingZone",
        "msExchDataEncryptionPolicyBL",
        "msExchDelegateListBL",
        "msExchDeviceAccessControlRuleBL",
        "msExchEvictedMemebersBL",
        "msExchHABRootDepartmentBL",
        "msExchHouseIdentifier",
        "msExchHygieneConfigurationMalwareBL",
        "msExchHygieneConfigurationSpamBL",
        "msExchIMAPOWAURLPrefixOverride",
        "msExchIntendedMailboxPlanBL",
        "msExchMailboxMoveSourceArchiveMDBBL",
        "msExchMailboxMoveSourceMDBBL",
        "msExchMailboxMoveSourceUserBL",
        "msExchMailboxMoveStorageMDBBL",
        "msExchMailboxMoveTargetArchiveMDBBL",
        "msExchMailboxMoveTargetMDBBL",
        "msExchMailboxMoveTargetUserBL",
        "msExchMDBAvailabilityGroupConfigurationBL",
        "msExchMobileRemoteDocumentsAllowedServersBL",
        "msExchMobileRemoteDocumentsBlockedServersBL",
        "msExchMobileRemoteDocumentsInternalDomainSuffixListBL",
        "msExchMultiMailboxDatabasesBL",
        "msExchMultiMailboxLocationsBL",
        "msExchOABGeneratingMailboxBL",
        "msExchOrganizationsAddressBookRootsBL",
        "msExchOrganizationsGlobalAddressListsBL",
        "msExchOrganizationsTemplateRootsBL",
        "msExchOriginatingForest",
        "msExchOWAAllowedFileTypesBL",
        "msExchOWAAllowedMimeTypesBL",
        "msExchOWABlockedFileTypesBL",
        "msExchOWABlockedMIMETypesBL",
        "msExchOWAForceSaveFileTypesBL",
        "msExchOWAForceSaveMIMETypesBL",
        "msExchOWARemoteDocumentsAllowedServersBL",
        "msExchOWARemoteDocumentsBlockedServersBL",
        "msExchOWARemoteDocumentsInternalDomainSuffixListBL",
        "msExchOWATranscodingFileTypesBL",
        "msExchOWATranscodingMimeTypesBL",
        "msExchParentPlanBL",
        "msExchQueryBaseDN",
        "msExchRBACPolicyBL",
        "msExchResourceGUID",
        "msExchResourceProperties",
        "msExchRMSComputerAccountsBL",
        "msExchServerAssociationBL",
        "msExchServerSiteBL",
        "msExchSMTPReceiveDefaultAcceptedDomainBL",
        "msExchSupervisionDLBL",
        "msExchSupervisionOneOffBL",
        "msExchSupervisionUserBL",
        "msExchTransportRuleTargetBL",
        "msExchTrustedDomainBL",
        "msExchUGMemberBL",
        "msExchUserBL",
        "msExchUserCulture",
        "msIIS-FTPDir",
        "msIIS-FTPRoot",
        "mSMQDigests",
        "mSMQDigestsMig",
        "mSMQSignCertificates",
        "mSMQSignCertificatesMig",
        "msNPAllowDialin",
        "msNPCallingStationID",
        "msNPSavedCallingStationID",
        "msOrg-LeadersBL",
        "msPKIAccountCredentials",
        "msPKI-CredentialRoamingTokens",
        "msPKIDPAPIMasterKeys",
        "msPKIRoamingTimeStamp",
        "msRADIUSCallbackNumber",
        "msRADIUS-FramedInterfaceId",
        "msRADIUSFramedIPAddress",
        "msRADIUS-FramedIpv6Prefix",
        "msRADIUS-FramedIpv6Route",
        "msRADIUSFramedRoute",
        "msRADIUS-SavedFramedInterfaceId",
        "msRADIUS-SavedFramedIpv6Prefix",
        "msRADIUS-SavedFramedIpv6Route",
        "msRADIUSServiceType",
        "msRASSavedCallbackNumber",
        "msRASSavedFramedIPAddress",
        "msRASSavedFramedRoute",
        "msRTCSIP-AcpInfo",
        "msRTCSIP-ApplicationOptions",
        "msRTCSIP-ArchivingEnabled",
        "msRTCSIP-DeploymentLocator",
        "msRTCSIP-FederationEnabled",
        "msRTCSIP-GroupingID",
        "msRTCSIP-InternetAccessEnabled",
        "msRTCSIP-Line",
        "msRTCSIP-LineServer",
        "msRTCSIP-OptionFlags",
        "msRTCSIP-OriginatorSid",
        "msRTCSIP-OwnerUrn",
        "msRTCSIP-PrimaryHomeServer",
        "msRTCSIP-PrimaryUserAddress",
        "msRTCSIP-PrivateLine",
        "msRTCSIP-TargetHomeServer",
        "msRTCSIP-TargetUserPolicies",
        "msRTCSIP-TenantId",
        "msRTCSIP-UserEnabled",
        "msRTCSIP-UserExtension",
        "msRTCSIP-UserLocationProfile",
        "msRTCSIP-UserPolicies",
        "msRTCSIP-UserPolicy",
        "msRTCSIP-UserRoutingGroupId",
        "msSFU30Name",
        "msSFU30NisDomain",
        "msSFU30PosixMemberOf",
        "msTSAllowLogon",
        "msTSBrokenConnectionAction",
        "msTSConnectClientDrives",
        "msTSConnectPrinterDrives",
        "msTSDefaultToMainPrinter",
        "msTSExpireDate",
        "msTSExpireDate2",
        "msTSExpireDate3",
        "msTSExpireDate4",
        "msTSHomeDirectory",
        "msTSHomeDrive",
        "msTSInitialProgram",
        "msTSLicenseVersion",
        "msTSLicenseVersion2",
        "msTSLicenseVersion3",
        "msTSLicenseVersion4",
        "msTSLSProperty01",
        "msTSLSProperty02",
        "msTSManagingLS",
        "msTSManagingLS2",
        "msTSManagingLS3",
        "msTSManagingLS4",
        "msTSMaxConnectionTime",
        "msTSMaxDisconnectionTime",
        "msTSMaxIdleTime",
        "msTSPrimaryDesktop",
        "msTSProfilePath",
        "msTSProperty01",
        "msTSProperty02",
        "msTSReconnectionAction",
        "msTSRemoteControl",
        "msTSSecondaryDesktops",
        "msTSWorkDirectory",
        "name",
        "netbootSCPBL",
        "networkAddress",
        "nonSecurityMemberBL",
        "ntPwdHistory",
        "nTSecurityDescriptor",
        "o",
        "objectCategory",
        "objectClass",
        "objectGUID",
        "objectVersion",
        "operatorCount",
        "otherFacsimileTelephoneNumber",
        "otherHomePhone",
        "otherIpPhone",
        "otherLoginWorkstations",
        "otherMailbox",
        "otherMobile",
        "otherPager",
        "otherTelephone",
        "otherWellKnownObjects",
        "ou",
        "ownerBL",
        "pager",
        "partialAttributeDeletionList",
        "partialAttributeSet",
        "personalPager",
        "personalTitle",
        "photo",
        "physicalDeliveryOfficeName",
        "possibleInferiors",
        "postalAddress",
        "postalCode",
        "postOfficeBox",
        "preferredDeliveryMethod",
        "preferredLanguage",
        "preferredOU",
        "primaryGroupID",
        "primaryInternationalISDNNumber",
        "primaryTelexNumber",
        "profilePath",
        "proxiedObjectName",
        "proxyAddresses",
        "pwdLastSet",
        "queryPolicyBL",
        "registeredAddress",
        "replPropertyMetaData",
        "replUpToDateVector",
        "repsFrom",
        "repsTo",
        "revision",
        "roomNumber",
        "scriptPath",
        "sDRightsEffective",
        "secretary",
        "seeAlso",
        "serialNumber",
        "serverReferenceBL",
        "servicePrincipalName",
        "showInAdvancedViewOnly",
        "siteObjectBL",
        "sn",
        "st",
        "street",
        "streetAddress",
        "structuralObjectClass",
        "subRefs",
        "subSchemaSubEntry",
        "systemFlags",
        "telephoneAssistant",
        "telephoneNumber",
        "teletexTerminalIdentifier",
        "telexNumber",
        "terminalServer",
        "thumbnailLogo",
        "thumbnailPhoto",
        "title",
        "uid",
        "unicodePwd",
        "url",
        "userAccountControl",
        "userCertificate",
        "userParameters",
        "userPassword",
        "userPKCS12",
        "userPrincipalName",
        "userSharedFolder",
        "userSharedFolderOther",
        "userSMIMECertificate",
        "userWorkstations",
        "uSNChanged",
        "uSNCreated",
        "uSNDSALastObjRemoved",
        "USNIntersite",
        "uSNLastObjRem",
        "uSNSource",
        "wbemPath",
        "wellKnownObjects",
        "whenChanged",
        "whenCreated",
        "wWWHomePage",
        "x121Address",
        "x500uniqueIdentifier"
        )
    $Compare = Compare-Object -ReferenceObject $UserAttributelist -DifferenceObject $UserAttributeListFromAD
    Write-Output $Compare
        }
        
        if($Class -eq "computer"){
                $ComputerAttributeListFromAD = Get-AllAttributesForClass -Class computer
        
        $ComputerAttributeList = @(
        "accountExpires",
        "aCSPolicyName",
        "adminCount",
        "adminDescription",
        "adminDisplayName",
        "allowedAttributes",
        "allowedAttributesEffective",
        "allowedChildClasses",
        "allowedChildClassesEffective",
        "assistant",
        "attributeCertificateAttribute",
        "audio",
        "badPasswordTime",
        "badPwdCount",
        "bridgeheadServerListBL",
        "businessCategory",
        "businessRoles",
        "c",
        "canonicalName",
        "carLicense",
        "catalogs",
        "cn",
        "co",
        "codePage",
        "comment",
        "company",
        "controlAccessRights",
        "countryCode",
        "createTimeStamp",
        "dBCSPwd",
        "defaultClassStore",
        "defaultLocalPolicyObject",
        "department",
        "departmentNumber",
        "description",
        "desktopProfile",
        "destinationIndicator",
        "directReports",
        "displayName",
        "displayNamePrintable",
        "distinguishedName",
        "division",
        "dNSHostName",
        "dSASignature",
        "dSCorePropagationData",
        "dynamicLDAPServer",
        "employeeID",
        "employeeNumber",
        "employeeType",
        "extensionName",
        "facsimileTelephoneNumber",
        "flags",
        "fromEntry",
        "frsComputerReferenceBL",
        "fRSMemberReferenceBL",
        "fSMORoleOwner",
        "generationQualifier",
        "givenName",
        "groupMembershipSAM",
        "groupPriority",
        "groupsToIgnore",
        "homeDirectory",
        "homeDrive",
        "homePhone",
        "homePostalAddress",
        "houseIdentifier",
        "initials",
        "instanceType",
        "internationalISDNNumber",
        "ipPhone",
        "isCriticalSystemObject",
        "isDeleted",
        "isPrivilegeHolder",
        "isRecycled",
        "jpegPhoto",
        "kMServer",
        "l",
        "labeledURI",
        "lastKnownParent",
        "lastLogoff",
        "lastLogon",
        "lastLogonTimestamp",
        "lmPwdHistory",
        "localeID",
        "localPolicyFlags",
        "location",
        "lockoutTime",
        "logonCount",
        "logonHours",
        "logonWorkstation",
        "logRolloverInterval",
        "machineRole",
        "mail",
        "managedBy",
        "managedObjects",
        "manager",
        "masteredBy",
        "maxStorage",
        "memberOf",
        "mhsORAddress",
        "middleName",
        "mobile",
        "modifyTimeStamp",
        "monitoredConfigurations",
        "monitoredServices",
        "monitoringAvailabilityStyle",
        "monitoringAvailabilityWindow",
        "monitoringCachedViaMail",
        "monitoringCachedViaRPC",
        "monitoringMailUpdateInterval",
        "monitoringMailUpdateUnits",
        "monitoringRPCUpdateInterval",
        "monitoringRPCUpdateUnits",
        "msCOM-PartitionSetLink",
        "msCOM-UserLink",
        "msCOM-UserPartitionSetLink",
        "msDFSR-ComputerReferenceBL",
        "msDFSR-MemberReferenceBL",
        "msDRM-IdentityCertificate",
        "msDS-AdditionalDnsHostName",
        "msDS-AdditionalSamAccountName",
        "msDS-AllowedToActOnBehalfOfOtherIdentity",
        "msDS-AllowedToDelegateTo",
        "msDS-Approx-Immed-Subordinates",
        "msDS-AssignedAuthNPolicy",
        "msDS-AssignedAuthNPolicySilo",
        "msDS-AuthenticatedAtDC",
        "msDS-AuthenticatedToAccountlist",
        "msDS-AuthNPolicySiloMembersBL",
        "msDS-Cached-Membership",
        "msDS-Cached-Membership-Time-Stamp",
        "msDS-ClaimSharesPossibleValuesWithBL",
        "msDS-CloudAnchor",
        "mS-DS-ConsistencyChildCount",
        "mS-DS-ConsistencyGuid",
        "mS-DS-CreatorSID",
        "msDS-EnabledFeatureBL",
        "msDS-ExecuteScriptPassword",
        "msDS-FailedInteractiveLogonCount",
        "msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon",
        "msDS-GenerationId",
        "msDS-HABSeniorityIndex",
        "msDS-HostServiceAccount",
        "msDS-HostServiceAccountBL",
        "msDS-IsDomainFor",
        "msDS-IsFullReplicaFor",
        "msDS-isGC",
        "msDS-IsPartialReplicaFor",
        "msDS-IsPrimaryComputerFor",
        "msDS-isRODC",
        "msDS-IsUserCachableAtRodc",
        "msDS-KeyCredentialLink",
        "msDS-KeyPrincipalBL",
        "msDS-KrbTgtLink",
        "msDS-KrbTgtLinkBl",
        "msDS-LastFailedInteractiveLogonTime",
        "msDS-LastKnownRDN",
        "msDS-LastSuccessfulInteractiveLogonTime",
        "msDS-LocalEffectiveDeletionTime",
        "msDS-LocalEffectiveRecycleTime",
        "msDs-masteredBy",
        "msds-memberOfTransitive",
        "msDS-MembersForAzRoleBL",
        "msDS-MembersOfResourcePropertyListBL",
        "msds-memberTransitive",
        "msDS-NCReplCursors",
        "msDS-NCReplInboundNeighbors",
        "msDS-NCReplOutboundNeighbors",
        "msDS-NC-RO-Replica-Locations-BL",
        "msDS-NcType",
        "msDS-NeverRevealGroup",
        "msDS-NonMembersBL",
        "msDS-ObjectReferenceBL",
        "msDS-ObjectSoa",
        "msDS-OIDToGroupLinkBl",
        "msDS-OperationsForAzRoleBL",
        "msDS-OperationsForAzTaskBL",
        "msDS-parentdistname",
        "msDS-PhoneticCompanyName",
        "msDS-PhoneticDepartment",
        "msDS-PhoneticDisplayName",
        "msDS-PhoneticFirstName",
        "msDS-PhoneticLastName",
        "msDS-PrimaryComputer",
        "msDS-PrincipalName",
        "msDS-PromotionSettings",
        "msDS-PSOApplied",
        "msDS-ReplAttributeMetaData",
        "msDS-ReplValueMetaData",
        "msDS-ReplValueMetaDataExt",
        "msDS-ResultantPSO",
        "msDS-RevealedDSAs",
        "msDS-RevealedList",
        "msDS-RevealedListBL",
        "msDS-RevealedUsers",
        "msDS-RevealOnDemandGroup",
        "msDS-SecondaryKrbTgtNumber",
        "msDS-Site-Affinity",
        "msDS-SiteName",
        "msDS-SourceAnchor",
        "msDS-SourceObjectDN",
        "msDS-SupportedEncryptionTypes",
        "msDS-SyncServerUrl",
        "msDS-TasksForAzRoleBL",
        "msDS-TasksForAzTaskBL",
        "msDS-TDOEgressBL",
        "msDS-TDOIngressBL",
        "msDS-User-Account-Control-Computed",
        "msDS-UserPasswordExpiryTimeComputed",
        "msDS-ValueTypeReferenceBL",
        "msExchAcceptedDomainBL",
        "msExchAccountForestBL",
        "msExchArchiveDatabaseBL",
        "msExchAssociatedAcceptedDomainBL",
        "msExchAuthPolicyBL",
        "msExchAuxMailboxParentObjectIdBL",
        "msExchAvailabilityOrgWideAccountBL",
        "msExchAvailabilityPerUserAccountBL",
        "msExchCatchAllRecipientBL",
        "msExchComponentStates",
        "msExchConferenceMailboxBL",
        "msExchControllingZone",
        "msExchDataEncryptionPolicyBL",
        "msExchDelegateListBL",
        "msExchDeviceAccessControlRuleBL",
        "msExchEvictedMemebersBL",
        "msExchExchangeServerLink",
        "msExchHABRootDepartmentBL",
        "msExchHouseIdentifier",
        "msExchHygieneConfigurationMalwareBL",
        "msExchHygieneConfigurationSpamBL",
        "msExchIMAPOWAURLPrefixOverride",
        "msExchIntendedMailboxPlanBL",
        "msExchMailboxMoveSourceArchiveMDBBL",
        "msExchMailboxMoveSourceMDBBL",
        "msExchMailboxMoveSourceUserBL",
        "msExchMailboxMoveStorageMDBBL",
        "msExchMailboxMoveTargetArchiveMDBBL",
        "msExchMailboxMoveTargetMDBBL",
        "msExchMailboxMoveTargetUserBL",
        "msExchMDBAvailabilityGroupConfigurationBL",
        "msExchMobileRemoteDocumentsAllowedServersBL",
        "msExchMobileRemoteDocumentsBlockedServersBL",
        "msExchMobileRemoteDocumentsInternalDomainSuffixListBL",
        "msExchMultiMailboxDatabasesBL",
        "msExchMultiMailboxLocationsBL",
        "msExchOABGeneratingMailboxBL",
        "msExchOrganizationsAddressBookRootsBL",
        "msExchOrganizationsGlobalAddressListsBL",
        "msExchOrganizationsTemplateRootsBL",
        "msExchOriginatingForest",
        "msExchOWAAllowedFileTypesBL",
        "msExchOWAAllowedMimeTypesBL",
        "msExchOWABlockedFileTypesBL",
        "msExchOWABlockedMIMETypesBL",
        "msExchOWAForceSaveFileTypesBL",
        "msExchOWAForceSaveMIMETypesBL",
        "msExchOWARemoteDocumentsAllowedServersBL",
        "msExchOWARemoteDocumentsBlockedServersBL",
        "msExchOWARemoteDocumentsInternalDomainSuffixListBL",
        "msExchOWATranscodingFileTypesBL",
        "msExchOWATranscodingMimeTypesBL",
        "msExchParentPlanBL",
        "msExchPolicyList",
        "msExchPolicyOptionList",
        "msExchQueryBaseDN",
        "msExchRBACPolicyBL",
        "msExchResourceGUID",
        "msExchResourceProperties",
        "msExchRMSComputerAccountsBL",
        "msExchServerAssociationBL",
        "msExchServerSiteBL",
        "msExchSMTPReceiveDefaultAcceptedDomainBL",
        "msExchSupervisionDLBL",
        "msExchSupervisionOneOffBL",
        "msExchSupervisionUserBL",
        "msExchTransportRuleTargetBL",
        "msExchTrustedDomainBL",
        "msExchUGMemberBL",
        "msExchUserBL",
        "msExchUserCulture",
        "msIIS-FTPDir",
        "msIIS-FTPRoot",
        "msImaging-HashAlgorithm",
        "msImaging-ThumbprintHash",
        "mSMQDigests",
        "mSMQDigestsMig",
        "mSMQSignCertificates",
        "mSMQSignCertificatesMig",
        "msNPAllowDialin",
        "msNPCallingStationID",
        "msNPSavedCallingStationID",
        "msOrg-LeadersBL",
        "msPKIAccountCredentials",
        "msPKI-CredentialRoamingTokens",
        "msPKIDPAPIMasterKeys",
        "msPKIRoamingTimeStamp",
        "msRADIUSCallbackNumber",
        "msRADIUS-FramedInterfaceId",
        "msRADIUSFramedIPAddress",
        "msRADIUS-FramedIpv6Prefix",
        "msRADIUS-FramedIpv6Route",
        "msRADIUSFramedRoute",
        "msRADIUS-SavedFramedInterfaceId",
        "msRADIUS-SavedFramedIpv6Prefix",
        "msRADIUS-SavedFramedIpv6Route",
        "msRADIUSServiceType",
        "msRASSavedCallbackNumber",
        "msRASSavedFramedIPAddress",
        "msRASSavedFramedRoute",
        "msRTCSIP-AcpInfo",
        "msRTCSIP-ApplicationOptions",
        "msRTCSIP-ArchivingEnabled",
        "msRTCSIP-DeploymentLocator",
        "msRTCSIP-FederationEnabled",
        "msRTCSIP-GroupingID",
        "msRTCSIP-InternetAccessEnabled",
        "msRTCSIP-Line",
        "msRTCSIP-LineServer",
        "msRTCSIP-OptionFlags",
        "msRTCSIP-OriginatorSid",
        "msRTCSIP-OwnerUrn",
        "msRTCSIP-PrimaryHomeServer",
        "msRTCSIP-PrimaryUserAddress",
        "msRTCSIP-PrivateLine",
        "msRTCSIP-TargetHomeServer",
        "msRTCSIP-TargetUserPolicies",
        "msRTCSIP-TenantId",
        "msRTCSIP-UserEnabled",
        "msRTCSIP-UserExtension",
        "msRTCSIP-UserLocationProfile",
        "msRTCSIP-UserPolicies",
        "msRTCSIP-UserPolicy",
        "msRTCSIP-UserRoutingGroupId",
        "msSFU30Aliases",
        "msSFU30Name",
        "msSFU30NisDomain",
        "msSFU30PosixMemberOf",
        "msTPM-OwnerInformation",
        "msTPM-TpmInformationForComputer",
        "msTSAllowLogon",
        "msTSBrokenConnectionAction",
        "msTSConnectClientDrives",
        "msTSConnectPrinterDrives",
        "msTSDefaultToMainPrinter",
        "msTSEndpointData",
        "msTSEndpointPlugin",
        "msTSEndpointType",
        "msTSExpireDate",
        "msTSExpireDate2",
        "msTSExpireDate3",
        "msTSExpireDate4",
        "msTSHomeDirectory",
        "msTSHomeDrive",
        "msTSInitialProgram",
        "msTSLicenseVersion",
        "msTSLicenseVersion2",
        "msTSLicenseVersion3",
        "msTSLicenseVersion4",
        "msTSLSProperty01",
        "msTSLSProperty02",
        "msTSManagingLS",
        "msTSManagingLS2",
        "msTSManagingLS3",
        "msTSManagingLS4",
        "msTSMaxConnectionTime",
        "msTSMaxDisconnectionTime",
        "msTSMaxIdleTime",
        "msTSPrimaryDesktop",
        "msTSPrimaryDesktopBL",
        "msTSProfilePath",
        "msTSProperty01",
        "msTSProperty02",
        "msTSReconnectionAction",
        "msTSRemoteControl",
        "msTSSecondaryDesktopBL",
        "msTSSecondaryDesktops",
        "msTSWorkDirectory",
        "name",
        "netbootDUID",
        "netbootGUID",
        "netbootInitialization",
        "netbootMachineFilePath",
        "netbootMirrorDataFile",
        "netbootSCPBL",
        "netbootSIFFile",
        "networkAddress",
        "nisMapName",
        "nonSecurityMemberBL",
        "ntPwdHistory",
        "nTSecurityDescriptor",
        "o",
        "objectCategory",
        "objectClass",
        "objectGUID",
        "objectVersion",
        "operatingSystem",
        "operatingSystemHotfix",
        "operatingSystemServicePack",
        "operatingSystemVersion",
        "operatorCount",
        "otherFacsimileTelephoneNumber",
        "otherHomePhone",
        "otherIpPhone",
        "otherLoginWorkstations",
        "otherMailbox",
        "otherMobile",
        "otherPager",
        "otherTelephone",
        "otherWellKnownObjects",
        "ou",
        "ownerBL",
        "pager",
        "partialAttributeDeletionList",
        "partialAttributeSet",
        "personalPager",
        "personalTitle",
        "photo",
        "physicalDeliveryOfficeName",
        "physicalLocationObject",
        "policyReplicationFlags",
        "possibleInferiors",
        "postalAddress",
        "postalCode",
        "postOfficeBox",
        "preferredDeliveryMethod",
        "preferredLanguage",
        "preferredOU",
        "primaryGroupID",
        "primaryInternationalISDNNumber",
        "primaryTelexNumber",
        "profilePath",
        "promoExpiration",
        "proxiedObjectName",
        "proxyAddresses",
        "pwdLastSet",
        "queryPolicyBL",
        "registeredAddress",
        "replPropertyMetaData",
        "replUpToDateVector",
        "repsFrom",
        "repsTo",
        "revision",
        "rIDSetReferences",
        "roomNumber",
        "scriptPath",
        "sDRightsEffective",
        "secretary",
        "securityProtocol",
        "seeAlso",
        "serialNumber",
        "serverReferenceBL",
        "servicePrincipalName",
        "showInAdvancedViewOnly",
        "siteGUID",
        "siteObjectBL",
        "sn",
        "st",
        "street",
        "streetAddress",
        "structuralObjectClass",
        "subRefs",
        "subSchemaSubEntry",
        "systemFlags",
        "telephoneAssistant",
        "telephoneNumber",
        "teletexTerminalIdentifier",
        "telexNumber",
        "terminalServer",
        "thumbnailLogo",
        "thumbnailPhoto",
        "title",
        "trackingLogPathName",
        "type",
        "uid",
        "unicodePwd",
        "url",
        "userAccountControl",
        "userCertificate",
        "userParameters",
        "userPassword",
        "userPKCS12",
        "userPrincipalName",
        "userSharedFolder",
        "userSharedFolderOther",
        "userSMIMECertificate",
        "userWorkstations",
        "uSNChanged",
        "uSNCreated",
        "uSNDSALastObjRemoved",
        "USNIntersite",
        "uSNLastObjRem",
        "uSNSource",
        "volumeCount",
        "wbemPath",
        "wellKnownObjects",
        "whenChanged",
        "whenCreated",
        "wWWHomePage",
        "x121Address",
        "x500uniqueIdentifier"
        )
    $Compare = Compare-Object -ReferenceObject $ComputerAttributeList -DifferenceObject $ComputerAttributeListFromAD
    Write-Output $Compare
    }
    }
}
    