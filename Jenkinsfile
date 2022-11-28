def awsAssumeRoleWithBaseRole(roleArn) {
  def sanitizedJobName = env.JOB_NAME.replaceAll("[\\W]|_", "")
  def sanitizedBuildNumber = env.BUILD_NUMBER.replaceAll("[\\W]|_", "")
  def roleSessionName = "jenkins-$sanitizedBuildNumber-$sanitizedJobName".take(64)

  env.AWS_ACCESS_KEY_ID = ""
  env.AWS_SECRET_ACCESS_KEY = ""
  env.AWS_SESSION_TOKEN = ""

  def tempRole = sh(returnStdout: true, script: """
    set +x
    aws sts assume-role --role-arn ${roleArn} --role-session-name ${roleSessionName}
  """).trim()

  env.AWS_ACCESS_KEY_ID = sh(returnStdout: true, script: """
    set +x
    echo '${tempRole}' | jq .Credentials.AccessKeyId | xargs
  """).trim()
  env.AWS_SECRET_ACCESS_KEY = sh(returnStdout: true, script: """
    set +x
    echo '${tempRole}' | jq .Credentials.SecretAccessKey | xargs
  """).trim()
  env.AWS_SESSION_TOKEN = sh(returnStdout: true, script: """
    set +x
    echo '${tempRole}' | jq .Credentials.SessionToken | xargs
  """).trim()
}

pipeline {

  agent { node { label 'ecs-agent-fargate' } }
  stages { 
    stage ("Fargate") {
      steps {
        script {
          echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
          sh("jq --version")
          sh("aws --version")
          
          env.role_arn = "arn:aws:iam::056231226580:role/IAM-JENKINS"
          awsAssumeRoleWithBaseRole(env.role_arn)
          sh ('aws sts get-caller-identity')

          env.KANIKO_CLS="ECS-CLUSTER-JENKINS-COMM"
          env.KANIKO_TD="builder-kaniko"
          env.KANIKO_SBN="subnet-07621e84987483b1c"
          env.KANIKO_SG="sg-06f6342db9529bdb7"

          env.CATEGORY="."
          env.CONTEXT_S3="jenkins-kaniko-ap-northeast-2"

          env.ECR_NAME="jenkins-kaniko"
          env.ECR_REPO="056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins-kaniko"
          // echo "${env.ECR_NAME}"
          // echo "${env.ECR_REPO}"

          
          sh("""
            chmod -R +x build-scripts/
            ./build-scripts/build-and-push-with-kaniko.sh ${env.ECR_REPO}
          """)
          
          
        }
      }
    }
  }
  // agent { node { label 'ecs-agent' } }
  // // 코드빌드 하나만 돌리게
  // stages {
  //   stage("Build Docker Image - CodeBuild") {
  //     steps {
  //       script {
  //         echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
  //         String nonProductionBuildSpec = """
  //           version: 0.2
  //           env:
  //             variables:
  //               AWS_DEFAULT_REGION: "ap-northeast-2"
  //               ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
  //           phases:
  //             build:
  //               commands:
  //                 - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
  //                 - docker build -t jenkins_tutorial .
  //                 - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
  //                 - docker image ls
  //                 - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
  //         """.stripIndent()
          
  //         writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
  //         //Send checked out files to AWS
  //         awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"

  //         // awsCodeBuild(
  //         //   credentialsType: 'keys',
  //         //   projectName: 'tutorial',
  //         //   region: 'ap-northeast-2',
  //         //   sourceControlType: 'jenkins',
  //         //   sseAlgorithm: 'AES256',
  //         //   buildSpecFile: "ci/${env.BRANCH_NAME}/buildspec.yml"
  //       }
  //     }
  //   } 
  // }
}



// 코드빌드 병렬로
// agent { node { label 'ecs-agent' } }
//   stages {
//     stage("parallel") {
//       parallel {
//         stage("Build Docker Image - CodeBuild1") { 
//           steps {
//             script {
//               echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
//               String nonProductionBuildSpec = """
//                 version: 0.2
//                 env:
//                   variables:
//                     AWS_DEFAULT_REGION: "ap-northeast-2"
//                     ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
//                 phases:
//                   build:
//                     commands:
//                       - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
//                       - docker build -t jenkins_tutorial .
//                       - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
//                       - docker image ls
//                       - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
//               """.stripIndent()
              
//               writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
//               //Send checked out files to AWS
//               awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"
//             }
//           }
//         } 

//         stage("Build Docker Image - CodeBuild2") {
//           steps {
//             script {
//               echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"   
//               // String nonProductionBuildSpec = """
//               //   version: 0.2
//               //   env:
//               //     variables:
//               //       AWS_DEFAULT_REGION: "ap-northeast-2"
//               //       ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
//               //   phases:
//               //     build:
//               //       commands:
//               //         - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
//               //         - docker build -t jenkins_tutorial .
//               //         - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
//               //         - docker image ls
//               //         - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
//               // """.stripIndent()
              
//               // writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
//               // //Send checked out files to AWS
//               // awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"
//             }
//           }
//         } 
//       }
//     }
//   }


  // 코드빌드 하나만 돌리게
  // stages {
  //   agent { node { label 'ecs-agent' } }
  //   stage("Build Docker Image - CodeBuild") {
  //     steps {
  //       script {
  //         echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
  //         String nonProductionBuildSpec = """
  //           version: 0.2
  //           env:
  //             variables:
  //               AWS_DEFAULT_REGION: "ap-northeast-2"
  //               ECR_URL: "056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr"
  //           phases:
  //             build:
  //               commands:
  //                 - aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
  //                 - docker build -t jenkins_tutorial .
  //                 - docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
  //                 - docker image ls
  //                 - docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr:latest
  //         """.stripIndent()
          
  //         writeFile file: 'buildspec.yml', text: nonProductionBuildSpec
  //         //Send checked out files to AWS
  //         awsCodeBuild credentialsType: 'keys', sseAlgorithm: 'AES256', projectName: "tutorial",region: "ap-northeast-2", sourceControlType: "jenkins"

  //         // awsCodeBuild(
  //         //   credentialsType: 'keys',
  //         //   projectName: 'tutorial',
  //         //   region: 'ap-northeast-2',
  //         //   sourceControlType: 'jenkins',
  //         //   sseAlgorithm: 'AES256',
  //         //   buildSpecFile: "ci/${env.BRANCH_NAME}/buildspec.yml"
  //       }
  //     }
  //   } 
  // }