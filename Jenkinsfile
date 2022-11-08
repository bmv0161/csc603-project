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
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml $USER@$NODE_ADDRESS:~/'
                    sh 'ssh -o StrictHostKeyChecking=no $USER@$NODE_ADDRESS kubectl apply -f /users/$USER/database.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no $USER@$NODE_ADDRESS kubectl apply -f /users/$USER/database_services.yaml -n jenkins'
                }
            }
        }
    }
}
