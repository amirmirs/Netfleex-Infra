pipeline {
    agent {
        label 'general'
    }
    
    triggers {
        githubPush()   // trigger the pipeline upon push event in GitHub
    }
    
    environment {        
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = "netflix-frontend"
        
        DOCKER_CREDS = credentials('dockerhub')
        DOCKER_USERNAME = "${DOCKER_CREDS_USR}"  // The _USR suffix added to access the username value 
        DOCKER_PASS = "${DOCKER_CREDS_PSW}"      // The _PSW suffix added to access the password value

        KUBECONFIG_CREDENTIALS = credentials('kubeconfig')  // Ensure this matches the ID in Jenkins
    } 

    stages {
        stage('Docker setup') {
            steps {             
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }
        
        stage('Build & Push') {
            steps {             
                sh '''
                  IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG
                
                  docker build -t $IMAGE_FULL_NAME .
                  docker push $IMAGE_FULL_NAME
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: KUBECONFIG_CREDENTIALS]) {
                    sh '''
                        kubectl set image deployment/netflix-frontend-deployment netflix-frontend=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG --record
                        kubectl rollout status deployment/netflix-frontend-deployment
                    '''
                }
            }
        }
    }
}
