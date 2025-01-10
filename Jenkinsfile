pipeline {
    agent any

    environment {
        // Repository URL
        REPO_URL = 'https://github.com/devops-4u/angular-example-app.git'
        DEV_BRANCH = 'dev'
        MASTER_BRANCH = 'master'
        BUILD_DIR = 'build' // Assuming your build output is stored in this directory
        DOCKER_IMAGE = 'angular-app' // Docker image name
    }

    stages {
        stage('Checkout Dev Branch') {
            steps {
                script {
                    // Check out the dev branch
                    git branch: "${DEV_BRANCH}", url: "${REPO_URL}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Copy Build Files to Master') {
            steps {
                script {
                    // Store the workspace location
                    def workspace = pwd()

                    // Create a temporary directory to hold the build files
                    sh "mkdir -p ${workspace}/temp_build"

                    // Copy build files from the Docker container to the workspace
                    sh "docker run --rm -v ${workspace}/temp_build:/output ${DOCKER_IMAGE} cp -r /usr/share/nginx/html /output"

                    // Check out the master branch
                    sh "git checkout ${MASTER_BRANCH}"

                    // Copy the build files from the temporary directory to master
                    sh "cp -r ${workspace}/temp_build/html/* ${workspace}/"

                    // Remove the temporary directory
                    sh "rm -rf ${workspace}/temp_build"

                    // Add, commit, and push changes to the master branch
                    sh '''
                    git add .
                    git commit -m "Copy build files from dev branch to master branch"
                    git push origin master
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs() // Clean up the workspace after the job
        }
    }
}

