# Axion Cloud Infrastructure: Architecture & Deployment Guide

Welcome to the Axion Infrastructure documentation. This guide provides a complete overview of our cloud environment. 

To make this architecture accessible to both technical and non-technical readers, i have structured this document using a **"Secure Corporate Campus" analogy**, while providing all the exact technical specifications (IPs, subnets, ports) required for engineers and administrators.

---

## 📋 1. Executive Summary

| Item | Value |
| :--- | :--- |
| **Cloud Provider** | Microsoft Azure |
| **Environment** | Development (Dev) |
| **Region** | Japan East |
| **Architecture** | Hub-Spoke |
| **Application Type** | 3-Tier Monolithic (Frontend, Backend, Database) |
| **Infrastructure as Code** | Terraform |
| **Terraform Pattern** | Modules + `for_each` + `map(object)` |

---

## 🏢 2. The Hub & Spoke Concept (The Campus Analogy)

We use a **Hub-Spoke** network topology. Think of it as a secure corporate campus:
*   **The Hub (Headquarters):** The central command center. It handles all security, entry points (Bastion), and shared storage. It does not run the application.
*   **The Spoke (Innovation Lab):** The dedicated workspace where the actual Axion and Todo applications live.
*   **VNet Peering:** A private, high-speed bridge connecting the Headquarters to the Lab, ensuring secure communication without touching the public internet.

### 2.1 Resource Groups (The Filing Cabinets)
*   **Hub:** `axion-rg-hub-dev`
*   **Spoke:** `axion-rg-spoke-dev`

### 2.2 VNet IP Addressing (The Private Estates)
*   **Hub VNet:** `axion-vnet-hub-dev` (`10.0.0.0/16`)
*   **Spoke VNet:** `axion-vnet-spoke-dev` (`192.168.0.0/16`)
*   *Note: These CIDR ranges do not overlap, ensuring seamless routing between the two networks.*

---

## 🗺️ 3. Network Topology & Subnet Design

### 3.1 Subnet IP Ranges (The Rooms)

| Tier / Purpose | Subnet Name | CIDR Range |
| :--- | :--- | :--- |
| **Bastion** | `AzureBastionSubnet` | `10.0.1.0/26` |
| **Frontend** | `axion-frontend-Subnet-spoke-dev` | `192.168.1.0/24` |
| **Backend** | `axion-backend-Subnet-spoke-dev` | `192.168.2.0/24` |
| **Database** | `axion-database-Subnet-spoke-dev` | `192.168.3.0/24` |

### 3.2 VNet Peering (The Private Bridge)
We have two active peerings to ensure bidirectional communication:
*   `axion-hub-to-spoke-peering`
*   `axion-spoke-to-hub-peering`

```text
       HUB VNET (10.0.0.0/16)
       └── AzureBastionSubnet (10.0.1.0/26)
              |
              |  (VNet Peering)
              |
       SPOKE VNET (192.168.0.0/16)
       ├── Frontend (192.168.1.0/24)
       ├── Backend  (192.168.2.0/24)
       └── Database (192.168.3.0/24)
```

---

## 🔐 4. Access & Security (The Security Guards)

### 4.1 Azure Bastion (The Secure Front Door)
Administrators do not connect to VMs via the public internet. Instead, they use Azure Bastion.
*   **Bastion Host:** `axion-bastion-dev`
*   **Bastion Subnet:** `AzureBastionSubnet` (`10.0.1.0/26`)
*   **Bastion PIP:** `axion-pip-bastion-dev` *(Note: Numeric Public IP not recorded)*

**Admin Flow:**
`Administrator` → `Bastion Public IP` → `Azure Bastion` → `Hub VNet` → `VNet Peering` → `Spoke VNet` → `Target VM`

### 4.2 Network Security Groups (NSGs)
NSGs act as internal security guards for each subnet, enforcing strict traffic rules.

*   **Frontend NSG (`axion-frontend-nsg`):**
    *   Allows: Internet → Frontend (TCP 80, 443)
*   **Backend NSG (`axion-backend-nsg`):**
    *   Allows: Frontend Subnet → Backend Subnet (TCP 8080)
*   **Database NSG (`axion-database-nsg`):**
    *   Allows: Backend Subnet → Database Subnet (TCP 1433)

---

## ⚖️ 5. Load Balancing & Traffic Flow

We have exactly **2 Load Balancers** to ensure high availability and smooth traffic distribution.

### 5.1 Public Load Balancer (The Reception Desk)
*   **Name:** `axion-lb-frontend-dev`
*   **Type:** Public
*   **Public IP:** `20.222.143.16` (Resource: `axion-pip-frontend-lb-dev`)
*   **Port:** 80
*   **Backend:** Frontend VM (`192.168.1.4:80`)
*   **Health Probe:** HTTP on Port 80, Path `/` (`axion-lb-frontend-dev-health-probe`)
*   **Rule:** `axion-lb-frontend-dev-http-rule` (TCP 80 → 80)

