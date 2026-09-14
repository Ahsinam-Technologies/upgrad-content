# Master Curriculum Overview — Professional Program in Enterprise Data Science & AI on AWS

> **Status:** 🔲 Draft / High-Level Placeholder  
> **Course Architecture:** 13 Modules (M00 Foundations + M11 Core Modules + M12 Dedicated Capstone)  
> **Total Sessions:** 52 Sessions (4 Sessions per Module)  
> **Last Updated:** 2026-09-14

---

## 🎯 Executive Summary & Course Goals
This comprehensive curriculum equips learners with industry-grade Data Science and Machine Learning capabilities deployed natively on Amazon Web Services (AWS). Learners progress from foundational Python and AWS cloud primitives, through scalable data engineering, ML modeling with SageMaker, to production MLOps and an end-to-end Capstone project.

---

## 🗺️ Modular Progression Roadmap

```
+-----------------------------------------------------------------------------------+
|                        M00: Foundations Pre-Module                                |
| (Python Programming, Linear Algebra, Statistical Foundations, Software Workflows) |
+-----------------------------------------+-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                     M01 - M04: Data Engineering on AWS                            |
|             (S3, Glue, Athena, Redshift, EMR, Feature Store)                      |
+-----------------------------------------+-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                      M05 - M08: Applied ML with AWS SageMaker                     |
|           (EDA, Model Training, Hyperparameter Tuning, AutoML, Deep Learning)     |
+-----------------------------------------+-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                     M09 - M11: MLOps, LLMs & Production AI                        |
|       (SageMaker Pipelines, CI/CD, Model Monitoring, GenAI / Bedrock)             |
+-----------------------------------------+-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                       M12: Comprehensive Capstone Project                         |
|           (End-to-End Enterprise ML Solution on AWS with Live Evaluation)         |
+-----------------------------------------+-----------------------------------------+
```

---

## 📚 13-Module High-Level Curriculum Index

*Details for individual sessions and learning outcomes are documented in the respective module [`Mxx/README.md`](./) directories.*

| Module ID | Module Title | Primary Stack / AWS Services | Key Focus Area | Session Plan Link |
| :---: | :--- | :--- | :--- | :---: |
| **M00** | Foundations of Data Science | Python 3.12+, NumPy, SciPy, Git, `uv`, `pytest` | Python Core & Memory, Linear Algebra, Probability & Inference, Software Engineering Workflows | [M00 Plan](./M00/README.md) |
| **M01** | Data Ingestion & Storage Architecture on AWS | S3, Lake Formation, AWS Glue Data Catalog, Athena | Object Storage, Data Lakehouse Architecture, Parquet & Partitioning Strategies | [M01 Plan](./M01/README.md) |
| **M02** | Scalable Data Processing & Transformation | AWS Glue, PySpark, EMR Serverless, Athena | Large-Scale Distributed Transformations, Spark Optimizations, ETL Pipelines | [M02 Plan](./M02/README.md) |
| **M03** | Data Warehousing & Modern Analytics on AWS | Amazon Redshift, Redshift Spectrum, SQL Analytics | Cloud Data Warehousing, Star/Snowflake Schema, High-Performance Analytics | [M03 Plan](./M03/README.md) |
| **M04** | Real-Time Streaming & Feature Store Architecture | Amazon Kinesis, MSK (Kafka), SageMaker Feature Store | Streaming Ingestion, Event-Driven Architectures, Online/Offline Feature Stores | [M04 Plan](./M04/README.md) |
| **M05** | Exploratory Data Analysis & Feature Engineering | SageMaker Studio, SageMaker Processing Jobs, Data Wrangler | Large-Scale EDA, Statistical Profiling, Feature Preprocessing Pipelines | [M05 Plan](./M05/README.md) |
| **M06** | Classical Machine Learning & Distributed Training | SageMaker Built-in Algorithms, Scikit-learn on AWS, Spot Training | Supervised & Unsupervised Modeling, Distributed Gradient Boosting (XGBoost) | [M06 Plan](./M06/README.md) |
| **M07** | Hyperparameter Optimization & AutoML | SageMaker HPO, Bayesian Search, SageMaker Autopilot | Automatic Model Tuning, Multi-Objective HPO, Model Registry & Governance | [M07 Plan](./M07/README.md) |
| **M08** | Deep Learning, NLP & Computer Vision on AWS | PyTorch, SageMaker Distributed Training, Hugging Face on AWS | Neural Networks, Distributed Data Parallel (DDP), Transfer Learning, Transformers | [M08 Plan](./M08/README.md) |
| **M09** | MLOps: Continuous Integration & Pipeline Orchestration | SageMaker Pipelines, Step Functions, CodePipeline, MLflow | Automated ML Workflows, Versioning, CI/CD for Model Delivery & Artifact Tracking | [M09 Plan](./M09/README.md) |
| **M10** | Production Model Deployment & Monitoring | SageMaker Real-Time Endpoints, Serverless, Model Monitor, Clarify | Low-Latency Inference, A/B Traffic Shifting, Data Drift & Model Bias Monitoring | [M10 Plan](./M10/README.md) |
| **M11** | Generative AI, Large Language Models & Bedrock | Amazon Bedrock, LangChain, OpenSearch Vector DB | Foundation Models, Retrieval-Augmented Generation (RAG), Prompt Engineering | [M11 Plan](./M11/README.md) |
| **M12** | Enterprise Capstone Project & Production Defense | Full AWS ML Stack, Streamlit/FastAPI | End-to-End Enterprise Solution Implementation & Live Architecture Defense | [M12 Plan](./M12/README.md) |

