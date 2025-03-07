pipeline {
    agent any

    environment {
        registry = "954976297955.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/suryan70195/docker-spring-boot.git']])
            }
        }

        stage("Build JAR") {
            steps {
                sh "mvn clean install"
            }
        }

        stage("Build Image") {
            steps {
                script {
                    dockerImage = docker.build("${registry}:${BUILD_NUMBER}")
                }
            }
        }

        stage("Push to ECR") {
            steps {
                script {
                    withEnv(["AWS_REGION=us-east-1"]) {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $registry"
                        sh "docker push $registry:$BUILD_NUMBER"
                    }
                }
            }
        }

        stage("Helm Deploy") {
            steps {
                sh "helm upgrade --install first mychart_chandu --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
            }
        }
    }
}
