# gcp-landing-zone
Google Cloud Landing Zone using Java IaC

# Developer Guide
- Refer to https://cloud.google.com/java/docs/reference
- https://cloud.google.com/storage/docs/reference/libraries#client-libraries-install-java
- https://github.com/googleapis/google-cloud-java
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
