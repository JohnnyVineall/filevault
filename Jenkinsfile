pipeline {
    agent any

    tools {
        nodejs 'NodeJS-20' // Name of the NodeJS installation in Jenkins
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                dir ('src/azure-sa') {
                    sh 'npm install'
                    sh 'npm run lint'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                dir ('src/azure-sa') {
                  // sh 'npm start'
                  echo 'Deployment coming soon...'
                }
            }
        }
    }
}