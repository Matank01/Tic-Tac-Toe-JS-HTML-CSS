// pipeline {
//     agent any
//     environment {
//         IMAGE_NAME = "10.0.0.11:8082/docker-local/tic-tac-toe"
//         TAG = "${env.BUILD_NUMBER}"
//         KUBECONFIG = credentials('minikube-kubeconfig') // This will create a temporary file with the kubeconfig
//     }
//     stages {
//         stage('Build Docker Image') {
//             steps {
//                 bat """
//                 docker build -t %IMAGE_NAME%:%TAG% .
//                 """
//             }
//         }
//         stage('Push to Nexus') {
//             steps {
//                 script {
//                     docker.withRegistry('http://10.0.0.11:8082', 'nexus-credentials') {
//                         docker.image("${env.IMAGE_NAME}:${env.TAG}").push()
//                     }
//                 }
//             }
//         }
//         stage('Configure Kubernetes Access') {
//             steps {
//                 bat """
//                 echo Configuring kubectl access...
//                 kubectl config use-context minikube --kubeconfig=%KUBECONFIG%
//                 """
//             }
//         }
//         stage('Deploy to Minikube') {
//             steps {
//                 bat """
//                 powershell -Command "(Get-Content k8s-deployment.yaml).replace('IMAGE_TAG_TO_REPLACE', '%TAG%') | Set-Content k8s-deployment.generated.yaml"
//                 kubectl apply -f k8s-deployment.generated.yaml --kubeconfig=%KUBECONFIG%
//                 """
//             }
//         }
//     }
//     post {
//         always {
//             // Clean up the temporary kubeconfig file
//             bat 'del /f "%KUBECONFIG%"'
//         }
//     }
// }

// pipeline {
//     agent any

//     environment {
//         REGISTRY      = "host.docker.internal:5000"          // כתובת Nexus החדשה
//         IMAGE_NAME    = "${REGISTRY}/myapp"                  // שם-repo אחיד
//         TAG           = "${env.BUILD_NUMBER}"                // תיוג ייחודי לכל build
//         CHART_REPO    = "https://github.com/Matank01/helm-chart.git"
//         CHART_PATH    = "myapp"                              // התיקייה שבה יושב Chart
//         CHART_BRANCH  = "main"
//     }

//     stages {

//         stage('Build Docker Image') {
//             steps {
//                 bat """
//                 docker build -t %IMAGE_NAME%:%TAG% .
//                 """
//             }
//         }

//         stage('Push to Nexus') {
//             steps {
//                 withCredentials([usernamePassword(
//                         credentialsId: 'nexus-credentials',
//                         usernameVariable: 'NEXUS_USER',
//                         passwordVariable: 'NEXUS_PASS')]) {
//                     bat """
//                     docker login %REGISTRY% -u %NEXUS_USER% -p %NEXUS_PASS%
//                     docker push  %IMAGE_NAME%:%TAG%
//                     """
//                 }
//             }
//         }

//         stage('Update Helm values.yaml') {
//             steps {
//                 dir('tmpChart') {
//                     git branch: "${CHART_BRANCH}", url: "${CHART_REPO}",poll: false,changelog: false

//                     bat """
//                     yq e ".image.tag = \\"%TAG%\\" " -i ${CHART_PATH}\\values.yaml
//                     """
//                     bat """
//                     echo Running Helm lint ...
//                     helm lint ${CHART_PATH}
//                     """                                                                                                 

//                     withCredentials([usernamePassword(
//                             credentialsId: 'git-creds',
//                             usernameVariable: 'GIT_USER',
//                             passwordVariable: 'GIT_PASS')]) {
//                         bat """
//                         git config user.email "matank222@gmail.com"
//                         git config user.name  "matank"
//                         git add ${CHART_PATH}\\values.yaml
//                         git commit -m "CI: bump image tag to %TAG%"
//                         git push https://%GIT_USER%:%GIT_PASS%@github.com/Matank01/helm-chart.git HEAD:%CHART_BRANCH%
//                         """
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         cleanup {
//             bat 'rd /s /q tmpChart'
//         }
//     }
// }


pipeline {
    agent any

    environment {
        REGISTRY      = "host.docker.internal:5000"          
        IMAGE_NAME    = "${REGISTRY}/myapp"                 
        TAG           = "${env.BUILD_NUMBER}"                
        CHART_REPO    = "https://github.com/Matank01/helm-chart.git"
        CHART_PATH    = "myapp"                              
        CHART_BRANCH  = "main"
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
                withCredentials([usernamePassword(
                        credentialsId: 'nexus-credentials',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS')]) {
                    bat """
                    docker login %REGISTRY% -u %NEXUS_USER% -p %NEXUS_PASS%
                    docker push  %IMAGE_NAME%:%TAG%
                    """
                }
            }
        }

        stage('Update Helm values.yaml') {
            steps {
                dir('tmpChart') {
                    git branch: "${CHART_BRANCH}", url: "${CHART_REPO}",poll: false,changelog: false

                    bat """
                    yq e ".image.tag = \\"%TAG%\\" " -i ${CHART_PATH}\\values.yaml
                    """
                    bat """
                    echo Running Helm lint ...
                    helm lint ${CHART_PATH}
                    """                                                                                                 

                    withCredentials([usernamePassword(
                            credentialsId: 'git-creds',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_PASS')]) {
                        bat """
                        git config user.email "matank222@gmail.com"
                        git config user.name  "matank"
                        git add ${CHART_PATH}\\values.yaml
                        git commit -m "CI: bump image tag to %TAG%"
                        git push https://%GIT_USER%:%GIT_PASS%@github.com/Matank01/helm-chart.git HEAD:%CHART_BRANCH%
                        """
                    }
                }
            }
        }
    }
}