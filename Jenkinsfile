pipeline {
    agent none 
    environment {
        app_name = "webui"
        docker_image = "${KUBEHEAD}:443/${app_name}"
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
                    sh 'docker build -t ${docker_image} -t ${docker_image}:$BUILD_NUMBER -f $WORKSPACE/${app_name}/Dockerfile .'
                    sh 'docker push -a ${docker_image}'
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
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} mkdir -p /users/${USER}/${app_name}'
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/${app_name}'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/${app_name}/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/${app_name}/service.yaml -n jenkins'                                   
                }
            }
        }
    }
}
