pipeline {
    agent any
    stages{
        stage ("Fargate") { 
          steps {
            script {
              echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
              bat 'mkdir test1'
              bat 'dir'           
            }
          }
        }
        stage ("agent") {
            steps {
             sshagent(credentials: ['ssh-credentials-id']) {
                bat 'mkdir test2'
                bat 'dir'           
              } 
            }
        }
    }
}
