# Project: Einrichtung von  Kontiniuerliche Integration/ kontiniuerliche Deployment Pipeline mit Jenkins 

# Gliederung 

A. Bereitstellung von Servern

1. Bereitstellung von virtuellen Maschinen

		a. Einrichtung von virtuellen Maschinen mit VMVare

		b. Einrichtung von ssh-Verbindungen zwischen virtuellen Maschinen

		c. Konfigurieren die Firewall

2. Installation von Jenkins Server 

		a. Update und Installation von Git, Docker, Docker-Compose OpenJDK.11, Gradle

		b. Schreiben von Dockerfile

		c. Installation von Jenkins

3. Installation von Docker-Registry Server

		a. Update und Installation von Git, Docker, Docker-Compose 

		b. Schreiben von Docker-Compose File

4. Installation von Deployment Server 

		a. Update und Installation von Git, Docker, Docker-Compose OpenJDK.11, Gradle

		b. Schreiben von Deployment und Service files for Kubernetes Cluster

		c. Installation von Minikube, kubectl

B. Konfigurationen von Jenkins

1. Global Tool Konfigurationen

		a. Spezifizierung der Home Directory von Git

		b. Spezifizierung der Home Directory von OpenJDK-11

		c. Spezifizierung der Home Directory von Docker

		d. Spezifizierung der Home Directory von Gradle

2. Docker-Registry Server und Deployment Server als Agent Knoten von Jenkins Konfigurieren

    a. Konfigurieren der SSH-Verbindung zwischen Master- und Slave-Knoten

    b. die Agentendatei vom Jenkins-Server auf den Slave-Knoten zu kopieren

C. CI/CD Pipeline Durchführen

1. Schreiben von Jenkinsfile

2. Durchführung und Validierung




## A. Bereitstellung von Servern

## 1. Bereitstellung von virtuellen Maschinen

## a. Einrichtung von virtuellen Maschien 

    für jenkinsserver         :  4 GB RAM, 2 kern CPU, 60 GB SATA, Net_Adapter: NAT 

    für docker-regisrty-server:  2 GB RAM, 2 kern CPU,60 GB SATA, Net_Adapter: NAT 

    für minikube-server       :  4 GB RAM, 2 kern CPU, 60 GB SATA, Net_Adapter: NAT, 
        
    OS:Ubuntu 20.04.LTS


## b. Einrichtung von ssh Verbindungen zwischen virtuellen Maschien ist eine Voraussetzung. 

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


## c. Konfigurieren die Firewall

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

## 2. Installation von Jenkins Server 

a. Update und Installation von Git, Docker, Docker-Compose OpenJDK.11, Gradle

sudo apt update -y

sudo install git -y

##

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

wenn benötigt login to Docker-Hub

docker login -u docker-registry-username



sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version

mkdir ~/compose-demo

cd ~/compose-demo

nano ./docker-registry-compose.yaml

Prüfen Sie, ob Java bereits installiert ist:

java -version

Wenn Java derzeit nicht installiert ist, 

sudo apt install openjdk-11-jdk

java -version

javac -version

sudo update-alternatives --config java

Öffnen Sie die Startdatei ~/.bashrc mit einem Texteditor Ihrer Wahl und fügen Sie die folgenden Definitionen am Ende der Datei hinzu:

# [...]

export JAVA_HOME=$"/usr/lib/jvm/java-11-openjdk-amd64"

export PATH=$PATH:$JAVA_HOME/bin

echo $JAVA_HOME

Installieren Gradle

wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp

sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip

sudo ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest

sudo nano /etc/profile.d/gradle.sh

export GRADLE_HOME=/opt/gradle/latest

export PATH=${GRADLE_HOME}/bin:${PATH}

sudo chmod +x /etc/profile.d/gradle.sh

source /etc/profile.d/gradle.sh

gradle -v

## b. Schreiben von Dockerfile
### Dockerfile 
'''

  FROM adoptopenjdk/openjdk11

  WORKDIR /temporary

  COPY build/libs/containertest-0.0.1-SNAPSHOT.jar .

  EXPOSE 8080

  CMD  ["java","-jar", "./containertest-0.0.1-SNAPSHOT.jar"]

'''
## c. Installation von Jenkins

