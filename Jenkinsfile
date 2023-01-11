pipeline {
    agent any
    tools {
  gradle 'gradle-7.4.2'
}

    stages {
        stage('Build Gradle') {
            steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Selahattinasn/gradle_exercise_java11']]])
                sh 'gradle clean'
                sh 'gradle build'
                sh 'whoami'
            }
            
        }
        stage('Build Docker Image') {
            steps {
               script{
                   sh 'docker build -t sennurmiray/snapshotintegration . '
               }
                
            }
        }
        stage('Push Docker Image') {
            steps {
               script{
                   withCredentials([string(credentialsId: 'dockerHub-pwd', variable: 'docker_login')]) {
                    sh 'docker login -u sennurmiray -p ${docker_login}'
                    }
                    sh 'docker push  sennurmiray/snapshotintegration '
               }
                
            }
        }
    }

}