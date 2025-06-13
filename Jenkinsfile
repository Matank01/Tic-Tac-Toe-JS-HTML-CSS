pipeline {
    agent any
    environment {
        IMAGE_NAME = "10.0.0.11:8082/docker-local/tic-tac-toe"
        TAG = "${env.BUILD_NUMBER}"
        KUBECONFIG = credentials('minikube-kubeconfig') // This will create a temporary file with the kubeconfig
    }
    stages {
        stage('Build Docker Image') {
            steps {
                bat """
                docker build -t %IMAGE_NAME%:%TAG% .
                """
            }
        }
        stage('Push to Nexus') {
            steps {
                script {
                    docker.withRegistry('http://10.0.0.11:8082', 'nexus-credentials') {
                        docker.image("${env.IMAGE_NAME}:${env.TAG}").push()
                    }
                }
            }
        }
        stage('Configure Kubernetes Access') {
            steps {
                bat """
                echo Configuring kubectl access...
                kubectl config use-context minikube --kubeconfig=%KUBECONFIG%
                """
            }
        }
        stage('Deploy to Minikube') {
            steps {
                bat """
                powershell -Command "(Get-Content k8s-deployment.yaml).replace('IMAGE_TAG_TO_REPLACE', '%TAG%') | Set-Content k8s-deployment.generated.yaml"
                kubectl apply -f k8s-deployment.generated.yaml --kubeconfig=%KUBECONFIG%
                """
            }
        }
    }
    post {
        always {
            // Clean up the temporary kubeconfig file
            bat 'del /f "%KUBECONFIG%"'
        }
    }
}