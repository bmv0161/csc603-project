pipeline {
    agent none 
    stages {
        stage ('Deploy') {
            agent {
                node {
                    label 'deploy'
                }
            }
            steps {
                sshagent(credentials: ['cloudlab']) {
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml ${USER}@${KUBEHEAD}:~/'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} mkdir -p /users/${USER}/mydb'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/mydb/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no ${USER}@${KUBEHEAD} kubectl apply -f /users/${USER}/mydb/service.yaml -n jenkins'
                }
            }
        }
    }
}
