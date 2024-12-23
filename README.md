
# EKS-EventFlow

This project demonstrates a solution leveraging AWS services (SQS, S3, EKS) and Kubernetes Event-driven Autoscaling (KEDA) to build a scalable cloud-native application. The main objective is to process messages from an SQS queue, store them in an S3 bucket, and deploy the solution as a ScaledJob in an EKS cluster using KEDA.

---

## Project Structure

### 1. Python Script

**Purpose**: Handles the core functionality of the application by:

- Receiving messages from an SQS queue.
- Saving the messages in an S3 bucket with a timestamp-based filename.
- Deleting the message from the queue after successful processing.

The script ensures efficient message processing and error handling while interacting with AWS resources.

### 2. Docker Image

**Purpose**: Containerizes the Python script for easy deployment and scalability. The Docker image:

- Encapsulates the Python environment and dependencies required to run the script.
- Is built locally and pushed to Amazon Elastic Container Registry (ECR) for use in the Kubernetes cluster.

### 3. Terraform Infrastructure

**Purpose**: Automates the creation and configuration of AWS resources required for the project. Terraform scripts include:

- **S3 Bucket**: To store the processed messages.
- **SQS Queue**: To serve as the message broker.
- **VPC and EKS Cluster**: To host the Kubernetes workloads and ensure networking between components.
- Additional configurations to support seamless communication between AWS resources.

### 4. Kubernetes with KEDA

**Purpose**: Deploys the solution into an EKS cluster and scales it dynamically based on the number of messages in the SQS queue. Key components include:

- **KEDA Installation**: Adds autoscaling capabilities to the Kubernetes cluster based on external metrics (SQS queue length).
- **ScaledJob Configuration**: Defines the workload (job) that processes messages from the queue and specifies triggers for scaling.

The ScaledJob ensures efficient resource utilization by automatically scaling the number of pods based on message volume.

---

## Workflow Overview

1. **Message Processing**:

   - Messages are sent to the SQS queue.
   - The Python script fetches messages, processes them, and saves them to the S3 bucket.

2. **Containerization**:

   - The Python script is packaged into a Docker container for portability and scalability.

3. **Infrastructure Deployment**:

   - Terraform scripts provision AWS resources including S3, SQS, and EKS.

4. **Dynamic Scaling**:

   - KEDA monitors the SQS queue and triggers the ScaledJob based on the number of messages.

---

## Key Features

- **Cloud-native architecture**: Combines AWS services and Kubernetes for a robust and scalable solution.
- **Event-driven scaling**: Automatically adjusts the number of processing pods based on the queue length.
- **Infrastructure as Code**: Uses Terraform to ensure reproducibility and automation.
- **Containerized deployment**: Docker images streamline application deployment and management.

---

## Prerequisites

To replicate or extend this project, ensure you have the following:

- AWS CLI installed and credentials configured.
- Docker installed and running.
- Terraform installed locally.
- Kubernetes tools: `kubectl` and Helm.
- An active AWS account with sufficient permissions.

---

## Deliverables

1. A Python script for message processing.
2. A Docker image pushed to an Amazon ECR repository.
3. Terraform scripts for deploying AWS resources.
4. KEDA configuration files for scaling in EKS.

This repository provides a comprehensive example of building scalable, event-driven applications with AWS and Kubernetes.
