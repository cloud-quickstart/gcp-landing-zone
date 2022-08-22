# Landing Zones for GCP
Landing zone concepts have a lot in common with aeronautical concepts.  As the automatation/autopilot level increases the restrictions on the pilot reduce and vice versa to VFR where the pilot is unrestricted
- Approach - https://www.faa.gov/regulations_policies/handbooks_manuals/aviation/airplane_handbook/media/10_afh_ch8.pdf
- ATC - Air Traffic Control
- CA - Controled Airspace
- Crosswinds = hacking, DDoS, 
- GC - Ground Control
- IFR - Instrument Flight Rules (fly with only instruments - IE at night in a cloud during landing) - restricted
- ILS - [Instrument Landing System](https://en.wikipedia.org/wiki/Instrument_landing_system) (Land using ADF equipment to process signals from multi-frequency directional radio systems on the side of the runway)
- Squak - 4 digit transponder code = label/tag
- VFR - Visual Flight Rules (fly in good weather using your human senses) - unrestricted (less ATC)

# GCP Onboarding Plan
Use the following guide - https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md
We will use the following organizations:

```mermaid
graph LR;
    style Landing-Zones fill:#44f,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
    %% mapped and documented

    on-prem-simulate-->prem
    identity-as-a-service-simulate-->idp-dev
    identity-as-a-service-simulate-->idp-uat
    3rd-cloud-->dev-aws
    
    manual-->sbx
    manual-->dev
    automated-->uat
    automated-->prd
    
    prem-->onprem.gcp.zone
    idp-dev-->azure.obrienlabs.dev
    idp-uat-->azure.cloudnuage.dev
    dev-->approach.gcp.zone-->procedure/verify
    dev-aws-->aws.cloudnuage.dev
    sbx-->checklist.gcp.zone-->experiment
    prd-->landing.gcp.zone-->resilient/stable
    uat-->gcp.zone-->cicd/automated
    gcp.zone-->gcp-domain-zone
    
    
```



## Automated Landing Zone Flight Plan


### Incremental Asset Inventory


## Manual Landing Zone Flight Plan

### Create new Google Cloud Identity Account with Domain/Organization and Billing
#### Open an incognito Chrome window
<img width="1569" alt="Screen Shot 2022-08-19 at 21 53 48" src="https://user-images.githubusercontent.com/24765473/185805672-37858ad2-3ad3-45e8-9b25-51150ae6c932.png">

#### Navigate to Google Cloud Identity Free Account Creation

follow https://cloud.google.com/identity/docs/set-up-cloud-identity-admin and select Cloud Identity Free https://workspace.google.com/signup/gcpidentity/welcome#0

<img width="1567" alt="Screen Shot 2022-08-19 at 21 56 06" src="https://user-images.githubusercontent.com/24765473/185805677-0ec5bf6b-5fd8-407e-8692-f047b35cde43.png">


#### Select single business user
<img width="1568" alt="Screen Shot 2022-08-19 at 21 56 40" src="https://user-images.githubusercontent.com/24765473/185805713-e5cbd3ee-ad7c-48af-9244-5fe729d10826.png">

#### Use same business name as subdomain - approach.gcp.zone
<img width="1563" alt="Screen Shot 2022-08-19 at 21 57 35" src="https://user-images.githubusercontent.com/24765473/185805716-bcbd5e66-c5b7-45ab-91bc-8628219a37e1.png">

#### Use base email from the hosting domain - gcp.zone
<img width="1563" alt="Screen Shot 2022-08-19 at 21 57 55" src="https://user-images.githubusercontent.com/24765473/185805725-ebc71f36-f20b-4919-ad45-210043cf4940.png">

#### Select name for the super admin
<img width="1560" alt="Screen Shot 2022-08-19 at 21 59 31" src="https://user-images.githubusercontent.com/24765473/185805732-8b381922-65ac-4285-a074-2d292521b6b4.png">

#### Select username for the super admin
<img width="1563" alt="Screen Shot 2022-08-19 at 22 00 08" src="https://user-images.githubusercontent.com/24765473/185805736-b7929959-de1f-41e1-8259-51314595726c.png">

<img width="1566" alt="Screen Shot 2022-08-19 at 22 00 35" src="https://user-images.githubusercontent.com/24765473/185805747-4b136f3b-6b73-4d83-907e-9d55ddf6d7ae.png">

#### Create Google Account
<img width="1570" alt="Screen Shot 2022-08-19 at 22 01 47" src="https://user-images.githubusercontent.com/24765473/185805754-92188cde-c35e-41c0-8289-63e92c066b9a.png">

#### Goto Setup
There is a very small chance your account will get flagged.

<img width="1565" alt="Screen Shot 2022-08-19 at 22 02 27" src="https://user-images.githubusercontent.com/24765473/185805763-a59c3192-05f0-4706-bc35-d57323e2981a.png">

<img width="1571" alt="Screen Shot 2022-08-19 at 22 02 45" src="https://user-images.githubusercontent.com/24765473/185805769-31181f05-f8d9-416b-8cdc-8c898ebd9d3b.png">

#### Use a phone for requested MFA
<img width="1568" alt="Screen Shot 2022-08-19 at 22 08 47" src="https://user-images.githubusercontent.com/24765473/185805777-7e1b2c88-662b-458d-844b-90ac6e91a89c.png">

<img width="1565" alt="Screen Shot 2022-08-19 at 22 09 26" src="https://user-images.githubusercontent.com/24765473/185805785-804278e4-637a-44f1-844b-04daebe5d07b.png">

<img width="1567" alt="Screen Shot 2022-08-19 at 22 09 40" src="https://user-images.githubusercontent.com/24765473/185805794-2a1a173f-b9e6-4604-a22e-32b684f122ed.png">

#### Domain verification in admin.google.com
<img width="1563" alt="Screen Shot 2022-08-19 at 22 09 52" src="https://user-images.githubusercontent.com/24765473/185805802-f3dfaaf6-2ec3-4a6a-ab53-8bdb8b147550.png">

<img width="1569" alt="Screen Shot 2022-08-19 at 22 10 30" src="https://user-images.githubusercontent.com/24765473/185805811-eb5fcab7-71fb-4cbd-82da-4719a62a5280.png">

<img width="1564" alt="Screen Shot 2022-08-19 at 22 10 38" src="https://user-images.githubusercontent.com/24765473/185805815-b356ade2-bb1e-4284-afe7-4073dd920c5f.png">

#### Switch to hosting account - gcp.zone
<img width="1571" alt="Screen Shot 2022-08-19 at 22 11 41" src="https://user-images.githubusercontent.com/24765473/185805821-77ded060-d60f-4558-8393-ca4fed59cad7.png">

#### Apply TXT record
<img width="1572" alt="Screen Shot 2022-08-19 at 22 12 23" src="https://user-images.githubusercontent.com/24765473/185805828-20cf4c1a-3b04-42b3-b3c1-975606f54ea0.png">

#### Check dig domain txt
<img width="842" alt="Screen Shot 2022-08-19 at 22 13 10" src="https://user-images.githubusercontent.com/24765473/185805998-4749b0f6-3770-42ef-9291-38bc62755948.png">

#### Return to verify domain
<img width="1569" alt="Screen Shot 2022-08-19 at 22 13 43" src="https://user-images.githubusercontent.com/24765473/185806010-be6fd133-062d-4201-b456-af4726802748.png">

<img width="825" alt="Screen Shot 2022-08-19 at 22 13 52" src="https://user-images.githubusercontent.com/24765473/185806020-23697524-7672-4318-9bc6-c6d16c0fec6d.png">

<img width="1558" alt="Screen Shot 2022-08-19 at 22 14 55" src="https://user-images.githubusercontent.com/24765473/185806034-e2e8826d-7b25-4c7f-a565-30b9a259a55b.png">

#### 2 min - Setup GCP Cloud Console Now
<img width="1561" alt="Screen Shot 2022-08-19 at 22 15 29" src="https://user-images.githubusercontent.com/24765473/185806042-ba6831c7-3020-4005-9cd5-0d321c9ad31a.png">

<img width="585" alt="Screen Shot 2022-08-19 at 22 15 36" src="https://user-images.githubusercontent.com/24765473/185806046-5b7f99ff-6389-4a54-8cdd-c7375ffae507.png">

#### Optionally - Move Billing Accounts or Projects
<img width="1564" alt="Screen Shot 2022-08-19 at 22 15 44" src="https://user-images.githubusercontent.com/24765473/185806060-06d49132-b1c3-474e-9548-47e3038861de.png">

<img width="565" alt="Screen Shot 2022-08-19 at 22 15 56" src="https://user-images.githubusercontent.com/24765473/185806063-486e7300-2ea2-4aa8-8ca0-062c945f2ce8.png">

#### Non-Government - Activate Credits - to enter Billing CC
Periodically you may incur a 48h wait when using the same billing info.

<img width="1553" alt="Screen Shot 2022-08-19 at 22 17 11" src="https://user-images.githubusercontent.com/24765473/185806093-b374ab24-bfc2-4ef8-9eed-226a33883d0c.png">

<img width="586" alt="Screen Shot 2022-08-19 at 22 20 22" src="https://user-images.githubusercontent.com/24765473/185806123-11634ff9-349c-4577-a903-f4664ac6b1a2.png">

#### Create new Chrome window and Profile
<img width="1015" alt="Screen Shot 2022-08-19 at 22 22 53" src="https://user-images.githubusercontent.com/24765473/185806133-94d1a47c-2511-40bd-8e01-dcca06694fcc.png">

<img width="1020" alt="Screen Shot 2022-08-19 at 22 23 17" src="https://user-images.githubusercontent.com/24765473/185806137-b682b8e2-09ea-4261-85c9-c7bdf5240c48.png">

#### Navigate to IAM - check organization

https://console.cloud.google.com/iam-admin/iam?organizationId=431498985862

<img width="1568" alt="Screen Shot 2022-08-19 at 22 24 17" src="https://user-images.githubusercontent.com/24765473/185806144-1bc406eb-0a2b-45ae-bfe5-d5421ad1c0c9.png">

#### Check billing

https://console.cloud.google.com/billing?organizationId=431498985862

<img width="1263" alt="Screen Shot 2022-08-19 at 22 24 29" src="https://user-images.githubusercontent.com/24765473/185806153-f8af3a04-ef0e-45a6-8330-b0e870a211bd.png">

<img width="1569" alt="Screen Shot 2022-08-19 at 22 24 41" src="https://user-images.githubusercontent.com/24765473/185806161-6e3e8aa7-d999-4cd0-b847-02055d4cf8fd.png">

30 min for a verify check this time

<img width="1560" alt="Screen Shot 2022-08-19 at 22 25 23" src="https://user-images.githubusercontent.com/24765473/185806167-30ed57ae-ce38-418f-b5e3-a868bb18a127.png">

#### Switch/Enable billing on default project

<img width="1571" alt="Screen Shot 2022-08-19 at 22 27 02" src="https://user-images.githubusercontent.com/24765473/185806174-23224ed0-6130-4fb1-9dc1-8ce77102ac9f.png">

#### Activate to enable all services

<img width="1570" alt="Screen Shot 2022-08-19 at 22 51 56" src="https://user-images.githubusercontent.com/24765473/185806183-24512d98-5c99-49fd-96d5-4b082c99ef65.png">

<img width="1571" alt="Screen Shot 2022-08-19 at 22 52 06" src="https://user-images.githubusercontent.com/24765473/185806190-100843b3-a478-4554-ac1c-4a334576d7d2.png">

#### Activate shell.cloud.google.com

<img width="1555" alt="Screen Shot 2022-08-19 at 22 54 19" src="https://user-images.githubusercontent.com/24765473/185806195-a495f5d2-e833-4acb-94c9-3a546abb3c08.png">

#### Increase Project Quotas

https://support.google.com/code/contact/billing_quota_increase

<img width="1567" alt="Screen Shot 2022-08-19 at 22 57 50" src="https://user-images.githubusercontent.com/24765473/185806204-2feab70c-b37d-46d3-9714-cc3b4a4db1d2.png">

### Add IAM Role Permissions - under organization
- folder admin  
- project billing manager = roles/billing.projectManager
- storage admin
- logging admin
- security admin
- Service Account Token Creator (for Terraform service accounts)

<img width="1684" alt="Screen Shot 2022-08-21 at 15 04 07" src="https://user-images.githubusercontent.com/24765473/185806883-9d9e3767-df71-4b34-b309-4458df095ab7.png">

- Service Account Admin
- Folder Creator = roles/resourcemanager.folderCreator
- Organization Policy Admin roles/orgpolicy.policyAdmin

### Create Folder structure
org
- landingzone
- - 
<img width="729" alt="Screen Shot 2022-08-21 at 15 06 17" src="https://user-images.githubusercontent.com/24765473/185806962-2dd1e676-9b6d-4632-a756-9a461821e60a.png">

### Create projects
- lz-agz-stg under landingzone folder


## Organization Policies
- set IAM role organization policy admin
- 
### constraints/compute.skipDefaultNetworkCreation = true

### constraints/compute.disableSerialPortAccess = true

### constraints/gcp.resourceLocations = list ["northamerica-northeast1", "northamerica-northeast2"]

https://cloud.google.com/resource-manager/docs/organization-policy/defining-locations

<img width="1057" alt="Screen Shot 2022-08-21 at 21 36 23" src="https://user-images.githubusercontent.com/24765473/185822523-0d169d77-0c18-464b-b9e3-127c75340688.png">

<img width="965" alt="Screen Shot 2022-08-21 at 21 38 12" src="https://user-images.githubusercontent.com/24765473/185822530-f746228c-8314-4475-97fc-1da90d1a26a8.png">

<img width="900" alt="Screen Shot 2022-08-21 at 21 38 24" src="https://user-images.githubusercontent.com/24765473/185822551-a7ec8ac3-0268-4028-9721-5117317e7443.png">

<img width="941" alt="Screen Shot 2022-08-21 at 21 38 37" src="https://user-images.githubusercontent.com/24765473/185822560-a28f735a-59e8-4d74-8c90-7e798626a200.png">

```
michael@cloudshell:~$ gcloud beta resource-manager org-policies set-policy --organization 962342543445 policy.yaml
constraint: constraints/gcp.resourceLocations
etag: CMe_i5gGEKDVkL8D
listPolicy:
  allowedValues:
  - in:northamerica-northeast2-locations
  - in:northamerica-northeast1-locations
updateTime: '2022-08-22T01:45:43.937700Z'
```

## Projects

## IAM Roles
### Super Admin User
#### org level cloudasset.assets.searchAllResources for Cloud Asset Inventory




# Links
- Request more users than 50 or 100 (workspaces) https://cloud.google.com/identity/pricing
