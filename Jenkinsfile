pipeline {
    agent none 
    environment {
        docker_app = "bmv0161/csc603-chatbot"
        docker_app2 = "bmv0161/csc603-actions"
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
                    sh 'docker build -t ${docker_app} -t ${docker_app}:$BUILD_NUMBER -f $WORKSPACE/chatbot/app/Dockerfile .'
                    sh 'docker build -t ${docker_app2} -t ${docker_app2}:$BUILD_NUMBER -f $WORKSPACE/chatbot/app/actions/Dockerfile .'

                    sh 'docker push ${docker_app}'
                    sh 'docker push ${docker_app2}'
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
                    sh "sed -i 's#DOCKER_APP#${docker_app}#g' deployment.yaml"
                    sh "sed -i 's#DOCKER_APP2#${docker_app2}#g' deployment.yaml"
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/service.yaml -n jenkins'
                }
            }
        }
    }
}
