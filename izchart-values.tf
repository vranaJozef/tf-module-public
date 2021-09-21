locals {
  izchart_values = {
    iz_rest_replicaCount: "1"
    iz_gps_replicaCount: "1"
    iz_md_replicaCount: "1"
    iz_dwh_replicaCount: "1"
    iz_lu_replicaCount: "1"
    iz_lu_version: "master"
    iz_polar_replicaCount: "1"
    iz_kodiak_replicaCount: "1"
    iz_task_replicaCount: "1"
    iz_w_inflow_replicaCount: "1"
    iz_w_aggregate_replicaCount: "6"
    iz_w_aggregate_loaderMemSize: "1"
    iz_w_admin_replicaCount: "1"
    iz_w_transform_replicaCount: "1"
    iz_w_move_replicaCount: "1"
    iz_pdfexport_replicaCount: "1"
    iz_pdfexport_version: "latest"
    iz_client_replicaCount: "1"
    iz_store_replicaCount: "1"
    iz_store_packageversion: "iapd-593"
    iz_w_backup_replicaCount: "1"
    backupVolumeHandle: "fs-43c41c38"
    backupSchedule: var.backupSchedule
    backupSuspend: var.backupSuspend
    global: {
      tag: var.iz_version
      env: "production"
      cloud: "prod"
      k8senv: "eks"
      mode: "single"
      ssl: true
      uidev: false
      namespace: "prod"
      domain: var.ssl_domain
      auth0clientid: var.auth0cliendID
      auth0secret: var.auth0secret
    }
  }
}
