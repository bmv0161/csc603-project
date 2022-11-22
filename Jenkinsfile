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
                    sh 'echo ${DOCKER_TOKEN} | docker login --username ${DOCKER_USER} --password-stdin'
                    sh 'docker build -t ${docker_chatbot} -t ${docker_chatbot}:$BUILD_NUMBER -f $WORKSPACE/chatbot/app/Dockerfile .'
                    sh 'docker build -t ${docker_actions} -t ${docker_actions}:$BUILD_NUMBER -f $WORKSPACE/chatbot/app/actions/Dockerfile .'

                    sh 'docker push ${docker_chatbot}'
                    sh 'docker push ${docker_actions}'
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
                    sh "sed -i 's#DOCKER_CHATBOT#${docker_chatbot}#g' deployment.yaml"
                    sh "sed -i 's#DOCKER_ACTIONS#${docker_actions}#g' deployment.yaml"
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/service.yaml -n jenkins'
                }
            }
        }
    }
}
