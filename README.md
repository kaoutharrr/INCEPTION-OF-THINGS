# Inception-of-Things (IoT) - Educational Guide

## 📚 Table of Contents
1. [Project Overview](#project-overview)
2. [Core Technologies Explained](#core-technologies-explained)
3. [Key Concepts](#key-concepts)
4. [Part 1: K3s and Vagrant](#part-1-k3s-and-vagrant)
5. [Part 2: K3s and Three Applications](#part-2-k3s-and-three-applications)
6. [Part 3: K3d and ArgoCD](#part-3-k3d-and-argocd)
7. [Glossary](#glossary)

---

## 🎯 Project Overview

**Inception-of-Things** is a hands-on project designed to introduce you to **Kubernetes** through practical implementation. You'll learn container orchestration, infrastructure as code, and GitOps principles by building increasingly complex environments.

### Why This Project?
- Understand how modern cloud infrastructure works
- Learn Kubernetes in a simplified, lightweight environment
- Practice DevOps and automation skills
- Experience continuous deployment workflows

---

## 🛠️ Core Technologies Explained

### 1. **Vagrant**
**What it is:** A tool for building and managing virtual machine environments.

**Why we use it:** Instead of manually creating VMs through VirtualBox's GUI, Vagrant lets you define everything in a text file (`Vagrantfile`) and create VMs with one command.

**Real-world use:** Development teams use Vagrant to ensure everyone has identical development environments.

**Analogy:** Think of it as a recipe for creating computers. Instead of manually setting up a kitchen, you follow the recipe and get the same result every time.

```ruby
# Example: This code creates a VM automatically
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"  # Operating system
  config.vm.network "private_network", ip: "192.168.56.110"  # Network settings
end
```

---

### 2. **Kubernetes (K8s)**
**What it is:** An open-source system for automating deployment, scaling, and management of containerized applications.

**Why we use it:** Modern applications run in containers (like Docker containers). When you have hundreds or thousands of containers, you need something to manage them. That's Kubernetes.

**Key functions:**
- **Scheduling:** Decides which server runs which container
- **Self-healing:** Restarts failed containers automatically
- **Scaling:** Adds or removes containers based on demand
- **Load balancing:** Distributes traffic across containers

**Analogy:** Kubernetes is like a conductor of an orchestra. It ensures all musicians (containers) play at the right time, replaces sick musicians, and adjusts the orchestra size based on the venue.

---

### 3. **K3s**
**What it is:** A lightweight, certified Kubernetes distribution created by Rancher Labs.

**Why we use it:** Regular Kubernetes is complex and resource-heavy. K3s strips away unnecessary components, making it perfect for:
- Learning Kubernetes
- Edge computing
- IoT devices
- Development environments

**Size comparison:**
- Full Kubernetes: ~1GB+ memory
- K3s: ~512MB memory

**Key features:**
- Single binary (less than 100MB)
- Simplified installation
- Same API as full Kubernetes
- Production-ready

**Analogy:** If Kubernetes is a full-featured SUV, K3s is a compact car. It gets you to the same destination but is easier to park and uses less fuel.

---

### 4. **K3d**
**What it is:** K3s in Docker. It runs K3s clusters inside Docker containers instead of virtual machines.

**Why we use it:** Even lighter than K3s! No need for VMs.

**Advantages:**
- Faster startup (seconds vs. minutes)
- Uses less resources
- Multiple clusters on one machine
- Easy cleanup

**When to use:**
- K3s with Vagrant: When you need full VM isolation
- K3d: When you want speed and simplicity

**Analogy:** If K3s is a compact car, K3d is an electric scooter. Even faster and lighter!

---

### 5. **ArgoCD**
**What it is:** A GitOps continuous delivery tool for Kubernetes.

**Why we use it:** Traditionally, you deploy applications manually. With ArgoCD, you define your desired state in Git, and ArgoCD automatically ensures your cluster matches that state.

**How it works:**
1. You push Kubernetes configs to GitHub
2. ArgoCD watches your GitHub repo
3. When you change something in Git, ArgoCD updates your cluster
4. Your cluster always reflects what's in Git

**Benefits:**
- **Version control:** All changes tracked in Git
- **Rollback:** Easy to revert to previous versions
- **Audit trail:** See who changed what and when
- **Automation:** No manual deployments

**Analogy:** ArgoCD is like a smart home system. You set your preferences (Git repo), and it automatically adjusts your home (cluster) to match those preferences.

---

## 🧠 Key Concepts

### Infrastructure as Code (IaC)
**Definition:** Managing and provisioning infrastructure through code instead of manual processes.

**Example in this project:**
- Your `Vagrantfile` is code that creates VMs
- Your Kubernetes YAML files are code that creates applications

**Benefits:**
- Reproducible environments
- Version controlled
- Easy to share and collaborate
- Reduces human error

---

### Container Orchestration
**Definition:** Automated management of containerized applications.

**What it handles:**
- **Deployment:** Where to run containers
- **Scaling:** How many copies to run
- **Networking:** How containers communicate
- **Storage:** Where to store data
- **Health checks:** Is the container working?

**Without orchestration:** You manually start containers, monitor them, restart failed ones, and manage networking.

**With orchestration (Kubernetes):** You declare "I want 3 copies of this app" and Kubernetes handles everything.

---

### GitOps
**Definition:** Using Git as the single source of truth for declarative infrastructure and applications.

**The workflow:**
1. Desired state is stored in Git
2. Automated process ensures actual state matches desired state
3. All changes go through Git (pull requests, reviews)

**Benefits:**
- Complete audit trail
- Easy rollbacks
- Declarative (describe what you want, not how to do it)
- Collaboration through Git workflows

**In this project:** ArgoCD implements GitOps by watching your GitHub repo and updating your cluster.

---

### Ingress Controller
**Definition:** A Kubernetes component that manages external access to services, typically HTTP/HTTPS.

**Why we need it:**
Without Ingress, each service needs its own external IP or port. With Ingress, you can:
- Route traffic based on domain names
- Use a single entry point
- Handle SSL/TLS termination
- Load balance traffic

**Example from Part 2:**
```
app1.com → routes to App 1
app2.com → routes to App 2
anything else → routes to App 3
```

All using the same IP: 192.168.56.110

**Analogy:** An Ingress is like a receptionist in a building. Visitors arrive at one entrance, and the receptionist directs them to the correct office based on who they're visiting.

---

## 📖 Part 1: K3s and Vagrant

### What You're Building
A 2-node Kubernetes cluster using virtual machines.

### Architecture
```
┌─────────────────────┐         ┌─────────────────────┐
│   Server (Control)  │         │   Worker (Agent)    │
│  192.168.56.110     │◄────────┤  192.168.56.111     │
│                     │         │                     │
│  K3s Server         │         │  K3s Agent          │
│  (Control Plane)    │         │  (Worker Node)      │
└─────────────────────┘         └─────────────────────┘
```

### Components Explained

#### **Server (Control Plane)**
- **Role:** The "brain" of your Kubernetes cluster
- **Responsibilities:**
  - Stores cluster state
  - Schedules workloads
  - Manages API requests
  - Monitors cluster health

#### **Worker (Agent)**
- **Role:** The "muscle" of your cluster
- **Responsibilities:**
  - Runs containerized applications
  - Reports status to control plane
  - Executes commands from control plane

### Key Files

#### **Vagrantfile**
Defines your VM infrastructure:
- OS to use
- Network settings (IPs)
- Resource allocation (CPU, RAM)
- Provisioning scripts to run

#### **server.sh**
Script that runs on the server VM:
- Updates the system
- Installs K3s in server mode
- Saves authentication token

#### **worker.sh**
Script that runs on the worker VM:
- Updates the system
- Reads the server's token
- Installs K3s in agent mode
- Connects to the server

### What Happens When You Run `vagrant up`

1. **VM Creation**
   - Vagrant downloads Ubuntu image (if needed)
   - Creates 2 VMs in VirtualBox
   - Assigns hostnames and IPs

2. **Networking**
   - Creates private network
   - Both VMs can communicate
   - You can SSH without passwords

3. **K3s Installation**
   - Server installs K3s control plane
   - Worker installs K3s agent
   - Worker joins the cluster

4. **Result**
   - A working 2-node Kubernetes cluster
   - Ready to deploy applications

---

## 📖 Part 2: K3s and Three Applications

### What You're Building
A single VM running K3s with 3 web applications, accessible through different domain names.

### Architecture
```
                    192.168.56.110
                          │
                    ┌─────▼─────┐
                    │  Ingress  │
                    └─────┬─────┘
                          │
         ┌────────────────┼────────────────┐
         │                │                │
    ┌────▼────┐      ┌────▼────┐     ┌────▼────┐
    │  App 1  │      │  App 2  │     │  App 3  │
    │         │      │ (3 pods)│     │ (default)│
    └─────────┘      └─────────┘     └─────────┘
    
app1.com route      app2.com route    fallback route
```

### New Concepts

#### **Pods**
- Smallest deployable unit in Kubernetes
- Contains one or more containers
- Shares network and storage
- Temporary (can be destroyed and recreated)

#### **Deployments**
- Manages a set of identical Pods
- Handles scaling (replicas)
- Manages updates and rollbacks
- Ensures desired number of Pods are running

**Example:**
```yaml
replicas: 3  # Kubernetes maintains exactly 3 copies
```

#### **Services**
- Provides stable networking for Pods
- Load balances traffic across Pods
- Pods come and go, but Service IP stays the same

**Types:**
- **ClusterIP:** Internal only (default)
- **NodePort:** Accessible from outside
- **LoadBalancer:** Cloud load balancer

#### **Ingress**
- Routes external HTTP/HTTPS traffic to Services
- Based on rules (host, path)
- Single entry point for multiple applications

### Workflow

1. **User types** `app1.com` in browser
2. **DNS resolves** to 192.168.56.110
3. **Ingress receives** request, checks Host header
4. **Ingress routes** to App 1 Service
5. **Service forwards** to one of App 1's Pods
6. **Pod responds** with content

### Key Files You'll Create

#### **Deployment YAML**
Defines your application:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1
spec:
  replicas: 1  # How many copies
  template:
    spec:
      containers:
      - name: app1
        image: nginx  # Docker image to use
```

#### **Service YAML**
Exposes your application:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app1-service
spec:
  selector:
    app: app1  # Matches Pods with this label
  ports:
  - port: 80
```

#### **Ingress YAML**
Routes traffic:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
  - host: app1.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: app1-service
            port:
              number: 80
```

---

## 📖 Part 3: K3d and ArgoCD

### What You're Building
A Kubernetes cluster running in Docker with ArgoCD automatically deploying applications from GitHub.

### Architecture
```
┌──────────────────────────────────────────────┐
│              K3d Cluster                     │
│  ┌────────────────┐    ┌──────────────────┐ │
│  │  ArgoCD        │    │   dev namespace  │ │
│  │  namespace     │    │                  │ │
│  │                │    │  ┌────────────┐  │ │
│  │  - ArgoCD App  │───▶│  │ Your App   │  │ │
│  │  - Watches Git │    │  │  (v1/v2)   │  │ │
│  └────────────────┘    │  └────────────┘  │ │
│                        └──────────────────┘ │
└──────────────────────────────────────────────┘
                 ▲
                 │
                 │ watches
                 │
          ┌──────┴──────┐
          │   GitHub    │
          │   Repo      │
          │             │
          │ - YAML files│
          └─────────────┘
```

### New Concepts

#### **Namespaces**
- Virtual clusters within a physical cluster
- Isolate resources
- Organize applications
- Apply policies per namespace

**In this project:**
- `argocd` namespace: ArgoCD components
- `dev` namespace: Your application

#### **GitOps Workflow**
1. Developer pushes changes to Git
2. ArgoCD detects changes
3. ArgoCD applies changes to cluster
4. Cluster state matches Git state

#### **Application Versioning**
Using Docker image tags:
- `myapp:v1` - Version 1
- `myapp:v2` - Version 2

Change the tag in Git, ArgoCD updates the cluster.

### Components

#### **K3d**
- Runs K3s in Docker containers
- Faster than VMs
- Multiple clusters easily
- Perfect for local development

#### **ArgoCD**
- Deployed as Kubernetes application
- Has its own UI (web interface)
- Continuously watches Git repo
- Automatically syncs changes

#### **Docker Image**
You can use:
- Pre-made: `wil42/playground:v1` and `wil42/playground:v2`
- Your own: Build and push to DockerHub

### The Synchronization Process

1. **Initial Setup**
   - Install K3d
   - Create cluster
   - Install ArgoCD
   - Create GitHub repo with YAML files

2. **Deploy Application**
   - Create ArgoCD Application resource
   - Point it to your GitHub repo
   - ArgoCD deploys to `dev` namespace

3. **Update Application**
   - Edit YAML in GitHub (change v1 to v2)
   - Commit and push
   - ArgoCD detects change
   - ArgoCD updates cluster
   - Application now runs v2

### Key Differences from Part 2

| Part 2 | Part 3 |
|--------|--------|
| Manual deployment with kubectl | Automatic deployment via GitOps |
| VMs with Vagrant | Docker containers with K3d |
| Single version | Version management (v1, v2) |
| Static configuration | Git-based configuration |

---

## 📚 Glossary

### **Agent**
A worker node in K3s that runs workloads but doesn't make decisions.

### **API Server**
The front-end of Kubernetes control plane. All commands go through it.

### **Cluster**
A set of nodes (machines) running Kubernetes.

### **Container**
A lightweight, standalone package of software that includes everything needed to run: code, runtime, libraries, and settings.

### **Control Plane**
The part of Kubernetes that makes decisions about the cluster (scheduling, responding to events).

### **Controller**
A control loop that watches the cluster state and makes changes to reach the desired state.

### **Deployment**
A Kubernetes resource that manages a replicated application.

### **Docker**
A platform for developing, shipping, and running applications in containers.

### **GitOps**
A way of implementing Continuous Deployment where Git is the single source of truth.

### **Ingress**
An API object that manages external access to services in a cluster.

### **kubectl**
Command-line tool for interacting with Kubernetes clusters.

### **Master/Control Plane**
The machine that controls Kubernetes nodes.

### **Namespace**
A way to divide cluster resources between multiple users.

### **Node**
A worker machine in Kubernetes (can be VM or physical machine).

### **Pod**
The smallest deployable unit in Kubernetes, containing one or more containers.

### **Provisioning**
The process of setting up IT infrastructure.

### **Replica**
A copy of a Pod. Multiple replicas provide high availability.

### **Service**
An abstract way to expose an application running on Pods.

### **YAML**
A human-readable data serialization language commonly used for configuration files.

---

## 🎓 Learning Path

### Beginner (Part 1)
- Understand virtualization
- Learn basic Kubernetes concepts
- Practice infrastructure as code with Vagrant

### Intermediate (Part 2)
- Deploy applications to Kubernetes
- Configure networking and routing
- Manage multiple applications

### Advanced (Part 3)
- Implement GitOps
- Automate deployments
- Version management
- Continuous delivery

---

## 🔗 Resources

### Official Documentation
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [K3s Documentation](https://docs.k3s.io/)
- [K3d Documentation](https://k3d.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)

### Tutorials
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [K3s Quick Start](https://rancher.com/docs/k3s/latest/en/quick-start/)
- [ArgoCD Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)

---

## 💡 Tips for Success

1. **Take it step by step** - Don't rush. Understand each part before moving on.
2. **Read error messages** - They usually tell you what's wrong.
3. **Use `kubectl get` commands** - To see what's happening in your cluster.
4. **Check logs** - When something fails, logs are your friend.
5. **Clean up and retry** - Sometimes starting fresh helps.
6. **Document as you go** - Write down commands that work.
7. **Ask for help** - The community is friendly and helpful.

---

**Good luck with your Inception-of-Things journey! �