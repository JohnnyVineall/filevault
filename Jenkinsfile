pipeline {
    agent any

    tools {
        nodejs 'NodeJS' // Name of the NodeJS installation in Jenkins
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                dir ('src/azure-sa') {
                    sh 'rm -rf node_modules package-lock.json'
                    sh 'npm cache clean --force'
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