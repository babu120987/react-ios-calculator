pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "babu120987/react-ios-calculator"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/babu120987/react-ios-calculator.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
            }
        }

stage('Login to DockerHub') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-credentials',
            usernameVariable: 'sarvah031220',
            passwordVariable: 'N0tguess@ble'
        )]) {
            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            '''
        }
    }
}

        stage('Push Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                sh """
                kubectl set image deployment/react-ios-app \
                react-ios-app=${DOCKER_IMAGE}:${IMAGE_TAG}
                """
            }
        }

        stage('Verify Rollout') {
            steps {
                sh "kubectl rollout status deployment/react-ios-app"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
