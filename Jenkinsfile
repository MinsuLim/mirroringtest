pipeline {
  agent { node { label '' } } 
  stages { 
    stage ("Fargate") { 
      steps {
        script {
          echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}" 
          sh("""
            ls -al 
          """)               
        }
      }
    }
    stage ("agent") {
         sshagent() {
            sh """
                ls -al
            """
          } 
    }
  }
  
}
