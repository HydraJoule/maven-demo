pipeline {
    agent { label 'windows' }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/hydrajoule/maven-demo.git'
            }
        }

        stage('Build Java App') {
            steps {
                bat '''
                    mvn -B -DskipTests=true clean package
                '''
            }
        }

        stage('Run Application') {
            steps {
                bat '''
                    cd target
                    java -jar maven-demo-1.0-SNAPSHOT.jar
                '''
            }
        }
    }
}
