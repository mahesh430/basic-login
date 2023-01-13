pipeline {
    agent {
        
        
        kubernetes {
            label 'my-agent'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: my-agent
spec:
  containers:
  - name: my-agent
    image: bharathpantala/jenkins-agent:v1.0.0
    resources:
      limits:
        cpu: "1000m"
        memory: "1Gi"
    env:
    - name: "JENKINS_AGENT_NAME"
      value: "my-agent"
    - name: "JENKINS_AGENT_WORKDIR"
      value: "/home/jenkins"
    - name: "JENKINS_URL"
      value: "http://jenkins-server:8080"
    - name: "JENKINS_SECRET"
      value: "my-secret"
    - name: "JENKINS_TUNNEL"
      value: "jenkins-server:50000"
    """
        }
      
    environment {
        //AWS_ACCOUNT_ID=""=
        //AWS_DEFAULT_REGION="us-east-2" 
        IMAGE_REPO_NAME="bharathpantala/basic-login"
        ARTIFACT_NAME="basic-login"
        IMAGE_TAG="1.0.0-SNAPSHOT"
        //REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        AWS_CREDS_ID="aws-creds-ecr"
        DH_CREDS_ID="docker-hub-secret"
        //K8S_SECRET="k8s-secret"
    }
    stages {
        // Building Docker images
        stage('Checkout SCM') {
            steps{
               git url: 'https://github.com/cloudrural/basic-login.git'
            }
        }
        // Building Docker images
        stage('Building App') {
            steps{       
                sh "mvn clean package"
            }
        }
        // Building Docker images
        stage('Docker Image') {
            steps{
                script {
                sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }
        stage('Logging into Docker Hub') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.DH_CREDS_ID, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login --username $USERNAME -p $PASSWORD docker.io"
                    sh "docker push ${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
    }
/*
        stage('Logging into AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.AWS_CREDS_ID, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 065740665475.dkr.ecr.us-east-2.amazonaws.com"
                    }
                }
            }
        }   
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps{  
                script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

        // Uploading Docker images into AWS ECR
        stage('Deploy') {
            steps{  
                script {
                    sh "echo Deploying"
                    sh "helm upgrade --install $ARTIFACT_NAME deploymemt/helm/$ARTIFACT_NAME --namespace app"

                   //sh "helm upgrade --install $ARTIFACT_NAME deploymemt/helm/$ARTIFACT_NAME"
                }
            }
        }
    }
}
*/
}
}
