# Rootless Kubernetes (k3d/k3s) GitOps Architecture Blueprint

This repository contains declarative manifests, parameterized Helm charts, and automation guidelines to provision a high-availability, fully anonymized Kubernetes development cluster inside an unprivileged user namespace. All cluster components, container runtimes, and image caches bypass the host's primary operating system partition to write natively into isolated, virtual storage layers.

---

## The Multi-Layer Architecture Layout

```text
+---------------------------------------------------------------------------------+

| Host Operating System: Linux (Debian/Ubuntu)                                    |
|   └── Mapped Virtual Disk: Isolated Virtual Image Loop Pool File                |
|         └── Daemon Layer: Rootless Docker Engine Namespace Execution Wrapper    |
|               └── Orchestration: Declarative K3d Cluster (`my-rootless-cluster`)|
|                     ├── Ingress Core: Native Traefik (Host Proxy Port 8080)     |
|                     └── GitOps Engine: Argo CD Controller (Namespace: argocd)   |
+---------------------------------------------------------------------------------+
```

---

## Repository Structural Map

```text
ArgoCD-RootApps/
├── .gitignore                # Safe-keeps environment scripts, local runtime cache, and passwords
├── .argocdignore             # Instructs Argo CD to completely ignore markdown/documentation edits
├── README.md                 # Master infrastructure manual (This file)
├── k3d-config.yaml           # Declarative cluster lifecycle configuration schema blueprint
├── start-cluster.sh          # Private machine-specific start script (Git-ignored)
├── argocd-admin-password.txt # Extracted secure admin dashboard credentials (Git-ignored)
├── argocd-apps/              # The GitOps Child Application Registry
│   ├── rails-app.yaml        # Tracks values-driven Rails 8 Gallery application parameters
│   └── web-app.yaml          # Tracks lightweight Nginx test application parameters
├── apps/                     # Complete Core Cluster Manifests (Backups, Secrets, Deployments)
│   ├── rails-app.yaml        # High-Availability Rails deployment with rolling update strategy
│   ├── rails-backup-cronjob.yaml # Automated GFS backup script with SQLite checkpoint flushing
│   └── rails-sealed-secrets.yaml # Encrypted client-side application keys managed via kubeseal
├── bootstrap/                # Master Cluster Initialization Framework
│   └── root-application.yaml # Master parent "Root App" targeting the argocd-apps/ registry
├── rails-app-chart/          # Parameterized Rails 8 Production Helm Chart Blueprint
└── rails-articles-project/   # Ruby on Rails 8 Application Core Source Code Workspace
```

---

## Step-by-Step Environment Provisioning Blueprint

If cloning this repository onto a fresh workstation, define your local machine paths using environment variables to keep your infrastructure definitions generic and shared.

### Step 1: Provision an Isolated Virtual Disk Allocation Loop Mount
To prevent storage leakages onto your primary internal operating system drive, build a dedicated virtual block loop volume inside your designated storage assembly:
```bash
# Export target paths for your local directory contexts
export STORAGE_DIR="/your/target/private/storage/directory"
export REPO_DIR="${STORAGE_DIR}/your-project-root/ArgoCD-RootApps"

mkdir -p "$STORAGE_DIR/docker-files"
dd if=/dev/zero of="$STORAGE_DIR/docker-disk.img" bs=1M count=250000
mkfs.ext4 "$STORAGE_DIR/docker-disk.img"
sudo mount -o loop "$STORAGE_DIR/docker-disk.img" "$STORAGE_DIR/docker-files"
sudo chown -R $UID:$GID "$STORAGE_DIR/docker-files"
```

### Step 2: Install and Point Rootless Docker to the Loop Mount
Install the rootless Docker utility framework and configure its core daemon configuration mapping file to write its runtime layers exclusively onto your newly mounted loop directory:
```bash
curl -fsSL https://docker.com | sh
mkdir -p ~/.config/docker
```
Create `~/.config/docker/daemon.json` and configure the data storage pointer target:
```json
{
  "data-root": "/your/target/private/storage/directory/docker-files"
}
```
Restart your user-level systemd service manager to apply changes:
```bash
systemctl --user restart docker.service
```

### Step 3: Configure Your Declarative Cluster Blueprints
To keep the main configuration file completely generic and clean for public version control tracking, the repository leverages a declarative cluster manifest. Create your `k3d-config.yaml` file at the root of the project:

```yaml
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: my-rootless-cluster
servers: 1
ports:
  - port: 8080:80
    nodeFilters:
      - loadbalancer
volumes:
  - volume: ${REPO_DIR}/bootstrap:/var/lib/rancher/k3s/server/manifests
    nodeFilters:
      - server:0
options:
  k3s:
    extraArgs:
      - arg: --kubelet-arg=feature-gates=KubeletInUserNamespace=true
        nodeFilters:
          - server:0
```

### Step 4: Stand Up the Local Environment via the Automation Script
To run this setup safely without exposing local partitions, create a local automation helper script named `start-cluster.sh` at your repository root. Note: Ensure this file is added to your `.gitignore` to prevent leakage.

```bash
#!/bin/bash
set -e

export STORAGE_DIR="/your/target/private/storage/directory"
export REPO_DIR="${STORAGE_DIR}/your-project-root/ArgoCD-RootApps"

if [ ! -d "$STORAGE_DIR" ] || [ ! -f "${REPO_DIR}/k3d-config.yaml" ]; then
    echo "Pre-flight checks failed. Verify folder structures and files."
    exit 1
fi

if k3d cluster list my-rootless-cluster >/dev/null 2>&1; then
    echo "Cluster already exists. Skipping creation."
else
    k3d cluster create --config "${REPO_DIR}/k3d-config.yaml"
fi
```
Grant execution controls and spin up your cluster with a single instruction:
```bash
chmod +x start-cluster.sh
./start-cluster.sh
```

### Step 5: Install Argo CD Framework Controls (Truncation-Free)
Stand up the Argo CD framework controller components natively using this string-glued command to guarantee the manifest download address stays complete:
```bash
kubectl create namespace argocd && kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Step 6: Deploy Secret Encryption Components
Install the cluster-side Sealed Secrets controller framework to handle declarative one-way cryptographic key translation natively within your namespace:
```bash
kubectl apply -f https://github.com
```

### Step 7: Bootstrap the App-of-Apps GitOps Pipeline Connection
Extract your administrative password file and register the master root bootstrap application file with the cluster to activate automated continuous monitoring, dashboard isolation, and fleet self-healing:
```bash
# Extract the unique initial administrative password block safely to an ignored text file
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-admin-password.txt

# Manually apply the master parent application blueprint file exactly one time
kubectl apply -f bootstrap/root-application.yaml
```

---

## GitOps Operations Workflow

Once the environment initialization steps are complete, manual `kubectl apply` commands are obsolete. Cluster infrastructure and application structures are managed entirely by declaring desired states within your Git workspace files:

```text
[ Code / Manifest Edit ] ──> [ git push origin main ] ──> [ Argo CD Auto-Poll ] ──> [ Automated Resource Synced ]
```

To bypass Argo CD's default 3-minute GitHub API polling delay and force an instantaneous sync of your entire project topology tree, execute this direct patch command:
```bash
kubectl patch application root-bootstrap-app -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"normal"}}}'
```
