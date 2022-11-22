pipeline {
    agent none 
    environment {
        registry = "bmv0161/csc603-webui"
        docker_user = "bmv0161"
        docker_app = "csc603-webui"
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
                    sh 'docker build -t ${registry} -t ${registry}:$BUILD_NUMBER .'
                    sh 'docker push ${registry}'
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
                    sh "sed -i 's#DOCKER_REGISTRY#${registry}#g' deployment.yaml"
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/service.yaml -n jenkins'                                   
                }
            }
        }
    }
}
