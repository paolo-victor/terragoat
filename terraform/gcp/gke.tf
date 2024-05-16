data "google_compute_zones" "available_zones" {
  project = var.project
  region  = var.region
}

resource "google_container_cluster" "workload_cluster" {
  # Drata: Kubernetes provides an additional layer of security for sensitive data, such as Secrets, stored in etcd. Using this functionality, you can use a key managed by your Cloud provider to encrypt data at the etcd layer. This encryption protects against attackers who gain access to an offline copy of etcd. Ensure that [google_container_cluster.database_encryption.state] properties are correctly defined for encrypting secrets
  name               = "terragoat-${var.environment}-cluster"
  logging_service    = "none"
  location           = var.region
  initial_node_count = 1

  enable_legacy_abac       = true
  monitoring_service       = "none"
  remove_default_node_pool = true
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.public-subnetwork.name
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }
}

resource "google_container_node_pool" "custom_node_pool" {
  # Drata: Set [google_container_node_pool.management.auto_upgrade] to true to automatically update nodes in the cluster to the latest control plane version
  cluster  = google_container_cluster.workload_cluster.name
  location = var.region

  node_config {
    image_type = "Ubuntu"
  }
}
