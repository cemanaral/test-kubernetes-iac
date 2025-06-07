pipeline {
    agent {
        label 'docker-build'   
    }

    stages {
        stage('Hello') {
            steps {
                container('docker-build') {
                  sh 'docker ps'
                }
            }
        }
    }
}