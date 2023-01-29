pipeline {
    agent any
    stages{
        stage ("Fargate") { 
          steps {
            script {
              echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
              echo "${GIT_COMMIT}"
              bat 'dir'           
            }
          }
        }
        stage ("agent") {
            steps {
             git branch: 'main',  url: 'https://github.com/MinsuLim/helmchart.git'
             bat 'dir'
             bat 'dir ..' 
//              sshagent(credentials: ['ssh-credentials-id']) {
//                 bat 'mkdir test2'
//                 bat 'dir'           
//               } 
            }
        }
        stage ("restore") {
            steps {
              checkout scm 
              bat 'dir'
            }
        }
    }
}
