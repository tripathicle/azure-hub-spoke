# Enterprise Axion Azure Hub-Spoke Infrastructure (Dev)

This repository contains production-grade Terraform code designed to deploy a one-click, modular **Hub-and-Spoke Network Architecture** on Microsoft Azure. Engineered for an enterprise 3-tier monolithic application in the `Japan East` region (`Dev` environment), this setup encapsulates strict micro-segmentation, centralized administrative access via Azure Bastion, and distributed load balancing.

---

## Architectural Topology & Traffic Flow

```text
                               INTERNET
                                  |
                                  | TCP 80 / 443
                                  v
                      +-----------------------+
                      | PUBLIC LOAD BALANCER  |
                      | 20.222.143.16         |
                      | :80                   |
                      +-----------+-----------+
                                  |
                                  | TCP 80
                                  v
                      +-----------------------+
                      | FRONTEND VM           |
                      | 192.168.1.4           |
                      +-----------+-----------+
                                  |
                                  | TCP 8080
                                  v
                      +-----------------------+
                      | INTERNAL LOAD BAL.    |
                      | 192.168.2.10          |
                      | :8080                 |
                      +-----------+-----------+
                                  |
                           +------+------+
                           |             |
                           v             v
                     +-----------+ +-----------+
                     | BACKEND01 | | BACKEND02 |
                     | :8080     | | :8080     |
                     +-----+-----+ +-----+-----+
                           |             |
                           +------+------+
                                  |
                                  | TCP 1433
                                  v
                      +-----------------------+
                      | DATABASE VM           |
                      | DB Subnet             |
                      | 192.168.3.0/24        |
                      +-----------------------+

             HUB                                  SPOKE
        10.0.0.0/16                           192.168.0.0/16
   +-------------------+                 +-------------------+
   | Azure Bastion     |  VNet Peering   | Frontend, Backend |
   | 10.0.1.0/26       |<--------------->| & Database Tiers  |
   +-------------------+                 +-------------------+

```text
---

Architecture Highlights
Hub-and-Spoke Separation: Isolates management tools (Azure Bastion, shared storage) in axion-rg-hub-dev while strictly separating business compute layers inside axion-rg-spoke-dev.

Zero Public IP Compute: Virtual machines across Frontend, Backend, and Database tiers carry no direct Public IP addresses for administration. Operations access is entirely tunneled via Azure Bastion over VNet Peering.

Micro-Segmented Security: Strict Network Security Groups (NSGs) bound to individual subnets ensure that only explicit port paths (80/443 → 8080 → 1433) are open between tiers.

Automated Scalability & High Availability: Backend application instances (axion-backend-vm-01 & axion-backend-vm-02) run behind an Internal Load Balancer utilizing HTTP health probes.

---

========================================================================================================
                                     CIDR MASTER PLAN & IP SCHEME
========================================================================================================
SCOPE / COMPONENT        | NAME                             | CIDR / IP ADDRESS  | RESOURCE GROUP
-------------------------+----------------------------------+--------------------+----------------------
Hub VNet                 | axion-vnet-hub-dev               | 10.0.0.0/16        | axion-rg-hub-dev
Bastion Subnet           | AzureBastionSubnet               | 10.0.1.0/26        | axion-rg-hub-dev
Spoke VNet               | axion-vnet-spoke-dev              | 192.168.0.0/16     | axion-rg-spoke-dev
Frontend Subnet          | axion-frontend-Subnet-spoke-dev  | 192.168.1.0/24     | axion-rg-spoke-dev
Frontend VM Private IP   | axion-frontend-vm-01             | 192.168.1.4        | axion-rg-spoke-dev
Backend Subnet           | axion-backend-Subnet-spoke-dev   | 192.168.2.0/24     | axion-rg-spoke-dev
Internal LB IP           | axion-lb-backend-dev             | 192.168.2.10       | axion-rg-spoke-dev
Database Subnet          | axion-database-Subnet-spoke-dev  | 192.168.3.0/24     | axion-rg-spoke-dev
Frontend Public IP       | axion-pip-frontend-lb-dev        | 20.222.143.16      | axion-rg-spoke-dev
Bastion Public IP        | axion-pip-bastion-dev            | Dynamic / Static   | axion-rg-hub-dev
========================================================================================================
---

📌 Architecture Highlights
Hub-and-Spoke Separation: Isolates management tools (Azure Bastion, shared storage) in axion-rg-hub-dev while strictly separating business compute layers inside axion-rg-spoke-dev.

Zero Public IP Compute: Virtual machines across Frontend, Backend, and Database tiers carry no direct Public IP addresses for administration. Operations access is entirely tunneled via Azure Bastion over VNet Peering.

Micro-Segmented Security: Strict Network Security Groups (NSGs) bound to individual subnets ensure that only explicit port paths (80/443 → 8080 → 1433) are open between tiers.

Automated Scalability & High Availability: Backend application instances (axion-backend-vm-01 & axion-backend-vm-02) run behind an Internal Load Balancer utilizing HTTP health probes.
---

🌐 IP Addressing & Subnet Specification
Plaintext
========================================================================================================
                                     CIDR MASTER PLAN & IP SCHEME
