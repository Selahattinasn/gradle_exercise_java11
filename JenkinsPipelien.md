 
Jenkins ist ein eigenständiger Open-Source-Automatisierungsserver, der zur Automatisierung aller Arten von Aufgaben im Zusammenhang mit dem Erstellen, Testen und Bereitstellen oder Bereitstellen von Software verwendet werden kann. Es hilft, den kontinuierlichen Integrationsprozess zu erreichen.

Jenkins ist kostenlos und vollständig in Java geschrieben. Es ist eine häufig verwendete weltweite Anwendung. Jenkins kann über native Systempakete oder Docker installiert oder sogar eigenständig auf jedem Computer ausgeführt werden, auf dem eine Java Runtime Environment (JRE) installiert ist.In unserem Fall haben wir OpenJDK-11 installiert. 

Kontinuierliche Integration ist eine Praxis, bei der Entwickler mehrmals am Tag Code in ein gemeinsam genutztes Repository integrieren müssen und Jeder Check-in führt zu einem automatisierten Build. 
Kontinuierliche Delivery ist die Fähigkeit, automatisierte Bereitstellungen durchzuführen
Es ist ein serverbasiertes System, das auf einem Webserver wie Apache Tomcat läuft. Mit Jenkins können Unternehmen den Softwareentwicklungsprozess durch Automatisierung beschleunigen. Jenkins kombiniert alle Arten von Lebenszyklus-Entwicklungsprozessen, einschließlich Erstellen, Dokumentieren, Testen, Verpacken, Bereitstellen, Bereitstellen, statischer Analyse und vielem mehr.

Kontinuierliche Integration
Kontinuierliche Integration (CI) ist die Praxis, die mehrmalige tägliche Integration von Codeänderungen aller Entwickler in die gemeinsame Hauptlinie zu automatisieren. Die Software wird nach einem Code-Commit sofort durch Kontinuierliche Integration gebaut und getestet. Wenn der Unit-Test bestanden wird, wird der Build für die Bereitstellung getestet. Der Code wird in die Produktion verschoben, wenn die Bereitstellung erfolgreich ist. All dies ist ein kontinuierlicher Prozess und daher der Name Kontinuierliche Integration.

Vor Jenkins haben alle Entwickler, sobald die ihnen zugewiesenen Programmieraufgaben abgeschlossen waren, ihren Code gleichzeitig übergeben. Der Build wird später getestet und bereitgestellt. Da der Code auf einmal erstellt wurde, mussten einige Entwickler warten, bis andere Entwickler mit dem Codieren fertig waren, um ihren Build zu testen. Das Isolieren, Erkennen und Beheben von Fehlern bei mehreren Commits ist nicht einfach. Wenn alle Fehler behoben und getestet wurden, wird der Code bereitgestellt. Der Entwicklungszyklus ist also träge.

Mit Jenkins wird die Software nach einem Code-Commit sofort erstellt und getestet. Da der Code erstellt wird, nachdem jeder einzelne Entwickler festgeschrieben hat, ist es einfach zu erkennen, wessen Code das Fehlschlagen des Builds verursacht hat. Nach jedem erfolgreichen Build und Test wird der Code bereitgestellt. Es beschleunigt also den Softwareentwicklungsprozess.

Durch die Verwendung von Plugins erreicht Jenkins Kontinuierliche Integration. Plugins ermöglichen die Integration verschiedener DevOps-Stufen. Wenn Sie eine bestimmte Anwendung integrieren möchten, müssen die Plugins für diese Anwendung installiert werden.

Jenkins-Terminologie

