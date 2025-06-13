pipeline {
  agent any
  environment {
    IMAGE_NAME = "10.0.0.11:8082/docker-local/tic-tac-toe"
  }
  stages {
    stage('Build Docker Image') {
      steps {
        bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ."
      }
    }
    stage('Push to Nexus') {
      steps {
        script {
          docker.withRegistry('http://10.0.0.11:8082', 'nexus-credentials') {
            docker.image("${env.IMAGE_NAME}:${env.BUILD_NUMBER}").push()
          }
        }
      }
    }
    stage('Deploy to Minikube') {
      steps {
        powershell """
          (Get-Content k8s-deployment.yaml) `
            -replace 'IMAGE_TAG_TO_REPLACE', '$env:BUILD_NUMBER' `
            | Set-Content k8s-deployment.generated.yaml
          kubectl apply -f k8s-deployment.generated.yaml
        """
      }
    }
  }
}
