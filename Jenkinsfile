pipeline {
  agent any

  environment {
    DOCKERHUB_USER = sarvah031220
    IMAGE_NAME = "react-ios-calculator"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
    LATEST = "${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE -t $LATEST .'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DU', passwordVariable: 'DP')]) {
          sh '''
            echo "$DP" | docker login -u "$DU" --password-stdin
            docker push $IMAGE
            docker push $LATEST
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s/
          kubectl set image deployment/react-ios-calculator web=$IMAGE
          kubectl rollout status deployment/react-ios-calculator
        '''
      }
    }
  }
}
