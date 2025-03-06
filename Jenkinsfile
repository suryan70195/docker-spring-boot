pipeline {
    agent any

    environment {
        registry = "954976297955.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'git \'https://github.com/suryan70195/docker-spring-boot.git\'']])
            }
        }
        
        stage ("Build JAR") {
            steps {
                sh "mvn clean install"
            }
        }
        
        stage ("Build Image") {
            steps {
                script {
                    dockerImage = docker.build registry
                    dockerImage.tag("$BUILD_NUMBER")
                }
            }
        }
        
        stage ("Push to ECR") {
            steps {
                script {
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 954976297955.dkr.ecr.us-east-1.amazonaws.com"
                    sh "docker push 954976297955.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo:$BUILD_NUMBER"
                    
                }
            }
        }
        
        stage ("Helm Depoly") {
            steps {
                    sh "helm upgrage first --install mychart_chandu --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
                }
            }
                
        
    }
}
