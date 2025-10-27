pipeline {
    agent { label 'windows' }
    stages {
        stage('Checkout with token') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    bat '''
                        git clone https://%GITHUB_TOKEN%@github.com/yourorg/yourrepo.git repo
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
