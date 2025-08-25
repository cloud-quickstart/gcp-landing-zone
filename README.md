# gcp-landing-zone
Google Cloud Landing Zone using Java IaC
- see https://github.com/CloudLandingZone/gcp-secure-landing-zone-poc/blob/main/README.md
- https://cloud.google.com/iam/docs/samples/iam-quickstart#iam_quickstart-java
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/wiki/DevOps#local-development---manual

# Developer Guide
- Refer to https://cloud.google.com/java/docs/reference
- https://cloud.google.com/storage/docs/reference/libraries#client-libraries-install-java
- https://github.com/googleapis/google-cloud-java

# Development Environments
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#deployments

#### Deployments

ID | Domain | D CSP | C CSP | Identity | sa | Phone | MFA | Credits | Use | Quotas
---|---|---|---|---|---|---|---|---|---|---
1 | gcp.obrien.services | AWS | GCP | Identity | m | oldev | | 0618 | LZ 0323 | 10 proj
2 | _gcp.obrienlabs.info_ | AWS | GCP | Identity | r | | | 1102 | empty |
3 | obrien.systems | | GCP | | | | | | |
4 | containerized.org | | GCP | WS | m | | | | LZ |
6 | _clouddevops.dev_ | | GCP | WS | m | | | 0716 | mostly empty |
9 | eventstream.dev| | GCP | Identity | m | | | - | very empty |
10 | _gcp.gcloud.network_ | | GCP | identity | ad-s | | | | very empty |
12 | ***cloudnuage.dev*** | | GCP | WS | r/m | | | 0902 | LZ june | aws/azure accounts
13 | ***nuage-cloud.org*** | | GCP | WS | a-r | | | 0904 | empty - with gcp.zone | 2 billing
15 | _eventfield.io_ | AWS | GCP | | m | | | 0 | empty |
16 | ***gcp.zone*** | | GCP | WS | m | | | 1104 | LZ manual - with n-c.org |
17 | ***landing.gcp.zone*** | | GCP | | m | | | 1113 | LZ automated CD - with n-c.org |

# Running the gcloud CLI
```
```
# Running the Java CLI
```
with dependencies (recommended)
michaelobrien@mbp7 gcp-landing-zone-deploy % mvn compile assembly:single 
(4 min on GCP Shell, 2 min on an M1 max pro)
michaelobrien@mbp7 gcp-landing-zone-deploy % java -jar target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT-jar-with-dependencies.jar zone.gcp.landing.Cli
Binding: {"members":["user:mic...ev"],"role":"roles/logging.logWriter"}
Role: roles/logging.logWriter
Members: [user:m..ev] 

without dependencies
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone (lz-stg)$ mvn clean install -U
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone (lz-stg)$ java -jar gcp-landing-zone-deploy/target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT.jar zone.gcp.landing.Cli
```
# GCP Quota Increases

# GCP Identity and Organization Onboarding
[https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/243-tef-retrofit/docs/google-cloud-onboarding.md)

# GCP IAM Roles
 - https://cloud.google.com/iam/docs/granting-changing-revoking-access?_ga=2.162573115.-680483834.1659746082

## Create your bootstrap Google Cloud project

```
michael@cloudshell:~$ gcloud projects create gcp-zone-landing-stg --name="gcp-zone-landing-stg" --labels=type=dev
Create in progress for [https://cloudresourcemanager.googleapis.com/v1/projects/gcp-zone-landing-stg].
Waiting for [operations/cp.6078773111587977724] to finish...done.    
Enabling service [cloudapis.googleapis.com] on project [gcp-zone-landing-stg]...
Operation "operations/acat.p2-1017366855021-820d71c9-a8f2-4d3c-a3ad-8d877176d5a8" finished successfully.
michael@cloudshell:~$ git config --global user.email "michael@"
michael@cloudshell:~$ git config --global user.name "Michael"
michael@cloudshell:~$ git clone https://github.com/cloud-quickstart/gcp-landing-zone.git
Username for 'https://github.com': obrien...
Password for 'https://obriensystems@github.com': use your auth token
michael@cloudshell:~/cloud-quickstart$ gcloud config set project gcp-zone-landing-stg
michael@cloudshell:~/cloud-quickstart (gcp-zone-landing-stg)$
```

