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
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml bm935325@130.127.132.227:~/'
                    sh 'ssh -o StrictHostKeyChecking=no bm935325@130.127.132.227 kubectl apply -f /users/bm935325/deployment.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no bm935325@130.127.132.227 kubectl apply -f /users/bm935325/service.yaml -n jenkins'
                }
            }
        }
    }
}
