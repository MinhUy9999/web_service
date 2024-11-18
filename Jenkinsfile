pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'minhuy19999/baitap2-image'
        DOCKER_TAG = 'latest'
        DOCKER_HOST = 'tcp://host.docker.internal:2375' // Sử dụng trên Windows nếu cần
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/MinhUy9999/web_service.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Kiểm tra quyền Docker (dành cho Windows nếu cần sử dụng TCP)
                    sh '''
                    if [ ! -z "$DOCKER_HOST" ]; then
                        echo "Using DOCKER_HOST: $DOCKER_HOST"
                    fi
                    '''
                    // Build Docker image
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                // Thêm lệnh kiểm tra nếu cần
                // sh 'docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} ./run-tests.sh'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Golang to DEV') {
            steps {
                echo 'Deploying to DEV...'

                script {
                    // Pull image mới từ Docker Hub
                    sh 'docker image pull MinhUy9999/golang-jenkins:latest'

                    // Dừng container nếu nó đã tồn tại
                    sh '''
                    docker container stop golang-jenkins || echo "Container does not exist, skipping stop step."
                    '''

                    // Tạo mạng nếu nó chưa tồn tại
                    sh '''
                    docker network create dev || echo "Network already exists, skipping creation."
                    '''

                    // Xóa các container không cần thiết
                    sh '''
                    docker container prune -f
                    '''

                    // Chạy container với image vừa build
                    sh '''
                    docker container run -d --rm --name server-golang \
                        -p 4000:3000 --network dev \
                        ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