Fügen Sie dem System den Repository-Schlüssel hinzu:

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

Nachdem der Schlüssel hinzugefügt wurde, kehrt das System mit OK zurück.

Als nächstes fügen wir die Debian-Paket-Repository-Adresse an die sources.list des Servers an:

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update

sudo apt install jenkins

Jenkins starten

sudo systemctl status jenkins

sudo systemctl start jenkins

Öffnen der Firewall

sudo ufw allow 8080 
sudo ufw allow OpenSSH  

sudo ufw enable

sudo ufw status

Setting Up Jenkins

Um Ihre Installation einzurichten, besuchen Sie Jenkins auf dem Standardport 8080 und verwenden Sie dabei ## Ihren Serverdomänennamen oder Ihre IP-Adresse: http://your_server_ip_or_domain:8080

Sie sollten den Bildschirm „Jenkins entsperren“ erhalten, der den Speicherort des anfänglichen Passworts anzeigt:

image.png

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

image.png

image.png

image.png

## Auf Wunch kann Jenkins Server als Docker-Container installiert wurden. 

docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v ~/$(USER):/var/jenkins_home jenkins


## 3. Installation von Docker-Registry Server

a. Update und Installation von Git, Docker, Docker-Compose 

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

wenn benötigt login to Docker-Hub

docker login -u docker-registry-username

Installing Docker Compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version


## b. Schreiben von Docker-Compose File

mkdir ~/docker-compose

cd ~/docker-compose

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

## 4. Installation von Deployment Server 

## a. Update und Installation von Git, Docker, Docker-Compose OpenJDK.11, Gradle

Nach dem Installieren, git, openjdk11, docker, docker.compose, gradle,
Installieren Minikube 

## b. Installation von Minikube, kubectl

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube-linux-amd64

sudo mv minikube-linux-amd64 /usr/local/bin/minikube

 minikube version

Installieren kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

Starten minikube

minikube start


## c. Schreiben von Deployment und Service files for Kubernetes Cluster
Deployment und Service Files

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


## B. Konfigurationen von Jenkins

## 1. Global Tool Konfigurationen
Wir öffnen http://<IP_jenkinsServer>:8080. Danach gehen wir auf Dashboard/Manage_Jenkins/Global_Tool_Configurations.

##	a. Spezifizierung der Home Directory von Git


    gehen wir auf Git-Feld, und wir geben ein :
    Name: Git
    Path_to_Git_executable:git

    Wenn die Path von Git-Executable nicht bekannt, kann es mit which befehl determiniert werden. 
     
     " which git"

##		b. Spezifizierung der Home Directory von Docker
    gehen wir auf JDK-Feld, und wir geben ein :
    Name: docker-<version>
    JAVA_HOME: /usr/bin/docker

    ### Wenn die Path von Home_Direktory nicht bekannt, kann es mit which befehl determiniert werden. 
     
     " which docker"

##		c. Spezifizierung der Home Directory von OpenJDK-11
    gehen wir auf Docker-Feld, und wir geben ein :
    Name: java-11
    JAVA_HOME: /usr/lib/jvm/java-11-openjdk-amd64

    ### Wenn die Path von Home_Direktory nicht bekannt, kann es mit which befehl determiniert werden. 
     
     " which java"

##		d. Spezifizierung der Home Directory von Gradle
     gehen wir auf Gradle-Feld, und wir geben ein :
    Name: gradle-<version>
    JAVA_HOME: /opt/gradle/gradle-<version>

    ### Wenn die Path von Home_Direktory nicht bekannt, kann es mit which befehl determiniert werden. 
     
     " which gradle"

## 2. Docker-Registry Server und Deployment Server als Agent Knoten von Jenkins Konfigurieren

Um Prozesse im Rahmen der CI/CD Pipeline auf anderen Nodes mit Jenkins Server auszuführen, sollten diese Nodes natürlich als Agenten gegenüber Jenkins Server definiert werden.
Dazu müssen wir eine SSH_Verbindung zwischen Jenkins_Server and Agent Node setzen und die „agent“ file vom Jenkins-Server auf den Slave-Knoten kopieren. 

