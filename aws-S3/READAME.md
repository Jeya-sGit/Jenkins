Here is the complete, professional **README.md** file for your project. You can copy and paste this directly into your GitHub repository.

---

# AWS S3 Infrastructure via Jenkins CI/CD

This project demonstrates a fully automated, professional-grade GitOps pipeline. It uses **Jenkins** on Windows to orchestrate **Terraform** for deploying AWS S3 infrastructure.

## 🚀 Key Features

* **Infrastructure as Code (IaC):** Managed via Terraform HCL.
* **Automated Pipeline:** Multi-stage Declarative Pipeline (`Init`, `Plan`, `Apply`).
* **Deployment Safety:** Manual Approval gate required for the `main` branch.
* **Colored Logs:** Clean, readable terminal output using the **AnsiColor** plugin.
* **Windows Optimized:** Configured to run flawlessly on Windows-based Jenkins nodes.


## 🏗️ Project Structure

```text
.
├── aws-S3/
│   ├── main.tf            # Core AWS resource definitions (S3 & Random ID)
│   ├── variables.tf       # Input variables (Region, Tags)
│   ├── outputs.tf         # Exported data (Bucket ARN, ID)
│   └── Jenkinsfile        # Pipeline-as-Code logic
└── README.md              # Documentation

```

## 🛡️ Why we use a Plan File (`-out=tfplan`)

A core best practice in this pipeline is the use of an execution plan file.

1. **Consistency:** It ensures that the exact changes you reviewed in the `Plan` stage are the **only** changes made during the `Apply` stage.
2. **Safety:** It prevents "race conditions." If the AWS environment changes while the pipeline is "Paused for Approval," Terraform will not apply outdated logic.
3. **Execution:** It allows us to use the `-auto-approve` flag safely because the changes were already locked in during the previous stage.

---

## 🛠️ The Pipeline Workflow

The pipeline is "branch-aware," meaning it protects your production environment by only allowing deployments from the `main` branch.

| Stage | Behavior | Condition |
| --- | --- | --- |
| **Terraform Init** | Downloads AWS provider plugins | Always |
| **Terraform Plan** | Creates the `tfplan` binary file | Always |
| **Manual Approval** | **Pauses** execution for human review | `main` branch only |
| **Terraform Apply** | Deploys the locked `tfplan` to AWS | `main` branch only |

---

## 💡 Technical Implementation Details

### 1. Windows vs. Linux Integration

Because the Jenkins agent runs on Windows, the `Jenkinsfile` utilizes `bat` commands instead of `sh` to interact with the system shell:

```
bat 'terraform init'

```

### 2. Directory Context

Since the Terraform files are located in the `aws-S3/` subfolder, the pipeline uses the `dir()` block to change the working directory before executing commands:

```
dir('aws-S3') {
    bat "terraform plan -out=tfplan"
}

```

### 3. Smart Branch Detection

To ensure the pipeline recognizes the `main` branch across different Git configurations, we use a flexible expression:

```
when {
    expression { 
        return env.GIT_BRANCH == 'origin/main' || env.BRANCH_NAME == 'main' || env.GIT_BRANCH == 'main'
    }
}

```

## 📦 Prerequisites

1. **Jenkins Plugins:** `Pipeline`, `Git`, `Credentials Binding`, and `AnsiColor`.
2. **AWS Credentials:** Stored in Jenkins as **Secret Text** with IDs `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
3. **Local Tools:** `terraform.exe` must be installed on the Jenkins host and added to the **System PATH**.
4. **ANSIColor:** Wrap the pipeline in `options { ansiColor('xterm') }` for readable logs.

---

## 🏁 How to Run

1. Commit your changes to a **feature branch**.
2. Jenkins will run the `Plan` to show you what will happen.
3. Merge the feature branch into **`main`**.
4. Run the Jenkins job.
5. When the **Manual Approval** stage turns yellow, click **Proceed** to create your S3 bucket.

---

**Is there anything else you'd like to add to the README, or shall we move on to testing Build #10 with the new logic?**