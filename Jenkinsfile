pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/devops-4u/angular-example-app.git'
        DEV_BRANCH = 'dev'
        MASTER_BRANCH = 'master'
        TEMP_BUILD_DIR = '/var/lib/jenkins/temp_build'
        DOCKER_IMAGE = 'angular-app'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${DEV_BRANCH}"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: REPO_URL,
                        credentialsId: 'github'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Copy Build Files to Master') {
            steps {
                script {
                    // Create a temporary directory
                    sh "mkdir -p ${TEMP_BUILD_DIR}"

                    // Set appropriate permissions
                    sh "chmod -R 777 ${TEMP_BUILD_DIR}"

                    // Copy build files from Docker container
                    sh "docker run --rm -v ${TEMP_BUILD_DIR}:/output ${DOCKER_IMAGE} cp -r /usr/share/nginx/html /output"

                    // Check out the master branch
                    sh "git checkout ${MASTER_BRANCH}"

                    // Copy files to workspace
                    sh "cp -r ${TEMP_BUILD_DIR}/html/* ."

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
                sh "rm -rf ${TEMP_BUILD_DIR}"
                cleanWs()
            }
        }
    }
}
