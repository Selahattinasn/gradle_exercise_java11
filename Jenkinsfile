node {

     stage('./gradlew clean') {
        sh './gradlew clean'
    }
     stage('Git Clone') {

       sh 'git clone https://github.com/Selahattinasn/gradle_exercise_java11.git'
    }

    stage('gradle build') {
        sh './gradlew build'
    }
}
 
