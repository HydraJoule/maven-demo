pipeline {
  agent any

  environment {
    IMAGE_NAME     = "maven-demo"
    IMAGE_TAG      = "${env.BUILD_NUMBER}"
    DOCKER_REG     = ""       // e.g., "docker.io/youruser" or leave blank for local
    REGISTRY_CRED  = 'docker-reg-creds'
    SHOULD_PUSH    = "false"  // set to "true" if you push to registry
    CONTAINER_NAME = "maven-demo-app"
    HOST_PORT      = "8080"   // adjust if your app uses different port
    APP_PORT       = "8080"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build with Maven') {
      steps {
        sh "mvn clean install -DskipTests=false"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def fullImage = "${DOCKER_REG ? DOCKER_REG + '/' : ''}${IMAGE_NAME}:${IMAGE_TAG}"
          env.FULL_IMAGE = fullImage
          sh "docker build -t ${fullImage} ."
        }
      }
    }

    stage('Push Image (optional)') {
      when { expression { SHOULD_PUSH == 'true' } }
      steps {
        withCredentials([usernamePassword(credentialsId: REGISTRY_CRED, usernameVariable: 'REG_USER', passwordVariable: 'REG_PSW')]) {
          sh "echo \$REG_PSW | docker login -u \$REG_USER --password-stdin ${DOCKER_REG}"
          sh "docker push ${FULL_IMAGE}"
          sh "docker logout ${DOCKER_REG}"
        }
      }
    }

    stage('Run Container') {
      steps {
        sh """
          if docker ps -a -q -f name=${CONTAINER_NAME}; then
            docker rm -f ${CONTAINER_NAME} || true
          fi
        """
        sh "docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${APP_PORT} ${FULL_IMAGE}"
        sh '''
          echo "Waiting 5 seconds for app..."
          sleep 5
          if ! curl -sSf http://localhost:${HOST_PORT}/ >/dev/null; then
            echo "Health check failed"
            exit 1
          fi
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Build and deployment succeeded. Image: ${FULL_IMAGE}"
    }
    failure {
      echo "❌ Build or deployment failed."
      sh "docker logs ${CONTAINER_NAME} || true"
    }
  }
}
