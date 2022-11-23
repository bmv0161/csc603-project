pipeline {
    agent none 
    environment {
        docker_image = '${KUBEHEAD}:443/csc603-webscraper'
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
                    sh 'docker login -u admin -p registry https://${KUBEHEAD}:443'
                    sh 'docker build -t ${docker_image} -t ${docker_image}:$BUILD_NUMBER -f $WORKSPACE/app/Dockerfile .'
                    sh 'docker push ${docker_image}'
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
                    sh "sed -i 's#DOCKER_IMAGE#${docker_image}#g' deployment.yaml"
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} mkdir -p /users/${USER}/webscraper'
                    sh 'scp -pr -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/webscraper'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/webscraper/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/webscraper/service.yaml -n jenkins'                                   
                }
            }
        }
    }
}
