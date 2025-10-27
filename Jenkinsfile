pipeline {
    agent any

    environment {
        IMAGE_NAME = "maven-demo"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
        CONTAINER_NAME = "maven-demo-app"
        HOST_PORT = "8080"
        APP_PORT = "8080"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                echo "Building project with Maven..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% .'
            }
        }

        stage('Run Docker Container') {
    steps {
        echo 'Stopping and removing old container if it exists...'
        bat '''
        for /f "tokens=*" %%i in ('docker ps -a -q -f "name=%CONTAINER_NAME%"') do docker rm -f %%i
        '''

        echo 'Running new Docker container...'
        bat '''
        docker run -d -p %HOST_PORT%:%APP_PORT% --name %CONTAINER_NAME% maven-demo:%BUILD_NUMBER%
        '''
    }
}

    }

    post {
        success {
            echo "✅ Build and deployment completed successfully!"
        }
        failure {
            echo "❌ Build or deployment failed. Check logs for details."
        }
    }
}
