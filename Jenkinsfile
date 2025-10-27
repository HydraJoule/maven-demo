pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'your-dockerhub-username/myapp'   // change this
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out source code...'
                // If Jenkins is already cloning from SCM, you can skip this line.
                // Otherwise, uncomment the next line and update your repo:
                // git 'https://github.com/your-username/myapp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                bat "docker build -t %DOCKER_HUB_REPO%:%IMAGE_TAG% ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo '🔐 Logging into Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo '📦 Pushing image to Docker Hub...'
                bat "docker push %DOCKER_HUB_REPO%:%IMAGE_TAG%"
                bat "docker tag %DOCKER_HUB_REPO%:%IMAGE_TAG% %DOCKER_HUB_REPO%:latest"
                bat "docker push %DOCKER_HUB_REPO%:latest"
            }
        }

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up local images...'
                bat "docker rmi %DOCKER_HUB_REPO%:%IMAGE_TAG% || exit /b 0"
                bat "docker logout"
            }
        }
    }

    post {
        success {
            echo "✅ Image successfully pushed to Docker Hub: %DOCKER_HUB_REPO%:%IMAGE_TAG%"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
