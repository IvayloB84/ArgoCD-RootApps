# Rails 8 GitOps Blog Template Blueprint

A production-ready, minimal Ruby on Rails 8 blogging template architecture engine. Hardened with native standalone Tailwind CSS v4, SQLite persistent data layouts, Active Storage image modules, and fully orchestrated via an automated GitHub Actions CI/CD pipeline straight to a live Kubernetes (K3s) cluster via ArgoCD.

---

## Architecture Overview & How It Works

This project is structured as a component inside a unified GitOps ecosystem that separates your active development code from production infrastructure parameters:

1. **The Codebase Core (`rails-articles-project/`)**: A standalone Rails 8 application setup. It runs locally on your PC, compiles static files using Propshaft, and packages into a lightweight multi-stage Docker layer on push.
2. **The GitOps Orchestrator**: Managed via the parent repository's master controller application using the **App-of-Apps Pattern** to monitor repository states and isolate lifecycles.
3. **The Parameterized Blueprint (`rails-app-chart/`)**: A production-grade **Helm Chart** package located outside this folder that dynamically maps ingress routing, persistent claims, and custom scrapers.

---

## Key Feature Layers
- **Native Authentication**: Built-in Rails 8 session authentication using cookie persistence. Includes a session resume fallback checkpoint (`before_action :resume_session`) to guarantee that your account stays securely logged in across all rollout updates and public page navigation cycles.
- **Dynamic Media Uploads**: Active Storage image attachment module with native system image processing (`vips`) and complete file purges.
- **Global Validation Gates**: Strict form validation rules enforced in the model and securely handled on form submission failures using a clean layout redirect block (`render :new, status: :unprocessable_entity`).
- **Form Error Notifications**: Built-in, clean HTML notification alerts right inside the form partial layout (`app/views/articles/_form.html.erb`) to automatically catch, count, and print validation failures onto the screen when fields are left blank.
- **Authorship Authorization**: Strict controller resource filter checkpoints (`before_action :ensure_author`) restricting editing, updating, and deletion actions exclusively to true account authors.
- **Super Admin Bypass**: Built-in global override capabilities assigned natively via a backend role boolean check (`Current.user&.admin?`).

---

## Local Workstation Control Commands

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

## High-Performance SQLite3 Optimization
To scale a serverless database engine smoothly inside a containerized Kubernetes pod, `config/database.yml` utilizes high-performance production pragmas:
- **WAL Mode (`journal_mode: wal`)**: Enables Write-Ahead Logging so concurrent database reads and writes execute simultaneously without throwing file-locking contentions.
- **Synchronous Settings (`synchronous: normal`)**: Balances data integrity and disk synchronization frequencies on containerized local-path storage sectors.
- **Memory Maps (`mmap_size: 134217728`)**: Maps a 128MB fast memory block directly in RAM for rapid database indexing and high-speed query retrievals.

---

## Database and Media Disaster Recovery Manual

The production application executes complete, data-consistent backup tasks automatically every midnight via a native Kubernetes CronJob (`apps/rails-backup-cronjob.yaml`). 

Before packaging the dataset, the worker automatically runs a transactional SQLite checkpoint flush (`PRAGMA wal_checkpoint(TRUNCATE);`) to safely force active memory logs directly out of the transient `-wal` caching shims into the physical file system. It then compiles the database file along with all deep multi-layer Active Storage image folders into a single compressed `.tar.gz` archive.

### Grandfather-Father-Son (GFS) Retention Rules:
- **Daily Archives**: Automatically evaluated and purged after **7 days** to minimize storage overhead.
- **Weekly Archives**: Saturday backups are automatically flagged and preserved for a full **30 days** before deletion to prevent data loss.

### Step-by-Step Restoration Procedure:
To restore a snapshot package without corrupting active threads or losing data consistency, follow these steps precisely:

1. Identify your target backup filename inside the container:
```bash
POD_NAME=\((kubectl get pods -n default -l app=rails-web -o jsonpath='{.items[0].metadata.name}') && kubectl exec -it\)POD_NAME -n default -c rails-container -- ls -la /app/storage
```