========================================================================================================
SCOPE / COMPONENT        | NAME                             | CIDR / IP ADDRESS  | RESOURCE GROUP
-------------------------+----------------------------------+--------------------+----------------------
Hub VNet                 | axion-vnet-hub-dev               | 10.0.0.0/16        | axion-rg-hub-dev
Bastion Subnet           | AzureBastionSubnet               | 10.0.1.0/26        | axion-rg-hub-dev
Spoke VNet               | axion-vnet-spoke-dev              | 192.168.0.0/16     | axion-rg-spoke-dev
Frontend Subnet          | axion-frontend-Subnet-spoke-dev  | 192.168.1.0/24     | axion-rg-spoke-dev
Frontend VM Private IP   | axion-frontend-vm-01             | 192.168.1.4        | axion-rg-spoke-dev
Backend Subnet           | axion-backend-Subnet-spoke-dev   | 192.168.2.0/24     | axion-rg-spoke-dev
Internal LB IP           | axion-lb-backend-dev             | 192.168.2.10       | axion-rg-spoke-dev
Database Subnet          | axion-database-Subnet-spoke-dev  | 192.168.3.0/24     | axion-rg-spoke-dev
Frontend Public IP       | axion-pip-frontend-lb-dev        | 20.222.143.16      | axion-rg-spoke-dev
Bastion Public IP        | axion-pip-bastion-dev            | Dynamic / Static   | axion-rg-hub-dev
========================================================================================================
---

🔐 Complete Port Matrix & Network Security

===================================================================================================================================
                                              PORT MATRIX & NETWORK SECURITY
===================================================================================================================================
SOURCE          | DESTINATION                      | PROTOCOL / PORT | PURPOSE                          | ENFORCED BY
----------------+----------------------------------+-----------------+----------------------------------+--------------------------
Internet        | Frontend Public LB (20.222.143.16)| TCP 80, 443     | Web Traffic Ingestion            | axion-frontend-nsg
Public LB       | Frontend VM (192.168.1.4)        | TCP 80          | Forwarded HTTP Load Balancing    | axion-frontend-nsg
Frontend Subnet | Internal LB (192.168.2.10)       | TCP 8080        | Backend API Routing              | axion-backend-nsg
Internal LB     | Backend Pool (VM-01, VM-02)      | TCP 8080        | API Load Distribution            | axion-backend-nsg
Backend Subnet  | Database Subnet (192.168.3.0/24) | TCP 1433        | Database Connections (SQL Server)| axion-database-nsg
Bastion Subnet  | All Spoke Subnets                | Local VNet      | Secure RDP/SSH Management        | VNet Peering
===================================================================================================================================
---
Resource Inventory
1. Compute & Network Interfaces
Total VMs (4):

axion-frontend-vm-01 (Frontend Tier)

axion-backend-vm-01 (Backend Tier)

axion-backend-vm-02 (Backend Tier)

axion-database-vm-01 (Database Tier)

Total NICs (4):

axion-frontend-nic-01

axion-backend-nic-01

axion-backend-nic-02

axion-database-nic-01

2. Load Balancers & Probes
===================================================================================================================
                                              LOAD BALANCERS & PROBES
===================================================================================================================
LOAD BALANCER         | TYPE     | IP / ASSOCIATION | HEALTH PROBE     | RULES
----------------------+----------+------------------+------------------+--------------------------------------------
axion-lb-frontend-dev | Public   | 20.222.143.16    | HTTP:80 (/)      | Frontend:80 → Backend:80 (TCP)
axion-lb-backend-dev  | Internal | 192.168.2.10     | HTTP:8080 (/)    | Frontend:8080 → Backend:8080 (TCP)
===================================================================================================================

3. Management & Storage Infrastructure
Azure Bastion Host: axion-bastion-dev deployed in AzureBastionSubnet (10.0.1.0/26).

Hub Storage Account: axionstorage06 (Located in axion-rg-hub-dev).

VNet Peering: Bidirectional peerings axion-hub-to-spoke-peering and axion-spoke-to-hub-peering.

🛠️ Infrastructure as Code (Terraform) Setup
This project uses modular Terraform configurations employing for_each and map(object) dynamic resource instantiation patterns.

Remote State Management Configuration
Note: Remote state management is maintained separately from the application infrastructure to ensure administrative isolation and zero state file corruption.

Resource Group: RakshakCi_Rg_pls_do_not_delete_it

Storage Account: rakshakstg1

Container Name: tfstate

State Key: dev.terraform.tfstate

🚀 One-Click Deployment Guide
Prerequisites
Azure CLI (>= 2.50.0) authenticated to the target subscription via az login.

Terraform CLI (>= 1.5.0).

Correct RBAC permissions (Contributor or Owner) on the target Azure subscription.

Execution Steps
# 1. Clone repository
git clone [https://github.com/your-org/axion-azure-infrastructure.git](https://github.com/your-org/axion-azure-infrastructure.git)
cd axion-azure-infrastructure

# 2. Initialize Terraform and connect to Azure Remote Backend
terraform init \
  -backend-config="resource_group_name=RakshakCi_Rg_pls_do_not_delete_it" \
  -backend-config="storage_account_name=rakshakstg1" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=dev.terraform.tfstate"

# 3. Validate configuration
terraform validate

# 4. Generate execution plan
terraform plan -out=tfplan

# 5. Provision complete Hub & Spoke architecture
terraform apply tfplan
