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
                    inheritFrom 'docker'
                }
            }
            steps{
                container('docker') {
                    sh 'echo ${DOCKER_TOKEN}'
                    sh 'echo ${env.DOCKER_APP}'
                    sh 'echo ${env.DOCKER_TOKEN} | docker login --username ${env.DOCKER_USER} --password-stdin'
                    sh 'docker build -t ${registry}:$BUILD_NUMBER .'
                    sh 'docker push ${registry}:$BUILD_NUMBER'
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
                    // sh "sed -i 's/BUILD_NUMBER/${env.BUILD_NUMBER}/g' deployment.yml"
                    sh "scp -r -v -o StrictHostKeyChecking=no *.yml ${USER}@${KUBEHEAD}:~/"
                    sh "ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/deployment.yml -n jenkins"
                    sh "ssh -o StrictHostKeyChecking=no ${USER}@${NODE_ADDRESS} kubectl apply -f /users/${USER}/service.yml -n jenkins"                                     
                }
            }
        }
    }
}
