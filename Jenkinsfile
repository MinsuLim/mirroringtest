pipeline {
  agent { node { label 'ecs-agent' } }

  stages {
    stage('Parallel Test') {
      parallel {
        stage('Build Docker Image - CodeBuild - 1') {
          steps {
            script {
              echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
              String nonProductionBuildSpec = """
                version: 0.2
                env:
                  variables:
                    AWS_DEFAULT_REGION: "ap-northeast-2"
                    ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
                phases:
                  build:
                    commands:
                      - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
                      - docker build -t jenkins_tutorial .
                      - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
                      - docker image ls
                      - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
              """.stripIndent()
              
              writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
              //Send checked out files to AWS
              awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"
            }
          }
        } 

        stage('Build Docker Image - CodeBuild' - 2) {
          steps {
            script {
              String nonProductionBuildSpec = """
                version: 0.2
                env:
                  variables:
                    AWS_DEFAULT_REGION: "ap-northeast-2"
                    ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
                phases:
                  build:
                    commands:
                      - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
                      - docker build -t jenkins_tutorial .
                      - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
                      - docker image ls
                      - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
              """.stripIndent()
              
              writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
              //Send checked out files to AWS
              awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"
            }
          }
        } 

      }
    }
    
    // stage('Build Docker Image - CodeBuild') {
    //   steps {
    //     script {
    //       echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
    //       String nonProductionBuildSpec = """
    //         version: 0.2
    //         env:
    //           variables:
    //             AWS_DEFAULT_REGION: "ap-northeast-2"
    //             ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
    //         phases:
    //           build:
    //             commands:
    //               - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
    //               - docker build -t jenkins_tutorial .
    //               - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
    //               - docker image ls
    //               - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
    //       """.stripIndent()
          
    //       writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
    //       //Send checked out files to AWS
    //       awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"

    //       // awsCodeBuild(
    //       //   credentialsType: 'keys',
    //       //   projectName: 'tutorial',
    //       //   region: 'ap-northeast-2',
    //       //   sourceControlType: 'jenkins',
    //       //   sseAlgorithm: 'AES256',
    //       //   buildSpecFile: "ci/${env.BRANCH_NAME}/buildspec.yml"
    //     }
    //   }
    // } 
    
    // stage('Build Docker Image - EC2') {
    //   steps {
    //     echo "Hello Agent!!!!"
    //     echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
        
    //     // echo '''
    //     //   aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
    //     //   docker build -t jenkins_tutorial .
    //     //   docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
    //     //   docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest

    //     // '''
    //    }
    // }

  }
}
