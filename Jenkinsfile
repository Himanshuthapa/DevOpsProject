pipeline {
    agent { label 'Slave1' }
    
    environment {   
        DOCKER_IMAGE_NAME = 'himanshuthapa98/sample-app'
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                // Checkout the repository containing Dockerfile and sample-app.yaml
                git branch: 'main', url: 'https://github.com/Himanshuthapa/DevOpsProject.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using Dockerfile from the repository
                    docker.build(DOCKER_IMAGE_NAME, '-f Dockerfile .')
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) {
                    sh 'docker login -u himanshuthapa98 -p ${dockerhubpwd}'
                    }
                    sh 'docker push himanshuthapa98/sample-app'
                    }
                }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes manifest (sample-app.yaml)
                    sh "kubectl apply -f app-deployment.yaml"
                }
            }
        }
    }
}
