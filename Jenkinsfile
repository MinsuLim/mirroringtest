pipeline {
    agent any
    stages{
        stage ("Fargate") { 
          steps {
            script {
              echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
              bat 'mkdir temp2'
              bat 'dir'           
            }
          }
        }
        stage ("agent") {
            steps {
             bat 'cd temp2'
             git branch: 'main',  url: 'https://github.com/MinsuLim/helmchart.git'
             bat 'dir'
             bat 'dir ..' 
//              sshagent(credentials: ['ssh-credentials-id']) {
//                 bat 'mkdir test2'
//                 bat 'dir'           
//               } 
            }
        }
    }
}