### 5.2 Internal Load Balancer (The Traffic Cop)
*   **Name:** `axion-lb-backend-dev`
*   **Type:** Internal
*   **Private IP:** `192.168.2.10` (Located in Backend Subnet)
*   **Port:** 8080
*   **Backend Pool:** `axion-backend-nic-01`, `axion-backend-nic-02`
*   **Health Probe:** HTTP on Port 8080, Path `/` (`axion-lb-backend-dev-health-probe`)
*   **Rule:** `axion-lb-backend-dev-http-rule` (TCP 8080 → 8080)

### 5.3 Complete Port Matrix & Data Flow

| Source | Destination | Port | Purpose |
| :--- | :--- | :--- | :--- |
| Internet | Public LB | 80, 443 | HTTP / HTTPS |
| Public LB | Frontend VM | 80 | Web Traffic |
| Frontend VM | Internal LB | 8080 | Backend API Call |
| Internal LB | Backend VM-01 | 8080 | API Traffic |
| Internal LB | Backend VM-02 | 8080 | API Traffic |
| Backend VMs | Database VM | 1433 | SQL Server Data |

**Visual Data Flow:**
```text
                         INTERNET
                            |
                            | 80/443
                            v
                  +---------------------+
                  | PUBLIC LOAD BALANCER|
                  | 20.222.143.16       |
                  | :80                 |
                  +----------+----------+
                             |
                             | :80
                             v
                  +---------------------+
                  | FRONTEND VM         |
                  | 192.168.1.4         |
                  +----------+----------+
                             |
                             | :8080
                             v
                  +---------------------+
                  | INTERNAL LOAD BAL.  |
                  | 192.168.2.10        |
                  | :8080               |
                  +----------+----------+
                             |
                       +-----+-----+
                       |           |
                       v           v
                 +---------+   +---------+
                 |Backend01|   |Backend02|
                 | :8080   |   | :8080   |
                 +----+----+   +----+----+
                       |           |
                       +-----+-----+
                             |
                             | :1433
                             v
                  +---------------------+
                  | DATABASE VM         |
                  | 192.168.3.0/24      |
                  +---------------------+
```

---

## 💻 6. Compute Inventory (The Workers)

We have a total of **4 Virtual Machines** and **4 Network Interface Cards (NICs)**.

| Tier | VM Name | NIC Name | Count |
| :--- | :--- | :--- | :--- |
| **Frontend** | `axion-frontend-vm-01` | `axion-frontend-nic-01` | 1 |
| **Backend** | `axion-backend-vm-01` | `axion-backend-nic-01` | 1 |
| **Backend** | `axion-backend-vm-02` | `axion-backend-nic-02` | 1 |
| **Database** | `axion-database-vm-01` | `axion-database-nic-01` | 1 |
| **Total** | **4 VMs** | **4 NICs** | |

---

## 💾 7. Storage Infrastructure

It is crucial to distinguish between the application storage and the Terraform state storage.

### 7.1 Application Storage (The Warehouse)
*   **Storage Account:** `axionstorage06`
*   **Location:** `axion-rg-hub-dev` (Hub Resource Group)
*   **Purpose:** Part of the Axion infrastructure for application data, logs, or backups.

### 7.2 Terraform Backend State (The Blueprints)
*   **Storage Account:** `rakshakstg1`
*   **Container:** `tfstate`
*   **State File:** `dev.terraform.tfstate`
*   **Backend RG:** `RakshakCi_Rg_pls_do_not_delete_it`
*   *Note: This is strictly for Terraform's internal state management and is completely separate from the Axion application infrastructure.*

---

## 🌐 8. Final IP Plan Reference

| Component | IP / CIDR |
| :--- | :--- |
| **Hub VNet** | `10.0.0.0/16` |
| **Bastion Subnet** | `10.0.1.0/26` |
| **Spoke VNet** | `192.168.0.0/16` |
| **Frontend Subnet** | `192.168.1.0/24` |
| **Frontend VM** | `192.168.1.4` |
| **Backend Subnet** | `192.168.2.0/24` |
| **Internal LB** | `192.168.2.10` |
| **Database Subnet** | `192.168.3.0/24` |
| **Frontend Public LB** | `20.222.143.16` |
| **Bastion Public IP** | `axion-pip-bastion-dev` *(Numeric IP not recorded)* |

---

## 9. Next Steps

**Infrastructure Status:** **Complete**
The networking, security, load balancing, and compute foundation is fully built and ready.

**Next Steps (Application Deployment):**
The "building" is ready, but we need to "move the furniture in." To make the Axion and Todo apps live, we must:
1.  **Deploy Application Code:** Install the Axion and Todo software onto the Frontend, Backend, and Database VMs.
2.  **Configure Key Vault:** Create a secure digital safe for passwords and connection strings.
3.  **Set up Private DNS:** Create an internal phonebook so VMs can find each other by name (e.g., `db.axion.internal`).
4.  **End-to-End Testing:** Verify that traffic flows correctly from the Internet → Public LB → Frontend → Internal LB → Backend → Database.
