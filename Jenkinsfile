pipeline {
    agent any

    stage ("Fargate") { 
      steps {
        script {
          echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
          sh("""
            id
            pwd
            touch 1
            ls -al 
          """)               
        }
      }
    }
    stage ("agent") {
         sshagent() {
            sh """
                id
                pwd
                touch 2
                ls -al
            """
          } 
    }
}
