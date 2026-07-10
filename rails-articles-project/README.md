# 📰 Rails 8 GitOps Blog Template Blueprint

A production-ready, minimal Ruby on Rails 8 blogging template architecture engine. Hardened with native standalone Tailwind CSS v4, SQLite persistent data layouts, Active Storage image modules, and fully orchestrated via an automated GitHub Actions CI/CD pipeline straight to a live Kubernetes (K3s) cluster via ArgoCD.

---

## 🏛️ Architecture Overview & How It Works

This repository is structured as a unified GitOps ecosystem that separates your active development code from your production infrastructure parameters while keeping them contained within a single repository:

1. **The Codebase Core (`rails-articles-project/`)**: A pure, standalone Rails 8 application setup. It runs locally on your PC, compiles static files using Propshaft, and packages into a lightweight multi-stage Docker layer on push.
2. **The GitOps Orchestrator (`argocd-apps/` & `bootstrap/`)**: Leverages the **App-of-Apps Pattern**. A master controller application monitors the repository and dynamically provisions independent child application cards (`rails-gallery-app` and `project-web-app`) to completely isolate system lifecycles.
3. **The Variable-Driven Blueprint (`rails-app-chart/`)**: A production-grade **Helm Chart** package. Instead of hardcoding drive names, values are managed dynamically inside a central `values.yaml` file, supporting effortless adjustments for multi-environment (Dev/Prod) cluster instances.
4. **Anonymized Infrastructure (`k3d-config.yaml`)**: Uses environment variables inside a native cluster setup script. Your private drive layout is hidden from Git using K3s `local-path` dynamic volume provisioners.

---

## 🚀 Key Feature Layers
- **Native Authentication 🔐**: Built-in Rails 8 session, username registration, and standalone password recovery card modules without heavy third-party dependencies.
- **Dynamic Media Uploads 🖼️**: Active Storage image attachment module with native system image processing (`vips`) and complete file purges.
- **Global Validation Gates ⏳**: Strict 10-character validation gates backed up by automated flash warning notification banners.
- **Authorship Authorization 👤**: Strict resource protection gates restricting editing and deletion actions exclusively to account authors.
- **Super Admin Bypass 👑**: Built-in global override capabilities assigned natively via a backend role boolean check (`admin: true`).

---

## 🛠️ Local Workstation Control Commands

Always execute development sessions exclusively from inside your local **`rails-articles-project/`** folder workspace using these command controls:

```bash
# 1. Spin up your asset-aware unified developer watchers preview session
bin/dev

# 2. Fire structural database schema alterations onto your development database
bin/rails db:migrate

# 3. Open the interactive system console shell to overwrite parameters directly
bin/rails console
```

---

## ⚡ High-Performance SQLite3 Optimization
To scale a serverless database engine smoothly inside a containerized Kubernetes pod, `config/database.yml` utilizes high-performance production pragmas:
- **WAL Mode (`journal_mode: wal`)**: Enables Write-Ahead Logging so concurrent database reads and writes execute simultaneously without throwing file-locking contentions.
- **Synchronous Settings (`synchronous: normal`)**: Balances data integrity and disk synchronization frequencies on containerized local-path storage sectors.
- **Memory Maps (`mmap_size: 134217728`)**: Maps a 128MB fast memory block directly in RAM for rapid database indexing and high-speed query retrievals.

---

## 🏗️ Production GitOps Pipeline Deployment Loop

Whenever you make structural view layout or controller logic adjustments, execute this unified command sequence from your **repository root directory** to commit your code, build the container image, and sync your cluster over port `8080`:

```bash
# 1. Stage, commit, and push your unified codebase modifications
git add . && git commit -m "feat: deploy system upgrades to production" && git push origin main

# 2. Build your production container layer directly from your repository root context
cd rails-articles-project && docker build -t ivaylob84/rails-gallery:latest . && docker push ivaylob84/rails-gallery:latest && cd ..

# 3. Bypass the 3-minute ArgoCD polling delay to trigger an instant cluster refresh
kubectl patch application root-bootstrap-app -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"normal"}}}'
```

### ⏳ Pod Rollout Lifecycle Management
Because your production Helm chart is configured with a strict `Recreate` deployment strategy, the cluster handles lifecycles gracefully without volume locking conflicts:
1. Pushing a new container image will trigger the cluster rollout.
2. The running Rails pod terminates automatically, releasing its volume disk lock and flushing existing SQLite tables cleanly.
3. The fresh container initializes onto your persistent **10Gi** storage block and automatically fires `bin/rails db:migrate` on boot.

---

## 🌱 Database State Seeding & Emergency Recovery

The project includes a secure, variable-driven seeder inside `db/seeds.rb` that protects your real credentials from public GitHub history. 

If your volume structure ever resets or you need to bootstrap a fresh administrator profile, identify your active running pod name via `kubectl get pods` and run this secure runtime injection command:

```bash
kubectl exec -it <your-active-pod-name> -n default -- env ADMIN_SEED_PASSWORD="your_private_password" ADMIN_SEED_EMAIL="your-email@domain.com" bin/rails db:seed -e production
```

---

## 📁 System Configuration Checkpoints
- **Routing Scope Mapping**: Everything is nested securely within the `/rails` parent scope path inside `config/routes.rb` to align perfectly with Traefik ingress paths.
- **Persistent Storage Volumes**: SQLite data and uploaded image binaries share a resilient, persistent `rails-sqlite-pvc` hard drive slice scaled to **10Gi** and managed by the `local-path` storage class.
- **Docker Build Context**: Operates using a secure minimal Alpine Linux footprint backed up by official build-time fallback dummy cryptographic keys (`SECRET_KEY_BASE_DUMMY=1`).
