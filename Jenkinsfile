pipeline {
    agent {
               kubernetes {
             defaultContainer 'worker'
            yaml """
kind: Pod
metadata:
  name: worker
spec:
  containers:
  - name: worker
    image: bharathpantala/jenkins-agent:v1.0.0
    imagePullPolicy: "IfNotPresent"
    command:
    - cat
    tty: true
    volumeMounts:
      - name: dockersock
        mountPath: "/var/run/docker.sock"
  restartPolicy: Never
  volumes:
      - name: dockersock
        hostPath:
          path: "/var/run/docker.sock"
"""
        }
    }
      
    environment {
        AWS_ACCOUNT_ID="566875954720"
        AWS_DEFAULT_REGION="us-east-2" 
        IMAGE_REPO_NAME="mahesh430/basic-login"
        ARTIFACT_NAME="basic-login"
        IMAGE_TAG="1.0.0-SNAPSHOT"
        //REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        AWS_CREDS_ID="AWS_CREDS_ID"
        DH_CREDS_ID="DH_CREDS_ID"
        //K8S_SECRET="k8s-secret"
    }
    stages {
        // Building Docker images
        stage('Checkout SCM') {
            steps{
               git url: 'https://github.com/mahesh430/basic-login.git'
            }
        }
        // Building Docker images
        stage('Building App') {
            steps{       
                sh "mvn clean package"
            }
        }
        // Building Docker images
    
        stage('Docker build and Logging') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.DH_CREDS_ID, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                     sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                        sh "docker images"
                    // sh "docker login --username $USERNAME -p $PASSWORD docker.io"
                     //sh "docker push ${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
    

        stage('Logging into AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.AWS_CREDS_ID, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 566875954720.dkr.ecr.us-east-2.amazonaws.com"
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