Name	Description
Agent	Ein Agent ist normalerweise eine Maschine oder ein Container, der sich mit einem Jenkins-Master verbindet und Aufgaben ausführt, wenn er vom Master angewiesen wird.
Build	Ergebnis einer einzelnen Ausführung eines Projekts
Core	Die primäre Jenkins-Anwendung (jenkins.war), die die grundlegende Webbenutzeroberfläche, Konfiguration und Grundlage bereitstellt, auf der Plugins erstellt werden können.
Job/Project	Jenkins scheint diese Begriffe synonym zu verwenden. Sie beziehen sich alle auf ausführbare Tasks, die von Jenkins gesteuert/überwacht werden.
Master	Der zentrale, koordinierende Prozess, der die Konfiguration speichert, Plugins lädt und die verschiedenen Benutzeroberflächen für Jenkins rendert.
Node	Eine Maschine, die Teil der Jenkins-Umgebung ist und Pipelines oder Projekte ausführen kann. Sowohl der Master als auch die Agenten werden als Knoten betrachtet.
Pipeline	Eine Pipeline automatisiert den Prozess der Softwarebereitstellung. Es erstellt Code, führt Tests durch und hilft Ihnen, eine neue Version der Software sicher bereitzustellen.
Plugin	Eine Erweiterung der Jenkins-Funktionalität, die separat von Jenkins Core bereitgestellt wird.
Publisher	Teil eines Builds nach Abschluss aller konfigurierten Schritte, der Berichte veröffentlicht, Benachrichtigungen sendet usw.
Step	Eine einzige Aufgabe; Grundsätzlich sagen Schritte Jenkins, was innerhalb einer Pipeline oder eines Projekts zu tun ist.

Jenkins installieren

Voraussetzungen
Für die Installation benötigen wir:
Eine Maschine mit 256 MB RAM, obwohl mehr als 512 MB empfohlen werden, und 10 GB Speicherplatz (für Jenkins und unser Docker-Image)
•	Java 8 oder 11 (entweder ein JRE oder ein Java Development Kit (JDK) ist in Ordnung)
•	Docker


1.	Laden Sie Jenkins herunter und führen Sie es aus
For Linux:
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

2.	Öffnen Sie ein Terminal im Download-Verzeichnis.
3.	Führen Sie diesen Befehl aus.

java -jar jenkins.war --httpPort=8080

Dieser Befehl lädt ein Jenkins herunter und führt es auf unserem Computer aus. Viele Meldungen werden auf dem Bildschirm angezeigt. Nach der Initialisierung von Jenkins gibt uns die Konsole ein Administratorkennwort, um die Ersteinrichtung für Jenkins zu starten.

4.	Navigieren Sie zu http://localhost:8080. Im Cloud http://(Ihre ec2-Instance IPv4 Public IP):8080). Wir sehen den Bildschirm unten. Geben Sie das Admin-Passwort auf dem Bildschirm ein und drücken Sie auf Weiter.
 
Klicken Sie im nächsten Bildschirm auf „Vorgeschlagene Plugins installieren“.

 

Warten Sie auf die Installationen.
 
Erstellen Sie einen Benutzer.

 
Wir schließen die Installation ab, klicken auf „Jenkins verwenden“
 

Wenn die Installation abgeschlossen ist, können wir damit beginnen, Jenkins zum Laufen zu bringen!


















Installieren Jenkins mit Docker(Optional)
Zuerst erstellen wir einen Container in unserer Maschine. Docker muss auf unseren Maschinen installiert sein und ausgeführt werden. Führen Sie diesen Befehl aus:

docker run -p 8080:8080 -p 50000:50000 -v ~/$(USER):/var/jenkins_home jenkins

Hier nutzen wir also ein Volume. Dadurch wird der Arbeitsbereich in /var/jenkins_home gespeichert. Darin befinden sich alle Jenkins-Daten – einschließlich Plugins und Konfiguration. Sie werden dies wahrscheinlich zu einem dauerhaften Volume machen wollen (empfohlen). 
Quelle: https://hub.docker.com/_/jenkins
	https://www.jenkins.io/doc/book/installing/docker/

Zusammenfassend: Dieser Befehl lädt ein Jenkins herunter und führt es auf unserem Computer aus. Viele Meldungen werden auf dem Bildschirm angezeigt. Nach der Initialisierung von Jenkins gibt uns die Konsole ein Administratorkennwort, um die Ersteinrichtung für Jenkins zu starten.
Wir können auf unsere Jenkins unter http://localhost:8080/ zugreifen (für die Cloud-Instanz IPv4 Public IP:8080). Wir sehen den Bildschirm unten. Geben Sie das Admin-Passwort auf dem Bildschirm ein und drücken Sie auf Weiter.
So greifen Sie auf das Admin-Passwort zu: Wenn Sie Jenkins innerhalb von Docker als getrennten Container ausführen, können Sie die Befehle docker logs < containerId > verwenden, um die Jenkins-Protokolle anzuzeigen.Oder führen Sie die folgenden Befehle aus:
docker exec -it < containerId > bash
cat /var/jenkins_home/secrets/initialAdminPassword











