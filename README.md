# k8s-pg.backup
Repository to backup the postgres database which is hosted inside kubernetes cluster. 

first configure your secrets here in this file called `secrets.yaml` : 
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secrets
  namespace: default
#make sure to encode them in b64
data:
  AWS_ACCESS_KEY_ID: [redacted]
  AWS_DEFAULT_REGION: [redacted]
  AWS_SECRET_ACCESS_KEY: [redacted]
  DB_BACKUP_PASSWORD: [redacted]
  POSTGRES_DB: [redacted]
  POSTGRES_HOST: [redacted]
  POSTGRES_PASSWORD: [redacted]
  POSTGRES_USER: [redacted]
  S3_BACKUP_PATH: [redacted]
type: Opaque

```
you'll also need a config-map
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-env
  namespace: default
data:
  AWS_ACCESS_KEY_ID: 
  AWS_DEFAULT_REGION: 
  AWS_SECRET_ACCESS_KEY: 
  DB_BACKUP_PASSWORD:
  POSTGRES_DB: 
  POSTGRES_HOST: 
  POSTGRES_PASSWORD: 
  POSTGRES_USER: 
  S3_BACKUP_PATH: 

```

CronJob Manifest:
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: safe-backup
  namespace: default
spec:
  schedule: 0 2 * * *
  concurrencyPolicy: Allow
  suspend: false
  jobTemplate:
    metadata:
      creationTimestamp: null
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
            - name: backup-maker
              image: connorv001/pg-k8s.backup:latest
              args:
                - /bin/bash
                - /do_backup.sh
              envFrom:
                - configMapRef:
                    name: config-env
              env:
                - name: POSTGRES_DB
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: POSTGRES_DB
                - name: POSTGRES_USER
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: POSTGRES_USER
                - name: POSTGRES_HOST
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: POSTGRES_HOST
                - name: POSTGRES_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: POSTGRES_PASSWORD
                - name: AWS_ACCESS_KEY_ID
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: AWS_ACCESS_KEY_ID
                - name: AWS_SECRET_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: AWS_SECRET_ACCESS_KEY
                - name: AWS_DEFAULT_REGION
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: AWS_DEFAULT_REGION
                - name: DB_BACKUP_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: DB_BACKUP_PASSWORD
                - name: S3_BACKUP_PATH
                  valueFrom:
                    secretKeyRef:
                      name: secrets
                      key: S3_BACKUP_PATH
              resources: {}
              terminationMessagePath: /dev/termination-log
              terminationMessagePolicy: File
              imagePullPolicy: Always


```