Get default enabled services
```
michael@cloudshell:~/cloud-quickstart (gcp-zone-landing-stg)$ gcloud services list --enabled --project gcp-zone-landing-stg | grep NAME
NAME: bigquery.googleapis.com
NAME: bigquerymigration.googleapis.com
NAME: bigquerystorage.googleapis.com
NAME: cloudapis.googleapis.com
NAME: clouddebugger.googleapis.com
NAME: cloudtrace.googleapis.com
NAME: datastore.googleapis.com
NAME: logging.googleapis.com
NAME: monitoring.googleapis.com
NAME: servicemanagement.googleapis.com
NAME: serviceusage.googleapis.com
NAME: sql-component.googleapis.com
NAME: storage-api.googleapis.com
NAME: storage-component.googleapis.com
NAME: storage.googleapis.com
```
Get project, organization and billing id
```
gcloud config set project lz-stg
export PROJ=$(gcloud config list --format 'value(core.project)') 
export ORGANIZATION_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
export BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
export USER_EMAIL=`gcloud config list account --format "value(core.account)"`
# add iam role
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$USER_EMAIL --role=roles/resourcemanager.folderAdmin
# create folder and save the id
# https://cloud.google.com/resource-manager/docs/creating-managing-folders#gcloud
export FOLDER_ROOT_0=$(gcloud resource-manager folders create --display-name=landingzone --organization=$ORGANIZATION_ID '--format=value(name)' | sed 's/.*\///')
export FOLDER_ROOT_1=$(gcloud resource-manager folders create --display-name=Infrastructure --folder=$FOLDER_ROOT_0 '--format=value(name)' | sed 's/.*\///')
export FOLDER_ROOT_2=$(gcloud resource-manager folders create --display-name=Networking --folder=$FOLDER_ROOT_1 '--format=value(name)' | sed 's/.*\///')
export FOLDER_ROOT_3=$(gcloud resource-manager folders create --display-name=ProdNetworking --folder=$FOLDER_ROOT_2 '--format=value(name)' | sed 's/.*\///')
export FOLDER_WORK_1=$(gcloud resource-manager folders create --display-name=Workloads --folder=$FOLDER_ROOT_0 '--format=value(name)' | sed 's/.*\///')
export FOLDER_WORK_2=$(gcloud resource-manager folders create --display-name=Prod --folder=$FOLDER_WORK_1 '--format=value(name)' | sed 's/.*\///')

export PROJECT_PERIMETER=odpe-obd-obdprd-obdpubper
export PROJECT_PRODHOST=odpe-obd-obdprd-obdhostproj
export PROJECT_PRODSERV1=odpe-obd-obdprd-obdservprj1
gcloud projects create $PROJECT_PERIMETER --folder=$FOLDER_ROOT_3
gcloud projects create $PROJECT_PRODHOST --folder=$FOLDER_ROOT_3
gcloud projects create $PROJECT_PRODSERV1 --folder=$FOLDER_WORK_2

# link billing account
gcloud beta billing projects link $PROJECT_PERIMETER --billing-account=$BILLING_ID
ERROR: (gcloud.beta.billing.projects.link) FAILED_PRECONDITION: Precondition check failed.
- '@type': type.googleapis.com/google.rpc.QuotaFailure
  violations:
  - description: 'Cloud billing quota exceeded: https://support.google.com/code/contact/billing_quota_increase'
    subject: billingAccounts/019283...
# use another billing account
export BILLING_ID=019D0C...
gcloud beta billing projects link $PROJECT_PERIMETER --billing-account=$BILLING_ID
gcloud beta billing projects link $PROJECT_PRODSERV1 --billing-account=$BILLING_ID
gcloud beta billing projects link $PROJECT_PRODHOST --billing-account=$BILLING_ID



https://cloud.google.com/resource-manager/docs/creating-managing-projects
```


Enable compute for VPC creation
```
michael@cloudshell:~ (lz-stg)$ gcloud services enable compute.googleapis.com
Operation "operations/acf.p2-918623670639-494fcadb-4df0-43e9-b778-835bea73645b" finished successfully.
```

## Add the GCP SDK to your maven project
- examples:  https://cloud.google.com/docs/samples/?q=enable+service&l=java
- Add the dependency in your pom
- https://github.com/googleapis/google-cloud-java/tree/monorepo_script_output/java-service-control
- https://cloud.google.com/iam/docs/samples/iam-quickstart#iam_quickstart-java
- https://github.com/GoogleCloudPlatform/java-docs-samples/blob/HEAD/iam/api-client/src/main/java/iam/snippets/Quickstart.java
```
<dependency>
  <groupId>com.google.cloud</groupId>
  <artifactId>google-cloud-service-control</artifactId>
  <version>1.3.0</version>
</dependency
```

