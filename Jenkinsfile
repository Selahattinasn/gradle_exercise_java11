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

 