2. Run the total recovery block (replace `weekly_archive_YYYYMMDD_HHMMSS.tar.gz` with your filename). This completely clears transient cache sidecars, extracts the archived data states, flattens deep media paths, maps explicit container user permissions (`1000:1000`), and restarts your application pods:
```bash
export BACKUP_FILE="weekly_archive_YYYYMMDD_HHMMSS.tar.gz"

POD_NAME=\$(kubectl get pods -n default -l app=rails-web -o jsonpath='{.items[0].metadata.name}') && \
kubectl exec -it \(POD_NAME -n default -c rails-container -- sh -c "rm -f /app/storage/production.sqlite3-shm /app/storage/production.sqlite3-wal && rm -rf /tmp/restore_extract && mkdir -p /tmp/restore_extract && tar -xzf /app/storage/\){BACKUP_FILE} -C /tmp/restore_extract/ && cp -a /tmp/restore_extract/production.sqlite3 /app/storage/ && cp -a /tmp/restore_extract/media/* /app/storage/ 2>/dev/null || true && rm -rf /tmp/restore_extract && chown -R 1000:1000 /app/storage && echo 'RESTORE_COMPLETE'" && \
kubectl rollout restart deployment/rails-app-deployment -n default
```

---

## Telemetry and Custom Prometheus Monitoring
The application includes integrated performance metrics hooks to stream system data directly to Grafana over port `8888`:
- **Middleware Exporter**: Powered by the `prometheus-client` engine initialized via `config/initializers/prometheus.rb` to render raw application statistics on the `/metrics` path.
- **ServiceMonitor Scraper**: Deployed natively inside the Helm templates layer with the correct labels (`release: cluster-monitoring-app`) to let the Prometheus Operator dynamically fetch performance data logs every 15 seconds.

---

## Cryptographic Production Credentials Encryption
Plain-text application secrets (such as `SECRET_KEY_BASE`) are **never stored** inside this Git repository. Production keys are fully encrypted offline using **Bitnami Sealed Secrets** via your unique cluster public key certificate (`apps/pub-sealed-secrets.pem`). 

The resulting encrypted `SealedSecret` custom resource definition is safely tracked in version control at `apps/rails-sealed-secrets.yaml`. When applied to the cluster, the server-side sealed secrets controller automatically handles background asymmetric decryption, generating a safe, runtime-only Kubernetes `Secret` named `rails-production-secrets` natively inside your application namespace.

---

## Database State Seeding & Emergency Recovery

The project includes a secure, variable-driven seeder inside `db/seeds.rb` that protects your real credentials from public GitHub history. 

If your volume structure ever resets or you need to bootstrap a fresh administrator profile, identify your active running pod name via `kubectl get pods` and run this secure runtime injection command:

```bash
kubectl exec -it <your-active-pod-name> -n default -- env ADMIN_SEED_PASSWORD="your_private_password" ADMIN_SEED_EMAIL="your-email@domain.com" bin/rails db:seed -e production
```

---

## System Configuration Checkpoints
- **Routing Scope Mapping**: Everything is nested securely within the `/rails` parent scope path inside `config/routes.rb` to align perfectly with Traefik ingress paths.
- **Persistent Storage Volumes**: SQLite data and uploaded image binaries share a resilient, persistent `rails-sqlite-pvc` hard drive slice scaled to **10Gi** and managed by the `local-path` storage class.
- **High Availability (HA) Rolling Strategy**: Configured with a `RollingUpdate` strategy (`maxSurge: 1`, `maxUnavailable: 0`) and explicit application readiness probes targeting `/rails/articles` over port `3000` to guarantee absolute zero-downtime restarts.
- **Docker Build Context**: Operates using a secure minimal Alpine Linux footprint backed up by official build-time fallback dummy cryptographic keys (`SECRET_KEY_BASE_DUMMY=1`).
