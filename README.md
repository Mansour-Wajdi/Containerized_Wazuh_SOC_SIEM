
# Integrating Wazuh with Elastic Stack on Docker

Integrating Wazuh with the Elastic Stack on Docker allows for efficient monitoring, logging, and alerting in a containerized environment. This guide will walk you through the process, from setting up Docker to deploying Wazuh and Elastic Stack.

---

## Prerequisites

### Install Docker Engine

Refer to [Docker Engine Installation](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) if Docker is not already installed.

### Install Docker Compose

Refer to [Docker Compose Installation](https://docs.docker.com/compose/install/standalone/) if Docker Compose is not already installed.

### Change vm.max_map_count

1. **Edit sysctl.conf:**
    ```bash
    sudo nano /etc/sysctl.conf
    ```

2. **Set the following:**
    ```text
    vm.max_map_count=262144
    ```

3. **Apply the changes:**
    ```bash
    sudo sysctl -p
    ```

4. **Check the changes:**
    ```bash
    sudo sysctl vm.max_map_count
    ```


## Wazuh Docker Deployment (Single-node Deployment)

### Clone the Repository

```bash
git clone https://github.com/Mansour-Wajdi/Wazuh_ElasticSack_Ingtegration_on_Docker.git 
```

### Navigate to the single-node directory:

```bash
cd Wazuh_ElasticSack_Ingtegration_on_Docker/wazuh-docker/single-node
```

### Generate Self-signed Certificates

```bash
docker-compose -f generate-indexer-certs.yml run --rm generator
```

This saves the certificates into the `config/wazuh_indexer_ssl_certs` directory.

### Create a Custom Docker Network

```bash
sudo docker network create elastic-network
```

Important note : Elastic stack will use this network, so you have to keep the same name (elastic-network) in order for the project to work. If you want to change the name, you will need to also change it in elk-wazuh-docker/docker-compose.yml.

### Start the Wazuh Single-node Deployment

```bash
docker-compose up -d 
```

After deploying Wazuh, the **Wazuh Dashboard** will be accessible at [https://localhost/app/login](https://localhost/app/login) with the default credentials **Login**: `admin` and **Password**: `SecretPassword`

### Add Wazuh Agent

Use the ip of the current machine to deploy an agent. 

## Install Elastic Stack with Docker Compose

### Navigate to the directory and start the ELK:

```bash
cd Wazuh_ElasticSack_Ingtegration_on_Docker/elasticstack_for_Wazuh_on_Docker
sudo docker-compose up -d --build
```
Note: Any data indexed before this configuration is complete would not be forwarded to the Elastic indexes. Make sure you have new data forwarded to Elastic before proceeding to the next step, otherwise the `wazuh_kibana_setup` will not execute properly.

## Configure Wazuh Alerts Index Pattern in Elastic + Elastic Dashboards

### Run the setup script:

```bash
sudo ./wazuh_kibana_setup.sh
```

By following these steps, you will have successfully integrated Wazuh with the Elastic Stack on Docker, providing a robust monitoring and alerting solution.
