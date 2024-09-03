pipeline {
    agent {
        label 'general'
    }
    
    triggers {
        githubPush()   // trigger the pipeline upon push event in GitHub
    }
    
    environment {        
        IMAGE_TAG = "latest"  // Default to latest if no specific versioning is required
        IMAGE_BASE_NAME = "netflix-frontend"
        
        DOCKER_CREDS = credentials('dockerhub')
        DOCKER_USERNAME = "${DOCKER_CREDS_USR}"  // The _USR suffix added to access the username value 
        DOCKER_PASS = "${DOCKER_CREDS_PSW}"      // The _PSW suffix added to access the password value
    } 

    stages {
        stage('Docker setup') {
            steps {             
                sh '''
                  echo $DOCKER_PASS | docker login -u $DOCKER_USERNAME --password-stdin
                '''
            }
        }
        
        stage('Pull Image') {
            steps {             
                sh '''
                  IMAGE_FULL_NAME=amirmirs/$IMAGE_BASE_NAME:$IMAGE_TAG
                
                  docker pull $IMAGE_FULL_NAME
                '''
            }
        }
    }
}
