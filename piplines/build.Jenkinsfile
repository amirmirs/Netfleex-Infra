pipeline {
    agent any
    
    triggers {
        githubPush()   // Trigger the pipeline upon push event in GitHub
    }
    
    environment {        
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = "netflix-frontend"
        
        DOCKER_CREDS = credentials('dockerhub')
        DOCKER_USERNAME = "${DOCKER_CREDS_USR}"  // Access the username value 
        DOCKER_PASS = "${DOCKER_CREDS_PSW}"      // Access the password value

        KUBECONFIG_CREDENTIALS = credentials('kubeconfig')  // Assuming your kubeconfig is stored in Jenkins credentials
    } 

    stages {
        stage('Docker Login') {
            steps {             
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }
        
        stage('Pull Docker Image') {
            steps {             
                sh '''
                  IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG
                
                  # Pull the existing Docker image from DockerHub
                  docker pull $IMAGE_FULL_NAME
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: KUBECONFIG_CREDENTIALS]) {
                    sh '''
                        # Update the Kubernetes deployment to use the new image
                        kubectl set image deployment/netflix-frontend-deployment netflix-frontend=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG --record
                        kubectl rollout status deployment/netflix-frontend-deployment
                    '''
                }
            }
        }
    }
}