Aufbau eines Jobs
Ein Jenkins-Projekt ist ein wiederholbarer Build-Job, der Schritte und Post-Build-Aktionen enthält. Die Arten von Aktionen, die Sie in einem Build-Schritt oder einer Post-Build-Aktion ausführen können, sind ziemlich begrenzt. Innerhalb eines Jenkins-Freestyle-Projekts sind viele Standard-Plugins verfügbar, die Ihnen helfen, dieses Problem zu lösen. Sie ermöglichen Ihnen die Konfiguration von Build-Triggern und bieten projektbasierte Sicherheit für Ihr Jenkins-Projekt.
Ein neues Jenkins-Element kann eine von sechs Auftragsarten sowie ein Ordner zum Organisieren von Elementen sein:

Freestyle-Projekt
Pipeline
externer Arbeitsplatz
Projekt mit mehreren Konfigurationen
Ordner
Github-Organisation
Multibranch-Pipeline

In Unserem Fall werden häufig Freestyle-Projekt oder Pipeline
Der Freestyle-Build-Job ist eine sehr flexible und einfach zu verwendende Option. Sie können es für jede Art von Projekt verwenden; Es ist einfach einzurichten und viele seiner Optionen erscheinen in anderen Build-Jobs.
1 - Um einen Jenkins-Freestyle-Job zu erstellen, öffnen Sie Ihren Jenkins-Installationspfad. Es wird auf http://localhost:8080 oder http://cloud-ip-address:8080 gehostet. Wenn wir auf einem anderen Port installiert haben, sollen wir diese Portnummer verwenden. Dann melden wir uns  mit Benutzername und Passwort bei unserem Jenkins-Dashboard an. In Unserem Fall die local private Netzwerkaadrese von unseres Jenkins_server ist: 192.168.22.129 
 

2. Lass uns öffnen Sie Ihr Jenkins-Dashboard und klicken Sie auf New Item, um ein neues Element zu erstellen.
 
3. Geben Sie den Itemnamen ein, wählen Sie dann ein Freestyle-Projekt und klicken Sie auf OK.
 

Beim Erstellen des ersten Projekts sehen Sie sechs Registerkarten. Diese sind:
1.	Source Code Management Tab : optionales SCM (Source Code Management), wie CVS (Concurrent Versions System) oder Subversion, wo sich Ihr Quellcode befindet.
2.	Build Triggers : Optionale Trigger zur Steuerung, wann Jenkins Builds ausführt.
3.	Build Environment: Eine Art Build-Skript, das den Build durchführt (Ameise, Maven, Shell-Skript, Batch-Datei usw.), wo die eigentliche Arbeit stattfindet
4.	Build : Optionale Schritte zum Sammeln von Informationen aus dem Build, z. B. Archivieren der Artefakte und/oder Aufzeichnen von Javadoc- und Testergebnissen.
5.	Post-build Actions : Optionale Schritte, um andere Personen/Systeme mit dem Build-Ergebnis zu benachrichtigen, z. B. Senden von E-Mails, IMs, Aktualisieren des Issue-Trackers usw
6.	General :

4.Geben wir die Beschreibung Ihres Jenkins-Projekts an. Gehen wir dann zu Bauen.
 





5.	Wählen Wir den entsprechenden Build-Schritt aus "Build-Schritt hinzufügen". Es hängt von Ihrem Betriebssystem ab. Wenn wir ein Windows-Benutzer sind, können Sie Windows-Stapelbefehl ausführen auswählen, oder wenn wir ein Linux- oder MacOS-Betriebssystem verwenden, können wir Shell ausführen auswählen.
 

6.	Wenn wir den Erstellungsschritt auswählen, wird der Befehlsraum angezeigt. Notieren wir einfach echo "Hello World", um den Shell-Befehl/Windows-Batch-Befehl auszuführen. Dann klicken Sie dann auf Anwenden und Speichern. Danach sehen wir das Innere des Projekts. Klicken wir dann auf Jetzt erstellen und warten wir einige Sekunden. Das Ergebnis dieser Build-Aktion wird im Build-Verlauf angezeigt
 


