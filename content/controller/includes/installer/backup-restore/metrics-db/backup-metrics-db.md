Make a backup copy of the metrics database following the steps for your volume type:

- **Local**: Make a back up copy of the metrics data that's located in `/opt/nginx-controller/clickhouse_data` by default, or on the volume that you specified when installing NGINX Controller.

- **NFS**: Make a backup copy of all of the data in the NFS path or make a copy of the ClickHouse binary data. Refer to the official ClickHouse documentation on [Data Backup](https://clickhouse.tech/docs/en/operations/backup/).

- **EBS**: For AWS, refer to the [Amazon EBS snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html) documentation to create a volume snapshot.
- 
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-268 -->