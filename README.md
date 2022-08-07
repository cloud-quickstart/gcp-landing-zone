# gcp-landing-zone
Google Cloud Landing Zone using Java IaC

# Developer Guide
- Refer to https://cloud.google.com/java/docs/reference
- https://cloud.google.com/storage/docs/reference/libraries#client-libraries-install-java
- https://github.com/googleapis/google-cloud-java

# Running the CLI
```
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone (lz-stg)$ mvn clean install -U
michael@cloudshell:~/github/cloud-quickstart/gcp-landing-zone (lz-stg)$ java -jar gcp-landing-zone-deploy/target/gcp-landing-zone-deploy-0.0.1-SNAPSHOT.jar zone.gcp.landing.Cli
S
```
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

```