## Authenticate

```
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ gcloud auth application-default login

You are running on a Google Compute Engine virtual machine.
The service credentials associated with this virtual machine
will automatically be used by Application Default
Credentials, so it is not necessary to use this command.

If you decide to proceed anyway, your user credentials may be visible
to others with access to this virtual machine. Are you sure you want
to authenticate with your personal account?

Do you want to continue (Y/n)?  y

Go to the following link in your browser:

    https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com&redirect_uri=https%3A%2F%2Fsdk.cloud.google.com%2Fapplicationdefaultauthcode.html&scope=openid+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fsqlservice.login+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&state=BgyTC4dzisSlh2PqZT3bJAU2rnKypa&prompt=consent&access_type=offline&code_challenge=U-KYvn2xVXbirxYw336968B1Z8g_dbkrrT-HgMD9yvA&code_challenge_method=S256

Enter authorization code: 4/0AdQt8qisZgiAFnmCM2OAkoZFjhJwEPitvFkOeCZSKT_z-Awg_v5feYtyx7QtOogCYxIiWA

Credentials saved to file: [/tmp/tmp.IX6qLvhyOT/application_default_credentials.json]

These credentials will be used by any library that requests Application Default Credentials (ADC).

Quota project "lz-stg" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.

still (missing parent pom dependency)
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ java -jar target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT.jar zone.gcp.landing.Cli
Error: Unable to initialize main class zone.gcp.landing.Cli
Caused by: java.lang.NoClassDefFoundError: com/google/auth/Credentials

enable resource manager
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ gcloud services list --available | grep resource
NAME: cloudresourcemanager.googleapis.com

michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ gcloud services enable cloudresourcemanager.googleapis.com
Operation "operations/acat.p2-918623670639-be41bc89-506f-4176-8152-bd39b5cd2d86" finished successfully.

https://cloud.google.com/docs/authentication/getting-started#auth-cloud-implicit-java

michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ cp /tmp/tmp.IX6qLvhyOT/application_default_credentials.json ~/
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ export GOOGLE_APPLICATION_CREDENTIALS=~/application_default_credentials.json
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ java -jar target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT.jar zone.gcp.landing.Cli


pom.xml change
<build>
      <plugins>
           <plugin> 
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <!--artifactId>maven-jar-plugin</artifactId-->
                <version>3.1.0</version>
                <configuration>
                  <archive>
                    <manifest>
                      <mainClass>zone.gcp.landing.Cli</mainClass>

                    </manifest>
                  </archive>
                  <!-- fix java.lang.NoClassDefFoundError: com/google/auth/Credentials-->
                  <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                <!-- single jar-->
        <execution>
          <id>make-assembly</id> <!-- this is used for inheritance merges -->
          <phase>package</phase> <!-- bind to the packaging phase -->
          <goals>
            <goal>single</goal>
          </goals>
        </execution>
      </executions>
        </plugin>
      <!--plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>11</source>
          <target>11</target>
        </configuration>
      </plugin-->
     </plugins>
    </build>
    
    [INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  04:30 min
[INFO] Finished at: 2022-08-07T18:29:24Z
[INFO] ------------------------------------------------------------------------
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ mvn clean compile assembly:single

my problem was the build - been a while since I worked outside of a spring boot jar - where we need all dependencies packaged into the jar

michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy (lz-stg)$ java -jar target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT-jar-with-dependencies.jar zone.gcp.landing.Cli
classloading
Buckets:
Bucket{name=empty-lz-stg}
Bucket{name=empty2-lz-ob}


shell
 mvn compile assembly:single
[INFO] Building jar: /home/michael/github/cloud-quickstart/gcp-landing-zone/gcp-landing-zone-deploy/target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT-jar-with-dependencies.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  04:08 min

macbook pro 2021 m1max
[INFO] Total time:  02:32 min
```

### Override Organization Policy on a Folder
vi policy.yaml

```
name: projects/690900791045/policies/gcp.resourceLocations
spec:
  rules:
    values:
      allowedValues:
       - in:canada-locations
       - in:us-locations    
```

set the orgpolicy.googleapis.com api on the project

```
gcloud org-policies set-policy policy.yaml
```
<img width="1077" alt="Screen Shot 2023-02-01 at 5 18 10 PM" src="https://user-images.githubusercontent.com/94715080/216176367-21967900-a564-4a0c-9e56-7419c5903d4e.png">

