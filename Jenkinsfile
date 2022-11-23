pipeline {
    agent none 
    environment {
        docker_chatbot = "bmv0161/csc603-chatbot"
        docker_actions = "bmv0161/csc603-actions"
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
                    sh 'docker build -t ${docker_chatbot} -t ${KUBEHEAD}:443/${docker_chatbot}:$BUILD_NUMBER -f $WORKSPACE/app/Dockerfile .'
                    sh 'docker build -t ${docker_actions} -t ${KUBEHEAD}:443/${docker_actions}:$BUILD_NUMBER -f $WORKSPACE/app/actions/Dockerfile .'

                    sh 'docker push -a ${docker_chatbot}'
                    sh 'docker push -a ${docker_actions}'
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
                    sh "sed -i 's#REGISTRY#${KUBEHEAD}#g' deployment.yaml"
                    sh "sed -i 's#DOCKER_CHATBOT#${docker_chatbot}#g' deployment.yaml"
                    sh "sed -i 's#DOCKER_ACTIONS#${docker_actions}#g' deployment.yaml"

                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} mkdir -p /users/${USER}/chatbot'
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/chatbot'
                    
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/chatbot/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/chatbot/service.yaml -n jenkins'
                }
            }
        }
    }
}
