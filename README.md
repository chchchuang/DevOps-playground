# DevOps Playground - CI/CD MVP

>* 這是一個用 Python FastAPI、Docker、Kubernetes、Helm、GitHub Actions、ArgoCD 架設的完整 CI/CD MVP 專案
>* 展示從開發到生產部署的完整 DevOps 流程，包含自動化測試、容器化部署、Kubernetes 編排和 GitOps 工作流程
>* 本專案目的僅為自我學習實現用

## Architecture Diagram 架構圖

![DevOps Playground Architecture](Architecture.png)

## Prerequisites 使用環境

| 類別 | 技術/工具 | 用途 |
|------|----------|------|
| **後端框架** | [Python FastAPI](https://fastapi.tiangolo.com/) | 現代化 Python Web API 框架 |
| **套件管理** | [uv](https://github.com/astral-sh/uv) | 快速 Python 套件管理工具 |
| **容器化** | [Docker](https://www.docker.com/) | 應用程式容器化 |
| **容器編排** | [Kubernetes](https://kubernetes.io/) | 容器編排與管理平台 |
| **套件管理** | [Helm](https://helm.sh/) | Kubernetes 應用程式套件管理 |
| **CI/CD** | [GitHub Actions](https://github.com/features/actions) | 持續整合與持續部署 |
| **GitOps** | [ArgoCD](https://argo-cd.readthedocs.io/) | 自動化部署與 GitOps 工作流程 |
| **Webhook** | [GitHub Webhook](https://docs.github.com/en/webhooks/about-webhooks) | 觸發自動同步機制 |
| **測試框架** | [pytest](https://pytest.org/) | Python 單元測試框架 |
| **本地開發** | [Kind](https://kind.sigs.k8s.io/) | Kubernetes in Docker 本地測試環境 |

## Project Structure 專案結構 

```
DevOps-playground/
├── main.py                           # FastAPI 應用程式主檔案
├── test_main.py                      # 單元測試
├── Dockerfile                        # Docker 映像建置檔案
├── pyproject.toml                    # Python 專案配置
├── uv.lock                           # 依賴鎖定檔案
├── kind-config.yml                   # Kind 叢集配置
├── argocd-application.yml            # ArgoCD 應用程式配置
├── argocd-cm-patch.yml               # ArgoCD ConfigMap patch
├── .github/workflows/                # GitHub Actions CI/CD 流程
│   └── ci.yml
└── devops-playground/                # Helm Chart
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        └── ...
```

## CI/CD 流程

本專案採用完整的 CI/CD 流程，分為 **持續整合 (CI)** 和 **持續部署 (CD)** 兩個階段。

### 1. CI 流程：功能開發與測試

**觸發條件：** Pull Request 或 Push 到 `main` 分支

**執行流程：**

```
開發者修改程式碼 → 建立 PR → 自動測試 → 測試通過 → 合併到 main
```

1. **開發階段**：開發者建立新分支並修改程式碼
2. **提交審查**：推送分支並建立 Pull Request
3. **自動化測試**：GitHub Actions 執行：
   - Checkout 程式碼
   - 安裝 Python 依賴 (使用 `uv`)
   - 執行 `pytest` 測試套件
4. **合併程式碼**：測試通過後合併到 `main` 分支

### 2. CD 流程：建置與自動部署

**觸發條件：** 建立並推送 Git 版本標籤

#### 步驟 A：建置 Docker image (手動觸發)

**操作指令：**

```bash
# 確保 main 分支為最新
git checkout main
git pull origin main

# 建立並推送版本標籤
git tag v1.1.0
git push origin v1.1.0
```

**GitHub Actions 自動執行：**
1. 登入 Docker Hub
2. 建置 Docker image
3. 標記 image 版本 (`underdog22a/devops-playground:v1.1.0`)
4. 推送 image 到 Docker Hub Registry

#### 步驟 B：GitOps 自動化部署 (全自動)

**執行流程：**

```
Docker Hub 更新 → ArgoCD 偵測 → 更新 Manifests → Webhook 觸發 → ArgoCD 同步 → 部署完成
```

1. **image 更新偵測** - ArgoCD Image Updater 偵測到新版本 image
2. **自動更新配置** - 更新 `devops-playground/.argocd-source-devops-playground.yaml` 中的 image 標籤
3. **觸發同步機制** - GitHub Webhook 通知 ArgoCD 配置變更
4. **Kubernetes 部署** - ArgoCD 自動執行 `helm upgrade` 更新 Deployment
5. **部署完成** - 應用程式自動更新到新版本

> **備註：** 若未收到 Webhook，ArgoCD 仍會每 3 分鐘進行定期同步確認。

## 參考資料 References

| 技術/工具 | 文件連結 |
|----------|---------|
| FastAPI | [FastAPI 文件](https://fastapi.tiangolo.com/) |
| Kubernetes | [Kubernetes 文件](https://kubernetes.io/docs/) |
| Helm | [Helm 文件](https://helm.sh/docs/) |
| ArgoCD | [ArgoCD 文件](https://argo-cd.readthedocs.io/) |
| GitHub Actions | [GitHub Actions 文件](https://docs.github.com/en/actions) |

---

## About 關於作者

* **作者 Author**: chchchuang
* **更新日期 Last Update**: 2025-10-26
* **聯絡方式 Contact**: chchchuang@gmail.com