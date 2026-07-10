# 📰 Rails 8 GitOps Blog Template Blueprint

A production-ready, minimal Ruby on Rails 8 blogging template architecture engine. Hardened with native standalone Tailwind CSS v4, SQLite persistent data layouts, Active Storage image modules, and fully orchestrated via an automated GitHub Actions CI/CD pipeline straight to a live Kubernetes (K3s) cluster via ArgoCD.

## 🚀 Key Feature Layers
- **Native Authentication 🔐**: Built-in Rails 8 session, username registration, and standalone password recovery card modules.
- **Dynamic Media Uploads 🖼️**: Active Storage image attachment module with native system image processing and complete file purges.
- **Global Validation Gates ⏳**: Strict 10-character validation gates backed up by automated flash warning notification banners.
- **Authorship Authorization 👤**: Strict resource protection gates restricting editing and deletion actions exclusively to account authors.
- **Super Admin Bypass 👑**: Built-in global override capabilities assigned natively to the master account username (`theone`).

---

## 🛠️ Local Workstation Control Commands

Always execute development sessions from your local `rails-app/` folder workspace using these command controls:

```bash
# 1. Spin up your asset-aware unified developer watchers preview session
bin/dev

# 2. Fire structural database schema alterations onto your laptop drive
bin/rails db:migrate

# 3. Safe database state reset (Wipes data constraints and rebuilds clean tables)
bin/rails db:drop db:create db:migrate

# 4. Open the interactive system console shell to overwrite parameters directly
bin/rails console
```

---

## 🏗️ Production GitOps Pipeline Deployment Loop

Whenever you make structural view layout or controller logic adjustments, execute this exact root repository pipeline execution script chain to push changes to your live cluster over port `8080`:

```bash
cd /media/theone/HDD/docker-files/github_projects/ArgoCD-RootApps && \
git add . && \
git commit -m "docs: finalize comprehensive readme blueprint manual guide" && \
git push origin main && \
kubectl patch application root-gitops-app -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' && \
cd rails-app
```

### ⏳ The Master Timing Rule
1. Open your browser tab and watch your **GitHub Actions repository tab workflow**.
2. **Wait completely until the spinning indicator wheel turns into a solid green checkmark.**
3. Execute the direct patch eviction command below to force K3s to discard old layers and initialize fresh ones:

```bash
kubectl patch deployment rails-app-deployment -n default -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"timestamp\":\"\$(date +%s)\"}}}}}"
```

---

## 📁 System Configuration Checkpoints
- **Routing Scope Mapping**: Everything is nested securely within the `/rails` parent scope path inside `config/routes.rb`.
- **Persistent Storage Volumes**: SQLite data and uploaded image binaries share the exact same resilient, persistent `rails-sqlite-pvc` hard drive slice mounted directly at `/app/storage` in K3s.
- **Docker Build Context**: Operates using a minimal Alpine Linux footprint backed up by official build-time fallback dummy cryptographic keys (`SECRET_KEY_BASE_DUMMY=1`).
