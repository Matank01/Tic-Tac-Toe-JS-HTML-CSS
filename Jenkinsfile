pipeline {
    agent any

    /* ===== ENVIRONMENT CONFIG ===== */
    environment {
        // IP and port of your Nexus Docker registry, da
        DOCKER_REGISTRY      = "10.0.0.11:8082"

        // Name of the Docker image to build and push, da
        IMAGE_NAME           = "my-app"

        // Credential ID in Jenkins for the Nexus user/password, da
        REGISTRY_CREDENTIALS = "04691a51-2b1c-40a8-9084-891be5df351a"
    }

    /* ===== OPTIONS ===== */
    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
    }

    stages {
        stage('Clone code') {
            steps {
                // Pull your repository, da
                git 'https://github.com/RonyBubnovsky/Tic-Tac-Toe-JS-HTML-CSS.git'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    // Build the Docker image, da
                    dockerImage = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Nexus registry') {
            steps {
                script {
                    docker.withRegistry("http://${DOCKER_REGISTRY}", REGISTRY_CREDENTIALS) {
                        // Push the version tag and the latest tag, da
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
