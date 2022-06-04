# k8s-pg.backup
Repository to backup the postgres database which is hosted inside kubernetes cluster. 


CronJob Manifest:
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: ds-pre-db-backup
  namespace: ds
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup-maker
            image: connorv001/pg-backup.k8s:latest
            envFrom:
            - configMapRef:
                name: config-env
            args:
            - /bin/bash
            - /do_backup.sh
            env:
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
          restartPolicy: OnFailure
```
