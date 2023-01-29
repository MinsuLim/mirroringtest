pipeline {
    agent any
    stages{
        stage ("Fargate") { 
          steps {
            script {
              echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
              
              bat 'dir'           
            }
          }
        }
        stage ("agent") {
            steps {
             git branch: 'master',  url: 'https://github.com/MinsuLim/helmchart.git'
             bat 'dir'
//              sshagent(credentials: ['ssh-credentials-id']) {
//                 bat 'mkdir test2'
//                 bat 'dir'           
//               } 
            }
        }
    }
}
