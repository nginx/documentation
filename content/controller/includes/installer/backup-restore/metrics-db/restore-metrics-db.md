Restore the backup copy of the metrics database following the steps for your volume type:

- **Local**: Copy the data you backed up to `/opt/nginx-controller/clickhouse_data`.

- **NFS**: Copy the ClickHouse binary data in the NFS path. Refer to the official ClickHouse documentation on [Data Backup](https://clickhouse.tech/docs/en/operations/backup/).

- **EBS**: For AWS, refer to the [Amazon EBS snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html) documentation to restore a volume snapshot.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-269 -->