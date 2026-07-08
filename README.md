# 🚀 Rootless Kubernetes (k3d/k3s) GitOps Architecture Blueprint

This repository contains the declarative manifests and step-by-step infrastructure automation guidelines to provision a high-availability Kubernetes cluster inside an unprivileged user namespace (`UID 1000`). All cluster components, container runtimes, and image caches bypass the host primary operating system partition to write natively into an isolated, virtual `ext4` filesystem wrapper hosted on your designated storage directory.

---

## 🏗️ The Multi-Layer Architecture Layout

```text
+---------------------------------------------------------------------------------+

| Host Operating System: Linux (Debian/Ubuntu)                                    |
|   └── Mapped Virtual Disk: 250GB ext4 Image Pool (`$STORAGE_DIR/docker-files/`) |
|         └── Daemon Layer: Rootless Docker Engine (`unix:///run/user/1000/...`)   |
|               └── Orchestration: K3d Cluster Container (`my-rootless-cluster`)  |
|                     ├── Ingress Core: Native Traefik (Host Proxy Port 8080)     |
|                     └── GitOps Engine: Argo CD Controller (Namespace: argocd)    |
+---------------------------------------------------------------------------------+
```

---

## 📁 Repository Map

```text
ArgoCD-RootApps/
├── .gitignore               # Safe-keeps local cluster admin tokens, cache files, and passwords
├── .argocdignore           # Instructs Argo CD to ignore markdown/documentation edits
├── README.md                # Infrastructure orchestration manual (This file)
├── argocd-admin-password.txt # Extracted secure admin dashboard credentials (Git-ignored)
├── bootstrap/
│   └── root-application.yaml # The GitOps "Root App" pointing back to this repository
└── apps/
    └── scaled-web-app.yaml   # Scaled 4-Pod Nginx cluster workload & network configurations
```

---

## 🛠️ Step-by-Step Environment Provisioning Blueprint

If cloning this repository onto a fresh workstation, export your target directory variables and execute these steps in order to stand up the entire architecture layout:

```bash
# Define your target path (e.g., an external drive mount point or custom folder)
export STORAGE_DIR="/path/to/your/storage/mount"
export REPO_DIR="$STORAGE_DIR/github_projects/ArgoCD-RootApps"
```

### Step 1: Provision the Isolated 250GB Native ext4 File Wrapper
To prevent storage leakages onto your primary internal operating system drive, build a dedicated virtual block loop volume inside your external storage assembly:
```bash
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
Create `~/.config/docker/daemon.json` using `vi` and configure the data storage pointer:
```json
{
  "data-root": "$STORAGE_DIR/docker-files"
}
```
Restart your user-level systemd service manager to apply changes:
```bash
systemctl --user restart docker.service
```

### Step 3: Install the k3d Orchestration CLI (Truncation-Free)
Execute this command. The link components are glued together at execution time to ensure the installation address stays complete:
```bash
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

### Step 4: Stand up the Rootless Kubernetes Cluster
Spin up the rootless cluster. This bridges port `8080` from your laptop host interface to the internal Traefik load balancer, maps your manifest configurations, and enables unprivileged user namespace permissions inside K3s:
```bash
k3d cluster create my-rootless-cluster \
  --servers 1 \
  -p "8080:80@loadbalancer" \
  -v "$REPO_DIR/bootstrap:/var/lib/rancher/k3s/server/manifests@server:0" \
  --k3s-arg "--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:0"
```

### Step 5: Pre-Cache Runtimes and Inject into Node (Speed Hack)
To bypass slow data translation layers during startup image downloads, pre-pull your runtime engine blocks natively on the host Docker daemon and inject them directly into your cluster nodes using direct memory streaming:
```bash
docker pull alpine:latest
docker pull nginx:alpine
k3d image import alpine:latest nginx:alpine --cluster my-rootless-cluster --mode direct
```

### Step 6: Deploy Argo CD Framework Controls (Truncation-Free)
Stand up the Argo CD framework controller natively using this string-glued command to guarantee the manifest download address stays complete:
```bash
kubectl create namespace argocd && kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Step 7: Bootstrap the GitOps Pipeline Connection
Extract your administrative password file and register the Root Application file with the cluster to activate automated continuous monitoring and fleet self-healing:
```bash
# Extract the unique password block
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-admin-password.txt

# Manually apply the root application mapping file exactly one time
kubectl apply -f bootstrap/root-application.yaml
```

---

## 🔄 GitOps Operations Workflow

Once the environment steps are complete, manual `kubectl apply` commands for apps are obsolete. Infrastructure is changed entirely by declaring states within code files:

```text
[ vi Manifest Edit ] ──> [ git push origin main ] ──> [ Argo CD Auto-Poll ] ──> [ 4-Pod Fleet Self-Heal ]
```

To bypass Argo CD's default 180-second GitHub api polling delay and force an instantaneous infrastructure refresh, trigger the controller interface natively via your prompt:
```bash
kubectl patch application root-gitops-app -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"normal"}}}'
```
