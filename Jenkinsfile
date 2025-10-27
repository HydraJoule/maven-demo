pipeline {
    agent any   // or agent { label 'windows' } if you labeled your node

    stages {
        stage('Checkout with token') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    bat '''
                        REM === Clone the repo using the GitHub token ===
                        REM Replace yourorg/yourrepo with your actual repo path
                        git clone https://%GITHUB_TOKEN%@github.com/HydraJoule/maven-demo.git repo
                        cd repo
                        git rev-parse --abbrev-ref HEAD
                    '''
                }
            }
        }

        stage('Build Java App') {
            steps {
                bat '''
                    cd repo
                    mvn -B -DskipTests=true clean package
                '''
            }
        }

        stage('Run Application') {
            steps {
                bat '''
                    cd repo/target
                    java -jar myapp.jar
                '''
            }
        }
    }
}
