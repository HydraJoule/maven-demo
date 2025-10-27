pipeline {
    agent any

    environment {
        IMAGE_NAME = 'maven-demo'
        CONTAINER_NAME = 'maven-demo-app'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        HOST_PORT = '8080'
        APP_PORT = '8080'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                echo '🏗️ Building project with Maven...'
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo '🧹 Removing old container if it exists...'
                bat '''
                for /F "tokens=*" %%i in ('docker ps -a -q -f "name=%CONTAINER_NAME%"') do docker rm -f %%i
                exit /b 0
                '''

                echo '🚀 Starting new Docker container...'
                bat "docker run -d -p %HOST_PORT%:%APP_PORT% --name %CONTAINER_NAME% %IMAGE_NAME%:%BUILD_NUMBER%"
            }
        }
    }

    post {
        success {
            echo '✅ Build and deployment successful!'
        }
        failure {
            echo '❌ Build or deployment failed. Check logs for details.'
        }
    }
}
