# 📰 Rails 8 GitOps Blog Template Blueprint

A production-ready, minimal Ruby on Rails 8 blogging template architecture engine. Hardened with native standalone Tailwind CSS v4, SQLite persistent data layouts, Active Storage image modules, and fully orchestrated via an automated GitHub Actions CI/CD pipeline straight to a live Kubernetes (K3s) cluster via ArgoCD.

---

## 🏛️ Architecture Overview & How It Works

This project is structured as a component inside a unified GitOps ecosystem that separates your active development code from production infrastructure parameters:

1. **The Codebase Core (`rails-articles-project/`)**: A standalone Rails 8 application setup. It runs locally on your PC, compiles static files using Propshaft, and packages into a lightweight multi-stage Docker layer on push.
2. **The GitOps Orchestrator**: Managed via the parent repository's master controller application using the **App-of-Apps Pattern** to monitor repository states and isolate lifecycles.
3. **The Parameterized Blueprint (`rails-app-chart/`)**: A production-grade **Helm Chart** package located outside this folder that dynamically maps ingress routing, persistent claims, and custom scrapers.

---

## 🚀 Key Feature Layers
- **Native Authentication 🔐**: Built-in Rails 8 session, username registration, and standalone password recovery card modules without heavy third-party dependencies.
- **Dynamic Media Uploads 🖼️**: Active Storage image attachment module with native system image processing (`vips`) and complete file purges.
- **Global Validation Gates ⏳**: Strict 10-character validation gates backed up by automated flash warning notification banners.
- **Authorship Authorization 👤**: Strict resource protection gates restricting editing and deletion actions exclusively to account authors.
- **Super Admin Bypass 👑**: Built-in global override capabilities assigned natively via a backend role boolean check (`admin: true`).

---

## 🛠️ Local Workstation Control Commands

Always execute development sessions exclusively from inside this **`rails-articles-project/`** folder workspace using these command controls:

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

## 📊 Telemetry and Custom Prometheus Monitoring
The application includes integrated performance metrics hooks to stream system data directly to Grafana over port `8888`:
- **Middleware Exporter**: Powered by the `prometheus-client` engine initialized via `config/initializers/prometheus.rb` to render raw application statistics on the `/metrics` path.
- **ServiceMonitor Scraper**: Deployed natively inside the Helm templates layer with the correct labels (`release: cluster-monitoring-app`) to let the Prometheus Operator dynamically fetch performance data logs every 15 seconds.

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
