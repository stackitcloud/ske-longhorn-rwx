# STACKIT SKE - RWX with Longhorn

To enable Read Write Many (RWX) storage on STACKIT SKE clusters follow this guide to install Rancher Lognhorn.

## Prerequisites
+ Access to an SKE Cluster
+ Helm & Kubectl installed
+ (Optional) S3 Object Storage to store Backups

## Dependencies

First we need to setup an Iscsi watchdog Daemonset that is starting the necessary services on the node.
```bash
kubectl apply -f enableISCSI.yml
```

## Install Longhorn
## Installation
https://longhorn.io/docs/latest/deploy/install/install-with-helm/
```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace -f values.yaml --version $(curl -s https://api.github.com/repos/longhorn/longhorn/releases/latest | jq -r '.tag_name')
  
```
> To use the install command provided here you need to have `curl` and `jq` installed

> Optional: Add the `values.yaml` to enable the backup and prepare parameters during deployment. See backup section below


## Create Longhorn Storage Class

```bash
kubectl apply -f storageClass.yaml
```

## Create Test Deployoment

```bash
kubectl apply -f example-rwx-deployment.yaml
```  
<br>

## Backup configuration
If you enabled the Backup via the `values.yaml` you can now configure the S3 Bucket and the Backup Job, otherwise you can skip this part.
https://longhorn.io/docs/latest/snapshots-and-backups/backup-and-restore/

## Create Secret for backup on S3 [optional]
```bash
kubectl create secret generic <name> \
    --from-literal=AWS_ACCESS_KEY_ID=<s3-access-key> \
    --from-literal=AWS_SECRET_ACCESS_KEY=<s3 secret key> \
    --from-literal=AWS_ENDPOINTS='https://object.storage.eu01.onstackit.cloud' \
    -n longhorn-system
```

## Create Recurring Backup Job [optional]
```bash
kubectl apply -f recurringBackupJob.yaml
```