## a.  Schritte zum Konfigurieren der SSH-Verbindung zwischen Master- und Slave-Knoten
- Wir  gehen  zum Jenkins Master-Server.
- Wir  wechseln zum Benutzer "jenkins". ( jenkins funtoniert auf Agentkonoten als jenkins-user. ) 
	„ sudo su - jenkins -s /bin/bash „
- Wir  generieren  mit keygen einen öffentlichen und einen privaten Schlüssel. 
	„ ssh-keygen „
- Wir drücken bei jeder Frage die Eingabetaste, um mit den Standardoptionen fortzufahren
- Wir  überprüfen den Ordner „.ssh“ und sehen Sie öffentliche (id_rsa.pub) und private Schlüssel (id_rsa)
	„cd .ssh ; ls „
-Wir müssen den öffentlichen Schlüssel auf den Slave-Knoten kopieren.
	„cat id_rsa.pub „
-Wir wählen alle Codes in id_rsa.pub aus und kopieren wir sie. Wir wechseln zum Ordner /root/.ssh auf der Slave-Knoteninstanz. 
	„sudo su
 cd /root/.ssh „
- Wir  öffnen die Datei „authorized_keys“ mit einem Editor und fügen wir den Code ein, den wir aus dem öffentlichen Schlüssel (id_rsa.pub) kopiert haben. Wir  speichern  die Datei „authorized_keys“. Wir  holen sich die Slave-Knoten-IP. 
	„ ifconfig „
- IP-Nummer kopieren und wir gehen zum Jenkins-Master-Server und testen wir die SSH-Verbindung. 
	„ ssh root@<slave-node-ip-number> „


## b. die Agentendatei vom Jenkins-Server auf den Slave-Knoten zu kopieren

- Wir wechseln  zum Ordner „/root“ auf der Slave-Knoteninstanz. Wir erstellen einen Ordner unter „/root“ und nennen Sie ihn „bin“. Agent-Datei vom Jenkins-Master-Server abrufen.

	„ mkdir bin
  cd bin
  wget http://<jenkins_master_ip>:8080/jnlpJars/slave.jar „ 

