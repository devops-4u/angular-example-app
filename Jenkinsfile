pipeline {
    agent any

    environment {
        DEV_BRANCH = 'dev'
        QA_DIR = 'D:/App/ERPAg'
        DOCKER_IMAGE = 'angular-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from DEV branch...'
                checkout scm
            }
        }

        stage('Build Angular Application') {
            steps {
                echo 'Building Angular application...'
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Copy to QA') {
            steps {
                echo 'Copying application to QA directory...'
                script {
                    sh """
                    docker create --name temp-container ${DOCKER_IMAGE}
                    docker cp temp-container:/usr/share/nginx/html ${QA_DIR}
                    docker rm temp-container
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