7.	Wie oben erwähnt, sehen Sie die Ergebnisse des Builds. Wenn Sie auf die Build-Nummer klicken, können Sie die Build-Seite erreichen. Wenn Sie die blaue Zahl sehen, hat der Aufbau gut funktioniert. Auf der Build-Seite können wir die Konsolenergebnisse von "Console Output" sehen. Wir können die Ergebnisse Ihres Builds sehen. Wie wir unser Ergebnis sehen können, wurde unser Job mit "Hello World" ausgedruckt und mit "SUCCESS" beendet.
 




















Pipeline

Jenkins Pipeline (oder einfach „Pipeline“) ist eine Suite von Plugins, die die Implementierung und Integration von Continuous-Delivery-Pipelines in Jenkins unterstützt.
Eine Continuous-Delivery-Pipeline ist ein automatisierter Ausdruck Ihres Prozesses, um Software von der Versionskontrolle bis zu Ihren Benutzern und Kunden zu bringen. Jenkins Pipeline bietet einen erweiterbaren Satz von Tools zum Modellieren einfacher bis komplexer Bereitstellungspipelines „als Code“. Die Definition einer Jenkins-Pipeline wird normalerweise in eine Textdatei (als Jenkinsfile bezeichnet) geschrieben, die wiederum in das Quellcodeverwaltungs-Repository eines Projekts eingecheckt wird.
Jenkins-Pipelines können mithilfe einer Textdatei namens JenkinsFile definiert werden. Sie können die Pipeline mithilfe von JenkinsFile als Code implementieren, und dies kann mithilfe einer domänenspezifischen Sprache (DSL) definiert werden. Mit JenkinsFile können Sie die Schritte schreiben, die zum Ausführen einer Jenkins-Pipeline erforderlich sind.
Es gibt zwei Arten von Syntax, die zum Definieren Ihrer JenkinsFile verwendet werden.
1. Deklarativ: Die deklarative Pipeline-Syntax bietet eine einfache Möglichkeit, Pipelines zu erstellen. Es enthält eine vordefinierte Hierarchie zum Erstellen von Jenkins-Pipelines.

	Pipeline {
		/*Hier geben wir Deklarative Formulierungen ein*/ 
}
2. Geskriptet: Geskriptete Jenkins-Pipeline läuft auf dem Jenkins-Master mit Hilfe eines leichtgewichtigen Executors. Es verwendet sehr wenige Ressourcen, um die Pipeline in atomare Befehle zu übersetzen.
 	
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














Einzel Step-Pipeline
1. Nachdem wir uns bei Jenkins angemeldet haben, klicken wir auf die Menüoption „New Item“. Geben wir den Namen der Jenkins-Pipeline ein, klicken wir auf "Pipeline". Drücken wir dann die „OK“-Taste.

2. Wir gelangen direkt zur Seite "Konfiguration" des Projekts, wählen wir den Abschnitt "Pipeline" aus und fügen wir den folgenden Code ein.
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
Innerhalb der Pipeline kann es „stages“ geben (Wir haben eine). Innerhalb der „stages“ können sich mehrere „stage elements“ befinden.
Innerhalb jeder „stage“ müssen „steps“ vorhanden sein. Die Schritte selbst sind Jenkins-Befehle.
„echo“ Befehl wird einfach etwas auf der Konsole ausgeben. Es kann nützlich sein, um Werte anzuzeigen, während die Pipeline Fortschritte macht.
 
 


Running Multiple Steps
Pipelines bestehen aus mehreren Schritten, mit denen wir Anwendungen erstellen, testen und bereitstellen können. Mit Jenkins Pipeline können wir auf einfache Weise mehrere Schritte zusammenstellen, mit denen wir jede Art von Automatisierungsprozess modellieren können.
Wenn ein Schritt erfolgreich ist, geht es zum nächsten Schritt über. Wenn ein Schritt nicht korrekt ausgeführt wird, schlägt die Pipeline fehl.
Wenn alle Schritte in der Pipeline erfolgreich abgeschlossen wurden, gilt die Pipeline als erfolgreich ausgeführt
… /*Ein Sample Multi Steps Pipeline*/
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
} ###
 
 



