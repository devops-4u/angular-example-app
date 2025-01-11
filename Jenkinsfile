pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/devops-4u/angular-example-app.git'
        DEV_BRANCH = 'dev'
        MASTER_BRANCH = 'master'
        BUILD_DIR = 'build' // Build output directory
        DOCKER_IMAGE = 'angular-app' // Docker image name
        TEMP_BUILD_DIR = '/var/lib/jenkins/temp_build' // Use a consistent directory
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/dev']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: "${REPO_URL}",
                        credentialsId: 'github' // Ensure correct credentials ID
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Copy Build Files to Master') {
            steps {
                script {
                    // Ensure the temporary directory exists with the right permissions
                    sh '''
                    sudo mkdir -p ${TEMP_BUILD_DIR}
                    sudo chmod -R 777 ${TEMP_BUILD_DIR}
                    '''

                    // Copy build files from Docker container to the temporary directory
                    sh "docker run --rm -v ${TEMP_BUILD_DIR}:/output ${DOCKER_IMAGE} cp -r /usr/share/nginx/html /output"

                    // Check out the master branch
                    sh "git checkout ${MASTER_BRANCH}"

                    // Copy files to the workspace and adjust permissions
                    sh '''
                    sudo cp -r ${TEMP_BUILD_DIR}/html/* .
                    sudo chmod -R 755 .
                    '''

                    // Add, commit, and push changes
                    sh '''
                    git add .
                    git commit -m "Copy build files from dev branch to master branch"
                    git push origin ${MASTER_BRANCH}
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up workspace and temporary files...'
                sh '''
                sudo rm -rf ${TEMP_BUILD_DIR}
                '''
            }
            cleanWs() // Clean up the workspace after the job
        }
    }
}
