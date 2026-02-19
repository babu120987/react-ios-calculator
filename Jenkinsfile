pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-ios-calculator"
        TEST_CONTAINER = "react-ios-test"
        PROD_CONTAINER = "react-ios-app"
        APP_PORT = "8787"
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
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Test Docker Container') {
            steps {
                sh """
                docker stop ${TEST_CONTAINER} || true
                docker rm ${TEST_CONTAINER} || true

                docker run -d --name ${TEST_CONTAINER} -p 9090:80 ${IMAGE_NAME}:latest

                sleep 5

                curl -f http://localhost:9090

                docker stop ${TEST_CONTAINER}
                docker rm ${TEST_CONTAINER}
                """
            }
        }

        stage('Run Production Container') {
            steps {
                sh """
                docker stop ${PROD_CONTAINER} || true
                docker rm ${PROD_CONTAINER} || true

                docker run -d --name ${PROD_CONTAINER} -p ${APP_PORT}:80 ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
    }
}