- Wir gehen zum Jenkins-Dashboard und klicken wir im linken Menü auf „Manage Jenkins“.
- Wir wählen „Manage Nodes and Clouds“
- Wir klicken im linken Menü auf „New Node“.
- Wir geben „SlaveNode-1“ in das Feld „Node name“ ein und wählen wir „Permanent Agent“ aus.
- Klicken auf die Schaltfläche "OK".
- Wir geben „Dies ist ein Linux-Slave-Knoten für Jenkins“ in das Beschreibungsfeld ein.
- "Number of Executors" ist die maximale Anzahl gleichzeitiger Builds, die Jenkins auf diesem Knoten ausführen kann. Wir geben in dieses Feld „1“ ein. Eigentlich ist die geeignete Anzahl zu diesem Bereich ist die Anzahl von CPU-Kerne. 
- Ein Agent muss ein Verzeichnis haben, das Jenkins gewidmet ist. Wir geben den Pfad zu diesem Verzeichnis auf dem Agenten an. Wir geben `/usr/jenkins` in das Feld "Remote root directory" ein.
- Geben "Linux" in das Feld "Labels" ein.
- Wählen im Dropdown-Menü im Feld „Launch method“ die Option „Launch agent via execution of command on the master“ aus.
- Enter `ssh -i /var/lib/jenkins/.ssh/ id_rsa  root@<slave_ip> java -jar /root/bin/slave.jar` in das Feld " Launch command " ein.
- Wählen im Dropdown-Menü im Feld "Availability" die Option " Keep this agent online as much as possible ".
- Klicken auf „Save“.
- Überprüfen die Konsolenprotokolle, falls der Agent-Knoten nicht gestartet werden kann. Wenn es ein Genehmigungsproblem gibt, gehen zu „Manage Jenkins“, wählen „`In-process Script Approval“ und „approve“ Sie das Skript.
- Gehen zum Jenkins-Dashboard. Überprüfen die Master- und Slave-Knoten im linken Menü.


## C. CI/CD Pipeline Durchführen
Jenkins Pipeline (oder einfach „Pipeline“) ist eine Suite von Plugins, die die Implementierung und Integration von Continuous-Delivery-Pipelines in Jenkins unterstützt.
Eine Continuous-Delivery-Pipeline ist ein automatisierter Ausdruck Ihres Prozesses, um Software von der Versionskontrolle bis zu Ihren Benutzern und Kunden zu bringen. Jenkins Pipeline bietet einen erweiterbaren Satz von Tools zum Modellieren einfacher bis komplexer Bereitstellungspipelines „als Code“. Die Definition einer Jenkins-Pipeline wird normalerweise in eine Textdatei (als Jenkinsfile bezeichnet) geschrieben, die wiederum in das Quellcodeverwaltungs-Repository eines Projekts eingecheckt wird.
Jenkins-Pipelines können mithilfe einer Textdatei namens JenkinsFile definiert werden. Wir können die Pipeline mithilfe von JenkinsFile als Code implementieren, und dies kann mithilfe einer domänenspezifischen Sprache (DSL) definiert werden. Mit JenkinsFile können wir die Schritte schreiben, die zum Ausführen einer Jenkins-Pipeline erforderlich sind.
Es gibt zwei Arten von Syntax, die zum Definieren Ihrer JenkinsFile verwendet werden.

## 1. Deklarativ: Die deklarative Pipeline-Syntax bietet eine einfache Möglichkeit, Pipelines zu erstellen. Es enthält eine vordefinierte Hierarchie zum Erstellen von Jenkins-Pipelines.

Jenkinsfile (Deklerative Pipeline)
…
	pipeline {
		agent none
		stages {
			stage('Build Gradle') {
			    steps {
				echo "sample shell code oder DSL -code"
			    }
}
}
}…

## 2. Geskriptet: Geskriptete Jenkins-Pipeline läuft auf dem Jenkins-Master mit Hilfe eines leichtgewichtigen Executors. Es verwendet sehr wenige Ressourcen, um die Pipeline in atomare Befehle zu übersetzen.
 	
	Node {
		stage ( `Build´) {
// some Codes
}
	              stage ( `Test´) {
// some Codes
}
           }


Pipeline-Konzepte
Code: Pipelines werden im Code implementiert und in der Regel in die Quellcodeverwaltung eingecheckt, sodass Teams ihre Bereitstellungspipeline bearbeiten, überprüfen und iterieren können.
Langlebig: Pipelines können sowohl geplante als auch ungeplante Neustarts des Jenkins-Masters überstehen.
Pausierbar: Pipelines können optional anhalten und auf menschliche Eingaben oder Genehmigungen warten, bevor sie die Pipeline-Ausführung fortsetzen.
Vielseitig: Pipelines unterstützen komplexe reale CD-Anforderungen, einschließlich der Fähigkeit, Arbeiten parallel zu forken/beizutreten, zu loopen und auszuführen.
Erweiterbar: Das Pipeline-Plugin unterstützt benutzerdefinierte Erweiterungen seiner DSL (domänenspezifische Sprache) und mehrere Optionen für die Integration mit anderen Plugins.
Pipeline: Eine Pipeline ist ein benutzerdefiniertes Modell einer CD-Pipeline. Der Code einer Pipeline definiert Ihren gesamten Build-Prozess, der normalerweise Phasen zum Erstellen einer Anwendung, zum Testen und dann zum Bereitstellen umfasst.
Knoten: Ein Knoten ist eine Maschine, die Teil der Jenkins-Umgebung ist und eine Pipeline ausführen kann.
Stage: Ein Stageblock definiert eine konzeptionell unterschiedliche Teilmenge von Tasks, die über die gesamte Pipeline durchgeführt werden (z. B. die Phasen „Build“, „Test“ und „Deploy“), die von vielen Plugins verwendet werden, um den Status/Fortschritt der Jenkins-Pipeline zu visualisieren oder darzustellen.
Step: Eine einzelne Task. Grundsätzlich teilt ein Step Jenkins mit, was zu einem bestimmten Zeitpunkt (oder „Step“ im Prozess) zu tun ist. Um beispielsweise den Shell-Befehl auszuführen, verwenden Sie den sh-Step: sh 'make'.



## 1. Schreiben von Jenkinsfile
Nachdem wir uns bei Jenkins angemeldet haben, klicken wir auf die Menüoption „New Item“. Geben wir den Namen der Jenkins-Pipeline ein, klicken wir auf "Pipeline". Drücken wir dann die „OK“-Taste.

Wir gelangen direkt zur Seite "Konfiguration" des Projekts, wählen wir den Abschnitt "Pipeline" aus und fügen wir den folgenden Code ein.

Innerhalb der Pipeline kann es „stages“ geben (Wir haben eine). Innerhalb der „stages“ können sich mehrere „stage elements“ befinden.
Innerhalb jeder „stage“ müssen „steps“ vorhanden sein. Die Schritte selbst sind Jenkins-Befehle.
„echo“ Befehl wird einfach etwas auf der Konsole ausgeben. Es kann nützlich sein, um Werte anzuzeigen, während die Pipeline Fortschritte macht.

Pipelines bestehen aus mehreren Schritten, mit denen wir Anwendungen erstellen, testen und bereitstellen können. Mit Jenkins Pipeline können wir auf einfache Weise mehrere Schritte zusammenstellen, mit denen wir jede Art von Automatisierungsprozess modellieren können.

Wenn ein Schritt erfolgreich ist, geht es zum nächsten Schritt über. Wenn ein Schritt nicht korrekt ausgeführt wird, schlägt die Pipeline fehl.
Wenn alle Schritte in der Pipeline erfolgreich abgeschlossen wurden, gilt die Pipeline als erfolgreich ausgeführt

### JENKINSFILE

pipeline {
    agent none
    tools {
  gradle 'gradle-7.4.2'
}

    stages {
        stage('Build Gradle') {
            agent {label 'jenkins'}
            steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Selahattinasn/gradle_exercise_java11']]])
                sh 'gradle clean'
                sh 'gradle build'
                sh 'whoami'
            }
        }

        stage('Build Docker Image') {
            agent {label 'jenkins'}
            steps {
               script{
                   sh 'docker build -t sennurmiray/snapshotintegration . '
                   sh 'docker tag sennurmiray/snapshotintegration:latest docker.registry:5000/selo/sennurmiray/snapshotintegration:v1 '
               } 
            }
        }

        stage('Push Docker Image') {
            agent {label 'jenkins'}
            steps {
               script{
                   withCredentials([string(credentialsId: 'dockerHub-pwd', variable: 'docker_login')]) {
                    sh 'docker login -u sennurmiray -p ${docker_login}'
                    }
                    sh 'docker push  sennurmiray/snapshotintegration '
                    sh 'docker push  docker.registry:5000/selo/sennurmiray/snapshotintegration:v1 '
               }
            }
        } 
        stage('Send Docker Image') {
            agent {label 'jenkins'}
            steps {
              sshPublisher(publishers: [sshPublisherDesc(configName: 'jenkins-node', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'pwd', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: './', remoteDirectorySDF: false, removePrefix: 'build/libs/', sourceFiles: 'build/libs/*SNAPSHOT.jar')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])  
            }
        }
        
        stage('deploy kube') {
            agent {label 'jenkins'}
         steps {
         sh 'uname'
         sh 'ip r'
             }
         } 
        stage('deploy KubeNode') {
            agent {label 'kubeNode'}
             steps {
                sh 'uname'
                sh 'ip r'
                sh 'runuser -l selahattin -c whoami'
                sh 'runuser -l selahattin -c "uptime"'
                sh 'runuser -l selahattin -c "kubectl cluster-info"'
                sh 'runuser -l selahattin -c "cd /home/selahattin"'
                sh 'runuser -l selahattin -c "pwd"'
                sh 'runuser -l selahattin -c "ls"'
                sh 'runuser -l selahattin -c "ls"'
                sh 'runuser -l selahattin -c "kubectl apply -f deploymentfile.yaml"'
                sh 'sleep 17'
                sh 'runuser -l selahattin -c "kubectl get pods"'
                sh 'runuser -l selahattin -c "curl 192.168.49.2:30456/greeting"'
                }
            }

    }
} 

####

## 2. Durchführung und Validierung

Wenn ist alles bereit, drucken wir apply && save , danach auf dem Dashboard drucken wir " Build " konoten. Wir könner den Prozessverfahren sowohl auf dem GUI als auch im Koncoleoutpu sehen.

