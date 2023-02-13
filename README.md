# Einrichtung von virtuellen Maschien 
    für jenkinsserver         :  4 GB RAM, 2 kern CPU, 60 GB SATA, Net_Adapter: NAT 
    für docker-regisrty-server:  2 GB RAM, 2 kern CPU,60 GB SATA, Net_Adapter: NAT 
    für minikube-server       :  4 GB RAM, 2 kern CPU, 60 GB SATA, Net_Adapter: NAT, 
        
    OS:Ubuntu 20.04.LTS

# Einrichtung von ssh Verbindungen zwischen virtuellen Maschien 

sshd (OpenSSH Daemon oder Server) ist das Daemon-Programm für den SSH-Client. Es ist ein kostenloser Open-Source-SSH-Server. ssh ersetzt das unsichere rlogin und rsh und bietet sichere verschlüsselte Kommunikation zwischen zwei nicht vertrauenswürdigen Hosts über ein unsicheres Netzwerk wie das Internet. Ubuntu Desktop und minimaler Ubuntu-Server werden nicht mit installiertem sshd geliefert. Mit den folgenden Schritten können Sie den SSH-Server jedoch problemlos in Ubuntu installieren.

- Öffnen Sie die Terminalanwendung für den Ubuntu-Desktop.

```bash

sudo apt update

sudo apt upgrade

sudo apt install openssh-server

## Aktivieren Sie den ssh-Dienst, indem Sie Folgendes eingeben:

sudo systemctl enable ssh

## Oder
sudo systemctl enable ssh --now

## Starten Sie den ssh-Dienst, indem Sie Folgendes eingeben:

sudo systemctl start ssh

sudo systemctl status ssh



## Wenn benötigt, konfigurieren die Firewall  und Port 22 öffnen

sudo ufw allow ssh

sudo ufw enable

sudo ufw status

## Genereieren Sie eine ssh-public/-und private key. 

ssh-keygen

image.png

## senden Sie die ssh public key (id_rsa.pub) an dem remoteServern.

cd ~/.ssh

ls

ssh-copy-id remoteUser@remoteHost

## Testen Sie es, indem Sie sich beim System anmelden mit:

ssh userName@Your-server-name-IP

ssh selo@jenkins
```

# 1 JENKINS SERVER INSTALLIEREN und KOFIGURIEREN auf Ubuntu-20.04

sudo apt update -y

sudo install git -y

## Installieren Docker

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce

sudo apt install docker-ce

sudo systemctl status docker

sudo usermod -aG docker ${USER}

su - ${USER}

sudo usermod -aG docker jenkins

docker run --rm hello-world

## wenn benötigt login to Docker-Hub

docker login -u docker-registry-username

##  Installing Docker Compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version

mkdir ~/compose-demo

cd ~/compose-demo

nano ./docker-registry-compose.yaml

 ## Prüfen Sie, ob Java bereits installiert ist:

java -version

## Wenn Java derzeit nicht installiert ist, 

sudo apt install openjdk-11-jdk

java -version

javac -version

sudo update-alternatives --config java

## Öffnen Sie die Startdatei ~/.bashrc mit einem Texteditor Ihrer Wahl und fügen Sie die folgenden Definitionen am Ende der Datei hinzu:

# [...]

export JAVA_HOME=$"/usr/lib/jvm/java-11-openjdk-amd64"

export PATH=$PATH:$JAVA_HOME/bin

echo $JAVA_HOME

## Installieren Gradle

wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp

sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip

sudo ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest

sudo nano /etc/profile.d/gradle.sh

export GRADLE_HOME=/opt/gradle/latest

export PATH=${GRADLE_HOME}/bin:${PATH}

sudo chmod +x /etc/profile.d/gradle.sh

source /etc/profile.d/gradle.sh

gradle -v

### Dockerfile 
'''

  FROM adoptopenjdk/openjdk11

  WORKDIR /temporary

  COPY build/libs/containertest-0.0.1-SNAPSHOT.jar .

  EXPOSE 8080

  CMD  ["java","-jar", "./containertest-0.0.1-SNAPSHOT.jar"]

'''

## Jenkins installieren

# - Fügen Sie dem System den Repository-Schlüssel hinzu:

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# - Nachdem der Schlüssel hinzugefügt wurde, kehrt das System mit OK zurück.

# - Als nächstes fügen wir die Debian-Paket-Repository-Adresse an die sources.list des Servers an:

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update

sudo apt install jenkins

# - Jenkins starten

sudo systemctl status jenkins

sudo systemctl start jenkins

# - Öffnen der Firewall

sudo ufw allow 8080 
sudo ufw allow OpenSSH  

sudo ufw enable

sudo ufw status

## Setting Up Jenkins
## Um Ihre Installation einzurichten, besuchen Sie Jenkins auf dem Standardport 8080 und verwenden Sie dabei ## Ihren Serverdomänennamen oder Ihre IP-Adresse: http://your_server_ip_or_domain:8080
## Sie sollten den Bildschirm „Jenkins entsperren“ erhalten, der den Speicherort des anfänglichen Passworts anzeigt:

image.png

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

image.png

image.png

image.png

### Auf Wunch kann Jenkins Server als Docker-Container installiert wurden. 

docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home jenkins


# 2- DOCKER_REGISTRY Server installieren auf Ubuntu-20.04

sudo apt update -y

sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

sudo apt install docker-ce

sudo systemctl status docker

sudo usermod -aG docker ${USER}

su - ${USER}

sudo usermod -aG docker jenkins

docker run --rm hello-world

## wenn benötigt login to Docker-Hub

docker login -u docker-registry-username

##  Installing Docker Compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version

mkdir ~/compose-demo

cd ~/compose-demo

nano ./docker-registry-compose.yaml

,,, version: '3'

services:

    docker-registry:

        container_name: docker-registry

        image: registry:2

        ports:

            - 5000:5000

        restart: always

        volumes:

            - ./volume:/var/lib/registry

    docker-registry-ui:

        container_name: docker-registry-ui

        image: konradkleine/docker-registry-frontend:v2

        ports:

            - 8080:80

        environment:

            ENV_DOCKER_REGISTRY_HOST: docker-registry

            ENV_DOCKER_REGISTRY_PORT: 5000

        ,,,,

# RUN

docker-compose -f docker-compose.yaml up

## 3- DEPLOMENT SERVER INSTALLIEREN

### Nach dem Installieren, git, openjdk11, docker, docker.compose, gradle,
###  Installieren Minikube 

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube-linux-amd64

sudo mv minikube-linux-amd64 /usr/local/bin/minikube

 minikube version

 # Installieren kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

# Starten minikube

minikube start

## Deployment und Service Files

,,, 
apiVersion: apps/v1

kind: Deployment

metadata:

  name: springapp-deployment

  labels:

    app: springapp

spec:

  replicas: 1

  selector:

    matchLabels:

      app: springapp

  template:

    metadata:

      labels:

        app: springapp

    spec:

      containers:

      - name: springapp-container

        image: sennurmiray/snapshotintegration

        ports:

        - containerPort: 8080


---

apiVersion: v1

kind: Service

metadata:

  name: springapp-service

spec:

  selector:

    app: springapp

  type: NodePort

  ports:

    - nodePort: 30456

      targetPort: 8080
      
      port: 9898

,,,,

kubectl apply -f deployment.yaml

minikube service springapp-service --url

curl $(minikube service springapp-service --url)

