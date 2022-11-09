pipeline {
    agent none 
    environment {
        registry = "bmv0161/csc603-webscraper"
        docker_user = "bmv0161"
        docker_app = "csc603-webscraper"
    }
    stages {
        stage('Publish') {
            agent {
                kubernetes {
                    inheritFrom 'agent-template'
                }
            }
            steps{
                container('docker') {
                    sh "echo $DOCKER_TOKEN | docker login --username $DOCKER_USER --password-stdin"
                    sh "docker build -t ${registry}:$BUILD_NUMBER ."
                    sh "docker push ${registry}:$BUILD_NUMBER"
                }
            }
        }
        stage ('Deploy') {
            agent {
                node {
                    label 'deploy'
                }
            }
            steps {
                sshagent(credentials: ['cloudlab']) {
                    sh "sed -i 's/DOCKER_USER/${docker_user}/g' deployment.yml"
                    sh "sed -i 's/DOCKER_APP/${docker_app}/g' deployment.yml"
                    sh "sed -i 's/BUILD_NUMBER/${BUILD_NUMBER}/g' deployment.yml"
                    sh "scp -r -v -o StrictHostKeyChecking=no *.yml $USER@$NODE_ADDRESS:~/"
                    sh "ssh -o StrictHostKeyChecking=no $USER@$NODE_ADDRESS kubectl apply -f /users/$USER/deployment.yml -n jenkins"
                    sh "ssh -o StrictHostKeyChecking=no $USER@$NODE_ADDRESS kubectl apply -f /users/$USER/service.yml -n jenkins"                                     
                }
            }
        }
    }
}
